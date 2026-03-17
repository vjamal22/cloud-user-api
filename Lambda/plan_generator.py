import json

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
        "body": json.dumps({
            "workout_plan": workout_plan,
            "meal_plan": meal_plan
        })
    }