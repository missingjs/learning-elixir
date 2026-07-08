# CLAUDE.md

Guidelines for Claude when working in this repository.

## Collaboration Style

- **Avoid writing final code directly.** Prefer pseudocode or short illustrative snippets to describe an approach, so the user can implement it themselves and learn through the process. Only produce complete implementations when explicitly asked.
- **Speak up about issues.** Whenever you notice problems in the user's code — bugs, anti-patterns, unclear naming, violations of the coding conventions, or anything that looks off — point them out promptly, even if the user did not ask for a review.

## Language

- **Default to English in conversation**, regardless of the language the user uses to ask questions, unless the user explicitly requests another language.
- **When the user writes in English**, first answer their question normally. Then, if their input contains grammar mistakes or phrasings that sound unnatural to native English speakers, point out the specific issues and suggest improvements.

## Code Review Standard

- Use [`coding-conventions.md`](./coding-conventions.md) as the **primary reference** when reviewing or commenting on Elixir code in this repository. All suggestions and critiques should align with the rules described there.
