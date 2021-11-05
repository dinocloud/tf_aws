[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We literally have [*hundreds of terraform modules*][terraform_modules] that are Open Source and well-maintained. Check them out! 







## Usage

Include this repository as a module in your existing terraform code:

```hcl
module "efs" {
  source     = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=master"
  namespace  = "eg"
  stage      = "prod"
  name       = "app"
  attributes = ["efs"]

  aws_region         = "${var.aws_region}"
  vpc_id             = "${var.vpc_id}"
  subnets            = ["${var.private_subnets}"]
  availability_zones = ["${var.availability_zones}"]
  security_groups    = ["${var.security_group_id}"]

  zone_id = "${var.aws_route53_dns_zone_id}"
}
```






## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `1`) | list | `<list>` | no |
| availability_zones | Availability Zone IDs | list | - | yes |
| aws_region | AWS Region | string | - | yes |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| dns_name | Name of the CNAME record to create. | string | `` | no |
| enabled | Set to false to prevent the module from creating any resources | string | `true` | no |
| encrypted | If true, the disk will be encrypted | string | `false` | no |
| mount_target_ip_address | The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target | string | `` | no |
| name | Name (_e.g._ `app`) | string | `app` | no |
| namespace | Namespace (_e.g._ `eg` or `cp`) | string | `eg` | no |
| performance_mode | The file system performance mode. Can be either `generalPurpose` or `maxIO` | string | `generalPurpose` | no |
| provisioned_throughput_in_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned | string | `0` | no |
| security_groups | Security group IDs to allow access to the EFS | list | - | yes |
| stage | Stage (_e.g._ `prod`, `dev`, `staging`) | string | `default` | no |
| subnets | Subnet IDs | list | - | yes |
| tags | Additional tags (e.g. `{ BusinessUnit = "XYZ" }` | map | `<map>` | no |
| throughput_mode | Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned. When using provisioned, also set provisioned_throughput_in_mibps | string | `bursting` | no |
| vpc_id | VPC ID | string | - | yes |
| zone_id | Route53 DNS zone ID | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| dns_name | EFS DNS name |
| host | Route53 DNS hostname for the EFS |
| id | EFS ID |
| mount_target_dns_names | List of EFS mount target DNS names |
| mount_target_ids | List of EFS mount target IDs (one per Availability Zone) |
| mount_target_ips | List of EFS mount target IPs (one per Availability Zone) |
| network_interface_ids | List of mount target network interface IDs |




## Share the Love 

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-efs)! (it helps us **a lot**) 

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)


## Related Projects

Check out these related projects.

- [terraform-aws-efs-backup](https://github.com/cloudposse/terraform-aws-efs-backup) - Terraform module designed to easily backup EFS filesystems to S3 using DataPipeline
- [terraform-aws-efs-cloudwatch-sns-alarms](https://github.com/cloudposse/terraform-aws-efs-cloudwatch-sns-alarms) - Terraform module that configures CloudWatch SNS alerts for EFS



## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-efs/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## Commercial Support

Work directly with our team of DevOps experts via email, slack, and video conferencing. 

We provide [*commercial support*][commercial_support] for all of our [Open Source][github] projects. As a *Dedicated Support* customer, you have access to our team of subject matter experts at a fraction of the cost of a full-time engineer. 

[![E-Mail](https://img.shields.io/badge/email-hello@cloudposse.com-blue.svg)][email]

- **Questions.** We'll use a Shared Slack channel between your team and ours.
- **Troubleshooting.** We'll help you triage why things aren't working.
- **Code Reviews.** We'll review your Pull Requests and provide constructive feedback.
- **Bug Fixes.** We'll rapidly work to fix any bugs in our projects.
- **Build New Terraform Modules.** We'll [develop original modules][module_development] to provision infrastructure.
- **Cloud Architecture.** We'll assist with your cloud strategy and design.
- **Implementation.** We'll provide hands-on support to implement our reference architectures. 

## Copyright

Copyright © 2017-2019 [Cloud Posse, LLC](https://cpco.io/copyright)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

## Trademarks

All other trademarks referenced herein are the property of their respective owners.
