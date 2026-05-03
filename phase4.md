\# Phase 4: Media Upload and AI Analysis



This phase implements media upload and AI-based image analysis using AWS services. Users upload an image, which is processed by a Lambda function using AWS Rekognition, and results are stored in DynamoDB.



\## Architecture



Client → API Gateway → Lambda → S3 → Rekognition → DynamoDB → Response



\## Completed Features



\- Created S3 bucket for media storage

\- Created POST /upload endpoint

\- Connected API Gateway to Lambda

\- Integrated AWS Rekognition

\- Stored analysis results in DynamoDB

\- Added error handling

\- Tested success and failure cases



\## Testing Summary



\- Missing image\_name returns 400

\- Invalid image name returns 500

\- Valid image returns 200 with Rekognition labels







