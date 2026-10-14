# Private Mac (pro23)

## Review: tier 2

Codex CLI on GPT-6.1 Sol, medium effort, read-only:

```bash
codex exec -m gpt-6.1-sol -c model_reasoning_effort=medium -s read-only "Review this plan. Don't nitpick trivial points; only point out fatal issues: {full_path}"

# re-review: the header of the first run prints "session id: ...";
# resume takes no -s, so the sandbox is set with -c
codex exec resume {session_id} -m gpt-6.1-sol -c model_reasoning_effort=medium -c sandbox_mode=read-only "I updated it; review it again. Don't nitpick trivial points; only point out fatal issues: {full_path}"
```
