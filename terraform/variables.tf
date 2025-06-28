variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "raw_bucket" {
  description = "S3 bucket name for raw CSV uploads"
  type        = string
  default     = "csv-raw-data-proj"
}

variable "processed_bucket" {
  description = "S3 bucket name for Lambda output"
  type        = string
  default     = "csv-processed-data-proj"
}

variable "final_bucket" {
  description = "S3 bucket name for Glue ETL output"
  type        = string
  default     = "csv-final-data-proj"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "csv-cleaner"
}

variable "glue_job_name" {
  description = "AWS Glue job name"
  type        = string
  default     = "csv-etl-job"
}

variable "glue_script_path" {
  description = "S3 path to Glue ETL script"
  type        = string
  default     = "s3://csv-processed-data-proj/scripts/etl_script.py"
}
