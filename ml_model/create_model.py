import xgboost as xgb
import numpy as np
import tarfile

# create dummy data
X = np.random.rand(20,3)
y = np.random.rand(20)

dtrain = xgb.DMatrix(X, label=y)

params = {
    "objective": "reg:squarederror"
}

# train model using Booster API
model = xgb.train(params, dtrain)

# save model
model.save_model("xgboost-model")

# create tar.gz artifact for SageMaker
with tarfile.open("model.tar.gz", "w:gz") as tar:
    tar.add("xgboost-model")

print("Model artifact created successfully")