import requests
import json

url = "https://17u9ta4fi2.execute-api.us-east-1.amazonaws.com/dev/upload"
headers = {"Content-Type": "application/json"}

payload = {
    "image_name": "VD 1.png"
}

print("Sending JSON:", json.dumps(payload))

response = requests.post(url, headers=headers, json=payload)
print("Status Code:", response.status_code)
print("Response Body:", response.text)