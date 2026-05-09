import json
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("FitnessBotResponses")


def lambda_handler(event, context):
    print(json.dumps(event))

    intent_name = event["sessionState"]["intent"]["name"]

    response = table.get_item(
        Key={
            "intentName": intent_name
        }
    )

    item = response.get("Item")

    if item:
        message = item["response"]
    else:
        message = "Sorry, I do not have a response for that request yet."

    return {
        "sessionState": {
            "dialogAction": {
                "type": "Close"
            },
            "intent": {
                "name": intent_name,
                "state": "Fulfilled"
            }
        },
        "messages": [
            {
                "contentType": "PlainText",
                "content": message
            }
        ]
    }