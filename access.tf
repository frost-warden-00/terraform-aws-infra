data "aws_iam_policy_document" "nat_instance_ssm_minimal" {
  count = var.enable_nat_instance == true ? 1 : 0
  statement {
    sid = "ssminimal"

    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
      "ssm:SendCommand"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "ssminimal2"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "ssminimal3"

    actions = [
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "ssminimal4"

    actions = [
      "s3:GetEncryptionConfiguration",
      "s3:Get*",
      "s3:List*"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "sourcecheckdisable"
    actions = [
      "ec2:ModifyInstanceAttribute",
    ]

    resources = [
      "*",
    ]

  }
}

resource "aws_iam_policy" "nat_instance_ssm_minimal" {
  count = var.enable_nat_instance == true ? 1 : 0

  name   = "${local.prefix}nat-instance"
  path   = "/"
  policy = data.aws_iam_policy_document.nat_instance_ssm_minimal[0].json

  tags = merge(tomap({ "Name" = "${local.prefix}nat-instance" }))
}

resource "aws_iam_role" "nat_instance_ssm_minimal" {
  count = var.enable_nat_instance == true ? 1 : 0

  name = "${local.prefix}nat-instance"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = merge(tomap({ "Name" = "${local.prefix}nat-instance" }))
}

resource "aws_iam_role_policy_attachment" "nat_instance_ssm_minimal" {
  count = var.enable_nat_instance == true ? 1 : 0

  role       = aws_iam_role.nat_instance_ssm_minimal[0].name
  policy_arn = aws_iam_policy.nat_instance_ssm_minimal[0].arn
}

resource "aws_iam_instance_profile" "nat_instance_ssm_minimal" {
  count = var.enable_nat_instance == true ? 1 : 0

  name = "${local.prefix}instance-profile"
  role = aws_iam_role.nat_instance_ssm_minimal[0].name

  tags = merge(tomap({ "Name" = "${local.prefix}instance-profile" }))
}