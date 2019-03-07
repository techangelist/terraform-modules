resource "aws_subnet" "private" {
  count = "${length(var.PrivateSubnets)}"

  depends_on        = ["aws_vpc.main"]
  availability_zone = "${count.index <= length(var.AvailabilityZones) -1 ? element(var.AvailabilityZones, count.index) : element(var.AvailabilityZones, count.index % length(var.AvailabilityZones) )}"
  cidr_block        = "${var.PrivateSubnets[count.index]}"
  vpc_id            = "${aws_vpc.main.id}"

  tags = "${merge(var.Tags, map("Tier", "Private"), map("Name", format("%s-private-subnet-%s", var.VpcName, element(var.AvailabilityZones, count.index))),map("kubernetes.io/role/internal-elb","1"))}"
}

resource "aws_subnet" "public" {
  count             = "${length(var.PublicSubnets)}"

  depends_on        = ["aws_vpc.main"]
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.PublicSubnets[count.index]}"
  availability_zone = "${element(var.AvailabilityZones, count.index )}"

  tags = "${merge(var.Tags, map("Tier", "Public"), map("Name", format("%s-public-subnet-%s", var.VpcName, element(var.AvailabilityZones, count.index))),map("kubernetes.io/cluster/${var.K8sClusterName}" , "shared"))}"
}