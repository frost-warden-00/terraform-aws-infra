##################  Nat Instance  ##################

resource "aws_launch_template" "this" {
  count = var.enable_nat_instance == true ? 1 : 0
  name  = "NatInstanceTemplate"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  instance_market_options {
    market_type = var.nat_spot == true ? "spot" : null
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.nat_instance_ssm_minimal[0].name
  }

  image_id                             = var.ami_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.nat_instance_type
  key_name                             = var.instance_key_name
  vpc_security_group_ids               = [aws_security_group.nat-gateway-instance[0].id]
  user_data                            = data.template_cloudinit_config.nat-gateway-config[0].rendered
  update_default_version               = true
}

##################  AWS Autoscaling  ##################

resource "aws_autoscaling_group" "this" {
  count               = var.enable_nat_instance == true ? 1 : 0
  name                = "${local.prefix}NatInstance"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.public[0].id, aws_subnet.public[1].id, aws_subnet.public[2].id]

  lifecycle {
    create_before_destroy = true
  }

  launch_template {
    id      = aws_launch_template.this[0].id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${local.prefix}nat-gateway"
    propagate_at_launch = true
  }

  tag {
    key                 = "APP"
    value               = "Nat-gateway"
    propagate_at_launch = true
  }
}