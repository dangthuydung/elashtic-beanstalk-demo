resource "aws_elastic_beanstalk_application" "EB_app" {
  name        = var.name_EB_app
  description = "beanstalk_application"
}

resource "aws_elastic_beanstalk_environment" "EB_env" {
  name                = var.name_EB_env
  application         = aws_elastic_beanstalk_application.EB_app.name
  solution_stack_name = var.solution_stack_name
  tier = var.tier
  
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     =  element(var.subnet_public,0)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     =  element(var.subnet_public,1)
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.key_name
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "true"
  }
}
