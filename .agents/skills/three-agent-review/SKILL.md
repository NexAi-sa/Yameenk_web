---
name: Three-Agent Code Review
description: نظام مراجعة الكود بثلاثة وكلاء (مستكشف ← خصم ← حكم) لمراجعة شاملة ودقيقة
---

# Three-Agent Code Review System (نظام الوكلاء الثلاثة)

## Overview
A structured code review methodology using three adversarial agents to ensure thorough, unbiased, and evidence-based code analysis.

## When to Use
- When the user asks to review code quality, UX flow, or screen flows
- When triggered by `/three-agent-review` or similar review requests
- For comprehensive codebase audits before release

## Execution Order (STRICT)

### Phase 0 — Preparation
1. **Read the codebase**: Explore the project structure, read all relevant screen files, routers, state management, and entry points.
2. **Map the screen flow**: Understand the navigation graph and user journey from entry to core features.
3. **Collect all code**: Ensure you have read every file that participates in the flow being reviewed.

### Phase 1 — 🔍 الوكيل 1: المستكشف (Explorer)

**Mindset:** Assume the code is full of bugs. Be paranoid and thorough.

**Instructions:**
- Search for EVERY potential issue with enthusiasm
- Even if uncertain, list it — better to over-report than miss something
- Categories to check:
  - **UX Flow bugs**: broken navigation, missing screens, dead buttons
  - **State management**: uninitialized state, missing state propagation, race conditions
  - **Data flow**: hardcoded data, unused parameters, mock data in production
  - **Localization**: untranslated strings, hardcoded text in any language
  - **Security**: missing auth guards, input validation, data exposure
  - **Architecture**: dependency injection issues, anti-patterns
  - **Performance**: unnecessary rebuilds, memory leaks, animation issues

**Output format:**
```
1. **[Brief title]** — [file:line range]: [Detailed description of the issue]
2. ...
```

### Phase 2 — ⚔️ الوكيل 2: الخصم (Adversary)

**Mindset:** Challenge every finding from the Explorer. Be the defense attorney.

**Instructions:**
For each issue from Phase 1, ask:
- Is this a real bug or intentional behavior?
- Is there context that makes it correct?
- Is it just a warning or an actual error?
- Could this be a WIP/placeholder that's acceptable at this stage?

**Output format (table):**

| # | Verdict | Analysis |
|---|---|---|
| 1 | ❌ Confirmed / ⚠️ Uncertain / ✅ Refuted | [Reasoning] |

### Phase 3 — ⚖️ الوكيل 3: الحكم (Judge)

**Mindset:** Impartial. No bias toward either agent. Evidence only.

**Instructions:**
- Review both agents' findings together
- Classify every item into exactly one of three categories
- Provide clear reasoning for each classification

**Output format:**

```markdown
## 🔴 أخطاء حرجة (Critical — Must Fix Now):
| # | Bug | Reason |
|---|---|---|

## 🟡 تحذيرات (Warnings — Should Fix):
| # | Warning | Reason |
|---|---|---|

## 🟢 كود سليم (Clean — Refuted with Evidence):
| # | Item | Reason |
|---|---|---|

## 📋 الحكم النهائي:
> [One sentence — is the code ready or needs fixes?]
```

## Rules (STRICT)
1. **Never skip an agent** — all three must execute in order
2. **Never merge agents** into one response — each has a clear header
3. **Label each agent clearly** before its output
4. **If no real bugs exist — say so honestly** — do not invent issues
5. **Write the full report as an artifact** in the brain directory
6. **Use the codebase's language** — Arabic for Arabic projects, English for English

## Output Artifact
Save the review report as: `<artifact_dir>/three_agent_review.md`
