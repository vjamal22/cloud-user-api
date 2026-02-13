Phase 2 – Secure User Preferences Architecture

Cloud-Native Fitness Experience

1. Executive Summary

Phase 2 introduces secure, identity-aware data ingestion to the platform. While Phase 1 established the foundational serverless infrastructure, Phase 2 focuses on enforcing authentication, validating structured domain input, and persisting user-specific preference data in a secure and cost-efficient manner.

This phase transitions the system from infrastructure-ready to personalization-ready.

2. Problem Statement

After Phase 1, the platform had authentication, API routing, compute, and storage in place. However, it lacked:

Enforced identity-bound data persistence

Structured domain validation

Controlled write access

Cost-conscious access patterns

Clean data preparation for future ML integration

Phase 2 addresses these gaps by introducing an authenticated preferences ingestion layer.

3. Architectural Evolution

The architecture remains serverless and event-driven:

Client → Cognito → API Gateway → Lambda → DynamoDB

The advancement in Phase 2 is enforcement, not service expansion.

Key enhancement:
Integration of a Cognito User Pool authorizer at API Gateway level to reject unauthorized requests before compute execution.

4. Security Model
Edge Authentication

API Gateway integrates a Cognito User Pool authorizer.

Result:
Unauthenticated requests are rejected with HTTP 401 before invoking Lambda.

This ensures:

No unauthenticated Lambda execution

Centralized identity validation

Reduced attack surface

Defense-in-Depth

Lambda validates the authenticated user ID extracted from the JWT claim (sub). If missing, the request is rejected.

This protects against:

Future misconfiguration

Authorizer removal errors

Silent anonymous writes

IAM Controls

Lambda execution role follows least-privilege principles, allowing only required DynamoDB write access.

No wildcard permissions. No unnecessary capabilities.

5. Data Model & Access Pattern

Table: user_preferences
Primary Key: user_id (derived from JWT sub claim)

Operation pattern:

Single put_item per authenticated request

No scans

No unbounded queries

No read amplification

Design principles:

O(1) write complexity

Predictable cost behavior

Linear scalability

This ensures efficient scaling even under traffic spikes.

6. Cost & Scalability Considerations
DynamoDB Configuration

Capacity Mode: On-demand

Rationale:

Unpredictable early-stage workload

Eliminates manual capacity planning

Cost directly tied to request volume

Avoids idle infrastructure

Serverless Strategy

Stateless Lambda functions

No background compute

No always-on servers

Pay-per-request architecture

The system remains horizontally scalable and operationally lightweight.

7. Tradeoffs & Design Decisions

REST API retained to support fine-grained authorization control and method-level configuration.

Tradeoff:
REST APIs require explicit redeployment when authorization changes. This was resolved through Terraform deployment triggers and create_before_destroy lifecycle configuration.

On-demand DynamoDB selected over provisioned capacity to prioritize flexibility during growth stage.

Security enforcement centralized at API Gateway with Lambda acting as secondary validation layer.

8. Challenges & Resolutions

Challenge: REST API authorization changes required redeployment.
Resolution: Implemented Terraform deployment triggers to ensure consistent propagation of method-level updates.

Challenge: Preventing silent fallback to anonymous user IDs.
Resolution: Hardened Lambda to explicitly validate authenticated identity before persistence.

Challenge: Avoiding cost inefficiencies in data access.
Resolution: Designed single-key write pattern without scans or unnecessary reads.

9. Outcome & Phase 3 Readiness

Phase 2 delivers:

Authenticated, identity-bound data ingestion

Secure API enforcement

Predictable and scalable cost structure

Production-grade Infrastructure-as-Code discipline