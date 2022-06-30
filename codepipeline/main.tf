resource "aws_iam_role" "role" {
  name = "test-role-codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "codepipeline" {
  name     = var.name_codepipeline
  role_arn = aws_iam_role.role.arn
  artifact_store {
    location = var.location_s3_bucket
    type     = "S3"

    # encryption_key {
    #   id   = data.aws_kms_alias.s3kmskey.arn
    #   type = "KMS"
    # }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["code"]

      configuration = {
        OAuthToken           = var.github_oauth_token
        Owner                = var.repo_owner
        Repo                 = var.repo_name
        Branch               = var.branch
        PollForSourceChanges = "false"
      }
    }
  }

  # stage {
  #   name = "Build"

  #   action {
  #     name             = "Build"
  #     category         = "Build"
  #     owner            = "AWS"
  #     provider         = "CodeBuild"
  #     input_artifacts  = ["source_output"]
  #     output_artifacts = ["build_output"]
  #     version          = "1"

  #     configuration = {
  #       ProjectName = "test"
  #     }
  #   }
  # }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["code"]
      version         = "1"

      configuration = {
        ApplicationName = var.application_name
        EnvironmentName = var.deployment_group_name
      }
    }
  }
}
