#########################################
### Provider - Environment variables
#########################################

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region where to deploy the infrastructure"
}

#########################################
### VPC variables
#########################################

variable "vpc_cidr" {
  description = "CIDR for a VPC"
  type        = string
}

variable "project" {
  description = "Name of project"
  type        = string
}

variable "env" {
  description = "Environment to deploy"
  type        = string
}

variable "nat_instance_type" {
  default     = "t3a.micro"
  type        = string
  description = "Instance type to use for the NAT instance"
}

variable "instance_key_name" {
  default     = "ec2_instances"
  type        = string
  description = "Name of the EC2 key"
}

variable "sg_nat_gateway_ingress" {
  description = "List object for create a custom SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "sg_nat_gateway_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "List object for create a custom SG"
  default     = []
}

variable "ami_id" {
  description = "ID of the AMI for use in the EC2"
  type        = string
}

#########################################
### VPC variables - Flags
#########################################

variable "enable_nat_gateway" {
  type        = bool
  description = "Flag for use a NAT Gateway instead of NAT Instance"
}

variable "enable_nat_instance" {
  type        = bool
  description = "Flag for create a NAT Instance instead of NAT Gateway"
}
variable "enable_vpc_logs" {
  type        = bool
  description = "Flag for enable vpc logs in the "
}

variable "nat_spot" {
  default     = false
  type        = bool
  description = "Flag for use Spot Instance when using NAT Instance"
}