import requests
import json

url = "https://lu4xapp41c.execute-api.us-east-1.amazonaws.com/dev/users"
headers = {"Content-Type": "application/json"}

data = {
    "user_id": "user123",
    "profile_data": {
        "goal": "muscle gain",
        "mood": "motivated"
    }
}

print("Sending JSON:", json.dumps(data))  # Debug line

response = requests.post(url, json=data)
print("Status Code:", response.status_code)
print("Response Body:", response.text)
