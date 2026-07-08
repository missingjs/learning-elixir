# Elixir Coding Conventions

## Basic Principles

For every module or function, do your best to:

- Follow the basic principles
  - [Single Responsibility](https://en.wikipedia.org/wiki/Single-responsibility_principle)
  - [KISS](https://en.wikipedia.org/wiki/KISS_principle)
  - [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
- Set clear and informative names
- Keep functions and control structures concise

## Code Style

- Prefer **explicit pattern matching** over dot access for maps and structs
- Prefer functions with **meaningful names and clear guard clauses** over nested conditional clauses (`case` / `cond` / `if`) within a single function
- When using `import`, prefer setting the `only` option to **explicitly specify the functions/macros to be imported** (unless importing a well-known module like `Ecto.Query`)
- **Avoid creating macros** unless you have a very good reason. Follow [Write macros responsibly](https://elixir-lang.org/getting-started/meta/macros.html#write-macros-responsibly): keep your macro definitions short, including their quoted contents
- Documentation and unit tests are nice to have
- Follow the conventions already used in the source code

## Error Handling

- **Use string interpolation in return values only when necessary.** In general, follow the patterns of function returns you see in the source and use terms like tuples / atoms / maps / structs to build structured returns that can be easily read by the machine.

  - Bad

    ```elixir
    {:error, "upload failure: #{object}"}
    ```

  - Good

    ```elixir
    {:error, :upload_failed}
    # or
    {:error, {:upload_failed, object}}
    ```

## Special Rules for the `with/1` Macro

- Keep the `else` clause as clean as possible
- Do not overuse `with`. Ideally, only use it in entry-level functions of a module
