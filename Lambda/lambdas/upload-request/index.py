import json
import boto3

rekognition = boto3.client("rekognition")
dynamodb = boto3.resource("dynamodb")

table = dynamodb.Table("analysis_results")


def build_response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "Content-Type,Authorization",
            "Access-Control-Allow-Methods": "OPTIONS,POST"
        },
        "body": json.dumps(body)
    }


def lambda_handler(event, context):
    bucket_name = "fitness-app-media-jamalv-2026"

    body = json.loads(event.get("body", "{}"))
    image_name = body.get("image_name")

    if not image_name:
        return build_response(400, {
            "error": "image_name is required"
        })

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

        return build_response(200, {
            "message": "Analysis complete",
            "labels": labels
        })

    except Exception as e:
        return build_response(500, {
            "error": str(e)
        })