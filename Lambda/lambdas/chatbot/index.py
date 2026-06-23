import json


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
    body = json.loads(event.get("body", "{}"))
    message = body.get("message", "")

    if not message:
        return build_response(400, {
            "error": "message is required"
        })

    return build_response(200, {
        "reply": "Thanks for your message. This response came from the chatbot Lambda."
    })