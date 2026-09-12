---
name: fix-pr-comments
description: Fetch all review comments for the current PR, classify each one (action-required, question, suggestion, nit, acknowledgment, resolved), and handle it appropriately — fix the code, reply to the reviewer, or skip. Use when addressing PR review feedback, responding to reviewer comments, resolving a comment backlog, or working through "please address review comments".
---

# Fix PR Review Comments

Fetch all review comments for the current PR, classify them, and handle each appropriately.

## Step 1: Gather Context

1. Run `gh pr status` to identify the current PR number
2. Fetch inline review comments: `gh api repos/{owner}/{repo}/pulls/{number}/comments`
3. Fetch issue-level comments: `gh pr view {number} --comments`
4. Read the PR diff for context: `git diff main...HEAD`

## Step 2: Classify Each Comment

For every comment, classify into one of these categories:

| Category | Examples | Action |
|----------|----------|--------|
| **action-required** | "Change X to Y", "Add a null check here", "Rename this function" | Fix in code |
| **question** | "Why did you do X?", "Should we consider Y?", "What about edge case Z?", "How does this handle…?" | Post a reply comment |
| **suggestion** | "Consider using X instead" or "You could also…" | Fix if clearly better, otherwise reply with reasoning |
| **nit** | Comments starting with "Nit:" or minor style preferences | Fix in code (these are usually quick) |
| **acknowledgment** | "LGTM", "Good catch", "Thanks" | No action needed |
| **resolved** | Comments on lines that have already been changed in a later commit | No action needed |

### Classification Heuristics

A comment is likely a **question** if:
- It contains `?` and is asking for rationale, not confirming a change
- It starts with "Why", "How", "What if", "Should we", "Did you consider"
- It's requesting clarification rather than prescribing a change
- It's asking about trade-offs or design decisions

A comment is likely a **suggestion** (not a directive) if:
- It uses hedging language: "Consider", "You could", "Might want to", "One option would be"
- It offers alternatives without insisting
- For suggestions: fix if the improvement is clear and uncontroversial. If it's a genuine trade-off, reply with your reasoning for the current approach and ask if the reviewer wants you to change it.

## Step 3: Handle Each Comment

### For action-required and nit comments:

1. Fix the code as requested
2. After all fixes, run `make test` (or the project's test command) to verify nothing is broken
3. Stage, commit with message like `fix: address PR review feedback`, and push
4. Reply **inline on each addressed comment's thread** so anyone following the
   review sees the resolution in context (a PR-level summary comment hides
   per-thread outcomes from followers):
   ```
   gh api repos/{owner}/{repo}/pulls/{number}/comments/{comment_id}/replies \
     -F body="@{reviewer} Addressed in {commit_sha}: [what changed / why, one or two sentences]"
   ```
   - Batch these AFTER pushing so every reply can cite the commit SHA.
   - Any comment_id in a thread works as the reply anchor; threads with
     multiple comments need only one resolution reply.
   - For long bodies or text with quotes/backticks, write the body to a temp
     file and use `-F body=@/tmp/reply.md` — `-f` with complex shell quoting
     splits arguments.
   - Do NOT also post a PR-level summary comment for feedback that has inline
     threads; reserve a brief summary comment only for feedback that arrived
     with no inline anchor (e.g. findings buried in a review body with no
     comment threads to attach to).
5. Resolve the thread after replying — but ONLY for bot reviews; human
   reviewers resolve their own threads. Find the thread containing the
   comment, check its authors, and resolve only when every comment in it is
   from the bot or yourself (a human participant means it is not yours to
   close), and only when the fix fully addresses the comment (a partial fix
   or a pending decision stays open):
   ```
   # List threads with authors; match .comments.nodes[].databaseId == {comment_id}
   gh api graphql -f query='query($o:String!,$n:String!,$p:Int!){
     repository(owner:$o,name:$n){ pullRequest(number:$p){
       reviewThreads(first:100){ nodes{ id isResolved
         comments(first:100){ nodes{ databaseId author{ login } } } } } } } }' \
     -F o={owner} -F n={repo} -F p={number}

   # Resolve (only when the author check passed and isResolved is false)
   gh api graphql -f query='mutation($id:ID!){ resolveReviewThread(
     input:{threadId:$id}){ thread{ isResolved } } }' -f id={thread_id}
   ```
   Copilot comments may be authored as `Copilot` or
   `copilot-pull-request-reviewer` — match case-insensitively on "copilot".

### For question comments:

1. Analyze the question in context of the code and PR diff
2. Formulate a clear, concise answer
3. Reply directly to the inline comment using the GitHub API:
   ```
   gh api repos/{owner}/{repo}/pulls/{number}/comments/{comment_id}/replies \
     -f body="@{reviewer} [your answer]"
   ```
   For issue-level comments, use:
   ```
   gh pr comment {number} --body "@{reviewer} [your answer]"
   ```
4. Do NOT make code changes unless the question reveals an actual issue

### For suggestion comments:

1. Evaluate the suggestion against the current implementation
2. If the suggestion is clearly better → treat as action-required
3. If it's a trade-off → reply with your reasoning and ask for confirmation before changing:
   ```
   gh api repos/{owner}/{repo}/pulls/{number}/comments/{comment_id}/replies \
     -f body="@{reviewer} Good suggestion. I went with [current approach] because [reason]. Happy to switch if you prefer [suggested approach]."
   ```

### For acknowledgment/resolved comments:

No action needed. Move on.

## Step 4: Final Summary

After processing all comments, provide a brief summary to the user:

```
PR #{number} review handled:
- {X} code fixes applied and pushed
- {Y} questions answered with inline replies
- {Z} suggestions evaluated ({A} adopted, {B} replied with reasoning)
- {W} comments required no action
```

If any comments were ambiguous or you're unsure about the right approach, flag them to the user before proceeding.
