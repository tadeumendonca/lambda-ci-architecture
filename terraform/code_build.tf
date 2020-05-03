data "template_file" "buildspec" {
  template = file("code-build/buildspec.yml")
}

resource "aws_codebuild_project" "build" {
  name          = "${var.project_tag}-lambda"
  description   = "Lambda build/deploy project."
  build_timeout = var.build_timeout
  badge_enabled = var.badge_enabled
  service_role  = "${aws_iam_role.code_build_role.arn}"

  artifacts {
    type           = "CODEPIPELINE"
    namespace_type = "BUILD_ID"
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = "LINUX_CONTAINER"
    privileged_mode = var.privileged_mode

    environment_variable {
      name  = "LAMBDA_DEPLOY_BUCKET"
      value = var.lambda_deploy_bucket
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec.rendered
  }

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}