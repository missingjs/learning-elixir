[← Back to projects](../README.md)

# Project 3: Simple Key-Value Store

## Goal

Build an in-memory key-value store:

```elixir
KV.put("foo", "bar")
KV.get("foo")
KV.delete("foo")
```

## Focus Areas

- Maps
- API design
- GenServer state
- `handle_call/3`
- `handle_cast/2`
- Synchronous vs asynchronous operations

## Suggested Versions

1. Implement it with a plain map and pure functions
2. Convert it into a GenServer
3. Add TTL, persistence, or crash simulation

## Key Lesson

A GenServer is not a class. It is a process that owns state and receives messages.
