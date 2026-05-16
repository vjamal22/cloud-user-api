# Phase 6: Serverless Analytics Dashboard

## Overview

Phase 6 focused on building a serverless analytics and dashboard solution using Amazon Athena, Amazon QuickSight, Amazon S3, and DynamoDB.

The analytics pipeline exports structured activity data from DynamoDB into Amazon S3, where Athena queries the data using SQL. Amazon QuickSight then visualizes the analytics results through interactive dashboards and charts.

---

## Architecture

### Analytics Pipeline Flow

```text
DynamoDB
    ↓
Amazon S3
    ↓
Amazon Athena
    ↓
Amazon QuickSight
    ↓
Analytics Dashboard
```

---

## AWS Services Used

| Service | Purpose |
|---|---|
| Amazon DynamoDB | Stores analytics and activity records |
| Amazon S3 | Stores exported analytics datasets |
| Amazon Athena | Queries exported analytics data using SQL |
| Amazon QuickSight | Creates analytics dashboards and visualizations |
| AWS IAM | Provides secure service permissions |
| Amazon CloudWatch | Supports monitoring and troubleshooting |

---

## Analytics Objectives

The dashboard solution was designed to:
- visualize workout and meal activity trends
- analyze chatbot interactions
- support serverless analytics workflows
- provide scalable dashboard reporting
- demonstrate cloud-native business intelligence architecture

---

## DynamoDB Analytics Dataset

### Table Name

```text
FitnessAnalytics
```

### Example Analytics Records

| userId | activityType | category | timestamp | status |
|---|---|---|---|---|
| user001 | WorkoutIntent | workout | 2026-05-10T10:00:00Z | success |
| user002 | MealIntent | meal | 2026-05-10T10:15:00Z | success |

---

## Export to Amazon S3

Point-in-Time Recovery (PITR) was enabled on DynamoDB to support table export functionality.

Analytics data was exported from DynamoDB into Amazon S3 using:
- Full export
- DynamoDB JSON format
- Server-side encryption (SSE-S3)

---

## Amazon Athena Configuration

### Athena Database

```sql
CREATE DATABASE fitness_analytics;
```

### Athena External Table

```sql
CREATE EXTERNAL TABLE fitness_events (
  userId string,
  activityType string,
  category string,
  timestamp string,
  status string
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://fitness-analytics-data-vjamal22/';
```

---

## Example Athena Queries

### Show Databases

```sql
SHOW DATABASES;
```

### Query Analytics Records

```sql
SELECT * FROM fitness_events;
```

---

## Amazon QuickSight Integration

Amazon QuickSight was connected to:
- Amazon Athena
- Amazon S3 analytics data
- Athena external tables

QuickSight datasets were configured using:
```text
fitness_events
```

An interactive dashboard sheet was created to support analytics visualization.

---

## Dashboard Metrics

The analytics dashboard was designed to track:
- total chatbot interactions
- workout-related requests
- meal-related requests
- successful request activity
- user activity trends over time

---

## Challenges & Solutions

### Challenge: QuickSight permission errors

Solution:
Configured QuickSight AWS resource permissions for Athena and S3 access.

---

### Challenge: No Athena tables visible in QuickSight

Solution:
Created Athena external table definitions connected to exported S3 datasets.

---

### Challenge: Null visualization values

Solution:
Identified nested DynamoDB JSON structures causing incomplete visualization rendering during Athena and QuickSight integration.

---

## Testing Completed

| Test | Result |
|---|---|
| DynamoDB export to S3 | Passed |
| Athena configuration | Passed |
| Athena SQL queries | Passed |
| Athena external table creation | Passed |
| QuickSight integration | Passed |
| Dashboard visualization workflow | Passed |
| Analytics pipeline validation | Passed |

---

## Cost Review

The analytics architecture uses fully serverless AWS services to minimize infrastructure management and operational cost.

### Cost-Efficient Services Used

- Amazon Athena: pay-per-query pricing
- Amazon S3: low-cost object storage
- Amazon QuickSight: lightweight dashboard usage
- DynamoDB: scalable serverless NoSQL storage

This architecture supports scalable analytics while maintaining low operational overhead.

---

## Summary

Phase 6 successfully implemented a serverless cloud analytics pipeline using DynamoDB, Amazon S3, Athena, and QuickSight.

The analytics architecture can:
- export operational data into S3
- query analytics data using SQL
- support interactive dashboard visualizations
- provide scalable serverless reporting workflows
- demonstrate cloud-native analytics engineering concepts