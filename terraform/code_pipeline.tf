resource "aws_codepipeline" "pipeline" {
  name     = "${var.project_tag}-pipeline"
  role_arn = "${aws_iam_role.code_pipeline_role.arn}"

  artifact_store {
    location = aws_s3_bucket.devops.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        OAuthToken           = var.github_token
        Owner                = var.github_owner
        Repo                 = var.github_repo
        Branch               = var.github_branch
        PollForSourceChanges = var.poll_source_changes
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}