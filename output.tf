output "vpc_id" {
  value       = aws_vpc.main_vpc.id
  description = "VPC ID"
}

output "private_subnets" {
  value = tomap({
    for k, inst in aws_subnet.private : k => inst.id
  })
  description = "Map of private subnets"
}

output "public_subnets" {
  value = tomap({
    for k, inst in aws_subnet.public : k => inst.id
  })
  description = "Map of public subnets"
}
