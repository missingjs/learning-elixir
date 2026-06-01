# Elixir Growth Roadmap: From Beginner to Advanced Practitioner

This document summarizes a structured learning path for someone who is new to Elixir and wants to grow into an advanced Elixir/OTP practitioner. Instead of relying only on books and tutorials, the recommended approach is to combine conceptual learning with a sequence of progressively more difficult small projects.

For the project sequence itself, see [projects/README.md](projects/README.md).

---

## 1. Core Philosophy

Elixir is not just a syntax layer on top of Erlang. To use Elixir well, you need to understand several layers:

1. The Elixir language itself
2. Functional programming habits
3. OTP and the actor/process model
4. The BEAM virtual machine
5. Concurrency and distributed systems
6. Phoenix, Ecto, and LiveView for web applications
7. Engineering practices such as testing, observability, debugging, and performance analysis

The key transition from intermediate to advanced Elixir usage happens when you stop thinking mainly in terms of classes, threads, and locks, and start thinking in terms of processes, messages, supervision trees, failure isolation, and data transformation.

---

## 2. Stage One: Master the Elixir Language

### 2.1 Pattern Matching

Pattern matching is one of the most important ideas in Elixir. You should become comfortable with:

- Variable binding
- Tuple matching
- Map matching
- Struct matching
- Function head matching
- Matching inside `case`, `cond`, and `with`
- Guard clauses

Example:

```elixir
def process(%User{name: name, age: age}) when age >= 18 do
  {:ok, name}
end
```

Advanced Elixir code often replaces large conditional branches with clear pattern matching.

### 2.2 Immutable Data Structures

You should understand the common data structures:

- Lists
- Tuples
- Maps
- Keyword lists
- Structs

You should also learn why immutability matters, how structural sharing works, and how different data structures affect performance.

### 2.3 Functional Programming Style

Important topics include:

- Pure functions
- Higher-order functions
- Pipelines
- Recursion
- `Enum`
- `Stream`
- `reduce`
- Side effects and where to place them

Example:

```elixir
users
|> Enum.filter(& &1.active)
|> Enum.map(& &1.email)
```

The goal is to think in terms of transforming data rather than mutating state.

### 2.4 Macros and Metaprogramming Basics

You do not need to write complex macros early, but you should understand:

- Abstract Syntax Trees, or ASTs
- `quote`
- `unquote`
- Why libraries such as Phoenix and Ecto use macros

Example:

```elixir
quote do
  1 + 2
end
```

---

## 3. Stage Two: Learn OTP Deeply

OTP is the biggest dividing line between casual Elixir users and advanced Elixir developers.

### 3.1 Processes

You should understand that BEAM processes are not operating system threads. They are lightweight, isolated, and communicate through message passing.

Topics to study:

- `spawn`
- `send`
- `receive`
- Mailboxes
- Process isolation
- Process lifecycle

Example:

```elixir
pid = spawn(fn ->
  receive do
    msg -> IO.inspect(msg)
  end
end)

send(pid, :hello)
```

### 3.2 GenServer

You should become comfortable with:

- `handle_call/3`
- `handle_cast/2`
- `handle_info/2`
- State management
- Synchronous calls
- Asynchronous casts
- API wrapper functions

A key lesson is that a GenServer is a process boundary, not a general-purpose business logic container.

### 3.3 Supervisor

You should understand:

- `:one_for_one`
- `:rest_for_one`
- `:one_for_all`
- Restart strategies
- Child specifications
- Fault tolerance
- The meaning of "let it crash"

Supervision is one of the most important concepts in the Erlang and Elixir ecosystem.

### 3.4 Application and Supervision Trees

You should be able to design a supervision tree such as:

```text
Application
└── Supervisor
    ├── Registry
    ├── DynamicSupervisor
    └── Worker Processes
```

Topics to understand:

- Application startup
- Service initialization order
- Failure propagation
- Process ownership
- Restart boundaries

### 3.5 DynamicSupervisor

Dynamic supervisors are useful when child processes are created at runtime.

Common use cases include:

- Chat rooms
- WebSocket sessions
- Game players
- IoT device connections
- Background workers

### 3.6 Registry

Registry helps with process discovery and local process naming.

Topics to learn:

- Registering processes
- Looking up processes
- Using `:unique` and `:duplicate` registries
- Combining `Registry` with `DynamicSupervisor`

---

## 4. Stage Three: Understand the BEAM Virtual Machine

To write high-performance Elixir systems, you need at least a practical understanding of the BEAM.

### 4.1 Scheduler

Topics to study:

- BEAM schedulers
- Run queues
- Reductions
- Preemptive scheduling
- `System.schedulers_online/0`

This explains why the BEAM can support a very large number of lightweight processes.

### 4.2 Garbage Collection

Important concepts:

- Per-process garbage collection
- No global stop-the-world garbage collection in the usual application-level sense
- Process heaps
- Binary memory behavior
- How long-lived processes can accumulate memory

### 4.3 Binaries and Memory

Elixir and Erlang are very good at binary pattern matching.

Example:

```elixir
<<header::16, body::binary>> = packet
```

Topics to understand:

- Binary pattern matching
- Sub-binaries
- Reference-counted binaries
- Large binary memory behavior

---

## 5. Stage Four: Concurrency and Distributed Systems

Elixir's real strength appears when you build concurrent and distributed systems.

### 5.1 Task

Topics to learn:

- `Task.async/1`
- `Task.await/2`
- `Task.async_stream/3`
- Timeouts
- Controlled concurrency
- Error handling

You should understand the difference between concurrency and parallelism.

### 5.2 Flow and GenStage

Useful for data processing pipelines.

Topics:

- Producers
- Consumers
- Producer-consumers
- Backpressure
- Streaming data processing

### 5.3 Distributed Erlang

Topics:

- Nodes
- Cookies
- `Node.connect/1`
- Cross-node communication
- Failure modes
- Network partitions

Example:

```elixir
Node.connect(:"node2@127.0.0.1")
```

### 5.4 Phoenix PubSub

Phoenix PubSub is important for real-time applications.

Topics:

- Broadcasting
- Subscribing
- Topics
- Message fan-out
- LiveView integration

---

## 6. Stage Five: Phoenix, Ecto, and LiveView

Phoenix is important, but it should not be confused with Elixir itself. Ideally, learn core Elixir and OTP first, then study Phoenix.

### 6.1 Phoenix Framework

Key topics:

- Router
- Controller
- Plug
- Endpoint
- Contexts
- Request lifecycle

The goal is not just to build CRUD endpoints, but to understand Phoenix's architecture.

### 6.2 Ecto

Core topics:

- Schemas
- Changesets
- Queries
- Migrations
- Repositories
- Transactions
- Associations

Example:

```elixir
from u in User,
  where: u.age > 18
```

Changesets are especially important because they encode validation and transformation logic.

### 6.3 Phoenix LiveView

Important topics:

- LiveView lifecycle
- `mount/3`
- `handle_event/3`
- `handle_info/2`
- Assigns
- Streams
- PubSub integration
- Server-driven UI
- Diff-based updates

LiveView is where OTP and web development begin to connect very naturally.

---

## 7. Stage Six: Engineering Practices

Advanced Elixir usage also requires strong engineering habits.

### 7.1 Testing

Study:

- ExUnit
- Doctests
- Mox
- Test supervision trees
- Property testing with StreamData

Testing is especially important when working with concurrent systems.

### 7.2 Telemetry and Observability

Study:

- `:telemetry`
- Metrics
- Logging
- Tracing
- Instrumentation
- OpenTelemetry integration

You should be able to observe system behavior, not just write code that appears to work.

### 7.3 Debugging and Performance Analysis

Useful tools and topics:

- `:observer`
- `:recon`
- Process inspection
- Mailbox growth
- Memory analysis
- Scheduler pressure
- Long-running processes

You should learn how to identify process leaks, mailbox buildup, memory pressure, and blocking calls.

---

## 8. Stage Seven: Read and Learn Erlang

Many core Elixir libraries are built on Erlang. To go from advanced to expert, you should gradually learn Erlang concepts and libraries.

Important topics:

- ETS
- DETS
- Mnesia
- `gen_statem`
- `gen_event`
- Cowboy
- Ranch
- Erlang standard library conventions

You do not need to become an Erlang expert immediately, but reading Erlang code will make you a much stronger Elixir developer.

---

## 9. Recommended Conceptual Learning Order

A good conceptual sequence is:

```text
1. Elixir syntax and core data structures
2. Functional programming style
3. Pattern matching and recursion
4. GenServer
5. Supervisor
6. OTP application structure
7. BEAM internals
8. Task and controlled concurrency
9. Phoenix and Ecto
10. LiveView and PubSub
11. Telemetry and observability
12. Distributed Erlang
13. Erlang core libraries
14. Macros and DSL design
```

---

## Final Advice

Do not start with Phoenix as if Phoenix were Elixir itself. Phoenix is excellent, but it hides many OTP details. A better path is:

```text
Small language projects
→ Data-processing projects
→ GenServer and Supervisor projects
→ Dynamic OTP systems
→ Phoenix and Ecto
→ LiveView
→ Distributed systems
```

The turning point comes when you can design a reasonable supervision tree, understand process ownership, and reason about failure recovery. Once you think in terms of processes, messages, supervision, and fault isolation, you are moving from ordinary Elixir usage into advanced Elixir system design.
