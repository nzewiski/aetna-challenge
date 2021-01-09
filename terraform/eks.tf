module "eks-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "challenge-cluster"
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  map_roles = [
    {
      rolearn  = "arn:aws:iam::672499893721:role/SSMManagedInstanceCore"
      username = "Bastion"
      groups   = ["system:masters"]
    }
  ]

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 3
    }
  ]
}

resource "aws_security_group_rule" "bastion_ingress" {
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.eks-cluster.cluster_security_group_id
  type                     = "ingress"
  source_security_group_id = "${var.account_id}/sg-5e3a2519"
}
