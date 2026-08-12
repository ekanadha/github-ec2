output "instance_id" {
  value = aws_instance.apache.id
}

output "public_ip" {
  value = aws_instance.apache.public_ip
}