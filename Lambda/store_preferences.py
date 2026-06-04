import json

CORS_HEADERS = {
    "Access-Control-Allow-Origin": "http://localhost:5173",
    "Access-Control-Allow-Headers": "Content-Type,Authorization",
    "Access-Control-Allow-Methods": "OPTIONS,POST",
}

def lambda_handler(event, context):

    body = json.loads(event.get("body", "{}"))

    user_id = body.get("user_id")
    profile_data = body.get("profile_data")

    if not user_id or not profile_data:
        return {
            "statusCode": 400,
            "headers": CORS_HEADERS,
            "body": json.dumps({
                "message": "Missing user_id or profile_data"
            })
        }

    return {
        "statusCode": 200,
        "headers": CORS_HEADERS,
        "body": json.dumps({
            "message": "User profile stored successfully"
        })
    }