---
name: catch-up
description: Find out where a piece of work stands now, after time has passed or others have moved it (merges, releases, CI runs, reviews, comments, changes by other teams), say what changed since it was last checked, look into anything unexpected, and report in one fixed shape that ends with what can be moved now. Also for an issue or PR the session has not looked at before. Use when the user asks for the latest state or where things are ("最新状況をキャッチして", "現在地を取得して", "キャッチアップして", "あれから数日経ちました。今の状況は？", "いくつかマージが進んだので最新状況を見て", "今なにか進められることある？", "この issue の最新状況も見て"). Not for learning an unfamiliar topic in depth (teach-me), or for checking what a session leaves behind before closing it (anything-else).
---

# catch-up

The user has been away from a piece of work for hours or days, or has just merged or approved something, and wants to know where it stands and what can move next. What they need first is the difference: what changed since they last looked, who changed it, and whether it changes the plan. A list of current states that they must compare with their memory is not enough.

Do the collecting in this session rather than in a subagent: telling what changed and what matters needs the context of the work.

## 1. Know what is tracked and what was last known

- Tracked items: the stages of the work and everything they hang on, such as PRs, issues, branches, releases, CI runs, deploys, settings, and replies from people. Take them from the plan of the work, wherever it is kept: a progress table in the conversation, a plan file or Gist that memory or the conversation points to, an issue's checklist or sub-issues.
- Last known state: the last time this session reported where things stood, or the plan's own "where it is now". Note its date and time; everything after it is what to look for. If the context was compacted, read the transcript (`ls ~/.claude/projects/*/<session id>.jsonl`) for states and dates instead of trusting the summary. For work done in earlier sessions, read them with claude-recall.
- Cold start (an issue or PR this session has not looked at): take the tracked items from its body, linked PRs and sub-issues, and use its recent activity as the baseline.

## 2. Collect the current state

Everything in this step and the next is read-only: no push, approval, comment, post, apply or edit, not even to a plan file.

- Run `date '+%Y-%m-%d %H:%M'` first. The report is stamped with it.
- Collect the tracked items in one batch where you can (one Bash call printing one line per item), not one call per PR. Print what decides the next step, not just open or merged: draft, review decision, mergeable or conflicting, CI conclusion, merged at, released or not, runs waiting.
- Look past the tracked items for changes by others that touch the plan. The ones that matter most are the ones nobody tracked:
  - commits on the default branch since the last check, limited to the paths the work touches;
  - new comments and reviews on the tracked issues and PRs, and on the issues they link to;
  - settings or infrastructure changed by another team (environments, required approvals, branch rules, permissions);
  - releases cut or shipped, and scheduled ones that moved;
  - Slack channels or threads where the work was discussed, when the user named them or the plan lists them.

## 3. Look into what is unexpected

A failed run, a run waiting for days, a new conflict, a dismissed approval, a release that did not happen on schedule, a setting nobody mentioned: find out why before reporting, as far as read-only checks allow (the run's logs, the commit or PR that changed it, who did it and when). A report that says "failed" without why sends the user to do the looking.

Say what you could not confirm, in those words (未確認), and what it would change if it turned out true.

## 4. Report in this shape

Write in the user's language, in this order, every time, so two catch-ups of the same work read side by side. Leave out a section with nothing in it, except the first line and 今進められること.

```markdown
<時点> 時点。前回 (<前回の時点>) から<結論: 計画に関わる変化が N つありました / 大きな変化はありませんでした>。

## 前回から変わったこと
- <何が変わったか>（<PR や issue の番号>、<いつ>、<誰が>）。<計画にとってどういう意味か>

## 現在地
| 段 | 内容 | 状態 |
|---|---|---|
| <計画と同じ行を同じ順で> | <中身、PR の番号> | <状態と、次に進む条件> |

## 止まっているところ
- <何が>、<なぜ>（調べた結果、または 未確認）、<誰なら動かせるか>

## 今進められること
| やること | なぜ今か | おすすめ |
|---|---|---|
| <あなたの操作も、誰も待たない作業も含める> | <今やる理由> | <今やる / 後で / やらない、と理由> |

おすすめの順:
1. <...>
2. <...>
```

- 前回から変わったこと: changes by others that override a decision in the plan come first. On a cold start, title it 最近の動き and list the recent activity instead.
- 現在地: the same rows as the plan, in the same order, every time. Without a plan, one row per tracked PR or issue. The state column says the condition for the next step, not just "open" ("draft。リリースの後で Ready にする", "approve 待ち。求められているのは X さんの approve だけ").
- 今進められること: if nothing can move, say what it waits for and when to look again.
- Restate an unchanged state only in the 現在地 table. Do not repeat the background of the work.

## 5. Ask what to do

End with one AskUserQuestion (multiSelect) that asks what to do now. Choose the options yourself from this catch-up; do not assume any particular workflow or skill. Typical options:

- record what changed where the plan of the work is kept (a progress table, a Gist, an issue's checklist);
- a local fix the next step needs anyway (bring the default branch into a work branch, resolve a conflict, run the formatter and tests), reported as not pushed;
- an action from 今進められること that leaves this Mac (approve a run, push, mark a PR ready, ask someone for a review), with what it will do.

Put the recommended options first. If there are more than four, ask about the ones you recommend and leave the rest to a reply by number from the 今進められること table. Do what is chosen; a choice counts as approval for that action and target only.
