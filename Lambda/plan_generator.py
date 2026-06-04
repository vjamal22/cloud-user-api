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

    workout_plan = [
        "Day 1: Full Body Workout",
        "Day 2: Cardio",
        "Day 3: Rest",
        "Day 4: Upper Body",
        "Day 5: Lower Body"
    ]

    meal_plan = [
        "Breakfast: Oatmeal and fruit",
        "Lunch: Grilled chicken salad",
        "Dinner: Salmon with vegetables"
    ]

    return {
        "statusCode": 200,
        "headers": CORS_HEADERS,
        "body": json.dumps({
            "workout_plan": workout_plan,
            "meal_plan": meal_plan
        })
    }