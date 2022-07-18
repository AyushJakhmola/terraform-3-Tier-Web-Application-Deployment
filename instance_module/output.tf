output "instance_id" {
  value = aws_instance.bastion.id
}
output "instance_sg" {
  value = aws_security_group.public_sg.id
}