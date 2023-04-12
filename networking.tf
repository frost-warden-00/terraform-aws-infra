resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = merge(tomap({ "Name" = var.project }))
}

##################  IG   ##################

resource "aws_internet_gateway" "public" {

  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(tomap({ "Name" = "${local.prefix}ig" }))
}

################# EIP ######################

resource "aws_eip" "nat-gateway" {
  count = var.enable_nat_gateway == true ? 1 : 0
  vpc   = true

  tags = merge(tomap({ "Name" = "${local.prefix}eip-nat01" }))
}
################## NAT Gateway #################

resource "aws_nat_gateway" "nat-gateway" {
  count         = var.enable_nat_gateway == true ? 1 : 0
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.nat-gateway[0].id

  depends_on = [aws_internet_gateway.public]

  tags = merge(tomap({ "Name" = "${local.prefix}nat01" }))
}

##################  VPC flow logs store  ##################

resource "aws_s3_bucket" "logs_bucket" {
  count         = var.enable_vpc_logs == true ? 1 : 0
  bucket        = "${local.prefix}vpc-logs"
  force_destroy = true

  tags = merge(tomap({ "Name" = "${local.prefix}vpc-logs" }))
}

resource "aws_s3_bucket_acl" "this" {
  count  = var.enable_vpc_logs == true ? 1 : 0
  bucket = aws_s3_bucket.logs_bucket[0].id
  acl    = "private"
}

resource "aws_flow_log" "main_vpc_flow_logs" {
  count                = var.enable_vpc_logs == true ? 1 : 0
  log_destination      = aws_s3_bucket.logs_bucket[0].arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main_vpc.id

  tags = merge(tomap({ "Name" = "${local.prefix}vpc-flow-logs" }))
}


##################  SUBNET - Public  ##################

resource "aws_subnet" "public" {
  for_each                = { for index, az_name in local.az : index => az_name }
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.key + 2)
  vpc_id                  = aws_vpc.main_vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = local.az[each.key]

  tags = merge(tomap({ "Name" = "${local.prefix}public-subnet-${each.key + 1}", "Tier" = "Public" }))
}


##################  SUBNET - Private  ##################

resource "aws_subnet" "private" {
  for_each                = { for index, az_name in local.az : index => az_name }
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.key + 10)
  vpc_id                  = aws_vpc.main_vpc.id
  map_public_ip_on_launch = "false"
  availability_zone       = local.az[each.key]

  tags = merge(tomap({ "Name" = "${local.prefix}private-subnet-${each.key + 1}", "Tier" = "Private" }))
}

######### Route tables
##################  ROUTE  - Public  ##################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(tomap({ "Name" = "${local.prefix}public-route" }))
}

resource "aws_route" "internet-gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

##################  ROUTE  - Private  ##################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(tomap({ "Name" = "${local.prefix}private-route" }))
}

resource "aws_route" "nat-gateway" {
  count                  = var.enable_nat_gateway == true ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway[0].id
}

resource "aws_route" "private_internet_gateway" {
  count                  = var.enable_nat_instance == true ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = data.aws_instance.NatCreatedASG[0].network_interface_id
  depends_on             = [aws_route_table.private]
}

######### Route table associations ########

resource "aws_route_table_association" "rt_subnet_association" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "rt_subnet_association_private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}