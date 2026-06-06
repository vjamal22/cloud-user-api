import json
import uuid
import boto3

s3 = boto3.client("s3")

BUCKET_NAME = "fitness-app-media-jamalv-2026"


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
    try:
        body = json.loads(event.get("body", "{}"))

        file_name = body.get("file_name")
        file_type = body.get("file_type", "image/png")

        if not file_name:
            return build_response(400, {
                "error": "file_name is required"
            })

        safe_file_name = file_name.replace(" ", "_")
        object_key = f"uploads/{uuid.uuid4()}-{safe_file_name}"

        upload_url = s3.generate_presigned_url(
            ClientMethod="put_object",
            Params={
                "Bucket": BUCKET_NAME,
                "Key": object_key,
                "ContentType": file_type
            },
            ExpiresIn=300
        )

        return build_response(200, {
            "upload_url": upload_url,
            "image_name": object_key
        })

    except Exception as e:
        return build_response(500, {
            "error": str(e)
        })