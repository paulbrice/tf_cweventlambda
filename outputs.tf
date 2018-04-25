output "lambda_arn" {
  value = "${aws_lambda_function.lambda_function.arn}"
}

output "lambda_name" {
  value = "${aws_lambda_function.lambda_function.function_name}"
}

output "cloudwatchrule_arn" {
  value = "${aws_cloudwatch_event_rule.cloud_watch_rule.arn}"
}

output "cloudwatchrule_name" {
  value = "${aws_cloudwatch_event_rule.cloud_watch_rule.name}"
}
