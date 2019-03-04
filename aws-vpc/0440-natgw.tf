
resource "aws_eip" "nat" {
  count = "${length(var.AvailabilityZones)}"
  vpc   = true
}

resource "aws_nat_gateway" "main" {
  count         = "${length(var.AvailabilityZones)}"

  allocation_id = "${element(aws_eip.nat.*.id,  count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id,  count.index)}"

  tags = "${merge(var.Tags, map("Name", format("%s-%s-NAT-gw",var.VpcName, element(var.AvailabilityZones, count.index))))}"

  depends_on = ["aws_internet_gateway.internet_gw", "aws_subnet.public"]
}

resource "aws_route" "private_nat_gateway" {
  count = "${length(var.PrivateSubnets)}"
  depends_on = ["aws_route_table.private_rt", "aws_nat_gateway.main"]
  route_table_id         = "${element(aws_route_table.private_rt.*.id , count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index % length(var.AvailabilityZones))}"

}