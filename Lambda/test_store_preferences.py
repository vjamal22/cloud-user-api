import json
from store_preferences import lambda_handler

# Simulate an API Gateway event
event = {
    "body": json.dumps({
        "goals": "gain muscle",
        "mood": "motivated",
        "injuries": ["knee"],
        "allergies": ["peanuts"]
    }),
    "requestContext": {
        "authorizer": {
            "claims": {
                "sub": "test-user-123"
            }
        }
    }
}

# Call the Lambda function
response = lambda_handler(event, None)

# Print the response nicely
print(json.dumps(response, indent=4))
