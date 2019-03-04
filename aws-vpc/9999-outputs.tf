output "vpc_id" {
  value="${aws_vpc.main.id}"
}

output "cidr_block" {
  value="${aws_vpc.main.cidr_block}"
}

output "eks-private-subnet-id"{
  value="${aws_subnet.private.*.id}"
}