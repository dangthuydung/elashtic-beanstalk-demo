resource "aws_iam_role" "role" {
  name = "example-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_codedeploy_app" "app" {
  compute_platform = var.compute_platform
  name             = var.name
}

resource "aws_codedeploy_deployment_config" "deployment_config" {
  deployment_config_name = "test-deployment-config"
  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = var.deployment_group_name
  service_role_arn       = aws_iam_role.role.arn
  deployment_config_name = aws_codedeploy_deployment_config.deployment_config.id

    ec2_tag_set {
    ec2_tag_filter {
      key   = var.key_ec2
      type  = "KEY_AND_VALUE"
      value =var.value_ec2
    }
}
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}



