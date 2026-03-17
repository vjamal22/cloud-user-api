import joblib
from sklearn.linear_model import LogisticRegression
import numpy as np

# Dummy training data
# Example: [age, workout_days_per_week]
X = np.array([
    [25, 3],
    [40, 1],
    [30, 5],
    [22, 4],
    [50, 1],
])

# Target: 1 = high intensity plan, 0 = low intensity plan
y = np.array([1, 0, 1, 1, 0])

# Train simple model
model = LogisticRegression()
model.fit(X, y)

# Save model
joblib.dump(model, "model.joblib")

print("Model trained and saved as model.joblib")
