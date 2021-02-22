provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "appsync_admin_access_role" {
  name = "appsync_admin_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    },
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "appsync.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "appsync_admin_access_role_policy" {
  name = "appsync_admin_access_role_policy"
  role = aws_iam_role.appsync_admin_access_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_appsync_graphql_api" "tf_api" {
  authentication_type = "API_KEY"
  name                = "tf_api"

  schema = file("schema.graphql")

  log_config {
    exclude_verbose_content = false
    cloudwatch_logs_role_arn = aws_iam_role.appsync_admin_access_role.arn
    field_log_level = "ALL"
  }
}

resource "aws_appsync_api_key" "tf_api_key" {
  api_id      = aws_appsync_graphql_api.tf_api.id  
  depends_on = [
    aws_appsync_graphql_api.tf_api,
  ]
}
