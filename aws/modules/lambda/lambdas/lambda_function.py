import json
import os
import boto3

environment = os.getenv("ENVIRONMENT")  # default to "dev" if not set
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(f"{environment}-table")

def lambda_handler(event, context):
    # Generate the data to be inserted
    item = {
        "id": "123",  # Example primary key
        "message": "Hello from Lambda to DynamoDB"
    }

    try:
        # Insert the item into DynamoDB
        table.put_item(Item=item)
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Item inserted into DynamoDB", "data": item})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Failed to insert item", "error": str(e)})
        }
