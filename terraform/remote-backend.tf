terraform {
  backend "s3" {
    encrypt = true
    bucket  = "lambda-arch-tf"
    key     = "lambda-arch-tadeu-mendonca.tfstate"
    region  = "us-east-1"
  }
}

