# Scala 3 Learning Roadmap

This roadmap is designed for learners who want to grow from Scala 3 beginners into advanced, production-capable Scala developers. It combines two perspectives:

1. **A systematic learning path** for Scala 3 language features, functional programming, type systems, JVM engineering, and ecosystem knowledge.
2. **A project-driven path** that gradually turns concepts into practical engineering skills.

Scala 3 is different from Go and Elixir. Go emphasizes simplicity, engineering discipline, concurrency, and production services. Elixir emphasizes OTP, lightweight processes, fault tolerance, and distributed systems. Scala 3 emphasizes:

> Type systems, functional programming, JVM engineering, and abstraction design.

The key to learning Scala 3 well is not to rush into advanced abstractions too early. Learn to write clear Scala first, then functional Scala, and only then highly abstract Scala.

---

## Part 1: Core Learning Roadmap

## 1. Understand Scala 3's Positioning

Scala 3 can be understood as three layers:

```text
Layer 1: Better Java
Layer 2: Functional Programming Language
Layer 3: Type-level Abstraction Language
```

A healthy learning path is:

```text
Write clear Scala
→ Write functional Scala
→ Write abstract and type-safe Scala
```

Avoid starting with Cats, ZIO, tagless final, higher-kinded types, or advanced type-level programming before you are comfortable with the language fundamentals.

---

## 2. Stage One: Master Scala 3 Syntax and Data Modeling

The first stage is becoming fluent in Scala 3 as an expression-oriented language with strong data modeling primitives. Before reaching for functional or type-level abstractions, you should be comfortable describing your domain with case classes, enums, and pattern matching, and processing data with the standard collection library.

### 2.1 Scala 3 Syntax and Expression-oriented Programming

Start with the core language:

```text
val
var
def
if expressions
for expressions
match expressions
indentation syntax
```

Scala is expression-oriented. Many constructs return values:

```scala
val result =
  if score >= 60 then "pass" else "fail"
```

This is different from Java or Go, where many constructs are primarily statements.

#### What to learn

- `val` versus `var`
- Method definitions with `def`
- Indentation-based syntax
- Expressions versus statements
- Type inference
- When to write explicit type annotations

Use explicit types especially for:

```text
public APIs
complex return types
effect types
recursive functions
module boundaries
```

---

### 2.2 Data Modeling with Case Classes and Enums

#### Case Classes

`case class` is the core tool for immutable data modeling:

```scala
case class User(id: UserId, email: Email, age: Int)
```

You should understand:

```text
immutability
copy
automatic equals / hashCode / toString
pattern matching
companion objects
```

Example:

```scala
val updated = user.copy(email = newEmail)
```

#### Enums

Scala 3 enums are very useful for modeling finite states and algebraic data types:

```scala
enum PaymentStatus:
  case Pending
  case Paid
  case Failed(reason: String)
```

Use enums for:

```text
states
commands
events
errors
finite choices
```

Avoid using raw strings or integers for domain states when an enum would be clearer and safer.

---

### 2.3 Pattern Matching

Pattern matching is central to Scala:

```scala
status match
  case PaymentStatus.Pending =>
    "waiting"
  case PaymentStatus.Paid =>
    "done"
  case PaymentStatus.Failed(reason) =>
    s"failed: $reason"
```

Learn:

```text
case class matching
enum matching
tuple matching
guards
sealed hierarchy matching
exhaustiveness checking
```

Good Scala code often combines type modeling with pattern matching to reduce illegal states and unclear branching logic.

---

### 2.4 Collections and Data Transformation

Scala's collection library is powerful. Learn these types early:

```text
List
Vector
Seq
Map
Set
Option
Either
Try
Iterator
LazyList
```

Core operations:

```text
map
flatMap
filter
foldLeft
collect
partition
groupBy
```

Example:

```scala
val emails =
  users
    .filter(_.active)
    .map(_.email)
```

Learn the difference between:

```text
map      transforms values inside a structure
flatMap  transforms and flattens nested structure
fold     aggregates many values into one result
```

---

## 3. Stage Two: Functional Programming Foundations

Once you can model data, the next stage is composing it. This is where Scala starts to feel different from "Java with better syntax": errors are values, transformations are pipelines, and `for` is a sequencing operator over many shapes.

### 3.1 Option, Either, and Typed Errors

#### Option

Use `Option[A]` to represent a value that may be absent:

```scala
def findUser(id: UserId): Option[User]
```

Avoid `null` in Scala code.

#### Either

Use `Either[E, A]` to represent a computation that may fail:

```scala
def parseEmail(raw: String): Either[ValidationError, Email]
```

Prefer domain-specific errors:

```scala
enum ValidationError:
  case EmptyEmail
  case InvalidEmailFormat
```

Then:

```scala
def parseEmail(raw: String): Either[ValidationError, Email]
```

This makes error handling explicit, composable, and testable.

#### Try

Use `Try[A]` mainly when working with exception-throwing APIs, especially Java APIs.

Suggested usage:

```text
Missing value: Option[A]
Business validation failure: Either[DomainError, A]
Exception-based computation: Try[A] or convert to Either
```

---

### 3.2 Functional Programming Foundations

You do not need to become a category theory expert to write good Scala, but you do need functional fundamentals.

#### Pure Functions

A pure function:

```text
returns the same output for the same input
has no side effects
```

Example:

```scala
def totalPrice(items: List[Item]): BigDecimal =
  items.map(_.price).sum
```

Try to keep core business logic pure, and push side effects to the boundary.

#### Immutability

Prefer:

```text
val
case class
List
Vector
Map
copy
```

Avoid overusing:

```text
var
mutable.Map
ArrayBuffer
null
```

Immutability makes code easier to reason about, test, and run safely in concurrent contexts.

#### Higher-order Functions

Functions can be passed as values:

```scala
def transform[A, B](values: List[A])(f: A => B): List[B] =
  values.map(f)
```

This is the foundation of many Scala abstractions.

---

### 3.3 For-comprehension

Scala's `for` is not just a loop. It is syntax over `map`, `flatMap`, and `withFilter`.

Example:

```scala
val result =
  for
    user <- findUser(userId)
    account <- findAccount(user.accountId)
  yield account.balance
```

You must understand how this expands. It will help you later with:

```text
Option
Either
Future
IO
ZIO
Parser
Stream
```

---

## 4. Stage Three: Object Composition and Extensions

Scala is also an object-oriented language. This stage covers the parts of the language that organize code rather than transform values: traits, classes, composition, and extension methods. Treat these as tools for shaping module boundaries, not as a separate paradigm to fight against the functional core.

### 4.1 Object-oriented Scala and Composition

Scala supports object-oriented programming, but idiomatic Scala often favors composition over inheritance.

Learn:

```text
class
trait
object
companion object
abstract class
constructor
```

Example:

```scala
trait UserRepository:
  def find(id: UserId): Option[User]

final class UserService(repo: UserRepository)
```

Recommended modeling style:

```text
Use case class for data
Use enum for finite states
Use trait for capability boundaries
Use class to compose dependencies
Avoid deep inheritance trees
```

---

### 4.2 Extension Methods

Scala 3 extension methods let you add methods to existing types:

```scala
extension (s: String)
  def isEmail: Boolean =
    s.contains("@")
```

They are useful for:

```text
domain-specific convenience methods
syntax improvements
type class syntax
small DSLs
```

Use them carefully. Too many extension methods can make code harder to understand because method origins become less obvious.

---

## 5. Stage Four: Contextual Abstractions, Type Classes, and Domain Modeling

This stage is the transition from intermediate to advanced Scala 3. `given`/`using`, type classes, and opaque types are the tools you reach for when you want to express invariants in the type system rather than enforce them with runtime checks.

### 5.1 Contextual Abstractions: given and using

Scala 3 replaces many Scala 2 implicit patterns with clearer `given` and `using` syntax.

Example:

```scala
def greet(name: String)(using prefix: String): String =
  s"$prefix $name"

given String = "Hello"

greet("Alice")
```

Learn:

```text
context parameters
given instances
summon
scope resolution
implicit search rules
how to avoid given pollution
```

This is one of the key transitions from intermediate to advanced Scala 3.

---

### 5.2 Type Classes

A type class defines behavior for a type without requiring that type to inherit from an interface.

Example:

```scala
trait JsonEncoder[A]:
  def encode(value: A): String

given JsonEncoder[User] with
  def encode(user: User): String =
    s"""{"email":"${user.email}"}"""

def toJson[A](value: A)(using encoder: JsonEncoder[A]): String =
  encoder.encode(value)
```

Type classes are foundational in Scala libraries such as Cats, Circe, and many functional ecosystems.

You should understand type classes before deeply studying Cats or effect-polymorphic programming.

---

### 5.3 Opaque Types and Domain Modeling

Opaque types allow you to create domain-specific types with little or no runtime overhead.

Example:

```scala
opaque type UserId = String

object UserId:
  def from(value: String): Option[UserId] =
    if value.nonEmpty then Some(value) else None

extension (id: UserId)
  def value: String = id
```

Use opaque types for:

```text
UserId
Email
OrderId
Money
Percentage
NonEmptyString
Quantity
```

This helps prevent primitive obsession, where everything is represented by raw `String`, `Int`, or `BigDecimal`.

---

## 6. Stage Five: Concurrency and Effect Systems

This stage moves from single-threaded transformations to programs that interact with the outside world. Start with `Future` to understand the JVM's standard concurrency story and its limits, then commit to one effect system to learn structured concurrency, typed errors, and resource safety in depth.

### 6.1 Future and Basic Concurrency

Scala's standard library provides `Future` for asynchronous computation:

```scala
val result: Future[User] =
  userRepository.findAsync(id)
```

Learn:

```text
ExecutionContext
map
flatMap
recover
recoverWith
sequence
traverse
timeout patterns
```

Also learn the limitations of `Future`:

```text
Future is eager
cancellation is weak
error channel is not typed
resource management is not very structured
blocking operations require care
```

This prepares you for Cats Effect or ZIO.

---

### 6.2 Effect Systems: Cats Effect or ZIO

Do not start here too early. First become comfortable with:

```text
Option
Either
Future
for-comprehension
map / flatMap
basic type classes
```

Then choose one main effect system.

#### Cats Effect / Typelevel Route

Learn:

```text
IO
Resource
Ref
Deferred
Queue
Fiber
cancellation
structured concurrency
fs2
http4s
doobie
circe
```

Core idea:

```text
Describe effects as values, then let a runtime execute them.
```

Example:

```scala
val program: IO[Unit] =
  for
    user <- readUser
    _    <- sendEmail(user)
  yield ()
```

#### ZIO Route

Learn:

```text
ZIO[R, E, A]
ZLayer
Scope
typed errors
Fiber
Schedule
Queue
Ref
ZStream
ZIO HTTP
zio-json
zio-test
```

ZIO makes dependencies, errors, and results visible in the type:

```scala
ZIO[UserRepo, CreateUserError, User]
```

Choose one route deeply first. Do not try to master Cats Effect and ZIO at the same time in the beginning.

---

## 7. Stage Six: Advanced Types and JVM Engineering

Scala runs on the JVM, and its type system can express much more than most application code requires. This stage is where you go deep on both: enough type-level fluency to read and design libraries, and enough JVM awareness to debug production systems.

### 7.1 Advanced Type System Topics

Learn these gradually after you are comfortable writing real Scala applications.

#### Generics

```scala
def first[A](values: List[A]): Option[A] =
  values.headOption
```

Learn:

```text
type parameters
upper bounds
lower bounds
context bounds
```

#### Variance

```scala
trait Producer[+A]
trait Consumer[-A]
trait Box[A]
```

Understand:

```text
covariance
contravariance
invariance
```

#### Higher-kinded Types

Example:

```scala
trait Repository[F[_]]:
  def findUser(id: UserId): F[Option[User]]
```

This appears in tagless final, Cats, and effect-polymorphic programs.

#### Match Types

Scala 3 supports type-level pattern matching:

```scala
type Elem[X] = X match
  case String => Char
  case Array[t] => t
  case Iterable[t] => t
```

This is mostly useful for library authors.

#### Inline and Macros

Learn later:

```text
inline
transparent inline
compiletime operations
quotes
Expr
```

Application developers usually need to read common macro usage before they need to write macros themselves.

---

### 7.2 JVM and Java Interoperability

Scala 3 runs on the JVM. Advanced Scala developers must understand JVM realities.

Learn:

```text
class loading
heap
stack
GC
JIT
threads
blocking IO
synchronized
volatile
exceptions
classpath
```

Java interop topics:

```text
Java collection conversion
Optional versus Option
CompletableFuture versus Future / IO / ZIO
checked exceptions
null boundaries
annotations
```

No matter how functional your Scala code is, production systems still face JVM issues such as thread pools, blocking calls, GC, dependency conflicts, and classpath problems.

---

## 8. Stage Seven: Engineering Practices and Ecosystem

The final stage covers the tooling, testing, and ecosystem decisions that turn Scala code into shippable systems. None of this is exotic, but Scala's expressiveness makes consistent style, good tests, and well-chosen libraries especially valuable.

### 8.1 Build Tools and Engineering

#### sbt

Learn sbt first:

```text
build.sbt
libraryDependencies
multi-project builds
test
run
assembly
dependency eviction
compiler options
```

Common commands:

```bash
sbt compile
sbt test
sbt run
```

#### Scala CLI and Mill

Scala CLI is convenient for learning and scripts. Mill is used by some teams for larger builds. Learn them after sbt basics.

Suggested order:

```text
sbt first
Scala CLI second
Mill as needed
```

#### Formatting and Linting

Learn:

```text
scalafmt
scalafix
compiler warnings
wartremover or scalafix rules
```

Scala is expressive, so consistent formatting and team conventions matter a lot.

---

### 8.2 Testing

Common testing tools:

```text
ScalaTest
MUnit
weaver-test
zio-test
ScalaCheck
Hedgehog
Discipline
```

Learn:

```text
unit testing
table-driven testing
property-based testing
effectful testing
test fixtures
fakes over excessive mocking
```

Property-based testing is especially valuable in Scala.

Example properties:

```text
reverse(reverse(xs)) == xs
decode(encode(value)) == value
normalizing twice gives the same result as normalizing once
```

---

### 8.3 Web, Database, and Streaming Ecosystem

#### Typelevel Route

Common stack:

```text
Cats Effect
http4s
fs2
doobie
circe
skunk
tapir
```

Characteristics:

```text
highly functional
type-safe
very composable
steeper learning curve
```

#### ZIO Route

Common stack:

```text
ZIO
ZIO HTTP
ZIO JSON
ZIO Config
ZIO Test
Quill
```

Characteristics:

```text
integrated ecosystem
typed errors
environment-based dependency management
strong consistency within the ecosystem
```

#### Actor and Stream Route

For actor systems and distributed applications, learn:

```text
Akka Typed
Apache Pekko
Akka Streams / Pekko Streams
Cluster
Persistence
```

Do not mix too many ecosystems early. Pick one main route and go deep.

---

## Part 2: Recommended Learning Order

A practical learning sequence:

```text
1. Scala 3 syntax and expression-oriented programming
2. Case class, enum, and pattern matching
3. Collections: List, Vector, Map, Option, Either
4. Functional basics: pure functions, immutability, higher-order functions
5. for-comprehension and map / flatMap
6. Class, trait, object, and composition
7. Error modeling with Option and Either
8. Extension methods
9. given / using and contextual abstractions
10. Type class basics
11. Opaque types and domain modeling
12. Future and ExecutionContext
13. sbt, testing, formatting, and engineering workflow
14. JVM and Java interoperability
15. Choose Cats Effect or ZIO as the main effect-system route
16. HTTP, JSON, database, and configuration ecosystem
17. Streaming: fs2, ZStream, or Akka Streams
18. Advanced type system: variance, higher-kinded types, match types
19. Inline, macros, and metaprogramming
20. Performance, GC, thread pools, observability, and production operations
```

---

## Part 3: Project-driven Scala 3 Roadmap

Scala 3 is excellent for project-driven learning, but the projects should be carefully sequenced. Each project should focus on one to three core skills.

Recommended progression:

```text
Scala 3 core
→ functional data modeling
→ error modeling
→ type classes
→ async / Future
→ effect system
→ HTTP / database
→ streaming
→ advanced type-level design
```

---

## Project 1: CLI TODO Tool

### Goal

Build a small command-line TODO app:

```text
todo add "learn Scala 3"
todo list
todo done 1
todo remove 1
```

### Focus

```text
sbt
Scala 3 syntax
case class
enum
List / Vector / Map
Option
Either
pattern matching
basic file IO
unit testing
```

### Suggested model

```scala
case class Todo(
  id: TodoId,
  title: String,
  status: TodoStatus
)

enum TodoStatus:
  case Open
  case Done
```

### Completion criteria

```text
Can add, list, complete, and delete tasks
Data persists to a local file
No null usage
Core logic has tests
Errors are not handled by raw unchecked exceptions
```

---

## Project 2: Order Validator

### Goal

Build a pure domain validator for orders.

Input:

```text
customer email
shipping address
line items
coupon
payment method
```

Output:

```text
valid order
or validation errors
```

### Focus

```text
case class
enum
opaque type
Either
Validated-style thinking
domain error modeling
pure functions
```

### Suggested model

```scala
opaque type Email = String
opaque type OrderId = String
opaque type Quantity = Int

enum ValidationError:
  case EmptyEmail
  case InvalidEmailFormat
  case EmptyCart
  case InvalidQuantity
  case UnsupportedPaymentMethod
```

### Completion criteria

```text
Email, Quantity, and OrderId are not raw String or Int everywhere
Validation errors are modeled as enum values
Business logic is pure
Can accumulate multiple validation errors
Has some property-based tests
```

---

## Project 3: Markdown or Log Analyzer

### Goal

Build a text analysis tool.

Possible directions:

```text
Markdown heading analyzer
access log analyzer
CSV summary tool
```

For a Markdown analyzer:

```text
Read README.md
Output heading hierarchy
Detect heading-level jumps
Count links
Detect duplicate headings
```

### Focus

```text
collections
Iterator
LazyList
foldLeft
pattern matching
regular expressions
file streaming
pure transformations
```

### Completion criteria

```text
Can process reasonably large files
Core parsing logic is pure
IO and business logic are separated
Has test fixture files
Errors are clear
```

---

## Project 4: Mini JSON Encoder Type Class

### Goal

Implement a tiny JSON encoder without using a real JSON library.

Example:

```scala
trait JsonEncoder[A]:
  def encode(value: A): String
```

Support:

```text
String
Int
Boolean
List[A]
Option[A]
case class User
```

Example API:

```scala
def toJson[A](value: A)(using encoder: JsonEncoder[A]): String =
  encoder.encode(value)

extension [A](value: A)
  def toJson(using JsonEncoder[A]): String =
    summon[JsonEncoder[A]].encode(value)
```

### Focus

```text
trait
given
using
summon
extension methods
type classes
generic abstraction
```

### Completion criteria

```text
Can define encoders for custom types
Can compose encoders for Option[A] and List[A]
Uses given / using
Provides extension method syntax
Does not depend on a real JSON library
```

---

## Project 5: Mini Parser Combinator

### Goal

Build a tiny parser combinator library.

Support:

```text
char
string
digit
many
orElse
map
flatMap
```

Suggested model:

```scala
case class Parser[+A](run: String => Either[ParseError, (A, String)])
```

Example:

```scala
val number: Parser[Int] =
  digit.many.map(_.mkString.toInt)
```

### Focus

```text
higher-order functions
map
flatMap
for-comprehension
generic data types
error modeling
functional composition
```

### Completion criteria

```text
Parser has map and flatMap
Can compose parsers with for-comprehension
Errors include position information
Can parse a simple expression or CSV line
Has tests
```

This project teaches why `map`, `flatMap`, and `for-comprehension` are central to Scala.

---

## Project 6: Future-based URL Checker

### Goal

Build an asynchronous URL checker:

```text
check urls.txt --parallelism 20 --timeout 2s
```

Output:

```text
OK      https://example.com       200   120ms
FAILED  https://bad.example.com   timeout
```

### Focus

```text
Future
ExecutionContext
traverse
sequence
recover
timeout
Java HTTP Client interop
controlled parallelism
```

### Completion criteria

```text
Does not launch unlimited parallel requests
Handles timeout
Models errors clearly
Uses ExecutionContext deliberately
Core logic has tests
```

After this project, you should understand:

```text
Future is eager
Future has weak cancellation
blocking IO requires careful thread-pool management
```

---

## Project 7: Choose an Effect System Route

At this stage, choose one main route:

```text
Route A: Cats Effect / Typelevel
Route B: ZIO
```

Do not try to master both at the same time in the beginning.

---

# Route A: Cats Effect / Typelevel Projects

## Project 7A: Cats Effect CLI API Client

### Goal

Build a CLI client that:

```text
reads configuration
calls an external HTTP API
parses JSON
prints results
handles errors
```

### Focus

```text
IO
Resource
retry
timeout
cancellation
http4s client
circe
pure description of effects
```

### Completion criteria

```text
main returns IO[Unit]
HTTP client is managed with Resource
All side effects are represented by IO
Has timeout
Has tests or a mock client
```

---

## Project 8A: http4s Bookmark API

### Goal

Build a small REST API:

```text
POST   /bookmarks
GET    /bookmarks
GET    /bookmarks/{id}
DELETE /bookmarks/{id}
```

### Focus

```text
Cats Effect IO
http4s routes
circe JSON
service / repository layering
EitherT
error handling
Resource
```

### Completion criteria

```text
Domain model and HTTP layer are separated
Errors map to consistent HTTP responses
Repository is a trait
Service logic can be tested independently
Startup and shutdown are managed by Resource
```

---

## Project 9A: Database-backed Bookmark API with Doobie

### Goal

Add PostgreSQL or SQLite persistence to the Bookmark API.

### Focus

```text
doobie
Transactor
ConnectionIO
transactions
SQL mapping
resource safety
migration
integration testing
```

### Completion criteria

```text
Database operations live in the repository layer
Transaction boundaries are clear
Has migrations
Has integration tests
Connection pool is managed by Resource
```

---

## Project 10A: fs2 Streaming Log Processor

### Goal

Build a streaming log processor:

```text
read large log file
parse records as a stream
aggregate status codes and paths
output JSON report
```

### Focus

```text
fs2 Stream
Pipe
Chunk
backpressure
resource safety
concurrent stream processing
```

### Completion criteria

```text
Does not load the full file into memory
Parsing logic is a Pipe
Transformations are composable
Errors are clear
Has benchmark or basic performance observation
```

---

# Route B: ZIO Projects

## Project 7B: ZIO CLI API Client

### Goal

Build a CLI API client.

### Focus

```text
ZIO[R, E, A]
ZLayer
Scope
typed errors
retry Schedule
timeout
zio-json
```

### Completion criteria

```text
Side effects are described with ZIO
Error channel uses domain errors where appropriate
Configuration is injected through Layer
Resources are safe
Has zio-test tests
```

---

## Project 8B: ZIO HTTP Bookmark API

### Goal

Build a small REST API:

```text
POST   /bookmarks
GET    /bookmarks
GET    /bookmarks/{id}
DELETE /bookmarks/{id}
```

### Focus

```text
ZIO HTTP
ZLayer
service pattern
typed errors
JSON codec
middleware
```

### Completion criteria

```text
Repository, service, and HTTP layers are separated
Error channel is explicit
Dependencies are composed with ZLayer
Has zio-test tests
```

---

## Project 9B: ZIO Database-backed API

### Goal

Add database persistence to the Bookmark API.

Possible tools:

```text
Quill
JDBC wrapper
zio-jdbc
```

### Focus

```text
transactions
connection pool
ZLayer resource
typed DB errors
integration testing
```

### Completion criteria

```text
Database resources are managed through Layer
DB errors are converted into domain errors
Transaction boundaries are clear
Has integration tests
```

---

## Project 10B: ZStream Log Processor

### Goal

Build a streaming log processor using ZStream.

### Focus

```text
ZStream
ZPipeline
backpressure
chunks
resource safety
parallel processing
```

### Completion criteria

```text
Does not load large files into memory
Uses ZStream to compose the processing flow
Supports clear error handling
Supports concurrent processing where useful
Has zio-test tests
```

---

# Shared Advanced Projects

The following projects are useful whether you choose Cats Effect or ZIO.

---

## Project 11: Background Job Queue

### Goal

Build a small background job system.

Features:

```text
enqueue job
worker executes job
failure retry
maximum retry count
timeout
graceful shutdown
```

### Focus

```text
fibers
queues
worker pool
retry policy
cancellation
resource safety
structured concurrency
```

Cats Effect concepts:

```text
Queue
Deferred
Ref
Supervisor
Resource
```

ZIO concepts:

```text
Queue
Ref
Promise
Fiber
Schedule
Scope
```

### Completion criteria

```text
Supports multiple workers
Supports retry and backoff
Supports timeout
Supports graceful shutdown
Job state is queryable
Does not leak fibers
```

---

## Project 12: Cache or Rate Limiter

### Goal

Build one of the following:

```text
TTL cache
LRU cache
token bucket rate limiter
sliding window rate limiter
```

### Focus

```text
Ref
state management
concurrency safety
time
atomic updates
testing time-dependent logic
```

### Completion criteria

```text
Concurrency-safe
Supports TTL or rate-limiting rules
Time-dependent logic is testable
Has property-based tests
```

---

## Project 13: Real-time Event Stream Service

### Goal

Build an SSE or WebSocket event service.

Features:

```text
clients subscribe to events
server broadcasts messages
client disconnects are handled
slow clients are isolated
```

### Focus

```text
streaming
PubSub
backpressure
client lifecycle
resource cleanup
concurrent broadcasting
```

### Completion criteria

```text
Resources are released when a client disconnects
Slow clients do not block everyone else
Broadcasting logic is testable
Supports graceful shutdown
```

---

## Project 14: Typed Domain Service

### Goal

Choose a business domain and model its core logic without focusing on Web or database first.

Possible domains:

```text
payment authorization
subscription billing
inventory reservation
ticket booking
workflow approval
```

### Focus

```text
opaque types
enum
state machines
typed errors
illegal states unrepresentable
domain events
pure core + effectful shell
```

Example:

```scala
enum PaymentState:
  case Created
  case Authorized(authId: AuthId)
  case Captured(captureId: CaptureId)
  case Failed(reason: PaymentFailure)
```

### Completion criteria

```text
Illegal states are difficult or impossible to represent
State transitions are pure functions
Errors are typed
Has property-based tests
Side effects are at the boundary
```

This is one of the most valuable Scala projects because it trains type-driven domain modeling.

---

## Project 15: Mini Tagless Final App

### Goal

Build a small application using effect-polymorphic design.

Example:

```scala
trait UserRepository[F[_]]:
  def find(id: UserId): F[Option[User]]

trait EmailService[F[_]]:
  def send(email: Email): F[Unit]

final class UserProgram[F[_]: Monad](
  users: UserRepository[F],
  emails: EmailService[F]
):
  def run(id: UserId): F[Unit] =
    ...
```

### Focus

```text
higher-kinded types
type classes
Monad
effect polymorphism
testability
algebra / interpreter pattern
```

### Completion criteria

```text
Business logic is not tied to a concrete IO or ZIO type
Has a test interpreter
Has a production interpreter
Abstraction is justified and not excessive
You can explain why F[_] is useful here
```

Do this project late, after you are comfortable with an effect system.

---

## Part 4: Recommended Project Order

Full recommended sequence:

```text
1. CLI TODO Tool
2. Order Validator
3. Markdown / Log Analyzer
4. Mini JSON Encoder Type Class
5. Mini Parser Combinator
6. Future URL Checker
7. Choose Cats Effect or ZIO
8. Effect-based API Client
9. Bookmark REST API
10. Database-backed Bookmark API
11. Streaming Log Processor
12. Background Job Queue
13. Cache or Rate Limiter
14. Real-time Event Stream Service
15. Typed Domain Service
16. Mini Tagless Final App
```

Why this order works:

```text
language basics
→ domain modeling
→ collections and data transformation
→ type classes
→ functional composition
→ Future and async
→ effect system
→ HTTP and database
→ streaming
→ concurrency and shared state
→ advanced domain modeling
→ effect-polymorphic design
```

---

## Part 5: If Time Is Limited

If you only do six projects, choose these:

```text
1. Order Validator
2. Mini JSON Encoder Type Class
3. Mini Parser Combinator
4. Future URL Checker
5. Bookmark REST API with Cats Effect or ZIO
6. Typed Domain Service
```

These cover the most important Scala 3 skills:

```text
type modeling
functional composition
given / using
for-comprehension
async and effect systems
HTTP backend development
typed errors
business domain modeling
```

---

## Part 6: Three-version Method for Each Project

For each project, build it in three passes.

### Version 1: Make it work

Implement the core feature first. Do not optimize for perfect abstraction.

### Version 2: Make it idiomatic Scala 3

Improve:

```text
case class and enum modeling
Option and Either usage
pattern matching
immutable data
pure core logic
separation of IO and business logic
```

### Version 3: Add advanced Scala features carefully

Depending on the project, add:

```text
opaque types
given / using
type classes
property-based testing
effect system
Resource or Scope
streaming
typed errors
```

The principle:

> Abstraction should grow from real needs, not from the desire to use advanced syntax.

---

## Part 7: Skill Levels by Project Cluster

The Stage One through Stage Seven structure above describes the **knowledge map**. The clusters below describe what skills you should have practiced after finishing the corresponding **projects**.

## Beginner Level: Projects 1 to 3

You should master:

```text
sbt
Scala 3 syntax
case class
enum
collections
Option / Either
pattern matching
basic testing
pure functions
```

## Intermediate Level: Projects 4 to 10

You should master:

```text
given / using
extension methods
type classes
map / flatMap
for-comprehension
Future
ExecutionContext
effect system basics
HTTP API
JSON
database access
```

## Advanced Level: Projects 11 to 15

You should master:

```text
fibers
Queue / Ref / Deferred / Promise
streaming
backpressure
resource safety
typed domain modeling
property-based testing
higher-kinded types
tagless final
performance and JVM awareness
```

---

## Part 8: Projects to Avoid at the Beginning

These are valuable, but not ideal for early learning:

```text
complete microservice platform
complex Akka Cluster system
large Spark data platform
custom effect system
complex macro library
compiler implementation
large tagless-final architecture
distributed stream processing system
```

They combine too many difficult topics at once:

```text
JVM
concurrency
type system
build tools
dependency management
effect systems
databases
deployment
streaming
distributed systems
```

Early projects should be small and focused.

---

## Part 9: Questions to Ask During Scala 3 Projects

For each project, ask:

```text
Can this domain be modeled more clearly with case class or enum?
Should this use Option, Either, or exception?
Can this error be modeled as a concrete type?
Should this String or Int be an opaque type?
Can this logic be a pure function?
Where is the side-effect boundary?
What does this for-comprehension expand into?
Is this given easy to discover, or does it pollute scope?
Is this type class really necessary?
Is Future enough here, or do I need IO / ZIO?
Are resources safely released?
Does concurrency support cancellation and timeout?
Is the abstraction helping, or just showing off?
```

---

## Part 10: Advanced Scala 3 User Checklist

You are becoming an advanced Scala 3 user when you can:

```text
Model domains clearly with case classes and enums
Use Option and Either to represent absence and failure
Use pattern matching and for-comprehension fluently
Write immutable, composable, testable business logic
Understand given / using scope and resolution rules
Design simple and useful type classes
Use opaque types to avoid primitive obsession
Decide when Future is enough and when IO / ZIO is better
Manage resources, concurrency, cancellation, and errors safely
Organize sbt multi-module projects
Interop with Java libraries and JVM ecosystem safely
Read Cats Effect, ZIO, fs2, http4s, or ZIO HTTP code
Avoid excessive abstraction and type gymnastics
Think about thread pools, blocking, GC, performance, and observability
```

---

## Final Note

Scala 3 is not about writing the most abstract code possible. Mature Scala code should be:

```text
clear in its domain model
precise in its types
moderate in its abstractions
explicit about errors
careful with side effects
safe in resource management
readable by a team
stable on the JVM
```

The ultimate goal is to combine Scala 3's type system, functional programming model, and JVM engineering capabilities to build systems that are safer, clearer, and easier to maintain.
