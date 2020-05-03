resource "aws_s3_bucket" "app" {
  bucket = "${var.lambda_deploy_bucket}"
  acl    = "private"
  force_destroy = true
  versioning {
    enabled = true
  }

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

resource "aws_s3_bucket" "devops" {
  bucket = "${var.lambda_devops_bucket}"
  acl    = "private"
  force_destroy = true
  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}