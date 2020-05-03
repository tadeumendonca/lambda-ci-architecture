resource "aws_api_gateway_rest_api" "lambdaarch_api_gateway" {
  name        = "${var.project_tag}-api"
  description = "Application APIs"
  body        = "${data.template_file.lambdaarch_api_swagger.rendered}"

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

data "template_file" lambdaarch_api_swagger{
  template = "${file("swagger/swagger.yaml")}"

  vars = {
    get_materias_arn = "${aws_lambda_function.get_materias_lambda.invoke_arn}",
    get_comentarios_arn = "${aws_lambda_function.get_comentarios_lambda.invoke_arn}"
    post_comentarios_arn = "${aws_lambda_function.post_comentarios_lambda.invoke_arn}"
  }
}

resource "aws_api_gateway_deployment" "lambdaarch_api_gateway_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.lambdaarch_api_gateway.id}"
  stage_name  = "${var.api_gtw_stage_name}"
}

resource "aws_api_gateway_method_settings" "_" {
  rest_api_id = aws_api_gateway_rest_api.lambdaarch_api_gateway.id
  stage_name  = aws_api_gateway_deployment.lambdaarch_api_gateway_deployment.stage_name
  method_path = "*/*"

  settings {
    throttling_burst_limit = var.api_gtw_throttling_burst_limit
    throttling_rate_limit  = var.api_gtw_throttling_rate_limit
    metrics_enabled        = var.api_gtw_metrics_enabled
    logging_level          = var.api_gtw_logging_level
    data_trace_enabled     = var.api_gtw_data_trace_enabled
  }
}

output "endpoint" {
  value = "${aws_api_gateway_deployment.lambdaarch_api_gateway_deployment.invoke_url}"
}

