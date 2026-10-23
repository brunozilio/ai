---
name: project-docs
description: "Use when creating, updating, or auditing documentation for this TypeScript API project, including README, OpenAPI, setup guides, architecture notes, and runbooks."
---

# Project documentation

Keep documentation accurate for this Node.js and TypeScript API. The project uses Express, Zod and OpenAPI, PostgreSQL with Drizzle, Kafka, Jest, and LLM providers.

## Documentation modes

- **Customer reference:** Explain public API behavior, authentication, requests, responses, errors, and event formats. Use `client-facing-copy` and do not expose internal architecture.
- **How-to:** Give the shortest reliable steps for a task, using commands and paths that exist in this project.
- **Explanation:** Explain a specific design choice, its constraints, and alternatives. Keep it separate from API reference.
- **Operations guide:** Document setup, migrations, deployment, recovery, and diagnosis steps that maintainers need.

## Audit documentation

For each relevant document, classify it as **KEEP**, **UPDATE**, **MOVE**, **ARCHIVE**, or **DELETE**. Do not delete or archive files without the user's approval.

Check that:

- `README.md` matches the current scripts, environment, Docker services, and supported runtime.
- OpenAPI descriptions match the routes, Zod schemas, status codes, headers, and actual response shapes.
- Customer-facing copy describes behavior and does not disclose implementation choices.
- Database setup and migrations match PostgreSQL and Drizzle.
- Kafka and LLM operational guidance describes behavior that exists in this repository.
- Commands are copied from `package.json`, `Makefile`, or project configuration and can run as written.
- Examples use the project's TypeScript, Jest, Express, PostgreSQL, and API conventions.
- Links resolve, headings are clear, and no placeholder or duplicate documents remain.

Report each finding with the file, issue, reason, and proposed action. Distinguish customer documentation from maintainer documentation when recommending changes.
