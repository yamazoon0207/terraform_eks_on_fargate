resource "aws_eks_fargate_profile" "kube_system" {
  cluster_name           = aws_eks_cluster.yamamoto.name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.kube_system.arn
  subnet_ids             = module.vpc.private_subnets

  selector {
    namespace = "kube-system"
    #labels = {
    #  "k8s-app" : "kube-dns"
    #}
  }

  selector {
    namespace = "yamamoto"
  }
  depends_on = [
    aws_iam_role_policy_attachment.kube-system-AmazonEKSFargatePodExecutionRolePolicy,
    aws_eks_cluster.yamamoto,
  ]

}

resource "aws_iam_role" "kube_system" {
  name = "eks-fargate-profile-kube-system"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "kube-system-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.kube_system.name
}
