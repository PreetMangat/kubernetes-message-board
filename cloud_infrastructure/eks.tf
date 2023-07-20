##############################################################################
#                                IAM
##############################################################################

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"

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

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

##############################################################################
#                            EKS Control Plane
##############################################################################

resource "aws_eks_cluster" "kubernetes_message_board" {
  name     = "kubernetes-message-board"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private_ca_central_1a.id,
      aws_subnet.private_ca_central_1b.id,
      aws_subnet.public_ca_central_1a.id,
      aws_subnet.public_ca_central_1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}
