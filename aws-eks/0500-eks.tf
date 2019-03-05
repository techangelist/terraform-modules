resource "aws_eks_cluster" "eks-cluster" {
  name            = "${var.K8sClusterName}"
  role_arn        = "${aws_iam_role.eks-cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.eks-cluster.id}"]
    subnet_ids         = ["${data.terraform_remote_state.vpc.eks-private-subnet-id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-clsuter-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy"
  ]
}

data "aws_ami" "eks-node" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.11*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

locals {
  eks-worker-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-cluster.certificate_authority.0.data}' '${var.K8sClusterName}'
USERDATA
}

resource "aws_launch_configuration" "eks-node" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.eks-node.name}"
  image_id                    = "${data.aws_ami.eks-node.id}"
  instance_type               = "${var.InstanceType}"
  name_prefix                 = "${var.K8sClusterName}"
  security_groups             = ["${aws_security_group.eks-node.id}"]
  user_data_base64            = "${base64encode(local.eks-worker-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-node" {
  desired_capacity     = "${var.MinNumberOfWorkerNodes}"
  launch_configuration = "${aws_launch_configuration.eks-node.id}"
  max_size             = "${var.MaxNumberOfWorkerNodes}"
  min_size             = "${var.MinNumberOfWorkerNodes}"
  name                 = "${var.K8sClusterName}"
  vpc_zone_identifier  = ["${data.terraform_remote_state.vpc.eks-private-subnet-id}"]

  tag {
    key                 = "Name"
    value               = "${var.K8sClusterName}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.K8sClusterName}"
    value               = "owned"
    propagate_at_launch = true
  }
}

