import requests
import json

url = "https://lu4xapp41c.execute-api.us-east-1.amazonaws.com/dev/users"
headers = {"Content-Type": "application/json"}

# CORRECT format for your Lambda
payload = {
    "user_id": "testuser001",
    "profile_data": {
        "goal": "muscle gain",
        "mood": "motivated",
        "allergies": "none"
    }
}

print("Sending JSON:", json.dumps(payload))

response = requests.post(url, headers=headers, json=payload)
print("Status Code:", response.status_code)
print("Response Body:", response.text)
