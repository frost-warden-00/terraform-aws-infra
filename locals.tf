locals {
  prefix      = "${var.project}-${var.env}-"
  environment = "${var.project}-${var.env}"
  az          = slice(data.aws_availability_zones.available.names, 0, 3)
}