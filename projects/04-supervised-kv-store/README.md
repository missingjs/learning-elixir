[← Back to projects](../README.md)

# Project 4: Supervised Key-Value Store

## Goal

Extend the key-value store with supervision so that it restarts after failure.

## Focus Areas

- Supervisor
- Child specs
- Restart strategies
- Application startup
- Fault recovery

## Exercise

Add an intentional crash function and observe how the supervisor restarts the process.

Example:

```elixir
def crash do
  GenServer.cast(__MODULE__, :crash)
end
```

## Key Lesson

"Let it crash" works only when the system has a proper supervision structure.
