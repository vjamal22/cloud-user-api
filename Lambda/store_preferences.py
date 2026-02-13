import json
import boto3
import os

# Initialize DynamoDB client
dynamodb = boto3.resource("dynamodb")
table_name = os.environ.get("TABLE_NAME", "user_preferences")
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    """
    Step 3.4 - Validate and store preferences in DynamoDB.
    """
    try:
        # 1️⃣ Parse JSON body
        body = json.loads(event.get("body", "{}"))

        goals = body.get("goals")
        mood = body.get("mood")
        injuries = body.get("injuries")
        allergies = body.get("allergies")

        # 2️⃣ Validate fields
        if not all([goals, mood, injuries, allergies]):
            return {
                "statusCode": 400,
                "body": json.dumps({
                    "error": "Missing required fields: goals, mood, injuries, allergies"
                })
            }

        # 3️⃣ Extract user ID (from Cognito auth)
        # In a real API, this comes from the requestContext when user is authenticated.
        user_id = event.get("requestContext", {}).get("authorizer", {}).get("claims", {}).get("sub")

if not user_id:
    return {
        "statusCode": 401,
        "body": json.dumps({"error": "Unauthorized"})
    }

        # 4️⃣ Store item in DynamoDB
        table.put_item(
            Item={
                "user_id": user_id,
                "goals": goals,
                "mood": mood,
                "injuries": injuries,
                "allergies": allergies
            }
        )

        # 5️⃣ Return success
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "User preferences saved successfully"})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
