# Contributing

## Prerequisites

- [just](https://just.systems/) — task runner
- [pre-commit](https://pre-commit.com/) — hook runner (already requires a Python 3 interpreter to install; no separate Ruby/ShellCheck install is needed — the local `shellcheck-action` hook provisions PyYAML and ShellCheck via pre-commit's own Python-language environment)
- [`act`](https://github.com/nektos/act) (optional) — runs `.github/workflows/ci.yml`'s fixture matrix locally instead of waiting on a push

## Setup

```sh
git clone https://github.com/connect0459/extract-changelog-release-notes
cd extract-changelog-release-notes
just setup
```

`just setup` installs the pre-commit hooks (`pre-commit install`).

To run all hooks manually:

```sh
pre-commit run --all-files
```

## Development workflow

This mirrors the CI pipeline (`.github/workflows/ci.yml`):

| Command | Purpose |
| :--- | :--- |
| `pre-commit run --all-files` | Formatting, Markdown lint, `actionlint`, and `shellcheck` on `action.yml` |
| `act -j fixture` | Run the fixture matrix locally (requires Docker) |

There is no separate build step: `action.yml` is the shipped artifact.

## Testing guidelines

This project has no domain code to unit test — `action.yml`'s extraction
logic was ported verbatim from production workflows already running
across several repositories, so correctness is locked via
**characterization tests**, not derived from a spec:

- Each fixture under `tests/fixtures/<case>/` pairs a `CHANGELOG.md` and a
  `ref-name` file with either an `expected.md` (the action must succeed
  and its output must match byte-for-byte) or no `expected.md` (the
  action must fail).
- Add a new fixture directory for each new edge case rather than
  branching an existing one — one scenario per fixture keeps `diff`
  output attributable to a single behavior change.
- Never hand-derive an `expected.md`. Run the action against the fixture
  and review the actual output before committing it as the expectation;
  see `AGENTS.md` for why.
- `.github/workflows/ci.yml` runs every fixture through the actual
  composite action (`uses: ./`) — nothing here is mocked.

## Commit format

```text
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `tidy`, `test`, `chore`, `ci`, `perf`

**Scope**: optional for this single-action repository; use `fixtures` when a change is confined to `tests/fixtures/`. Use a domain-axis type (`docs`, `style`, `test`, `chore`, `ci`, `tidy`) as `type` when the change is fully contained within that domain, rather than as `scope` on an impact-axis type.

**Subject**: imperative mood ("add", "fix", "remove"), 72 characters max, no trailing period.

**Body** (optional): wrap at 72 characters; explain **why**, not what — the diff already shows what changed.

**Footer** (optional): `BREAKING CHANGE: <description>`, or `Closes #123` / `Fixes #456` to link issues.

## Pull request process

1. Fork the repository and create a branch: `feat/xxx`, `fix/xxx`, `docs/xxx`.
2. Add or update a fixture before changing `action.yml`; keep one concern per commit.
3. Run `pre-commit run --all-files` and, if you have Docker, `act -j fixture`; ensure both pass.
4. Open a pull request using the repository's PR template — CI (`ci.yml`'s fixture matrix) runs automatically.

## Code style

- Avoid code comments in `action.yml` unless the **why** is genuinely non-obvious — let the fixtures document behavior.
- Inputs are passed to the shell via the step's `env:` block, never interpolated directly into `run:` via `${{ }}` — this keeps a caller-supplied `ref-name`/`changelog-path`/`output-path` from being spliced into the script as code.
- All identifiers, fixture names, and documentation must be in **English** (see `AGENTS.md`).
