resource "aws_internet_gateway" "internet_gw" {
  vpc_id = "${aws_vpc.main.id}"
  
  tags = "${merge(var.Tags, map("Name", format("%s-internet-gw", var.VpcName)))}"
}

resource "aws_route" "public_internet_gateway" {
  count = "${length(var.AvailabilityZones)}"
  depends_on = ["aws_route_table.public_rt", "aws_nat_gateway.main"]
  route_table_id         = "${element(aws_route_table.public_rt.*.id , count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gw.id}"

}