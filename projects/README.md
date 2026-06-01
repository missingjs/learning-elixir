# Project-Based Learning Path

A project-driven approach is not only reasonable, but highly effective for learning Elixir. Many Elixir and OTP concepts only become clear when you encounter concrete design questions:

- Does this state need a process?
- Who owns this state?
- What should happen if this process crashes?
- Should this be synchronous or asynchronous?
- Could a mailbox grow without limit?
- Is this module business logic or a process boundary?
- Can pattern matching replace conditional logic?

The best project sequence increases difficulty gradually. Each project focuses on one to three major ideas.

For the conceptual map behind these projects, see [../roadmap.md](../roadmap.md).

---

## The Ten Projects

1. [CLI TODO Tool](01-cli-todo/README.md) — Mix project structure, pattern matching, file I/O.
2. [Log Analyzer](02-log-analyzer/README.md) — `Stream` vs `Enum`, `reduce`, large-file processing.
3. [Key-Value Store](03-kv-store/README.md) — GenServer state ownership, `handle_call` vs `handle_cast`.
4. [Supervised Key-Value Store](04-supervised-kv-store/README.md) — Supervisor, restart strategies, "let it crash".
5. [Dynamic Chat Rooms](05-chat-rooms/README.md) — DynamicSupervisor, Registry, GenServer per room.
6. [Background Job Queue](06-job-queue/README.md) — Task.Supervisor, retries, backoff, failure isolation.
7. [Concurrent URL Checker](07-url-checker/README.md) — `Task.async_stream/3`, controlled concurrency.
8. [Phoenix CRUD with Ecto](08-phoenix-crud/README.md) — Router, Context, Schema, Changeset, Repo.
9. [LiveView Dashboard](09-liveview-dashboard/README.md) — LiveView lifecycle, PubSub, server-driven UI.
10. [Distributed System](10-distributed-system/README.md) — Distributed Erlang, clustering, partition thinking.

---

## Recommended Project Order

```text
1. CLI TODO Tool
2. Log Analyzer
3. GenServer Key-Value Store
4. Supervised Key-Value Store
5. Dynamic Chat Rooms
6. Background Job Queue
7. Concurrent URL Checker
8. Phoenix + Ecto Application
9. LiveView Dashboard
10. Distributed System
```

This order works well because it moves from:

```text
Language basics
→ Functional data processing
→ OTP state ownership
→ Fault tolerance
→ Runtime process architecture
→ Controlled concurrency
→ Web development
→ Real-time UI
→ Distributed systems
```

---

## How to Approach Each Project

For each project, use three iterations.

### Version 1: Make It Work

Focus only on functionality. Do not over-engineer the design.

### Version 2: Make It Idiomatic

Refactor toward better Elixir style:

- Use pattern matching
- Reduce unnecessary conditionals
- Separate pure functions from side effects
- Improve pipelines
- Clarify data structures

### Version 3: Make It Robust

Add production-style qualities:

- Supervision
- Tests
- Telemetry
- Error handling
- Timeouts
- Observability
- Property testing where appropriate

---

## Good Questions to Ask While Building

A good Elixir project should force you to ask:

```text
Does this need a process?
Who owns this state?
What happens if this process crashes?
Should this call be synchronous or asynchronous?
Can the mailbox grow too large?
Should this state be stored in ETS, a GenServer, or a database?
Can this logic be a pure function?
Can pattern matching replace this conditional?
Is this module business logic or a process boundary?
Where should supervision begin and end?
What should be restarted, and what should not be restarted?
```

If a project forces you to answer these questions, it is a useful Elixir learning project.
