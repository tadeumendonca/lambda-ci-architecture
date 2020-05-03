resource "aws_dynamodb_table" "lambdaarch_comentarios_dynamodb_table" {
  name = "Comentarios"
  read_capacity = "${var.dynamo_db_read_capacity}"
  write_capacity = "${var.dynamo_db_write_capacity}"
  hash_key = "materia"
  range_key = "timestamp"

  attribute {
    name = "materia"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  # provisioner "local-exec" {
  #   command = "aws dynamodb batch-write-item --request-items file://dynamo/comentarios.json "
  # }

  tags = {
    Environment = var.environment_tag
    Name        = var.project_tag
  }
}

