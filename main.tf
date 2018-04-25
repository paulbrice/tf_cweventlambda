data "archive_file" "source_file" {
  type        = "zip"
  source_file = "${var.lambda_source}"
  output_path = "${var.lambda_package}"
}

# template file for lambda role trust
data "template_file" "config_role_trust_policy_tpl" {
  template = "${file("${path.module}/policies/lambda-role-trust-policy.tpl")}"
}

# template file for lambda role policy
data "template_file" "lambda_role_policy_tpl" {
  template = "${file("${path.module}/policies/lambda-role-policy.tpl")}"
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "cwr-${var.function_name}-role"

  assume_role_policy = "${data.template_file.lambda_role_trust_policy_tpl.rendered}"
}

resource "aws_iam_role_policy" "lambda_iam_policy" {
  name = "cwr-${var.function_name}-policy"
  role = "${aws_iam_role.lambda_iam_role.id}"

  policy = "${data.template_file.lambda_role_policy_tpl.rendered}"
}

resource "aws_lambda_function" "lambda_function" {
  depends_on = ["data.archive_file.source_file"]
  filename      = "${var.lambda_package}"
  function_name = "${var.lambda_name}"
  role          = "${aws_iam_role.lambda_iam_role.arn}"
  handler       = "${var.lambda_handler}"
  source_code_hash = "${data.archive_file.source_file.output_base64sha256}"
  runtime       = "${var.lambda_runtime}"
  memory_size   = "${var.lambda_memory_size}"
  timeout       = "${var.lambda_timeout}"
  description   = "${var.lambda_description}"
  publish = true
  environment {
  }
}

resource "aws_cloudwatch_event_rule" "cloud_watch_rule" {
  name        = "Enforce_IAMAccountPasswordPolicy"
  description = "Enforce_IAMAccountPasswordPolicy"
  is_enabled = true

  event_pattern = <<PATTERN
{

}
PATTERN
}

resource "aws_cloudwatch_event_target" "target_lambda" {
  rule      = "${aws_cloudwatch_event_rule.cloud_watch_rule.name}"
  target_id = "Invoke_Lambda"
  arn       = "${aws_lambda_function.lambda_function.arn}"
}

resource "aws_lambda_permission" "cloud_watch_rule_permision" {
  statement_id = "cwrule-invokelambda"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.cloud_watch_rule.arn}"
}
