import json
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("user_profiles")

def lambda_handler(event, context):
    body = json.loads(event.get("body", "{}"))

    user_id = body.get("user_id")
    profile_data = body.get("profile_data")

    if not user_id or not profile_data:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "message": "Missing user_id or profile_data"
            })
        }

    try:
        table.put_item(
            Item={
                "user_id": user_id,
                "profile_data": profile_data
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "User profile stored successfully"
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": str(e)
            })
        }
