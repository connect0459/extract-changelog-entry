# AGENTS.md / CLAUDE.md

This is a GitHub composite Action, written as `action.yml` plus embedded bash (`awk`/`sed`). There is no application code, domain layer, or compiled artifact — the shipped behavior is the YAML file itself.

## Language Convention

This project may be released publicly. All of the following must be written in **English**:

- Commit messages
- Code comments
- Documentation (including `AGENTS.md`, `README.md`, etc.)
- Fixture names
- Error messages

## Before Starting Development

Before making changes, read `CONTRIBUTING.md` and run `just --list` to learn the commands this project uses for setup, linting, and testing. Use those commands rather than reaching for ad-hoc equivalents.

## Development Philosophy

### Fixture-based Characterization Testing

- `action.yml`'s extraction logic was ported verbatim from production workflows already running across multiple repositories; it is proven behavior, not a new design. Correctness is therefore locked via characterization tests rather than derived from a spec: each fixture under `tests/fixtures/<case>/` pairs a `CHANGELOG.md` and `ref-name` input with either an `expected.md` (the action must succeed and match byte-for-byte) or no `expected.md` (the action must fail).
- Write the fixture (input + expected outcome) before changing `action.yml`; run `.github/workflows/ci.yml`'s fixture matrix after, to confirm the change is deliberate rather than an accidental regression.
- The only real external boundary is the filesystem (`CHANGELOG.md`, `output-path`); tests exercise the actual composite action end-to-end (`uses: ./`) against real files — nothing here is mocked.
- Never hand-derive an `expected.md` from reading the `awk`/`sed` script. Run the action against the fixture and review the actual output; save that as the fixture's expectation. A hand-transcribed expectation risks encoding the same transcription error the test was meant to catch.

### Fixture Naming

- A fixture's directory name describes the CHANGELOG.md **scenario** being exercised (e.g. `first-release`, `no-reference-link`), not the `awk`/`sed` mechanism that handles it.
- A new edge case gets a new fixture directory, not a branch inside an existing one — one scenario per fixture keeps `diff` output attributable to a single behavior change.

### Code Comments

- Do NOT write code comments unless explicitly permitted by the user
- Let the code speak for itself; let the fixtures document the behavior
- Code = How, Fixtures = What, Commit messages = Why

## Git Conventions

### Format

```text
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

| Type | Description |
| :--- | :--- |
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Code style (formatting, whitespace) |
| `refactor` | Code change that is neither a fix nor a feature |
| `tidy` | Small, safe cleanup (< 2 min; no behavior change) |
| `test` | Adding or updating fixtures |
| `chore` | Build process, tooling, or config changes |
| `ci` | CI/CD pipeline changes (GitHub Actions, workflows) |
| `perf` | Performance improvement |

### Scopes

Scope is optional for this single-action repository; omit it for most
changes. Use `fixtures` when a change is confined to `tests/fixtures/`.

### Type vs. Scope Precedence

The type vocabulary above mixes two axes: an **impact axis** (`feat`, `fix`, `perf`, `refactor` — the SemVer-relevant effect of a change) and a **domain axis** (`docs`, `style`, `test`, `chore`, `ci`, `tidy` — a layer with no runtime/SemVer effect). When a change is fully contained within a domain, use that domain as `type` (e.g. `docs: fix typo`); do not use it as `scope` on an impact-axis type (avoid `fix(docs): ...`). `scope` sub-divides whatever `type` already established (e.g. `feat(auth)`); it is not a substitute classification axis. This also matches how release automation typically bumps versions from `type` alone, without inspecting `scope`.

### Subject Line

- Use the imperative mood: "add", "fix", "remove" — not "added" or "adds"
- 72 characters max
- No trailing period

### Body (optional)

- Wrap at 72 characters
- Explain **why**, not what — the diff already shows what changed
- Leave one blank line between subject and body

### Footer (optional)

- `BREAKING CHANGE: <description>` for breaking changes
- `Closes #123` or `Fixes #456` to link issues

### Branch naming

`feat/xxx`, `fix/xxx`, `docs/xxx`
