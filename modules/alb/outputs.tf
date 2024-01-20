
output "alb" {
  value = aws_lb.this
}

output "target_groups" {
  value = aws_lb_target_group.target_groups
}

output "listeners" {
  value = aws_lb_listener.listeners
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = concat(aws_lb.this.*.dns_name, [""])[0]
}

output "zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = concat(aws_lb.this.*.zone_id, [""])[0]
}