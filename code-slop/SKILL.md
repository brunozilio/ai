---
name: code-slop
description: "Use when reviewing TypeScript implementation or Jest tests for needless complexity, generic AI-generated patterns, or code that is harder to maintain than its behavior requires."
---

# TypeScript code quality review

Review the requested diff or files. Report only concrete issues that make this Node.js API harder to understand, test, or change. Do not treat personal style preferences as defects.

Check for:

- Comments that repeat the next line, empty documentation, or unfinished placeholders.
- Vague names where the domain has a clearer term, and long names that obscure rather than clarify.
- Interfaces, wrappers, classes, or dependencies added without a real need or a second implementation.
- Broad catches, silent fallbacks, redundant guards, and unsafe casts such as `as any`.
- Tests that assert implementation details, only check that code does not throw, or mock every meaningful boundary.
- Debug output or temporary code in shipped paths.
- Repeated validation inside the system after input has already been parsed at a boundary.

Respect established project patterns, including Zod validation, discriminated unions, structured logging, Jest, and the existing module layout. Do not demand arbitrary formatting differences, comments, TODOs, or deliberate "rough edges."

## Output

List findings by file and line. For each, explain the observable maintenance or correctness cost and suggest a focused change. Use **CLEAN** when no meaningful issue is present. Do not label code as AI-generated based only on style.
