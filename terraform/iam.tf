# AWS IAM ROLES / POLICIES
# Declarando as roles necessárias para os serviços AWS utilizados na aplicação.

# LAMBDA
resource "aws_iam_role" "lambda_iam_role" {
  name = "${var.project_tag}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

# DYNAMO DB
resource "aws_iam_role_policy" "dynamodb_lambda_policy" {
  name   = "${var.project_tag}-dynamodb-lambda-policy"
  role   = aws_iam_role.lambda_iam_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "${aws_dynamodb_table.lambdaarch_comentarios_dynamodb_table.arn}"
    }
  ]
}
EOF
}

# CLOUD WATCH (API GTW LOGS)
resource "aws_iam_role_policy" "cloudwatch_lambda_policy_python" {
  name   = "${var.project_tag}-cloudwatch-lambda-policy"
  role   = aws_iam_role.lambda_iam_role.id
  policy = data.aws_iam_policy_document.api_gateway_logs_policy_document_python.json
  
}

data "aws_iam_policy_document" "api_gateway_logs_policy_document_python" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

# CODE PIPELINE
resource "aws_iam_role" "code_pipeline_role" {
  name = "${var.project_tag}-code-pipeline-role"

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
  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

resource "aws_iam_role_policy" "code_pipeline_policy" {
  name = "${var.project_tag}-code-pipeline-policy"
  role = "${aws_iam_role.code_pipeline_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.devops.arn}",
        "${aws_s3_bucket.devops.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# CODE BUILD
resource "aws_iam_role" "code_build_role" {
  name = "${var.project_tag}-code-build-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
EOF
  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

resource "aws_iam_role_policy" "code_build_policy" {
  name = "${var.project_tag}-code-build-policy"
  role = "${aws_iam_role.code_build_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "lambda:GetLayerVersion",
        "lambda:PublishLayerVersion",
        "lambda:PublishVersion",
        "lambda:UpdateAlias",
        "lambda:UpdateFunctionCode",
        "lambda:UpdateFunctionConfiguration",
        "lambda:ListFunctions",
        "iam:PassRole"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:List*",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.devops.arn}",
        "${aws_s3_bucket.devops.arn}/*",
        "${aws_s3_bucket.app.arn}",
        "${aws_s3_bucket.app.arn}/*"
      ]
    }
  ]
}
EOF
}