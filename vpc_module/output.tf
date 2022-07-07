output "vpc_id" {
  value = aws_vpc.sample_project.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_vpc_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_vpc_subnet[*].id
}
