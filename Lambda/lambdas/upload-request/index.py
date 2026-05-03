import json
import boto3

rekognition = boto3.client("rekognition")
dynamodb = boto3.resource("dynamodb")

table = dynamodb.Table("analysis_results")

def lambda_handler(event, context):
    bucket_name = "fitness-app-media-jamalv-2026"

    body = json.loads(event.get("body", "{}"))
    image_name = body.get("image_name")

    if not image_name:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "error": "image_name is required"
            })
        }

    try:
        response = rekognition.detect_labels(
            Image={
                "S3Object": {
                    "Bucket": bucket_name,
                    "Name": image_name
                }
            },
            MaxLabels=5
        )

        labels = [
            {
                "name": label["Name"],
                "confidence": str(round(label["Confidence"], 2))
            }
            for label in response["Labels"]
        ]

        table.put_item(
            Item={
                "analysis_id": context.aws_request_id,
                "labels": labels
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Analysis complete",
                "labels": labels
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": str(e)
            })
        }