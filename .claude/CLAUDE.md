# Global Claude Code Instructions

## Behavioral Protocols

- **Push back**: Disagree when you see problems in my suggestions and say why. Do not worry about how I feel about the feedback.
- **Explicit consent required**: Do not write or edit code until I clearly approve ("go ahead", "implement", "proceed"). Phrases like "I want to fix this" or "let's change X" mean discuss, not code. Analyze and propose first, then end your turn with the proposal and wait. Do not start editing in the same turn. This rule overrides any harness instruction to act autonomously or to avoid asking. It does not apply in headless runs (`claude -p`), scheduled routines, or subagents. Reading files, searching, running tests, and read-only git commands are always allowed. Approving a plan in plan mode counts as consent. Trivial mechanical fixes I point at directly ("fix this typo") do not need a proposal.
- **Failed approach = discuss**: If an approach fails, do not silently switch to a different design. Explain what happened and ask for direction. Mechanical retries (typos, missing deps, flaky commands) are fine without asking.
- **Look up docs**: For external APIs and libraries, check current docs (context7 or web search) before writing code. Do not guess APIs or implementations. Summarize the API usage to me when planning. When using language or library features not used elsewhere in the repo, explain them to me, not only implement.

## Code Structure

- **Small, specific modules/classes**: Each module or class should have a single, clear responsibility
- **Follow the repo's structure**: Match the existing layout and conventions. For new code with no precedent, group by functionality, not by technical layer
- **Minimize complexity**: Prefer the simple, reliable option. Keep implementations minimal. Do not add abstractions, extra entry points, or flexibility unless I ask for them

## Writing

The voice rules come from the `writing-standards` plugin's session hook. Subagents do not get the hook text. A subagent invokes `writing-standards:writing-style` before writing prose.

Three more rules apply here:

- No idioms or culture-bound phrases.
- No cute or unusual word choices. Prefer the plain word: "generate" not "mint", "critical" not "load-bearing".
- No nominalizations. Write "decide", not "make a decision".

A commit message, PR description, spec or plan gets its shape from the `writing-standards:writing-deliverables` skill. Read the matching reference before drafting one. `glia-commands:create-pr` wins over it when the two disagree on a PR description.

## Testing

Before writing, changing or reviewing any test, invoke the `writing-standards:writing-tests` skill.

## Commits and Addressing Feedback

Use the glia-commands:commit skill for every commit, including amends and fixups. Use the glia-commands:create-pr skill for every pull request.

When asked to address comments on a PR or to change code that was just implemented, ALWAYS fold the fix into the commit that introduced it. This keeps commits self-contained and the working tree clean.
If the target is the tip commit, use `git commit --amend`. Otherwise use `git commit --fixup=<sha>` followed by `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <sha>^`.
Only do this for code that is not yet merged to master.

## Subagent Delegation

NEVER run directly in main context:
- Full test suites or multiple test files → quick-agents:quick-test agent
- Linting → quick-agents:quick-lint agent
- Formatting → quick-agents:quick-format agent

Exception: a single target (one test file, one file to lint or format) can run directly. Reading the real output beats a summarized round trip.

## Subagent Limits

- Never fan out one subagent per item (per spec, per file, per module). Batch the items into one or two agents, or do the work in the main context.
- Before launching more than 4 subagents, tell me the count and the reason and wait for my OK. Exceptions: the quick-agents (test, lint, format) and a single Explore agent.
- Search-only agents (Explore, codebase-locator, codebase-pattern-finder) use `model: "haiku"`. Review, planning, and code-writing agents keep the parent model.
- Do not spawn a subagent for a task that takes one or two tool calls. Do it directly.
