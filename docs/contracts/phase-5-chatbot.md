# Phase 5: Serverless Fitness Chatbot

## Overview

Phase 5 focused on building a serverless fitness chatbot using Amazon Lex, AWS Lambda, and Amazon DynamoDB.

The chatbot processes workout and meal-related requests from users. Amazon Lex identifies the user intent, AWS Lambda handles the backend fulfilment logic, and DynamoDB stores chatbot responses that are returned to the user through Lex.

---

## Architecture

### Chatbot Flow

```text
User
  ↓
Amazon Lex
  ↓
AWS Lambda
  ↓
Amazon DynamoDB
  ↓
AWS Lambda
  ↓
Amazon Lex
  ↓
User
```

---

## AWS Services Used

| Service | Purpose |
|---|---|
| Amazon Lex | Handles chatbot conversations, intents, and utterances |
| AWS Lambda | Processes chatbot logic and fulfilment |
| Amazon DynamoDB | Stores chatbot responses |
| AWS IAM | Provides secure permissions between AWS services |
| Amazon CloudWatch | Logs Lambda execution and errors |

---

## Lex Intents

### WorkoutIntent

Used when the user requests workout or fitness guidance.

Example utterances:

```text
Give me a workout plan
Suggest a workout
What workout should I do
```

---

### MealIntent

Used when the user requests meal suggestions.

Example utterances:

```text
Suggest a meal plan
Give me a meal plan
What should I eat
```

---

### FallbackIntent

Used when the chatbot receives unsupported or unknown requests.

Example fallback response:

```text
Sorry, I can only help with workout plans and meal plans right now.
```

---

## DynamoDB Configuration

### Table Name

```text
FitnessBotResponses
```

### Partition Key

```text
intentName
```

### Example DynamoDB Records

| intentName | response |
|---|---|
| WorkoutIntent | Here is your workout plan: Day 1 Full Body, Day 2 Cardio, Day 3 Rest, Day 4 Upper Body, Day 5 Lower Body. |
| MealIntent | Here is your meal plan: Oatmeal breakfast, chicken salad lunch, salmon dinner. |

---

## Lambda Fulfilment Logic

AWS Lambda receives the intent name from Amazon Lex, queries DynamoDB using the intent name, retrieves the matching chatbot response, and returns the response back to Lex.

---

## Testing Completed

The chatbot was tested successfully using valid and invalid user inputs.

### Successful Tests

| Test | Result |
|---|---|
| Workout request | Passed |
| Meal request | Passed |
| DynamoDB response retrieval | Passed |
| Lambda fulfilment | Passed |
| End-to-end chatbot flow | Passed |
| Invalid input handling | Passed |
| Edge case testing | Passed |

---

## Example Test Results

### Workout Test

```text
User: give me a workout plan

Bot: Here is your workout plan: Day 1 Full Body, Day 2 Cardio, Day 3 Rest, Day 4 Upper Body, Day 5 Lower Body.
```

---

### Meal Test

```text
User: suggest a meal plan

Bot: Here is your meal plan: Oatmeal breakfast, chicken salad lunch, salmon dinner.
```

---

### Invalid Input Test

```text
User: tell me a joke

Bot: Sorry, I can only help with workout plans and meal plans right now.
```

---

## Cost Review

The chatbot architecture uses serverless AWS services, making the overall deployment cost-efficient and scalable.

### Cost-Efficient AWS Services Used

- Amazon Lex: charged per request
- AWS Lambda: charged per invocation and execution time
- Amazon DynamoDB: charged based on reads and writes
- Amazon CloudWatch: charged based on log storage

This architecture keeps costs low because resources are only used when requests are made.

---

## Summary

Phase 5 successfully implemented a serverless chatbot architecture using Amazon Lex, AWS Lambda, and DynamoDB.

The chatbot can:
- recognise workout and meal-related intents
- retrieve responses dynamically from DynamoDB
- process fulfilment using Lambda
- handle unsupported requests using fallback logic
- support end-to-end conversational flow in a serverless AWS environment