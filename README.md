# Main Infra

## Getting started

Example

````
module "example-main-infra" {
  enable_nat_gateway  = false
  enable_nat_instance = true
  env                 = var.env
  project             = local.project_name
  vpc_cidr            = "10.2.0.0/16"
  enable_vpc_logs     = true
  ami_id              = data.aws_ami.amazon_linux.id
}
````

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.62.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_eip.nat-gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.main_vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_instance_profile.nat_instance_ssm_minimal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.nat_instance_ssm_minimal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.nat_instance_ssm_minimal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.nat_instance_ssm_minimal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_nat_gateway.nat-gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.internet-gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.nat-gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.rt_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_subnet_association_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_security_group.nat-gateway-instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.nat_instance_ssm_minimal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_instance.NatCreatedASG](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_instances.NatCreated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [template_cloudinit_config.nat-gateway-config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.ec2_cloudinit_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.ec2_cloudinit_script](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | ID of the AMI for use in the EC2 | `string` | n/a | yes |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Flag for use a NAT Gateway instead of NAT Instance | `bool` | n/a | yes |
| <a name="input_enable_nat_instance"></a> [enable\_nat\_instance](#input\_enable\_nat\_instance) | Flag for create a NAT Instance instead of NAT Gateway | `bool` | n/a | yes |
| <a name="input_enable_vpc_logs"></a> [enable\_vpc\_logs](#input\_enable\_vpc\_logs) | Flag for enable vpc logs in the | `bool` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment to deploy | `string` | n/a | yes |
| <a name="input_instance_key_name"></a> [instance\_key\_name](#input\_instance\_key\_name) | Name of the EC2 key | `string` | `"ec2_instances"` | no |
| <a name="input_nat_instance_type"></a> [nat\_instance\_type](#input\_nat\_instance\_type) | Instance type to use for the NAT instance | `string` | `"t3a.micro"` | no |
| <a name="input_nat_spot"></a> [nat\_spot](#input\_nat\_spot) | Flag for use Spot Instance when using NAT Instance | `bool` | `false` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where to deploy the infrastructure | `string` | `"us-east-1"` | no |
| <a name="input_sg_nat_gateway_egress"></a> [sg\_nat\_gateway\_egress](#input\_sg\_nat\_gateway\_egress) | List object for create a custom SG | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_sg_nat_gateway_ingress"></a> [sg\_nat\_gateway\_ingress](#input\_sg\_nat\_gateway\_ingress) | List object for create a custom SG | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for a VPC | `string` | n/a | yes |

## Outputs

| Name | Description            |
|------|------------------------|
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Map of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Map of public subnets  |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID                 |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
