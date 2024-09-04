output "ec2_instances_public_ips" {
  value = [for instance in module.ec2_instances : instance.public_ip]
}