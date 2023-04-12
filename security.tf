##################  SG - Nat Gateway Instance  ##################

resource "aws_security_group" "nat-gateway-instance" {
  count = var.enable_nat_instance == true ? 1 : 0

  name        = "${local.prefix}nat-gateway-instance-sg"
  description = "Security Group for nat gateway instance public."
  vpc_id      = aws_vpc.main_vpc.id

  ##################  ingress section  ##################

  dynamic "ingress" {
    for_each = var.sg_nat_gateway_ingress
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]
    description = "nat-private-instance-traffic"
  }

  ##################  egress section  ##################

  dynamic "ingress" {
    for_each = var.sg_nat_gateway_egress
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(tomap({ "Name" = "${local.prefix}nat-gateway-instance-sg" }))

}