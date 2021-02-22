resource "aws_lambda_function" "books_lambda" {
  filename      = "bundles/books_lambda.zip"
  function_name = "books_lambda"
  role          = aws_iam_role.appsync_admin_access_role.arn
  handler       = "books_lambda.handler"
  source_code_hash = filebase64sha256("bundles/books_lambda.zip")

  runtime = "nodejs14.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_appsync_datasource" "books_lambda_datasource" {
  type = "AWS_LAMBDA"
  name = "books_lambda_datasource"
  api_id = aws_appsync_graphql_api.tf_api.id
  service_role_arn = aws_iam_role.appsync_admin_access_role.arn

  lambda_config {
    function_arn = aws_lambda_function.books_lambda.arn
  }
}

resource "aws_appsync_resolver" "books_lambda_datasource_resolver" {
  api_id = aws_appsync_graphql_api.tf_api.id
  type        = "Query"
  field       = "books"
  data_source = aws_appsync_datasource.books_lambda_datasource.name
  kind = "UNIT"
  request_template = file("request_template.vtl")
  response_template = file("response_template.vtl")
}
