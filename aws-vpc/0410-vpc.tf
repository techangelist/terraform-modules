resource "aws_vpc" "main" {
  cidr_block = "${var.VpcCidr}"
  instance_tenancy = "default"
  enable_dns_hostnames = "${var.EnableDnsHostNames}"

  tags = "${merge(var.Tags, map("Name", var.VpcName),map("kubernetes.io/cluster/${var.ClusterName}", "shared"))}"
}