import boto3
import csv
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    raw_bucket = event['Records'][0]['s3']['bucket']['name']
    raw_key = event['Records'][0]['s3']['object']['key']
    processed_bucket = os.environ['PROCESSED_BUCKET']

    try:
        response = s3.get_object(Bucket=raw_bucket, Key=raw_key)
        lines = response['Body'].read().decode('utf-8').splitlines()

        reader = csv.reader(lines)
        clean_rows = [row for row in reader if any(cell.strip() for cell in row)]

        output = "\n".join([",".join(row) for row in clean_rows])
        processed_key = raw_key.replace("raw", "processed")

    
        s3.put_object(Bucket=processed_bucket, Key=processed_key, Body=output)

        return {
            'statusCode': 200,
            'body': f"File processed and stored at {processed_bucket}/{processed_key}"
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error processing file: {str(e)}"
        }
