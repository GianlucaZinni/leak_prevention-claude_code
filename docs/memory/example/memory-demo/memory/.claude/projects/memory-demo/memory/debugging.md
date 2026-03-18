# Debugging notes

- If API responses drift, compare the request validator and the handler return shape.
- If tests pass locally but fail in CI, check environment-specific secrets and default values.
- If a change touches payment retry logic, verify idempotency behavior explicitly.
