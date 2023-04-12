data "aws_caller_identity" "account" {}

data "aws_availability_zones" "available" {}

data "template_file" "ec2_cloudinit_config" {
  template = fileexists("templates/nat_gateway.cloud_config") ? file("templates/nat_gateway.cloud_config") : file("${path.module}/files/nat_gateway.cloud_config")

  vars = {
    hostname = "${local.prefix}nat-gateway"
  }
}

data "template_file" "ec2_cloudinit_script" {
  template = fileexists("templates/nat_script.cloud_config") ? file("templates/nat_script.cloud_config") : file("${path.module}/files/nat_script.cloud_config")

  vars = {
    FORCE_REPLACE = "202102032151"
    #Random string to force replace if changed
  }
}

data "template_cloudinit_config" "nat-gateway-config" {
  count         = var.enable_nat_instance == true ? 1 : 0
  gzip          = false
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.ec2_cloudinit_config.rendered
  }

  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.ec2_cloudinit_script.rendered
  }
}

data "aws_instances" "NatCreated" {
  count = var.enable_nat_instance == true ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["${local.prefix}nat-gateway"]
  }

  filter {
    name   = "tag:APP"
    values = ["Nat-gateway"]
  }

  depends_on = [aws_autoscaling_group.this]
}

data "aws_instance" "NatCreatedASG" {
  count       = var.enable_nat_instance == true ? 1 : 0
  instance_id = data.aws_instances.NatCreated[0].ids[0]

  depends_on = [aws_autoscaling_group.this]
}