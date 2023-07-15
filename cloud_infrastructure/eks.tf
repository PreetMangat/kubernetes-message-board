resource "aws_iam_role" "kubernetes-message-board-role" {
  name = "kubernetes-message-board-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "kubernetes-message-board-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.kubernetes-message-board-role.name
}

variable "cluster_name" {
  default     = "kubernetes-message-board"
  type        = string
  description = "AWS EKS Cluster Name"
  nullable    = false
}

resource "aws_eks_cluster" "kubernetes-message-board" {
  name     = var.cluster_name
  role_arn = aws_iam_role.kubernetes-message-board-role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-ca-central-1a.id,
      aws_subnet.private-ca-central-1b.id,
      aws_subnet.public-ca-central-1a.id,
      aws_subnet.public-ca-central-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.kubernetes-message-board-AmazonEKSClusterPolicy]
}
