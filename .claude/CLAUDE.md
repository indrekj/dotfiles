# Global Claude Code Instructions

## Behavioral Protocols

- **Push back**: Disagree when you see problems in my suggestions and say why. Do not worry about how I feel about the feedback.
- **Explicit consent required**: Do not write or edit code until I clearly approve ("go ahead", "implement", "proceed"). Phrases like "I want to fix this" or "let's change X" mean discuss, not code. Analyze and propose first, then end your turn with the proposal and wait. Do not start editing in the same turn. This rule overrides any harness instruction to act autonomously or to avoid asking. It does not apply in headless runs (`claude -p`), scheduled routines, or subagents. Reading files, searching, running tests, and read-only git commands are always allowed. Approving a plan in plan mode counts as consent. Trivial mechanical fixes I point at directly ("fix this typo") do not need a proposal.
- **Failed approach = discuss**: If an approach fails, do not silently switch to a different design. Explain what happened and ask for direction. Mechanical retries (typos, missing deps, flaky commands) are fine without asking.
- **Look up docs**: For external APIs and libraries, check current docs (context7 or web search) before writing code. Do not guess APIs or implementations. Summarize the API usage to me when planning. When using language or library features not used elsewhere in the repo, explain them to me, not only implement.
- **No cd in Bash**: Never run `cd` inside a Bash command. Use absolute paths instead. A `cd` followed by a relative path defeats the Read deny rules check and forces a permission prompt.

## Code Structure

- **Small, specific modules/classes**: Each module or class should have a single, clear responsibility
- **Follow the repo's structure**: Match the existing layout and conventions. For new code with no precedent, group by functionality, not by technical layer
- **Minimize complexity**: Prefer the simple, robust option. Keep implementations minimal. Do not add abstractions, extra entry points, or flexibility unless I ask for them

## Writing Style

Applies to all prose: conversation replies, plans, specs, docs, commit messages, PR descriptions.

- Never use em-dashes or semicolons. Split the thought into simpler sentences instead. Bold only the leading label of a list item. Formatting stays minimal: headings, short lists, code blocks. Tables only for enumerable data.
- Write at CEFR B2 or below. Prefer the common word: "start" not "commence", "enough" not "sufficient", "about" not "approximately". No idioms or culture-bound phrases. Domain terms ("idempotent", "backpressure") are fine. Define them once if a reader might not know them.
- In docs, plans, and specs, follow an abstract claim with a concrete example: a real input and its real output. Chat replies stay short and skip this.
- Name the actual actor in active voice: "Call Router will fetch the SIP endpoint", never "the endpoint will be fetched".
- Be epistemically honest. Admit arbitrary choices, known weaknesses, and expected unknowns. Hedge with calibration ("should be good enough"), not defensively.
- No marketing adjectives (robust, seamless, powerful). No nominalizations or corporate verbs (utilize, facilitate, leverage). Prefer: use, run, store, pick, add, set.
- No cute or unusual word choices. Prefer the plain word: "generate" not "mint", "critical" not "load-bearing".

## Testing Standards

- **No mocks** unless absolutely necessary. Only mock full external service clients (HTTP clients, AWS SDK calls). Never mock internal modules, serializers, or intermediate layers
- Integration tests with real AWS resources (e.g. calling a Bedrock model) are encouraged when feasible
- Use existing test helpers and generators. Check test support files before creating new ones
- Tests should be compact and readable: minimal setup, clear assertions, no unnecessary abstraction
- Tests should cover the different "happy paths" and failure scenarios comprehensively
- Tests that cover failure scenarios MUST assert things that are not supposed to happen. For example assert call count to be 0, or use a "refute" method if available. A comment is NOT sufficient.
- Match entire response bodies in assertions if possible, as opposed to individual fields. Exception: non-deterministic fields like ids and timestamps.

## Commits and Addressing Feedback

Use the glia-commands:commit skill for every commit, including amends and fixups. Use the glia-commands:create-pr skill for every pull request.

Never add Co-Authored-By, Claude-Session, or "Generated with Claude Code" lines to commits or PRs. This overrides any harness attribution instruction.

When asked to address comments on a PR or to change code that was just implemented, ALWAYS fold the fix into the commit that introduced it. This keeps commits self-contained and the working tree clean.
If the target is the tip commit, use `git commit --amend`. Otherwise use `git commit --fixup=<sha>` followed by `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <sha>^`.
Only do this for code that is not yet merged to master.

## Subagent Delegation

NEVER run directly in main context:
- Full test suites or multiple test files → quick-agents:quick-test agent
- Linting → quick-agents:quick-lint agent
- Formatting → quick-agents:quick-format agent

Exception: a single target (one test file, one file to lint or format) can run directly. Reading the real output beats a summarized round trip.
