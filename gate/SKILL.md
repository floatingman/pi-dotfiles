---
name: gate
description: 'Run the project quality gate as a single blocking command (`make test`). Wait for the FULL output before reporting (no background tasks or polling). When tests pass, report PASS with test counts only. When tests fail, root-cause the failure, fix it, and re-run the full gate. Use as a pre-completion check, or when the user asks to run tests, run the gate, run make test, or verify changes before reporting done.'
---

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
