module "eks-cluster" {
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = "challenge-cluster"
  cluster_version                 = "1.18"
  subnets                         = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

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
