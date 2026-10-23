---
name: technical-debt
description: "Use when auditing or prioritizing technical debt in this Node.js and TypeScript API, especially its Express routes, authentication, PostgreSQL/Drizzle data layer, Kafka processing, tests, and LLM integrations."
---

# Technical debt

Audit this project as a TypeScript API. Use evidence from source, migrations, configuration, tests, and commands. Do not assume frameworks or infrastructure that are not present.

## Audit checklist

- **Code:** Look for duplication, excessive branching, dead code, unsafe casts, unclear ownership, and abstractions that add indirection without value.
- **API and security:** Check Zod validation at request boundaries, organization-level authorization, API-key and OAuth handling, rate limits, safe error responses, and request size limits.
- **Data:** Check Drizzle schemas and migrations, PostgreSQL constraints, foreign keys, indexes, transaction boundaries, and organization scoping in every data access path.
- **Kafka and retries:** Check delivery guarantees, duplicate processing, idempotency, retry behavior, poison messages, consumer lifecycle, and observability.
- **LLM integrations:** Check timeouts, response validation, error propagation, secret handling, resource cleanup, and provider-specific behavior at integration boundaries.
- **Performance:** Look for unbounded reads, missing pagination, inefficient queries, connection-pool issues, synchronous work on request paths, and unmeasured performance claims.
- **Tests:** Check meaningful Jest coverage of API contracts, authorization, failure cases, database behavior, and event processing. Flag brittle tests, excessive mocks, disabled tests, and flaky timing assumptions.
- **Dependencies and runtime:** Review `package.json` and the lockfile with npm tooling. Check supported Node.js versions and deprecated APIs used by this codebase.
- **Operations:** Check migration safety, configuration validation, structured logs, request correlation, health checks, graceful shutdown, and recovery steps.
- **Documentation:** Compare README, OpenAPI, and operational guidance with implemented behavior.

## Evidence and priority

For each finding, include the file and line or exact command evidence, user or operational impact, remediation, and effort (**S**, **M**, or **L**). Rank critical security or data-integrity issues first, then high-impact reliability and API-contract issues, then maintainability and low-impact improvements.

Mark checks **N/A** only when the project has no corresponding behavior. Do not report generic recommendations as findings without evidence. Do not change code during an audit unless asked to implement fixes.

## Project checks

Use the commands defined by the repository. Relevant checks include `npm run lint`, `npm run build`, and `npm test`. Use `npm audit` for dependency advisories. Inspect Drizzle migrations and PostgreSQL query plans when the question involves database performance.
