---
name: client-facing-copy
description: "Use when writing or reviewing Swagger/OpenAPI descriptions, API schemas, customer-facing README sections, or other API text. Keep it clear, direct, and free of internal architecture details."
---

# Client-facing API text

Write for the person integrating with the API. Use clear, direct language and include only information they need to use the service.

- Describe observable behavior: what the client can do, what to send, and what response to expect.
- Do not expose internal architecture or implementation details. Avoid naming internal frameworks, libraries, providers, databases, queues, services, or component boundaries unless they are part of the public API contract.
- Keep useful protocol details, including HTTP methods, headers, status codes, authentication requirements, and event formats.
- In documents for both customers and maintainers, keep implementation guidance separate from customer-facing instructions.
- Prefer concrete instructions and plain language. Remove marketing claims, unnecessary jargon, and commentary about implementation.
- Match the language used by the surrounding API documentation.
