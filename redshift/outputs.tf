output "id" {
  description = "The Redshift Cluster ID"
  value       = aws_redshift_cluster.default.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_redshift_cluster.default.arn
}

output "cluster_identifier" {
  description = "The Cluster Identifier"
  value       = aws_redshift_cluster.default.cluster_identifier
}

output "cluster_revision_number" {
  description = "The specific revision number of the database in the cluster"
  value       = aws_redshift_cluster.default.cluster_revision_number
}

output "cluster_subnet_group_name" {
  description = "The name of a cluster subnet group to be associated with this cluster"
  value       = aws_redshift_cluster.default.cluster_subnet_group_name
}

output "cluster_parameter_group_name" {
  description = "The name of the parameter group to be associated with this cluster"
  value       = aws_redshift_cluster.default.cluster_parameter_group_name
}

output "port" {
  description = "The Port the cluster responds on"
  value       = aws_redshift_cluster.default.port
}

output "dns_name" {
  description = "The DNS name of the cluster"
  value       = aws_redshift_cluster.default.dns_name
}

output "vpc_security_group_ids" {
  description = "The VPC security group Ids associated with the cluster"
  value       = aws_redshift_cluster.default.vpc_security_group_ids
}

output "cluster_security_groups" {
  description = "The security groups associated with the cluster"
  value       = aws_redshift_cluster.default.cluster_security_groups
}

output "endpoint" {
  description = "The connection endpoint"
  value       = aws_redshift_cluster.default.endpoint
}

output "database_name" {
  description = "The name of the default database in the Cluster"
  value       = aws_redshift_cluster.default.database_name
}

output "node_type" {
  description = "The type of nodes in the cluster"
  value       = aws_redshift_cluster.default.node_type
}

output "cluster_type" {
  description = "The cluster type"
  value       = aws_redshift_cluster.default.cluster_type
}

output "redshift_subnet_group_arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Subnet group name"
  value       = aws_redshift_subnet_group.default.arn
}

output "redshift_subnet_group_id" {
  description = "The Redshift Subnet group name ID"
  value       = aws_redshift_subnet_group.default.id
}

output "redshift_parameter_group_arn" {
  description = "Amazon Resource Name (ARN) of the Redshift parameter group"
  value       = aws_redshift_parameter_group.default.arn
}

output "redshift_parameter_group_id" {
  description = "The Redshift parameter group name"
  value       = aws_redshift_parameter_group.default.id
}

