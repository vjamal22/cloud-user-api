import json

CORS_HEADERS = {
    "Access-Control-Allow-Origin": "http://localhost:5173",
    "Access-Control-Allow-Headers": "Content-Type,Authorization",
    "Access-Control-Allow-Methods": "OPTIONS,POST",
}

DISCLAIMER = (
    "This fitness and meal plan is general guidance only. "
    "Consult a qualified health professional before starting a new exercise or diet plan, "
    "especially if you have injuries, allergies, medical conditions, or dietary restrictions."
)

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

    goal = profile_data.get("goal", "").lower()
    activity_level = profile_data.get("activity_level", "").lower()

    if goal == "weight loss":
        workout_plan = [
            """Day 1: HIIT Cardio
- Warm-up: 5–10 minutes brisk walking
- Jumping Jacks: 3 sets x 30 seconds
- Mountain Climbers: 3 sets x 30 seconds
- Bodyweight Squats: 3 sets x 12 reps
- Rest: 45–60 seconds between rounds
- Cooldown: 5 minutes stretching
""",
            """Day 2: Full Body Circuit
- Warm-up: 5–10 minutes dynamic stretching
- Push-ups: 3 sets x 8–12 reps
- Walking Lunges: 3 sets x 10 reps per leg
- Plank: 3 sets x 30–45 seconds
- Glute Bridges: 3 sets x 12 reps
- Rest: 60 seconds between rounds
- Cooldown: 5 minutes stretching
""",
            """Day 3: Walking and Mobility
- Brisk Walk: 30–45 minutes
- Hip Circles: 2 sets x 10 each side
- Shoulder Rolls: 2 sets x 15 reps
- Hamstring Stretch: 2 sets x 30 seconds
- Focus: Recovery, movement quality, and consistency
""",
            """Day 4: HIIT Cardio
- Warm-up: 5–10 minutes light cardio
- High Knees: 3 sets x 30 seconds
- Burpees: 3 sets x 8–10 reps
- Skaters: 3 sets x 30 seconds
- Bicycle Crunches: 3 sets x 20 reps
- Rest: 45–60 seconds between rounds
- Cooldown: 5 minutes slow walking and stretching
""",
            """Day 5: Strength Training
- Warm-up: 5–10 minutes mobility work
- Goblet Squats or Bodyweight Squats: 3 sets x 10–12 reps
- Dumbbell Rows or Backpack Rows: 3 sets x 10 reps
- Romanian Deadlifts: 3 sets x 10 reps
- Plank: 3 sets x 30–45 seconds
- Rest: 60–90 seconds between sets
- Cooldown: 5 minutes stretching
"""
        ]

        meal_plan = [
            """Breakfast: Greek Yogurt Bowl
- Ingredients: Greek yogurt, mixed berries, chia seeds, small handful of oats
- Goal: High-protein, filling breakfast
""",
            """Lunch: Grilled Chicken Salad
- Ingredients: Chicken breast, mixed salad leaves, cucumber, tomato, avocado, olive oil dressing
- Goal: Lean protein with fibre and healthy fats
""",
            """Dinner: Salmon and Vegetables
- Ingredients: Salmon fillet, broccoli, carrots, courgette, small portion of brown rice
- Goal: Protein-rich dinner with controlled carbohydrates
""",
            """Snack: Apple with Peanut Butter
- Ingredients: 1 apple, 1 tablespoon peanut butter
- Goal: Balanced snack to reduce cravings
"""
        ]

    elif goal == "muscle gain":
        workout_plan = [
            """Day 1: Chest and Triceps
- Warm-up: 5–10 minutes light cardio and shoulder mobility
- Push-ups or Bench Press: 4 sets x 8–12 reps
- Incline Dumbbell Press: 3 sets x 8–10 reps
- Tricep Dips: 3 sets x 10–12 reps
- Overhead Tricep Extension: 3 sets x 10 reps
- Rest: 90 seconds between sets
- Cooldown: Chest and arm stretching
""",
            """Day 2: Back and Biceps
- Warm-up: 5–10 minutes mobility work
- Pull-ups or Lat Pulldowns: 4 sets x 8–10 reps
- Dumbbell Rows: 3 sets x 10 reps each side
- Seated Row or Resistance Band Row: 3 sets x 10–12 reps
- Bicep Curls: 3 sets x 10–12 reps
- Rest: 90 seconds between sets
- Cooldown: Back and bicep stretching
""",
            """Day 3: Legs
- Warm-up: 5–10 minutes light cardio
- Squats: 4 sets x 8–12 reps
- Romanian Deadlifts: 3 sets x 8–10 reps
- Walking Lunges: 3 sets x 10 reps per leg
- Calf Raises: 3 sets x 15 reps
- Rest: 90–120 seconds between sets
- Cooldown: Lower-body stretching
""",
            """Day 4: Shoulders and Core
- Warm-up: Shoulder circles and light cardio
- Shoulder Press: 4 sets x 8–10 reps
- Lateral Raises: 3 sets x 12 reps
- Front Raises: 3 sets x 10 reps
- Plank: 3 sets x 45 seconds
- Russian Twists: 3 sets x 20 reps
- Rest: 60–90 seconds between sets
- Cooldown: Shoulder and core stretching
""",
            """Day 5: Full Body Strength
- Warm-up: 5–10 minutes dynamic movement
- Deadlifts or Hip Hinges: 4 sets x 6–8 reps
- Push-ups or Chest Press: 3 sets x 10 reps
- Rows: 3 sets x 10 reps
- Squats: 3 sets x 10 reps
- Farmer's Carry: 3 rounds x 30 seconds
- Rest: 90 seconds between sets
- Cooldown: Full-body stretching
"""
        ]

        meal_plan = [
            """Breakfast: Eggs and Oats
- Ingredients: Eggs, oats, banana, milk or plant milk, peanut butter
- Goal: High-calorie, high-protein breakfast
""",
            """Lunch: Chicken, Rice and Vegetables
- Ingredients: Chicken breast or thighs, rice, broccoli, peppers, olive oil
- Goal: Protein and carbohydrates for muscle recovery
""",
            """Dinner: Steak and Sweet Potatoes
- Ingredients: Lean steak, sweet potatoes, green vegetables, olive oil
- Goal: Protein-rich meal with quality carbohydrates
""",
            """Snack: Protein Smoothie
- Ingredients: Protein powder or Greek yogurt, banana, oats, milk, peanut butter
- Goal: Extra calories and protein between meals
"""
        ]

    else:
        workout_plan = [
            """Day 1: Full Body Workout
- Warm-up: 5–10 minutes light cardio
- Squats: 3 sets x 10 reps
- Push-ups: 3 sets x 8–12 reps
- Rows: 3 sets x 10 reps
- Plank: 3 sets x 30 seconds
- Cooldown: 5 minutes stretching
""",
            """Day 2: Cardio
- Brisk walk, cycling, or jogging: 30 minutes
- Keep intensity moderate
- Cooldown: 5 minutes slow walking
""",
            """Day 3: Rest and Mobility
- Gentle stretching: 10–15 minutes
- Focus on recovery and hydration
""",
            """Day 4: Upper Body
- Push-ups: 3 sets x 8–12 reps
- Rows: 3 sets x 10 reps
- Shoulder Press: 3 sets x 10 reps
- Bicep Curls: 3 sets x 12 reps
""",
            """Day 5: Lower Body
- Squats: 3 sets x 10–12 reps
- Lunges: 3 sets x 10 reps per leg
- Glute Bridges: 3 sets x 12 reps
- Calf Raises: 3 sets x 15 reps
"""
        ]

        meal_plan = [
            "Breakfast: Oatmeal with fruit and Greek yogurt",
            "Lunch: Grilled chicken salad with wholegrain bread",
            "Dinner: Salmon with vegetables and rice",
            "Snack: Nuts, fruit, or yogurt"
        ]

    if activity_level == "high":
        workout_plan.append(
            """Bonus Day: Endurance Training
- Activity: Jogging, cycling, swimming, or rowing
- Duration: 30–45 minutes
- Intensity: Moderate pace
- Goal: Improve cardiovascular fitness and stamina
- Cooldown: 5–10 minutes stretching
"""
        )

    return {
        "statusCode": 200,
        "headers": CORS_HEADERS,
        "body": json.dumps({
            "workout_plan": workout_plan,
            "meal_plan": meal_plan,
            "hydration": "Aim to drink water regularly throughout the day, especially before and after workouts.",
            "disclaimer": DISCLAIMER
        })
    }