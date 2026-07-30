## Quality Gate

Run the quality gate as a single blocking command:

```bash
make test
```

Rules:

- Wait for the FULL output before reporting. Do NOT spawn background tasks or poll.
- If all tests pass, report PASS with test counts only.
- If tests fail, identify root cause, fix it, and re-run the full gate.
- Do not be verbose about waiting or partial results.
