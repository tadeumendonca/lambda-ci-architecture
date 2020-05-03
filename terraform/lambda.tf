data "archive_file" "get_materias_lambda_zip_file" {
  type        = "zip"
  source_dir  = "../src/get-materias"
  output_path = "../src/get-materias.zip"
  
}

resource "aws_s3_bucket_object" "get_materias_lambda_file_upload" {
  bucket = "${aws_s3_bucket.app.id}"
  key    = "get-materias.zip"
  source = "${data.archive_file.get_materias_lambda_zip_file.output_path}"

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

resource "aws_lambda_function" "get_materias_lambda" {
  function_name = "${var.project_tag}-get-materias"

  s3_bucket = "${aws_s3_bucket.app.id}"
  s3_key = "${aws_s3_bucket_object.get_materias_lambda_file_upload.key}"

  handler = "index.handler"
  runtime = "nodejs12.x"
  memory_size = "${var.lambda_memory_size}"
  timeout = "${var.lambda_timeout}"

  role = "${aws_iam_role.lambda_iam_role.arn}"

  environment {
    variables = {
      api_key = "${var.lambda_api_key}"
    }
  }

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

resource "aws_lambda_permission" "api_gateway_invoke_get_materias_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get_materias_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_deployment.lambdaarch_api_gateway_deployment.execution_arn}/*/*"

}

data "archive_file" "get_comentarios_lambda_zip_file" {
  type        = "zip"
  source_dir  = "../src/get-comentarios"
  output_path = "../src/get-comentarios.zip"
  
}

resource "aws_s3_bucket_object" "get_comentarios_lambda_file_upload" {
  bucket = "${aws_s3_bucket.app.id}"
  key    = "get-comentarios.zip"
  source = "${data.archive_file.get_comentarios_lambda_zip_file.output_path}"

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

resource "aws_lambda_function" "get_comentarios_lambda" {
  function_name = "${var.project_tag}-get-comentarios"

  s3_bucket = "${aws_s3_bucket.app.id}"
  s3_key = "${aws_s3_bucket_object.get_comentarios_lambda_file_upload.key}"

  handler = "index.handler"
  runtime = "nodejs12.x"
  memory_size = "${var.lambda_memory_size}"
  timeout = "${var.lambda_timeout}"

  role = "${aws_iam_role.lambda_iam_role.arn}"
  
  environment {
    variables = {
      api_key = "${var.lambda_api_key}"
    }
  }

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

resource "aws_lambda_permission" "api_gateway_invoke_get_comentarios_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get_comentarios_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_deployment.lambdaarch_api_gateway_deployment.execution_arn}/*/*"

}

data "archive_file" "post_comentarios_lambda_zip_file" {
  type        = "zip"
  source_dir  = "../src/post-comentarios"
  output_path = "../src/post-comentarios.zip"
  
}

resource "aws_s3_bucket_object" "post_comentarios_lambda_file_upload" {
  bucket = "${aws_s3_bucket.app.id}"
  key    = "post-comentarios.zip"
  source = "${data.archive_file.post_comentarios_lambda_zip_file.output_path}"

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

resource "aws_lambda_function" "post_comentarios_lambda" {
  function_name = "${var.project_tag}-post-comentarios"

  s3_bucket = "${aws_s3_bucket.app.id}"
  s3_key = "${aws_s3_bucket_object.post_comentarios_lambda_file_upload.key}"

  handler = "index.handler"
  runtime = "nodejs12.x"
  memory_size = "${var.lambda_memory_size}"
  timeout = "${var.lambda_timeout}"

  role = "${aws_iam_role.lambda_iam_role.arn}"

  environment {
    variables = {
      api_key = "${var.lambda_api_key}"
    }
  }

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

resource "aws_lambda_permission" "api_gateway_invoke_post_comentarios_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.post_comentarios_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_deployment.lambdaarch_api_gateway_deployment.execution_arn}/*/*"

}