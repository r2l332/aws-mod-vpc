## EKS Module

WIP ... 

## Providers

No provider.

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
