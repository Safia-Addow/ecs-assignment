output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "service_name" {
  value = aws_ecs_service.service.name
}