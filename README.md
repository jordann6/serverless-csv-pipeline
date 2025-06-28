Serverless CSV Data Pipeline (AWS)

This project is a fully serverless pipeline that processes CSV files uploaded to an S3 bucket and transforms them into Parquet format using AWS Glue.

What It Does
A CSV file is uploaded to an S3 bucket (csv-raw-data-proj)
An AWS Lambda function automatically cleans or processes the file
The cleaned file is saved to another S3 bucket (csv-processed-data-proj)
AWS Glue performs ETL on the processed data and saves it to a final bucket (csv-final-data-proj) in Parquet format

Tools and Services Used
AWS S3 – for storage of raw, processed, and final datasets
AWS Lambda – for automatic processing of uploaded CSVs
AWS Glue – for serverless ETL (Extract, Transform, Load)
Terraform – to automate infrastructure setup
Python – for Lambda and Glue scripting
Visual Studio Code – local development environment
AWS CLI – for triggering Glue jobs and uploading test files

How I Built It
This project was built as part of my self-study journey in cloud engineering. I referenced AWS documentation, experimented with tutorials on YouTube, and did a lot of trial and error to get everything working smoothly.

Everything was built from scratch locally and deployed using Terraform. It helped me get hands-on practice with automation, permissions, and working across multiple AWS services.

The overall goal of this project was to build a fully automated serverless data pipeline using AWS services to ingest, transform, and store CSV data without relying on traditional servers. The purpose was to demonstrate practical cloud skills by designing and deploying a real world ETL pipeline using tools like AWS Lambda, S3, and Glue, while managing all infrastructure with Terraform for repeatability and automation. This project served as both a learning opportunity and a portfolio piece, showcasing the ability to integrate AWS services, configure IAM roles and permissions, and handle structured data processing through clean and scalable architecture. It also introduced key data engineering concepts such as ingesting raw files, cleaning and transforming data, and optimizing it for storage in columnar format using Parquet. Ultimately, the project highlights proficiency in cloud automation, serverless design, and infrastructure as code, making it a strong example of production ready cloud engineering.
