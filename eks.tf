resource "aws_eks_cluster" "yamamoto" {
  name     = "yamamoto-eks"
  role_arn = aws_iam_role.yamamoto.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.yamamoto-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.yamamoto-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.yamamoto.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.yamamoto.certificate_authority[0].data
}

resource "aws_iam_role" "yamamoto" {
  name = "eks-cluster-yamamoto"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "yamamoto-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.yamamoto.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "yamamoto-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.yamamoto.name
}
