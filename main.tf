provider "aws" {
  region = "ap-southeast-1"
}

module "module_network" {
  source   = "./network"
  vpc_name = "demo_vpc"
}

# module "module_server" {
#   source         = "./server"
#   public_subnet  = module.module_network.public_subnet
#   security_group = [module.module_network.security_group]
# }

module "module_EB" {
  source              = "./beanstalk"
  name_EB_app         = "EB-python-flask-123"
  name_EB_env         = "EB-python-flask-env-123"
  solution_stack_name = "64bit Amazon Linux 2 v3.3.15 running Python 3.8"
  tier                = "WebServer"
  vpc_id              = module.module_network.vpc_id
  subnet_public       = module.module_network.public_subnet
  key_name            = "app-key-1"
}

# module "module_codedeploy" {
#   source                = "./codedeploy"
#   compute_platform      = "Server"
#   name                  = "codedeploy-app-python"
#   deployment_group_name = "deployment-group-name-python"
#   key_ec2               = "Name"
#   value_ec2             = "web_instance"
# }

# module "module_codepipeline" {
#   source = "./codepipeline"

# }

# codepipeline = {
#   name_codepipeline     = "test-codepipeline-python"
#   location_s3_bucket    = "codepipeline-ap-southeast-1-794253563693"
#   github_oauth_token    = "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"
#   repo_name             = "python-flask-app"
#   branch                = "main"
#   repo_owner            = "dangthuydung"
# }

# module "module_s3" {
#     source = "./s3"
#     aws_vpc_endpoint = module.module_network.vpc_id
# }

# terraform {
#   backend "s3" {
#       bucket = "terraform-state-dungdang"
#       key = "terraform.tfstate"
#     #   dynamodb_table = "terraform-state-locking"
#       encrypt = true
#   }
# }