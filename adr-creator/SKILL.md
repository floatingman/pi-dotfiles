---

name: adr-creator
description: 'Skills to create an Architecture Decision Record (ADR). Generates ADR files that comply with ADR format and quality standards. Triggered by instructions like "Write an ADR", "Create an ADR", "I want to record my architectural decisions", or "Document my decision to adopt X". Use when documentation of architectural decisions is required, such as technology selection, design policy changes, or contract development.'

---

# ADR Creator

Skills to create ADR (Architecture Decision Record) with a certain quality.

## Workflow

### Step 1: Gathering Information

The quality of an ADR depends on how well the writer understands the background. Gather the following information:
If the user has already provided enough information, check only the missing information.

1.  **What did you decide? ** — Clarify decision-making to the point where it can be said in one sentence
2.  **Why did you reach that decision? ** — Background issues, constraints, and motivations
3.  **What other options have you considered? ** — At least two or more alternatives and their evaluation
4.  **What would be better and what would be sacrificed by this judgment? ** — Trade-offs
5.  **Do you have any reference links? ** — Slack discussion URLs, technical documentation, books, etc

### Step 2: Deciding on consecutive numbers

Check the 'docs/adr/' directory and set the maximum number of the existing ADR + 1 as the new number.

"'bash
ls docs/adr/\*.md | sort -t/ -k3 | tail -1
``

### Step 3: Writing ADR

Prepare ADRs according to the following formats and guidelines:

## File naming conventions

` 
docs/adr/{NNNN}-{kebab-case-name}.md  `

- '{NNNN}': 4-digit zero-filled consecutive number (e.g., '0019')
- '{kebab-case-name}': English kebab case name that succinctly indicates the contents of the ADR

**Example:**

- '0024-adopt-redis-for-caching.md'
- '0025-frontend-state-management-with-zustand.md'

## ADR format

"'markdown

# ADR {NNNN}: {Japanese title}

## Status

{Proposed | Accepted | Deprecated | Superseded}

## Context

{Describe the background and issues in a value-neutral manner}

### Issues you want to solve

{List specific issues in bullet points or explanatory text}

### Options considered

{Enumerate at least two or more options}

### Evaluate each option

{Evaluate objectively in a comparison table}

| Perspective | Option A | Option B | Option C |
| ----------- | -------- | -------- | -------- |
| ...         | ...      | ...      | ...      |

## Decision

**{Summarize your decision in one sentence in bold.} **

### 1. {Decision Details 1}

{Include code examples, diagrams, and configuration examples as needed}

### 2. {Decision Details 2}

{...}

## Consequences

### Positive

- {Positive Results}

### Negative

- {negative results}
  - → {mitigation measures}

### Risks

- {Risk}
  - → {Measures}

## Undecided (optional)

{If there is something out of scope, please state it}

| Item | Reasons for not deciding | When to decide |
| ---- | ------------------------ | -------------- |
| ...  | ...                      | ...            |

## Notes

### References

- {Reference links and related ADRs}
  ``

## Writing Guidelines

### Context section — Tell the reader "why this decision is needed now"

- Write value-neutral. Don't write in a way that encourages a specific option
- Briefly state the current state of the project (tech stack, architecture) at the beginning, allowing the reader to share their assumptions
- Mention relevant existing ADRs, if any (e.g., "Adopts Modular Monolith Architecture (ADR 0002)")
- Organize the options you consider in a **comparison table**. Choose an evaluation axis that is directly related to your judgment

### Decision section — Clarify "what and how you decided"

- Summarize your decision at the beginning in **bold sentences**
- Details are structured in numbered subsections
- Technical decisions should include **code examples** to convey an implementation image
- Use **ASCII diagrams** to show the architecture structure
- In the "Reason for Choice" and "Reason for Hiring" sections, state why you chose that option

### Consequences section — don't hide trade-offs

- Be sure to write both Positive and Negative. There is no judgment where Negative is zero
- Negative always has a '→' **mitigation**
- Describe future risks and countermeasures in the Risks section
- A reference to the relevant ADR to provide the basis for the measure

### Undecided section — clarify scope

- Add an "Undecided" section when there are things that are intentionally out of scope
- Tabulate "why not decide" and "when to decide" to indicate that the postponement is intentional
- This section prevents readers from wondering "why this wasn't written"
- Not required for all ADRs. If the scope is clear and there are no postponements, it can be omitted

### Overall quality standards

- **Language**: Write in Japanese (code examples and technical terms remain in English)
- **Length**: Approximately 1〜3 pages. Amounts that are not redundant and convey sufficient evidence for judgment
- **Cross-reference**: Relevant existing ADRs are referenced by number and title
- **Code Example**: For technical decisions, indicate the implementation policy with a Good/Bad contrast
- **Reader**: Aim for a level that can be read and understood by team members and new participants six months from now

### Step 4: Review Presentation

Once the draft ADR is complete, present it to users for feedback.
Based on the suggestions, we will revise it and write the final version in 'docs/adr/'.
If not otherwise specified, Status is set to 'Proposed', and after review approval, it is proposed to change it to 'Accepted'.
