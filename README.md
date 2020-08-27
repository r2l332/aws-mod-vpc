## VPC Module

Module to VPC plus 6 subnets; 3 private and 3 public.

* VPC
* 3 Private Subnets
* 3 Public Subnets
* NAT Gateway
* Routes for each subnet and Route Table 

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| create\_network | Creates Entire network stack | `bool` | n/a | yes |
| name | n/a | `any` | n/a | yes |
| priv\_subnet\_cidrs | n/a | `list` | n/a | yes |
| pub\_subnet\_cidrs | n/a | `list` | n/a | yes |
| region | n/a | `any` | n/a | yes |
| vpc\_cidr | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| eks\_private\_subnet | n/a |
| eks\_public\_subnet | n/a |
| eks\_vpc\_id | n/a |
| route\_table\_ids | n/a |
