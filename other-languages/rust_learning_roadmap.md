# Rust Learning Roadmap

A project-driven roadmap for growing from Rust beginner to advanced Rust user.

Rust is different from Go, Elixir, and Scala in one crucial way: its learning curve is dominated by **ownership, borrowing, lifetimes, and memory-safety-oriented design**. Rust is not merely a systems language with modern syntax; it teaches a different way to think about data, mutation, aliasing, concurrency, and API boundaries.

This roadmap is designed around two goals:

1. Build a systematic understanding of Rust's language model.
2. Use progressively harder projects to turn that understanding into practical engineering skill.

---

## 1. Understand Rust's Positioning

Rust is best understood as a language for writing software that needs some combination of:

- memory safety without garbage collection
- predictable performance
- low-level control
- strong static guarantees
- safe concurrency
- reliable command-line tools
- networking services
- embedded or systems programming
- WebAssembly

Rust is not optimized for rapid scripting in the way Python is, nor is it as minimal as Go. Its power comes from making important correctness constraints explicit in the type system.

A good Rust developer is not someone who fights the borrow checker forever. A good Rust developer learns how to design data ownership so the borrow checker becomes a guide instead of an enemy.

---

## 2. Stage One: Master Rust Syntax and Tooling

The first stage is becoming productive in the Rust workflow. Before tackling ownership in depth, you should be able to create projects, run tests, and read the standard tooling output without friction.

### 2.1 Cargo and Tooling

Learn the standard Rust workflow early:

```bash
cargo new myapp
cargo build
cargo run
cargo test
cargo fmt
cargo clippy
cargo doc --open
```

Key topics:

- `Cargo.toml`
- crates and packages
- binary vs library crates
- modules
- workspaces
- dependency versions
- feature flags
- `rustfmt`
- Clippy
- documentation tests

Rust's tooling is one of its strongest advantages. Treat Cargo, rustfmt, Clippy, and tests as part of the language experience, not as optional extras.

---

## 3. Stage Two: Ownership, Borrowing, and Lifetimes

This stage is the heart of Rust's learning curve. Most of what makes Rust unique — and most of what early learners struggle with — lives here. The goal is not to memorize rules, but to develop a feel for designing data ownership so the borrow checker becomes a collaborator.

### 3.1 Ownership and Moves

Ownership is the foundation of Rust.

You must understand:

- every value has one owner
- moving transfers ownership
- values are dropped when their owner goes out of scope
- types may or may not implement `Copy`
- cloning is explicit

Example:

```rust
let name = String::from("Alice");
let other = name;
// name can no longer be used here
```

Important questions to practice asking:

```text
Who owns this value?
Is this value moved, borrowed, cloned, or copied?
When will this value be dropped?
Should this function take ownership or borrow?
```

---

### 3.2 Borrowing and References

Borrowing lets code access data without taking ownership.

You need to internalize:

- immutable references: `&T`
- mutable references: `&mut T`
- many immutable references are allowed
- only one mutable reference is allowed at a time
- references must not outlive the data they point to

Example:

```rust
fn len(s: &String) -> usize {
    s.len()
}
```

In idiomatic Rust, prefer `&str` over `&String` when you only need string data:

```rust
fn len(s: &str) -> usize {
    s.len()
}
```

This is the beginning of good Rust API design.

---

### 3.3 Lifetimes

Lifetimes describe how long references are valid.

At first, most lifetimes are inferred. Later, you need to understand explicit lifetime parameters:

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

Learn lifetimes as a way to express relationships between references, not as random compiler annotations.

Key topics:

- lifetime elision
- lifetime parameters
- references in structs
- `'static`
- owned data vs borrowed data
- avoiding unnecessary lifetime complexity

A practical rule:

> If lifetimes become too complicated, reconsider your ownership model.

---

## 4. Stage Three: Data Modeling and Error Handling

Once ownership feels natural, the next stage is modeling your domain in Rust's type system. This is where Rust starts to feel different from "C with safety": you express invariants as types, replace runtime branches with pattern matching, and treat errors as values.

### 4.1 Structs, Enums, and Pattern Matching

Rust's data modeling power comes from structs and enums.

Use structs for product types:

```rust
struct User {
    id: UserId,
    email: Email,
}
```

Use enums for sum types:

```rust
enum PaymentStatus {
    Pending,
    Paid,
    Failed(String),
}
```

Pattern matching is central:

```rust
match status {
    PaymentStatus::Pending => "waiting",
    PaymentStatus::Paid => "done",
    PaymentStatus::Failed(reason) => reason.as_str(),
}
```

Learn to model states explicitly instead of using strings, booleans, or magic integers.

---

### 4.2 Option and Result

Rust avoids null and exceptions for normal control flow.

Use `Option<T>` when a value may be absent:

```rust
fn find_user(id: UserId) -> Option<User> {
    // ...
}
```

Use `Result<T, E>` when an operation may fail:

```rust
fn read_config(path: &str) -> Result<Config, ConfigError> {
    // ...
}
```

Learn:

- `map`
- `and_then`
- `unwrap_or`
- `ok_or`
- `?`
- custom error enums
- `thiserror`
- `anyhow`

Recommended distinction:

```text
Library code: prefer typed errors, often with thiserror.
Application boundary code: anyhow can be practical.
```

---

### 4.3 Traits and Generics

Traits define shared behavior.

```rust
trait Repository {
    fn find(&self, id: UserId) -> Result<Option<User>, RepoError>;
}
```

Learn:

- trait definitions
- trait implementations
- default methods
- generic functions
- trait bounds
- associated types
- `impl Trait`
- trait objects: `dyn Trait`

Important distinction:

```text
Static dispatch: generics and impl Trait
Dynamic dispatch: dyn Trait
```

Use generics when performance and compile-time specialization matter. Use trait objects when runtime polymorphism and simpler boundaries are useful.

---

## 5. Stage Four: Iterators, Smart Pointers, and API Design

This stage is about writing idiomatic Rust at a larger scale: composing transformations with iterators, reaching for smart pointers only when ownership genuinely needs them, and shaping module boundaries that communicate intent. Many ownership headaches at this point are actually API design problems.

### 5.1 Iterators and Closures

Rust iterators are powerful, zero-cost abstractions when used well.

Learn:

- `iter`
- `iter_mut`
- `into_iter`
- `map`
- `filter`
- `fold`
- `collect`
- `find`
- `any`
- `all`
- `flat_map`

Example:

```rust
let emails: Vec<String> = users
    .iter()
    .filter(|user| user.active)
    .map(|user| user.email.clone())
    .collect();
```

Pay attention to ownership in iterator chains. Many Rust learning problems appear here.

---

### 5.2 Smart Pointers and Interior Mutability

Eventually you need to understand:

- `Box<T>`
- `Rc<T>`
- `Arc<T>`
- `RefCell<T>`
- `Mutex<T>`
- `RwLock<T>`
- `Cow<'a, T>`

Typical uses:

```text
Box<T>: heap allocation and recursive data structures
Rc<T>: shared ownership in single-threaded code
Arc<T>: shared ownership across threads
RefCell<T>: runtime-checked interior mutability
Mutex<T>: synchronized mutation across threads
Cow<T>: clone-on-write borrowed-or-owned data
```

Do not overuse these to avoid learning ownership. Use them when the ownership model genuinely requires them.

---

### 5.3 Modules, Crates, and API Design

Rust's module system matters for maintainability.

Learn:

- `mod`
- `pub`
- `pub(crate)`
- `use`
- library crate vs binary crate
- integration tests
- workspaces

Good Rust APIs make ownership clear:

```rust
fn parse(input: &str) -> Result<Document, ParseError>
fn save(path: impl AsRef<Path>, document: &Document) -> Result<(), SaveError>
fn into_inner(self) -> Inner
```

Useful naming patterns:

```text
as_*      borrowed view
to_*      converted or cloned value
into_*    consumes self
try_*     fallible operation
from_*    conversion constructor
new       ordinary constructor
```

---

## 6. Stage Five: Concurrency and Async

Rust's type system rules out many concurrency bugs at compile time, but you still need to design ownership and lifetimes deliberately. Start with synchronous threads and channels, then move to async only after the rest of the language feels comfortable.

### 6.1 Threads and Message Passing

Start with standard library threads:

```rust
std::thread::spawn(|| {
    println!("hello from another thread");
});
```

Learn:

- thread spawning
- join handles
- channels
- `Send`
- `Sync`
- `move` closures

Rust's type system prevents many data races at compile time, but you still need good design.

---

### 6.2 Shared State Concurrency

Learn:

- `Arc<T>`
- `Mutex<T>`
- `RwLock<T>`
- atomics
- poisoning
- lock scope
- deadlock avoidance

Example:

```rust
use std::sync::{Arc, Mutex};

let counter = Arc::new(Mutex::new(0));
```

Important question:

> Should this be shared mutable state, message passing, or independent ownership?

---

### 6.3 Async Rust

Async Rust is powerful but complex. Learn it after ownership, traits, and error handling.

Key topics:

- `async fn`
- `.await`
- futures are lazy until polled
- executors and runtimes
- Tokio
- async channels
- cancellation
- timeouts
- `Send` futures
- blocking vs non-blocking work

Common ecosystem tools:

- Tokio
- reqwest
- axum
- hyper
- tower
- sqlx
- tracing

Do not block inside async tasks unless you understand `spawn_blocking` or equivalent patterns.

---

## 7. Stage Six: Engineering Practices

Mature Rust code is observable, tested, and measured. This stage is the same kind of work that any production language requires, but Rust's tooling makes it unusually rewarding to invest in early.

### 7.1 Testing and Quality

Learn testing early:

```rust
#[test]
fn parses_valid_input() {
    // ...
}
```

Key topics:

- unit tests
- integration tests
- doc tests
- test fixtures
- property-based tests
- snapshot tests
- benchmarking
- fuzzing basics

Useful tools:

```text
cargo test
cargo fmt
cargo clippy
cargo doc
cargo bench
proptest
insta
criterion
cargo-nextest
```

A strong Rust workflow usually includes:

```bash
cargo fmt --check
cargo clippy -- -D warnings
cargo test
```

---

### 7.2 Performance and Memory

Rust gives you low-level control, but you still need measurement.

Learn:

- stack vs heap
- allocation behavior
- cloning costs
- iterator performance
- `Vec` capacity
- string allocation
- zero-copy parsing
- memory layout
- `#[derive]` costs and benefits
- benchmarking with Criterion
- profiling with flamegraphs or platform profilers

Important principle:

> Optimize after measuring. Rust makes performance possible, not automatic.

---

## 8. Stage Seven: Advanced and Specialized Topics

After core Rust, you choose a direction. Unsafe Rust, FFI, embedded, and WebAssembly each have their own learning curves on top of the foundation. Do not start here, and do not try to learn every specialization at once.

### 8.1 Unsafe Rust

Unsafe Rust is advanced. You do not need it for most application development.

Learn only after you are comfortable with safe Rust.

Topics:

- raw pointers
- unsafe functions
- unsafe traits
- FFI
- aliasing rules
- invariants
- soundness
- `MaybeUninit`
- `Pin`

Rule of thumb:

```text
Minimize unsafe blocks.
Document invariants.
Wrap unsafe internals in safe APIs.
Prefer proven crates when possible.
```

---

### 8.2 Web, CLI, Systems, and Specialized Ecosystems

After core Rust, choose one or two directions.

#### CLI and Developer Tools

Learn:

- `clap`
- `serde`
- `toml`
- `anyhow`
- `thiserror`
- `tracing`
- file I/O
- terminal output

#### Web Backend

Learn:

- Tokio
- axum
- tower
- serde
- sqlx
- reqwest
- tracing
- metrics
- graceful shutdown

#### Systems Programming

Learn:

- OS APIs
- memory layout
- FFI
- networking
- parsers
- binary protocols
- unsafe boundaries

#### WebAssembly

Learn:

- wasm-bindgen
- wasm-pack
- JS interop
- browser APIs
- size optimization

#### Embedded Rust

Learn:

- `no_std`
- HAL crates
- embedded-hal
- interrupts
- memory constraints
- hardware-specific tooling

---

## 9. Recommended Learning Order

A practical order for learning Rust is:

```text
1. Basic syntax, Cargo, crates, and modules
2. Ownership, borrowing, and moves
3. References, mutability, and lifetimes
4. Structs, enums, pattern matching, and traits
5. Error handling with Result and Option
6. Collections, iterators, and closures
7. Smart pointers and interior mutability
8. Generics and trait bounds
9. Testing, documentation, rustfmt, and Clippy
10. File I/O, CLI tools, and serialization
11. Concurrency with threads, channels, Arc, and Mutex
12. Async Rust with Tokio or async-std
13. HTTP services, databases, and production tooling
14. Performance profiling and memory optimization
15. Unsafe Rust, FFI, embedded, or WebAssembly specialization
```

Do not rush into async Rust, macros, or unsafe Rust. Rust becomes much easier once ownership and API design feel natural.

---

## 10. Project Roadmap

The best way to learn Rust is through small projects that each target a specific set of concepts.

### Project 1: CLI TODO Tool

Build a command-line TODO app.

Features:

```text
todo add "learn Rust"
todo list
todo done 1
todo remove 1
```

Focus:

- Cargo
- structs
- enums
- ownership basics
- file I/O
- JSON or TOML serialization
- `Result`
- tests

Completion standard:

```text
Tasks persist to disk.
Errors are handled with Result.
Core logic is tested.
The CLI is usable without panics.
```

---

### Project 2: Log Analyzer

Build a tool that reads a log file and prints statistics.

Focus:

- `std::fs::File`
- `BufReader`
- iterators
- string parsing
- maps
- error handling
- streaming rather than loading everything into memory

Stretch goals:

```text
Support large files.
Output JSON.
Benchmark parsing performance.
```

---

### Project 3: Config Loader

Build a small configuration loader.

Features:

```text
Load TOML or JSON config.
Apply defaults.
Override with environment variables.
Validate values.
```

Focus:

- `serde`
- custom error types
- `Path` and `PathBuf`
- API design
- `Option`
- `Result`

Completion standard:

```text
Invalid config returns clear typed errors.
The public API is small and easy to use.
Tests cover valid and invalid configs.
```

---

### Project 4: Domain Validator

Build a pure domain validation library.

Example domain:

```text
User registration
Order checkout
Payment request
Inventory reservation
```

Focus:

- newtype pattern
- enums
- typed errors
- pure functions
- `Result`
- avoiding primitive obsession

Example:

```rust
struct Email(String);
struct Quantity(u32);

enum ValidationError {
    EmptyEmail,
    InvalidEmail,
    InvalidQuantity,
}
```

Completion standard:

```text
Invalid states are harder to represent.
Business logic is independent of I/O.
Errors are modeled as enums.
```

---

### Project 5: Mini Parser

Build a parser for a small format, such as:

```text
CSV subset
INI file
simple arithmetic expressions
Markdown headings
custom log format
```

Focus:

- borrowing with `&str`
- lifetimes
- enums
- recursive data structures
- error positions
- zero-copy parsing where possible

Stretch goals:

```text
Avoid unnecessary String allocation.
Return spans or borrowed slices.
Add property-based tests.
```

This is one of the best projects for learning lifetimes in a practical way.

---

### Project 6: Concurrent URL Checker

Build a tool that checks a list of URLs concurrently.

Features:

```text
urlcheck urls.txt --concurrency 20 --timeout 2s
```

Focus:

- async Rust
- Tokio
- reqwest
- timeouts
- concurrency limits
- error handling
- structured output

Completion standard:

```text
Concurrency is bounded.
Timeouts are enforced.
Failures are reported clearly.
The program exits cleanly on Ctrl+C.
```

---

### Project 7: In-Memory HTTP API

Build a small REST API, such as a bookmark service.

Endpoints:

```text
POST   /bookmarks
GET    /bookmarks
GET    /bookmarks/{id}
DELETE /bookmarks/{id}
```

Focus:

- axum
- serde
- shared state
- `Arc`
- `Mutex` or `RwLock`
- handler design
- error responses
- integration tests

Completion standard:

```text
HTTP layer and domain logic are separated.
Errors return consistent JSON responses.
Shared state is concurrency-safe.
```

---

### Project 8: Database-Backed API

Extend the previous API with a database.

Focus:

- sqlx
- migrations
- connection pools
- transactions
- typed query results
- repository boundaries
- integration testing

Completion standard:

```text
Database schema is migrated.
Queries are tested.
Transactions are used where needed.
The API can be started and stopped cleanly.
```

---

### Project 9: Background Job Queue

Build a small in-process job queue.

Features:

```text
Enqueue jobs.
Run multiple workers.
Retry failed jobs.
Apply timeout.
Shutdown gracefully.
```

Focus:

- Tokio tasks
- channels
- cancellation
- retry policy
- backoff
- state management
- tracing

Completion standard:

```text
Workers do not leak.
Shutdown waits for active jobs or cancels them deliberately.
Failures and retries are observable.
```

---

### Project 10: Cache or Rate Limiter

Build one of:

```text
TTL cache
LRU cache
token bucket rate limiter
sliding window rate limiter
```

Focus:

- ownership and shared state
- `Arc`
- `Mutex` / `RwLock`
- time handling
- generics
- trait bounds
- testing time-dependent logic

Completion standard:

```text
The data structure is concurrency-safe.
Tests cover expiration or rate limiting behavior.
The public API is ergonomic.
```

---

### Project 11: Streaming Log Tail Service

Build a service that streams log updates over HTTP.

Features:

```text
GET /logs
GET /logs/stream
```

Focus:

- streaming responses
- Server-Sent Events or WebSocket
- file watching
- client disconnect handling
- backpressure
- async task lifecycle

Completion standard:

```text
Disconnected clients are cleaned up.
Slow clients do not break the entire service.
The service shuts down gracefully.
```

---

### Project 12: Performance Lab

Choose an earlier project and optimize it.

Focus:

- Criterion benchmarks
- allocation reduction
- profiling
- flamegraphs
- zero-copy parsing
- `Cow`
- `Vec` capacity
- clone avoidance

Completion standard:

```text
There is a benchmark baseline.
Optimizations are measured, not guessed.
You can explain the performance improvement.
```

---

### Project 13: Unsafe Boundary Exercise

Build a small safe wrapper around an unsafe or FFI boundary.

Possible examples:

```text
Call a tiny C library.
Wrap a raw pointer-based API.
Implement a small arena-like structure.
```

Focus:

- unsafe blocks
- invariants
- safe abstractions
- FFI
- ownership across boundaries
- documentation

Completion standard:

```text
Unsafe code is minimal.
Safety invariants are documented.
The public API is safe.
Tests cover normal and edge cases.
```

Only attempt this after you are comfortable with safe Rust.

---

## 11. Recommended Project Order

```text
1. CLI TODO Tool
2. Log Analyzer
3. Config Loader
4. Domain Validator
5. Mini Parser
6. Concurrent URL Checker
7. In-Memory HTTP API
8. Database-Backed API
9. Background Job Queue
10. Cache or Rate Limiter
11. Streaming Log Tail Service
12. Performance Lab
13. Unsafe Boundary Exercise
```

This order gradually builds:

```text
syntax and tooling
→ ownership and borrowing
→ error modeling
→ lifetimes
→ async and concurrency
→ web services
→ databases
→ production behavior
→ performance
→ unsafe boundaries
```

---

## 12. If Time Is Limited

If you only have time for five projects, do these:

```text
1. Log Analyzer
2. Domain Validator
3. Mini Parser
4. Concurrent URL Checker
5. Database-Backed API
```

These cover the most important Rust skills:

```text
ownership
borrowing
lifetimes
error handling
iterators
async
concurrency
API design
serialization
database access
```

---

## 13. Three-Version Method for Every Project

For each project, build it in three passes.

### Version 1: Make It Work

Focus on completing the feature set. Do not over-engineer.

### Version 2: Make It Idiomatic

Refactor for:

```text
clear ownership
fewer clones
better error types
smaller modules
cleaner API boundaries
more tests
```

### Version 3: Make It Robust

Add production-like concerns:

```text
logging / tracing
timeouts
configuration
benchmarks
graceful shutdown
property tests
Clippy cleanups
```

---

## 14. Common Rust Mistakes

### Mistake 1: Fighting the Borrow Checker Instead of Redesigning Ownership

If the borrow checker keeps rejecting your code, step back and ask:

```text
Who should own this data?
Can I split the data structure?
Should this function borrow instead of own?
Should this value be cloned deliberately?
Is shared mutability actually required?
```

---

### Mistake 2: Using `clone()` Everywhere

Cloning is sometimes correct, but excessive cloning often hides poor ownership design.

Ask:

```text
Can this function take &T instead of T?
Can this type use borrowed data?
Is the clone cheap and intentional?
```

---

### Mistake 3: Calling `unwrap()` in Real Code

`unwrap()` is acceptable in quick experiments, tests, and impossible states. For application code, prefer explicit error handling.

---

### Mistake 4: Starting With Async Too Early

Async Rust combines lifetimes, traits, pinning, runtimes, cancellation, and Send bounds. Learn synchronous Rust well first.

---

### Mistake 5: Overusing `Arc<Mutex<T>>`

`Arc<Mutex<T>>` is useful, but it is not the answer to every ownership problem. Prefer simpler ownership, message passing, or immutable data when possible.

---

### Mistake 6: Ignoring Error Design

String errors are easy, but typed errors make libraries and services easier to maintain.

---

### Mistake 7: Reaching for Unsafe Too Soon

Most Rust applications need little or no unsafe code. Learn safe Rust deeply before writing unsafe Rust.

---

## 15. Advanced Rust User Checklist

You are becoming an advanced Rust user when you can:

```text
Design APIs with clear ownership semantics.
Choose between owned values, borrowed values, and Cow.
Use lifetimes to express relationships rather than silence errors.
Model domains with structs, enums, and typed errors.
Write ergonomic Result-based APIs.
Use traits, generics, impl Trait, and dyn Trait appropriately.
Use iterators without losing track of ownership.
Design modules and crates with clean boundaries.
Write unit, integration, doc, and property-based tests.
Use rustfmt, Clippy, and Cargo workflows naturally.
Build reliable CLI tools.
Build async HTTP services with bounded concurrency.
Use Arc, Mutex, channels, and tasks safely.
Handle cancellation, timeouts, and graceful shutdown.
Profile before optimizing.
Reduce unnecessary allocation and cloning.
Understand when unsafe is necessary and how to wrap it safely.
Read and understand production Rust crate APIs.
```

---

## 16. Final Advice

Rust rewards patience. The early learning curve can feel slower than Go or Python because the compiler forces you to answer design questions that other languages allow you to postpone.

That difficulty is also the value of Rust.

A mature Rust developer does not merely know syntax. A mature Rust developer can design ownership, model errors, manage concurrency, and expose APIs that make invalid states difficult to represent.

The goal is not to silence the compiler. The goal is to collaborate with it.
