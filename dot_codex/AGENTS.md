# Code readability

Write code for the person who will read and change it next. Spend the
lines and whitespace needed to make the logic easy to follow.

## Structure on the page

Group related statements and use blank lines between distinct steps.
Give validation, data preparation, and state changes their own visual
space when they occur in the same function.

Use ordinary control flow when a dense expression would hide branches,
side effects, or error handling. Name intermediate results when the
name helps explain what the next step does.

## Names

Use names that describe what a value represents or what an operation
does in the domain. Name booleans so their conditions read naturally.
Use abbreviations when they are familiar in the surrounding code.

## Comments

When semantic names and clear structure still leave something the reader
needs to know unclear, add a concise comment that supplies the missing
explanation.

Prefer short inline comments when the reader needs help following the
flow. Put a short comment paragraph before the section when the reader
needs context to understand what follows. Use both when the context and
the flow each need explanation.

## Abstractions

Start with code shaped around the behavior needed today. Extract a
helper when it gives a meaningful operation a name, or when multiple
callers need to share the same rule. Introduce a general interface once
the code has concrete uses that require it.
