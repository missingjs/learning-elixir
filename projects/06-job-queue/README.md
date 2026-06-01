[← Back to projects](../README.md)

# Project 6: Background Job Queue

## Goal

Build a small background job processor:

```text
Enqueue job
Worker executes job
Retry on failure
Limit max retries
Handle timeout
```

## Focus Areas

- Task
- Task.Supervisor
- DynamicSupervisor
- Retry policies
- Backoff
- Failure isolation
- Timeouts

## Challenge

Support multiple concurrent workers while preserving controlled concurrency.
