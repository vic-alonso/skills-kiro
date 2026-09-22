# Superpowers for Kiro

Superpowers is a complete software-development methodology for coding agents,
built on a set of composable **skills** plus a bootstrap that makes the agent
actually use them. This directory is the **Kiro-native** port.

On Kiro the integration maps cleanly onto three native mechanisms:

- **Skills** → Kiro Agent Skills at `.kiro/skills/<name>/SKILL.md`. Same folder +
  `SKILL.md` format, same `name` / `description` frontmatter, same progressive
  disclosure and `references/` layout Superpowers already uses. The skill bodies
  are copied verbatim — they describe *actions* ("dispatch a subagent", "read a
  file"), never harness-specific tool names.
- **Bootstrap** → an always-included **steering** file at
  `.kiro/steering/superpowers-bootstrap.md`. Steering files with
  `inclusion: always` load into every Kiro session automatically, with no
  per-session opt-in — this is what makes skills auto-trigger at the right moments.
- **Tool mapping** → `.kiro/skills/using-superpowers/references/kiro-tools.md`,
  which translates the skills' action vocabulary into Kiro's real tools
  (`invokeSubAgent`, `todoList`, `grepSearch`, `readFile`, etc.).

## Layout

```
superpowers-skills/
├── README.md                  # this file
├── install.sh                 # copies skills + steering into a workspace's .kiro/
├── skills/                    # all 15 Superpowers skills (SKILL.md + references/scripts)
│   ├── using-superpowers/
│   │   ├── SKILL.md
│   │   └── references/kiro-tools.md
│   ├── brainstorming/
│   ├── writing-plans/
│   ├── executing-plans/
│   ├── subagent-driven-development/
│   ├── test-driven-development/
│   ├── systematic-debugging/
│   └── ...
└── steering/
    └── superpowers-bootstrap.md   # inclusion: always — injects the bootstrap every session
```

## Install into a Kiro workspace

Kiro loads skills from `.kiro/skills/` and steering from `.kiro/steering/` in the
workspace root. Install by copying both trees into the target workspace's `.kiro/`
directory.

### Option A — install script

From this repository, run the script and point it at the workspace you want to
enable Superpowers in (defaults to the current directory):

```bash
bash superpowers-skills/install.sh /path/to/your/workspace
```

Re-run the same command to update after pulling a newer version.

### Option B — manual copy

```bash
# from the target workspace root
mkdir -p .kiro/skills .kiro/steering
cp -R /path/to/superpowers/superpowers-skills/skills/.   .kiro/skills/
cp -R /path/to/superpowers/superpowers-skills/steering/. .kiro/steering/
```

### Global install (all workspaces)

Kiro also reads `~/.kiro/skills/` and `~/.kiro/steering/`. Copy the two trees
there instead to enable Superpowers for every workspace (a workspace-level file of
the same name still wins on conflict).

```bash
bash superpowers-skills/install.sh ~
```

## Verify

Start a fresh Kiro session in the target workspace and send exactly:

> Let's make a react todo list

A working install auto-triggers the **brainstorming** skill *before any code is
written* — the agent asks about intent and design rather than jumping into
implementation. If it doesn't, the steering bootstrap isn't loading: confirm
`.kiro/steering/superpowers-bootstrap.md` exists in the workspace and that
`.kiro/skills/using-superpowers/SKILL.md` resolves (the bootstrap references it
with Kiro's `#[[file:...]]` syntax, relative to the workspace root).

You can also ask the agent "what are your superpowers?" — if the bootstrap
injected, it knows it has them.

## The basic workflow

1. **brainstorming** — refines a rough idea into a design before any code.
2. **using-git-worktrees** — isolated workspace on a new branch.
3. **writing-plans** — breaks work into small, verifiable tasks.
4. **subagent-driven-development** / **executing-plans** — execute the plan
   (fresh subagent per task with review, or inline with one final review).
5. **test-driven-development** — RED-GREEN-REFACTOR.
6. **requesting-code-review** / **receiving-code-review** — review between tasks.
7. **finishing-a-development-branch** — merge / PR / cleanup.

## Notes on the Kiro port

- **Subagents** map to `invokeSubAgent` (`general-task-execution` for implementer
  work, `context-gatherer` for research, `semantic_reviewer` for review). They are
  available only in **Autopilot** mode; in Supervised mode the subagent-based
  skills fall back to inline execution.
- **Todos** map to Kiro's `todoList` tool.
- The bootstrap is delivered through steering, not a shell hook. An `inclusion:
  always` steering file is Kiro's documented mechanism for guaranteed
  every-session context injection and is more reliable than a SessionStart hook
  for static instructions.

MIT License — see the repository `LICENSE`.
