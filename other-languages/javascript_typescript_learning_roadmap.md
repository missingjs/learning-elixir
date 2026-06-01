# JavaScript and TypeScript Learning Roadmap

## Purpose

This roadmap is designed for learners who want to master **JavaScript and TypeScript as languages**, rather than being immediately absorbed by the enormous frontend ecosystem.

JavaScript and TypeScript should be understood as a continuum:

- **JavaScript** defines the runtime behavior.
- **TypeScript** provides a typed development layer on top of JavaScript.
- TypeScript improves safety, design, and maintainability, but it does not replace the need to understand JavaScript runtime semantics.

The central learning principle is:

```text
Learn JavaScript runtime behavior first.
Then learn TypeScript type modeling.
Use frontend and Node.js topics as application contexts, not as the center of the roadmap.
```

---

## 1. Core Learning Philosophy

JavaScript and TypeScript are often learned through frontend frameworks such as React, Vue, Next.js, or Angular. That approach can be useful, but it often leads to a shallow understanding of the language itself.

A better route is:

```text
JavaScript runtime semantics
-> modern JavaScript programming model
-> asynchronous programming
-> modules and tooling
-> TypeScript type system
-> typed application architecture
-> selected browser and Node.js contexts
```

Avoid this route early on:

```text
React / Next.js / CSS / build tools / state libraries
-> scattered JavaScript knowledge
-> partial TypeScript usage
```

The goal is to become someone who understands why JS/TS programs behave the way they do, not merely someone who can assemble framework code.

---

## 2. Stage One: JavaScript Runtime Foundations

The first stage is understanding how JavaScript actually executes. JavaScript is not difficult because of syntax — it is difficult because of its runtime model. Most "weird JS" stories trace back to a handful of concepts: references, scope, closures, `this`, and prototypes. Get these right and modern features start to look like ergonomic shortcuts rather than magic.

### 2.1 JavaScript Runtime Fundamentals

JavaScript is not difficult because of syntax. It is difficult because of its runtime model.

You should systematically learn:

- Primitive values vs objects
- Value copying vs reference sharing
- Mutation and immutability
- Scope and lexical environments
- Closures
- `this` binding
- Prototypes and classes
- Property descriptors
- Iteration protocols
- Error handling
- Event loop
- Promise and async execution

#### Key Concepts

##### Values, Objects, and References

You need to understand how references are shared:

```js
const a = { count: 1 }
const b = a
b.count = 2

console.log(a.count) // 2
```

This affects almost every modern JS/TS program, including React state updates, caches, memoization, data transformation, and API response handling.

##### Scope and Closure

Closures are central to JavaScript:

```js
function createCounter() {
  let count = 0

  return function increment() {
    count += 1
    return count
  }
}
```

You should understand:

- Lexical scope
- Function scope vs block scope
- `let`, `const`, and `var`
- Closure over variables, not just values
- Closure in callbacks, event handlers, async code, and React hooks

##### `this`

`this` is determined by how a function is called, not where it is defined.

You should understand:

- Global `this`
- Method call `this`
- Function call `this`
- Arrow function lexical `this`
- `bind`, `call`, and `apply`
- Class methods and lost `this`

##### Prototypes and Classes

JavaScript classes are built on top of prototypes.

Learn:

- Prototype chain
- Constructor functions
- `class` syntax
- Method lookup
- `instanceof`
- `Object.create`

Modern code may use classes or composition, but prototypes remain essential to understanding JavaScript.

---

### 2.2 Modern JavaScript Language Features

After understanding the runtime model, become comfortable with modern JavaScript syntax and idioms:

- Destructuring
- Rest and spread
- Optional chaining
- Nullish coalescing
- Template literals
- Arrow functions
- Default parameters
- Modules
- Iterators and generators
- `Map`, `Set`, `WeakMap`, `WeakSet`
- `Array` methods
- `Object` utilities

Important collection methods:

```text
map
filter
reduce
flatMap
some
every
find
findIndex
sort
toSorted
toSpliced
with
```

A mature JavaScript developer should understand whether each operation mutates data or returns a new value.

---

## 3. Stage Two: Asynchronous JavaScript

Asynchronous programming deserves its own stage. The JavaScript event loop and the Promise model shape almost every real program — frontend rendering, network calls, file IO, timers — and this is also where most subtle bugs live. Learn it deliberately rather than picking it up by osmosis from framework code.

### 3.1 Asynchronous JavaScript

Asynchronous programming is one of the most important parts of JS/TS.

You should learn:

- Callback style
- Promise
- `async` / `await`
- `Promise.all`
- `Promise.allSettled`
- `Promise.race`
- `Promise.any`
- Error propagation
- Unhandled rejection
- Timeout
- Cancellation
- `AbortController`
- Async iterator
- Streams

### 3.2 Event Loop

You must understand:

- Call stack
- Task / macrotask queue
- Microtask queue
- Promise jobs
- `setTimeout`
- `queueMicrotask`
- Browser event loop
- Node.js event loop

Example:

```js
console.log("A")

Promise.resolve().then(() => console.log("B"))

setTimeout(() => console.log("C"), 0)

console.log("D")
```

Output:

```text
A
D
B
C
```

Key questions to answer:

```text
Is Promise eager or lazy?
Does await block the thread?
What happens when Promise.all fails?
How do you limit concurrency?
How do you cancel a fetch request?
How do you handle partial success and partial failure?
What does an async function return?
```

---

## 4. Stage Three: TypeScript Fundamentals

The next stage is putting types on the JavaScript you already understand. TypeScript is not a separate runtime — it is a typed development layer over the JS semantics from Stage One. Begin by learning the basic type system and the crucial principle that types are erased at runtime.

### 4.1 TypeScript as Typed JavaScript

TypeScript should be understood as a typed layer over JavaScript, not as a separate runtime language.

TypeScript types are mostly erased at runtime. This means:

```ts
type User = {
  name: string
}

const user: User = JSON.parse(input)
```

The type annotation does not validate that `input` is actually a `User` at runtime.

This is a crucial principle:

```text
TypeScript improves compile-time safety, but runtime data still needs runtime validation.
```

---

### 4.2 TypeScript Fundamentals

Learn the basic type system first:

- `string`
- `number`
- `boolean`
- `bigint`
- `symbol`
- `null`
- `undefined`
- `object`
- Arrays
- Tuples
- Literal types
- Union types
- Intersection types
- Type aliases
- Interfaces
- Function types

Avoid thinking of TypeScript as merely adding annotations:

```ts
const name: string = "Alice"
```

The real value of TypeScript is type modeling.

---

## 5. Stage Four: Type Modeling and Runtime Validation

This is the stage where TypeScript starts paying for itself. You stop annotating values and start designing types: discriminated unions for state, generics for reuse, branded types for domain identity. Pair that with runtime validation at every boundary, because the compiler trusts your annotations but the network and disk do not.

### 5.1 Type Modeling with TypeScript

TypeScript becomes powerful when you model state, errors, and API boundaries.

Instead of this:

```ts
type Payment = {
  status: string
  transactionId?: string
  errorMessage?: string
}
```

Prefer this:

```ts
type Payment =
  | { status: "pending" }
  | { status: "paid"; transactionId: string }
  | { status: "failed"; errorMessage: string }
```

This allows the compiler to help you prevent invalid states.

#### Important TypeScript Concepts

##### Narrowing

Learn:

- `typeof` narrowing
- `instanceof` narrowing
- `in` operator
- Discriminated unions
- Custom type guards
- Control-flow analysis

Example:

```ts
function render(value: string | number) {
  if (typeof value === "string") {
    return value.toUpperCase()
  }

  return value.toFixed(2)
}
```

##### Discriminated Unions

Use them to model state and errors:

```ts
type Result<T, E> =
  | { ok: true; value: T }
  | { ok: false; error: E }
```

##### Generics

Generics are essential for reusable TypeScript:

```ts
function first<T>(items: T[]): T | undefined {
  return items[0]
}
```

Learn:

- Generic functions
- Generic types
- Generic interfaces
- Constraints
- Default type parameters
- `keyof`
- Indexed access types

##### Utility Types

Important built-in utility types:

```text
Partial<T>
Required<T>
Readonly<T>
Pick<T, K>
Omit<T, K>
Record<K, V>
ReturnType<T>
Parameters<T>
Awaited<T>
NonNullable<T>
Extract<T, U>
Exclude<T, U>
```

##### Structural Typing

TypeScript uses structural typing:

```ts
type User = { id: string }
type Product = { id: string }

const user: User = { id: "u1" }
const product: Product = user // allowed
```

This is convenient, but it can mix up domain concepts. Later, learn branded types or opaque type patterns.

Example:

```ts
type UserId = string & { readonly brand: unique symbol }
```

##### Conditional and Mapped Types

Learn these after you are comfortable with everyday TypeScript:

```ts
type Nullable<T> = {
  [K in keyof T]: T[K] | null
}
```

```ts
type UnwrapPromise<T> =
  T extends Promise<infer A> ? A : T
```

These are especially important for library design, schema inference, API clients, and framework typings.

---

### 5.2 Runtime Validation

All external input should be treated as untrusted:

- `JSON.parse`
- `fetch` responses
- `localStorage`
- URL query parameters
- Form input
- Message events
- Database responses
- Third-party SDKs

Mature TypeScript projects validate data at boundaries.

Common libraries include:

- Zod
- Valibot
- io-ts
- ArkType
- TypeBox

Core principle:

```text
Validate at runtime boundaries.
Use reliable static types inside the application.
```

Example:

```ts
const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
})

const user = UserSchema.parse(json)
```

This connects compile-time types with runtime safety.

---

## 6. Stage Five: Modules, Tooling, and Environments

A program is more than its source. This stage covers how JS/TS code is packaged, configured, and executed — module systems, tsconfig, package managers, and the two main runtimes you will actually deploy to (browsers and Node.js). Learn enough of each to be deliberate, not exhaustive.

### 6.1 Modules, Packages, and Tooling

You should understand the module system:

- ES Modules
- CommonJS
- `import` / `export`
- Default export
- Named export
- Dynamic import
- Tree shaking
- Module resolution
- `package.json`
- npm packages
- ESM vs CJS

Package management:

- npm
- pnpm
- yarn
- Lock files
- Semantic versioning
- `dependencies` vs `devDependencies`

TypeScript project configuration:

- `tsconfig.json`
- `strict`
- `noUncheckedIndexedAccess`
- `exactOptionalPropertyTypes`
- `module`
- `moduleResolution`
- `target`
- `lib`

Recommended strict settings:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true
  }
}
```

Tooling to learn early:

- TypeScript compiler
- Vitest or Jest
- ESLint
- Prettier
- Vite
- `tsx`
- `tsc --noEmit`

Do not try to master every bundler immediately. Learn what problem each tool solves.

---

### 6.2 Minimal Browser Knowledge

Frontend knowledge is useful, but it should not dominate this roadmap.

Learn the minimal browser environment needed to understand JavaScript in the browser:

- DOM
- DOM events
- Event bubbling and capturing
- `fetch`
- `AbortController`
- `FormData`
- `localStorage` and `sessionStorage`
- `URL` and `URLSearchParams`
- Basic browser security concepts

Delay advanced frontend topics:

- Complex CSS
- Large React architecture
- Next.js
- SSR / SSG / RSC
- Complex state management
- Micro-frontends
- Design systems
- Deep Webpack configuration

React can be learned later as an application context for JS/TS, not as the starting point.

---

### 6.3 Node.js Basics

Node.js helps you understand JavaScript outside the browser.

Learn:

- Node.js module system
- `fs/promises`
- `path`
- `process`
- Environment variables
- Streams
- `EventEmitter`
- Basic HTTP server
- CLI tools
- Worker threads basics

This allows you to build:

- CLI tools
- Automation scripts
- Test utilities
- Small backend services
- Build tools

---

## 7. Stage Six: Error Handling and Testing

The final stage of the knowledge map is how you make programs reliable. Errors and tests are not afterthoughts — they are how runtime behavior, async control flow, and types come together. Decide deliberately when to throw and when to return a Result, and treat tests as the place where async, time, and types are forced to behave.

### 7.1 Error Handling

JavaScript and TypeScript error handling should be studied deliberately.

Learn:

- `throw`
- `try` / `catch` / `finally`
- `Error` objects
- Custom error classes
- Promise rejection
- Unhandled rejection
- Result pattern
- Typed error modeling

Two useful styles:

```text
Exception-based errors
Result/Either-based errors
```

Example Result type:

```ts
type Result<T, E> =
  | { ok: true; value: T }
  | { ok: false; error: E }
```

You should understand:

- Which errors should be thrown
- Which errors should be returned
- How to preserve context
- How to handle async errors
- How to represent expected failures in types

---

### 7.2 Testing

Testing is one of the best ways to learn JS/TS deeply.

Learn:

- Vitest or Jest
- Unit tests
- Table-driven tests
- Mocking
- Fake timers
- Async tests
- DOM testing basics
- Property-based testing
- Type-level tests

Testing helps reinforce:

- Pure functions
- Async behavior
- Time-dependent logic
- Module boundaries
- Runtime validation
- Error handling

---

# Project-Driven Learning Roadmap

## Project 1: JavaScript Utilities Library

Build a small utility library.

Functions:

```text
chunk(array, size)
groupBy(array, keyFn)
debounce(fn, delay)
throttle(fn, delay)
deepClone(value)
isPlainObject(value)
memoize(fn)
```

Focus:

- Values vs references
- Mutation vs immutability
- Array methods
- Functions as values
- Closures
- `this`
- Rest and spread

Completion criteria:

- All utilities have tests.
- Mutation behavior is explicit.
- `debounce` and `throttle` use closures.
- Edge cases are documented.

---

## Project 2: Event Loop Playground

Create a small CLI or browser-based experiment collection showing async execution order.

Focus:

- Call stack
- Microtasks
- Macrotasks
- Promise jobs
- `setTimeout`
- `queueMicrotask`
- `async` / `await`
- Browser vs Node.js event loop

Completion criteria:

- At least 10 examples.
- Each example includes predicted and actual output.
- You can explain the output order.

---

## Project 3: Promise Utilities

Implement Promise helpers.

Functions:

```text
delay(ms)
timeout(promise, ms)
retry(fn, options)
parallelLimit(tasks, concurrency)
promiseAllSettledLite(promises)
raceWithTimeout(promise, ms)
```

Focus:

- Promise composition
- `async` / `await`
- Error propagation
- Concurrency control
- Timeout
- Preparation for cancellation

Completion criteria:

- Supports concurrency limits.
- Supports retry.
- Supports timeout.
- Tests cover success, failure, timeout, and partial failure.

---

## Project 4: Mini EventEmitter

Implement a simplified EventEmitter.

Features:

```text
on(event, handler)
off(event, handler)
once(event, handler)
emit(event, payload)
listenerCount(event)
```

Second version: rewrite it as a typed TypeScript EventEmitter.

Example:

```ts
type Events = {
  login: { userId: string }
  logout: { userId: string }
  error: { message: string }
}

const emitter = new TypedEventEmitter<Events>()

emitter.on("login", payload => {
  console.log(payload.userId)
})
```

Focus:

- Closure
- `Map` and `Set`
- Callback lifecycle
- Generic types
- `keyof`
- Indexed access types

Completion criteria:

- JavaScript version works.
- TypeScript version infers payload types from event names.
- `once` fires only once.
- `off` removes handlers correctly.

---

## Project 5: CLI TODO Tool

Build a Node.js command-line TODO app.

Commands:

```text
todo add "learn TypeScript"
todo list
todo done 1
todo remove 1
todo search "typescript"
```

Focus:

- Node.js basics
- `fs/promises`
- `path`
- `process.argv`
- JSON persistence
- Modules
- TypeScript project setup
- Error handling

Suggested structure:

```text
todo-cli/
├── src/
│   ├── domain/
│   ├── storage/
│   ├── cli/
│   └── main.ts
├── test/
├── package.json
└── tsconfig.json
```

Completion criteria:

- Written in TypeScript.
- Domain logic is separated from CLI parsing.
- Data persists to a JSON file.
- Core logic has tests.
- Errors are clear.

---

## Project 6: Runtime Schema Validator

Build a minimal runtime validation library.

Example API:

```ts
const UserSchema = object({
  id: string(),
  age: number(),
  email: string(),
})

const result = UserSchema.parse(input)
```

Support:

```text
string
number
boolean
array
object
optional
literal
union
```

Advanced goal:

```ts
type User = Infer<typeof UserSchema>
```

Focus:

- `unknown`
- Type guards
- Runtime validation
- Generic inference
- Conditional types
- Mapped types
- Schema-to-type inference

Completion criteria:

- External input is `unknown`, not `any`.
- Successful parse returns a reliable static type.
- Failed parse returns useful errors.
- Object, array, and optional fields are supported.

---

## Project 7: Typed Result Library

Build a small Result / Either-style library.

Type:

```ts
type Result<T, E> =
  | { ok: true; value: T }
  | { ok: false; error: E }
```

Functions:

```text
ok(value)
err(error)
map(result, fn)
mapError(result, fn)
andThen(result, fn)
unwrapOr(result, fallback)
fromThrowable(fn)
fromPromise(promise)
```

Focus:

- Discriminated unions
- Generic types
- Typed errors
- Functional composition
- Async error handling

Completion criteria:

- Type narrowing works correctly.
- Supports sync and async error conversion.
- Avoids unnecessary `throw`.
- Can compose multiple fallible operations.

---

## Project 8: Typed HTTP Client

Build a small typed API client.

Example:

```ts
const user = await client.get("/users/:id", {
  params: { id: "u1" },
})
```

Focus:

- `fetch`
- `AbortController`
- Timeout
- Runtime validation
- Generic API response typing
- Template literal types
- Typed errors

Completion criteria:

- Supports GET and POST.
- Supports timeout and cancellation.
- Response data is runtime-validated.
- Errors distinguish network, timeout, validation, and server errors.
- Return values have accurate TypeScript types.

---

## Project 9: Markdown / CSV / JSON Parser

Choose one small parser:

```text
Markdown heading parser
CSV parser
JSON subset parser
URL query parser
```

Focus:

- String processing
- State machines
- Iterators and generators
- Error reporting
- Pure functions
- TypeScript union states

Completion criteria:

- Core parser is pure.
- Errors include line and column.
- Common edge cases are handled.
- Tests cover valid and invalid inputs.

---

## Project 10: Browser DOM Mini App

Build a small app without a frontend framework.

Options:

```text
Habit tracker
Bookmark manager
Expense tracker
Notes app
```

Requirements:

- Vanilla TypeScript
- DOM API
- Event handling
- `localStorage`
- `URLSearchParams`
- `FormData`

Focus:

- Browser runtime
- DOM events
- Event bubbling
- State updates
- Render functions
- Immutability
- Runtime validation at storage boundary

Completion criteria:

- No React or Vue.
- State has clear TypeScript types.
- `localStorage` reads are validated.
- DOM update logic is clear.

---

## Project 11: Tiny Reactive State System

Implement a tiny reactive state or store system.

Example API:

```ts
const store = createStore({ count: 0 })

store.subscribe(state => console.log(state.count))

store.setState(state => ({ count: state.count + 1 }))
```

Focus:

- Closure
- Subscription lifecycle
- Observer pattern
- Immutability
- Generic state type
- Memory leak prevention

Completion criteria:

- Supports subscribe / unsubscribe.
- Supports state updates.
- TypeScript infers state type.
- No duplicate subscription leaks.

---

## Project 12: React + TypeScript Mini App

Build a small React app, but keep the focus on language and types rather than UI complexity.

Options:

```text
Task board
Searchable notes
Small dashboard
Form wizard
```

Focus:

- Typed props
- Typed state
- Discriminated union state
- Custom hooks
- Async data loading
- Runtime validation
- Event typing
- Form typing

Example state:

```ts
type LoadState<T> =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; error: string }
```

Completion criteria:

- All props are typed.
- Async state is not represented by scattered booleans.
- API responses are validated.
- Custom hooks have clear input and output types.
- No unnecessary state management library.

---

## Project 13: Node.js HTTP API Server

Build a small API server using Node.js directly or a lightweight framework such as Hono or Fastify.

Endpoints:

```text
POST   /bookmarks
GET    /bookmarks
GET    /bookmarks/:id
DELETE /bookmarks/:id
```

Focus:

- Node.js HTTP model
- Request / response handling
- Routing
- JSON parsing
- Runtime validation
- Typed service layer
- Error responses
- Testing

Recommended layers:

```text
domain
service
repository
http
```

Completion criteria:

- Request bodies are runtime-validated.
- Service layer does not depend on HTTP.
- Error response format is consistent.
- Handlers have tests.
- Supports graceful shutdown.

---

## Project 14: Async Job Queue

Build an in-memory background job queue.

Features:

```text
enqueue job
worker executes job
retry on failure
maximum retry count
timeout
cancellation
status query
```

Focus:

- Promise concurrency
- `AbortController`
- Queue design
- Retry
- Backoff
- Async state machines
- Typed job payloads

Example status model:

```ts
type JobStatus =
  | { type: "queued" }
  | { type: "running"; startedAt: Date }
  | { type: "succeeded"; completedAt: Date }
  | { type: "failed"; error: string }
```

Completion criteria:

- Supports multiple workers.
- Supports concurrency limits.
- Supports timeout.
- Failed jobs can retry.
- State is modeled with discriminated unions.
- Tests use fake timers where appropriate.

---

## Project 15: Advanced TypeScript Type Challenges

Create a type-level utility package.

Implement:

```ts
type DeepReadonly<T> = ...
type DeepPartial<T> = ...
type PickByValue<T, V> = ...
type AwaitedAll<T> = ...
type Path<T> = ...
type PathValue<T, P> = ...
type UnionToIntersection<T> = ...
```

Focus:

- Conditional types
- Mapped types
- `infer`
- Template literal types
- Recursive types
- Distribution over unions
- Type-level testing

Completion criteria:

- Each utility has type tests.
- You can explain conditional type distribution.
- You know which utilities are appropriate for application code and which are mainly for library design.

---

# Recommended Project Order

```text
1. JavaScript Utilities Library
2. Event Loop Playground
3. Promise Utilities
4. Mini EventEmitter
5. CLI TODO Tool
6. Runtime Schema Validator
7. Typed Result Library
8. Typed HTTP Client
9. Markdown / CSV / JSON Parser
10. Browser DOM Mini App
11. Tiny Reactive State System
12. React + TypeScript Mini App
13. Node.js HTTP API Server
14. Async Job Queue
15. Advanced TypeScript Type Challenges
```

The progression is:

```text
JavaScript values and functions
-> event loop and async behavior
-> typed events and generics
-> Node.js and TypeScript setup
-> runtime validation
-> typed error modeling
-> browser environment
-> small frontend framework usage
-> backend TypeScript
-> advanced async architecture
-> advanced TypeScript type system
```

---

# If Time Is Limited

Prioritize these projects:

```text
1. Promise Utilities
2. Mini EventEmitter
3. Runtime Schema Validator
4. Typed Result Library
5. Typed HTTP Client
6. Browser DOM Mini App
7. Async Job Queue
```

These cover the most important JS/TS skills:

- Closure
- Event loop
- Promise and async control flow
- Generics
- Discriminated unions
- Runtime validation
- Typed errors
- Browser APIs
- Cancellation
- Concurrency control

---

# Three-Version Method for Each Project

## Version 1: JavaScript First

Focus on behavior:

- Runtime semantics
- Data mutation
- Closure
- Async behavior
- Module boundaries

## Version 2: TypeScript Rewrite

Focus on modeling:

- `unknown` instead of `any`
- Generic APIs
- Discriminated unions
- Narrowing
- Strict `tsconfig`
- Typed errors

## Version 3: Testing and Tooling

Focus on reliability:

- Vitest or Jest
- ESLint
- Prettier
- `tsc --noEmit`
- Fake timers
- Type tests
- Coverage

This three-step method is especially effective for JS/TS because it prevents you from being overwhelmed by runtime behavior, type modeling, and tooling all at once.

---

# Common Mistakes to Avoid

## Mistake 1: Learning React Before JavaScript

React is valuable, but it should not replace learning JavaScript.

Understand closures, async behavior, mutation, modules, and `this` first.

## Mistake 2: Treating TypeScript as Runtime Validation

TypeScript does not validate JSON, API responses, or localStorage data at runtime.

Validate data at system boundaries.

## Mistake 3: Using `any` to Escape Design Problems

`any` removes the benefits of TypeScript.

Prefer:

```text
unknown
narrowing
schema validation
generic constraints
discriminated unions
```

## Mistake 4: Overusing Advanced Type Tricks

Conditional types and recursive mapped types are useful, but they can become unreadable.

Application code should prioritize clarity.

## Mistake 5: Ignoring Cancellation and Timeout

Modern JS/TS code often talks to networks, files, timers, and user interfaces.

Learn `AbortController`, timeout patterns, cleanup, and partial failure handling.

---

# Advanced User Checklist

You are moving toward advanced JS/TS proficiency when you can:

```text
Explain value vs reference behavior
Avoid accidental object mutation
Use closures intentionally
Explain `this` binding rules
Understand prototypes and classes
Explain microtasks and macrotasks
Compose Promises safely
Handle async errors correctly
Implement cancellation and timeout
Design clear module boundaries
Use TypeScript to model state and errors
Use discriminated unions to avoid invalid states
Write useful generic functions and types
Understand structural typing and branded types
Validate runtime data at boundaries
Configure strict TypeScript projects
Write reliable async tests
Build small Node.js and browser programs
Read modern TypeScript frontend or backend projects
Use React as an application context without letting it dominate language learning
```

---

# Final Goal

The goal of this roadmap is not to become a framework user first. It is to become someone who deeply understands:

```text
How JavaScript runs
How asynchronous JavaScript behaves
How TypeScript models programs
How runtime data and static types interact
How to design reliable JS/TS modules
How to use browser and Node.js environments deliberately
```

After completing this roadmap, you should be able to move into React, Next.js, Node.js backend development, frontend tooling, or full-stack TypeScript with a much stronger foundation.
