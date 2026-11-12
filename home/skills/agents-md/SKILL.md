---
name: agents-md
description: Write a new AGENTS.md or CLAUDE.md, or rewrite or review an existing one, so that it holds only what an agent needs on most tasks and cannot learn from the code, says what the project is aiming for, and sends everything else to scoped docs, rules, skills, hooks or the bin. Use when the user asks to create, improve, clean up, shorten or review an agent instruction file ("CLAUDE.md を書いて", "AGENTS.md を良くして", "CLAUDE.md が散らかってる", "この CLAUDE.md をレビューして", "/init の結果を直して"). Not for a skill's SKILL.md or for docs written for humans.
---

# agents-md

An agent instruction file (AGENTS.md, CLAUDE.md, and the files they import) is read at the start of every session, before the agent knows what the task is. Every line competes for the same attention with every other line and with the task itself, and the agent obeys a long file less well than a short one, not just less of it. A good file is therefore short, true, and pointed in one direction: an agent that reads it knows what the project values, what it would get wrong by guessing, and where to look for the rest. A bad file is a pile of fixes added one at a time after something went wrong, with no aim the agent can read off it. The one controlled study so far found that context files mostly do not raise task success and add about 20% to cost, that repository overviews do not help, and that what does help is stating the non-standard practices an agent would not guess.

## 1. Find what the agent actually loads

Before judging a file, find every file that reaches the agent and in what order.

- Claude Code loads at launch `~/.claude/CLAUDE.md`, then `CLAUDE.md` and `CLAUDE.local.md` from every directory from the root down to the working directory (all concatenated, the nearer read last), `.claude/rules/*.md` without `paths:`, and every `@path` import (up to four hops). A subdirectory's `CLAUDE.md` and a rule with `paths:` load only once the agent touches a matching file. An `@` import organizes; it does not save context.
- Claude Code reads `AGENTS.md` only when no `CLAUDE.md` or `CLAUDE.local.md` exists at or above the working directory. Adding either one silently hides `AGENTS.md`.
- Codex reads `~/.codex/AGENTS.md`, then at most one file per directory from the repository root down (`AGENTS.override.md` before `AGENTS.md`), the nearer overriding the farther, and stops adding files past `project_doc_max_bytes` (32 KiB by default). Other agents mostly follow the agents.md convention: the nearest file wins.
- When both tools are used, keep one source of truth: `AGENTS.md` holds the content and `CLAUDE.md` is `@AGENTS.md` plus anything only Claude Code needs. Keep whatever arrangement the repository already uses unless the user wants it changed.

Read all of them. A rule in a user-level file and a contradicting one in the project file are both delivered, nothing warns about it, and the agent may follow either. In Claude Code, `/context` shows which memory files loaded and `/doctor` can audit them for contradictions and missing references; in Codex, `codex --ask-for-approval never "Summarize the current instructions."` shows what it read.

## 2. Learn the project from its code, not from the old file

The file must be true, and the old file may not be. Check every factual claim against the repository: the commands (package.json scripts, Makefile, justfile, flake, CI workflows), the test and lint setup, existing hooks and permissions in `.claude/settings.json`, and the docs directory. Run the commands that are cheap and safe to run. A command that no longer works is worse than no command.

While reading, note what the code itself already makes obvious (stack, layout, style followed everywhere): the agent will see that on its own.

## 3. Sort every line

For a rewrite, take each line of the old file; for a new file, each thing you are tempted to write. Ask, in this order:

1. Is it false, stale, or contradicted by another line? Fix it from step 2. When two lines contradict each other and the code does not settle which is right, ask the user (one question, with your recommendation). Do not pick silently.
2. Must it happen every time, with no exceptions, and can a machine check it? Prose cannot enforce anything. If a linter or formatter rule, a hook, a permission deny rule or a CI check already enforces it, leave at most one line saying the check exists. If none does, keep the line and propose the mechanism; drop the line only once the mechanism is in place and you have seen it work. A rule no machine can judge (which actions need the user's approval, for example) stays in prose.
3. Can the agent learn it from the code in a few seconds? (directory trees, dependency lists, "we use React", style the codebase already follows). Delete it. Agents copy the patterns around them.
4. Is it generic advice any project would get? ("write clean code", "be careful", "follow best practices"). Delete it. It costs attention and changes nothing.
5. Does it matter only for some tasks, some directories, or one procedure? Move it out of the root file: a nested `AGENTS.md`/`CLAUDE.md` for a directory, `.claude/rules/` with `paths:` for a file pattern, a doc under `docs/` named for its topic, a skill for a procedure (release, migration, deploy). Leave a pointer in the root file that says when to read it.
6. Otherwise it is a root-file line: something an agent would get wrong by making a reasonable assumption, on most tasks.

## 4. Write the root file

What belongs, roughly in this order. Leave out any part the project does not need.

- What the project is and what it is for, in a sentence or two. This frames every decision the agent makes.
- The aim, when the project has one beyond "working code": the principles or trade-offs that decide cases no rule covers. This is what makes a file read as a direction instead of a list. State it once, and let the rules below visibly follow from it.
- How to build, test, lint and check a change, with the exact commands, especially the ones that differ from what the stack would suggest (package manager, a wrapper script, a required flag). Say how the agent can confirm its work is done.
- Rules the agent would break by guessing: non-default conventions, things that must not be touched and why, pitfalls that have bitten before, actions that need the user (push, deploy, migrations).
- A map of where to read more, as a table or list of "before you do X, read Y". Point to files; do not copy their content. Prefer pointers to stable things (a doc, a concept) over exact paths and line numbers that move.

How to write each line:

- Specific and checkable. "Use 2-space indentation", not "format code properly". "Every route handler needs a test for its 4xx path", not "write good tests".
- With the reason, when the reason is not obvious. "Do not edit `src/generated/`; `npm run codegen` rewrites it." The reason lets the agent handle the case next to the one you wrote down.
- Plain and calm. No ALL CAPS, no "CRITICAL", no stacks of "always" and "never", no bold for emphasis. Shouting one rule makes the others quieter and pushes the agent to over-apply the shouted one.
- One rule in one place. Do not restate a rule in another section or another file.
- Human-only notes go in block HTML comments (`<!-- -->`), which Claude Code strips before the agent sees them.

Size: there is no official limit, but the fewer lines the better. Treat about 200 lines as a ceiling for the root file and aim far below it; many good root files are under 60. Count instructions, not just lines: a dense line with three rules is three rules.

Do not generate the file with `/init` or a similar command and keep the result as it is. Such output favors coverage and fills the file with what step 3 deletes. If one was run, use its output as raw material for step 3.

## 5. Check the result

- Reread the file as an agent that has never seen the repository. For each line: would I act differently on a typical task with this line than without it? If not, cut it.
- Ask the two questions of every file you moved content into: does each pointer in the root file say when to read it, and does every pointed-to file exist?
- For a large rewrite, give a fresh subagent only the new file and one or two realistic tasks, and ask what it would do and what it would need to look up. Gaps and misreadings show here.
- Show the user the diff, then report: what moved where, what was deleted and why (grouped by the reason in step 3), the enforcement you proposed in place of prose, and any contradiction you asked about. Do not commit unless the user or the repository's own instructions say to.

## Keeping it good

Tell the user how the file stays this way: add a line when the agent made the same mistake twice and a line would have prevented it; delete lines nobody has needed in months; review changes to the file like code, since a bad line here spreads into every plan and change the agent makes. To review a file without rewriting it, run steps 1 to 3 and report the sorting as findings.

Sources this skill draws on are in [references/sources.md](references/sources.md). Read them only when the user asks why a recommendation is made.
