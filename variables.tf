variable "aws_region" {
  description = "AWS region name"
}

variable "lambda_source" {
  description = "Lambda source code path"
}

variable "lambda_package" {
  description = "Lambda destination package path"
}
variable "lambda_name" {
  description = "Lambda Function name"
}

variable "lambda_handler" {
  description = "Lambda handler"
}

variable "lambda_memory_size" {
  description = "Lambda function memory"
}

variable "lambda_runtime" {
  description = "Lambda function runtime"
}

variable "lambda_timeout" {
  description = "Lambda function timeout"
}

variable "description" {
  description = "Lambda function description"
}
