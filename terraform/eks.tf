module "eks-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "challenge-cluster"
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 3
    }
  ]
}