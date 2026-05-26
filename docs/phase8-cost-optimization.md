# Phase 8 – Cost Optimization Strategy

# Cost Optimization Strategy

## Overview

This phase focused on reviewing and optimizing the operational costs of the AWS Cloud-Native Fitness App. The project uses a serverless architecture designed to remain scalable, lightweight, and cost-efficient while operating primarily within AWS Free Tier limits.

## Cost Optimization Goals

The main goal of Phase 8 is to maintain a low-cost and operationally efficient AWS serverless environment while improving visibility into cloud resource usage and spending.

Key goals include:
- reviewing AWS resource usage
- monitoring cloud spending with AWS Budgets
- optimizing Lambda, DynamoDB, S3, and API Gateway usage
- identifying unused resources
- improving CloudWatch monitoring visibility
- documenting long-term cost optimization strategies

## AWS Resource Usage Review

AWS Billing and Cost Explorer were reviewed to identify active cloud services and potential cost drivers.

Services reviewed:
- AWS Lambda
- API Gateway
- DynamoDB
- S3
- Athena
- CloudWatch
- Lex
- QuickSight
- Secrets Manager

The review confirmed that most serverless services currently operate within low-cost or AWS Free Tier limits.

## AWS Free Tier Usage

AWS Free Tier usage was reviewed across multiple services including Lambda, CloudWatch, Lex, Glue, X-Ray, and Key Management Service.

The serverless architecture currently operates primarily within AWS Free Tier allowances, supporting low operational cost for development and testing workloads.

## AWS Budgets and Alerts

An AWS monthly budget was configured to monitor cloud spending.

Budget configuration:
- Monthly budget: $5
- Budget health monitoring enabled
- Actual and forecasted spending alerts configured

Configured alerts:
- 85% actual cost threshold
- 100% forecasted cost threshold
- 100% actual cost threshold

## Lambda Cost Optimization

Lambda functions were reviewed to evaluate:
- memory allocation
- timeout settings
- runtime configuration
- serverless operational efficiency

Current Lambda configuration:
- Runtime: Python 3.11
- Memory allocation: 128 MB
- Timeout: 30 seconds

These settings support lightweight and cost-efficient serverless execution.

## DynamoDB Cost Optimization

DynamoDB tables were reviewed for:
- storage usage
- capacity mode
- scaling configuration

All DynamoDB tables currently use:
- On-demand capacity mode

This configuration supports low-cost serverless scaling by charging only for actual usage.

## S3 Cost Optimization

S3 buckets were reviewed for:
- unused storage
- analytics storage
- deployment artifacts
- upload storage usage

Potential cleanup opportunities were identified for:
- unused buckets
- older development resources
- unnecessary storage artifacts

## API Gateway Cost Optimization

API Gateway usage was reviewed to evaluate serverless API operational costs.

Current configuration:
- REST APIs
- Edge-optimized endpoints

HTTP APIs were identified as a possible future cost optimization because they are generally lower cost than REST APIs for lightweight serverless workloads.

## Analytics Service Cost Review

Athena and QuickSight services were reviewed.

Findings:
- Athena usage remains low-cost with lightweight query activity
- QuickSight usage is primarily experimental and learning-focused
- analytics services are not currently major cost drivers

## CloudWatch Monitoring Review

CloudWatch log groups and monitoring resources were reviewed.

Several log groups were configured with:
- Never expire retention settings

This was identified as a potential long-term cost optimization opportunity because unlimited log retention can increase storage costs over time.

## GitHub Actions CI/CD Cost Review

GitHub Actions workflow usage was reviewed.

Findings:
- lightweight Terraform CI/CD workflows
- short execution durations
- low operational CI/CD cost impact

## Unused Resource Review

Potential unused resources identified:
- duplicate API Gateway APIs
- unused S3 buckets
- old CloudWatch log groups
- older SageMaker and ECS logging resources

These resources may be reviewed later for cleanup and further cost optimization.

## Scalability vs Cost Considerations

The serverless architecture provides:
- automatic scaling
- low infrastructure management overhead
- pay-per-use pricing

This architecture supports cost-efficient scaling while minimizing operational complexity for the fitness application.

## Conclusion

Phase 8 focused on improving financial visibility, operational monitoring, and cost awareness across the AWS Cloud-Native Fitness App infrastructure.

The review confirmed that the application currently operates with very low serverless infrastructure costs while maintaining scalability and cloud-native architectural benefits.