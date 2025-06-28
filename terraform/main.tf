provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_role" "lambda_exec" {
  name = "lambda-csv-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "lambda-s3-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::csv-raw-data-proj/*",
          "arn:aws:s3:::csv-processed-data-proj/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}


resource "aws_lambda_function" "csv_cleaner" {
  function_name = "csv-cleaner"
  filename      = "${path.module}/lambda/function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/function.zip")
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      PROCESSED_BUCKET = "csv-processed-data-proj"
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_cleaner.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::csv-raw-data-proj"
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = "csv-raw-data-proj"

  lambda_function {
    lambda_function_arn = aws_lambda_function.csv_cleaner.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}


resource "aws_iam_role" "glue_role" {
  name = "glue-csv-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "glue_s3_policy" {
  name = "glue-s3-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.processed_bucket}",
          "arn:aws:s3:::${var.final_bucket}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.processed_bucket}/*",
          "arn:aws:s3:::${var.final_bucket}/*"
        ]
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "glue_policy_attach" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_s3_policy.arn
}


resource "aws_glue_job" "csv_etl" {
  name     = "csv-etl-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://csv-processed-data-proj/scripts/etl_script.py"
    python_version  = "3"
  }

  glue_version        = "4.0"
  number_of_workers   = 2
  worker_type         = "G.1X"
  max_retries         = 0
  timeout             = 10
}
