resource "aws_route_table" "private_rt" {
    count    = "${length(var.PrivateSubnets)}"
    
    depends_on = ["aws_subnet.private"]
    vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(var.Tags, map("Name", format("%s-private-rt", var.VpcName)))}"
}

resource "aws_route_table_association" "private_rt_ass" {
  count = "${length(var.PrivateSubnets)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_rt.*.id, count.index)}"
}




resource "aws_route_table" "public_rt" {
    count    = "${length(var.PublicSubnets)}"

    depends_on = ["aws_subnet.private"]
    vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(var.Tags, map("Name", format("%s-public-rt", var.VpcName)))}"
}

resource "aws_route_table_association" "public_rt_ass" {
  count = "${length(var.PublicSubnets)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public_rt.*.id, count.index)}"
}