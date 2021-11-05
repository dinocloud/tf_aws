//output "arn" {
//  value       = "${join("", aws_efs_file_system.main.*.)}"
//  description = "EFS ARN"
//}

output "id" {
  value       = join("", aws_efs_file_system.main.*.id)
  description = "EFS ID"
}

output "dns_name" {
  value       = local.dns_name
  description = "EFS DNS name"
}

output "mount_target_dns_names" {
  value       = [coalescelist(aws_efs_mount_target.main.*.dns_name, [""])]
  description = "List of EFS mount target DNS names"
}

output "mount_target_ids" {
  value       = [coalescelist(aws_efs_mount_target.main.*.id, [""])]
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "mount_target_ips" {
  value       = [coalescelist(aws_efs_mount_target.main.*.ip_address, [""])]
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "network_interface_ids" {
  value       = [coalescelist(aws_efs_mount_target.main.*.network_interface_id, [""])]
  description = "List of mount target network interface IDs"
}

output "sg_id" {
  value       = aws_security_group.main.*.id[0]
  description = "EFS's security group id"
}

