[← Back to projects](../README.md)

# Project 7: Concurrent URL Checker

## Goal

Given a list of URLs, check which ones are reachable.

```text
Check 1000 URLs
Limit max concurrency to 20
Report failures
Report slow responses
```

## Focus Areas

- `Task.async_stream/3`
- Controlled concurrency
- HTTP client usage
- Timeouts
- Error handling
- Rate limiting

## Key Lesson

Concurrency does not mean spawning unlimited work. It means controlling work safely.
