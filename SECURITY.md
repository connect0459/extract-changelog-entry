# Security Policy

## Supported Versions

Only the latest major version tag (`v1`) is actively maintained. As this
project is pre-1.0 in practice (a single action, no compiled releases),
no long-term support window is guaranteed for a superseded major version.

## Reporting a Vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.**

Use GitHub's [private vulnerability reporting][private-report] feature, or
email <connect0459@gmail.com>, to disclose issues confidentially. You can
expect an acknowledgement within 7 days and a status update within 30 days.

**What to include:**

- A minimal `CHANGELOG.md` fixture and the `with:` inputs that trigger the
  issue.
- The version (tag or SHA) of this action in use.
- A description of the impact.

[private-report]: https://github.com/connect0459/extract-changelog-release-notes/security/advisories/new

## Scope

This action's `run:` step reads `CHANGELOG.md`, writes `release-notes.md`
(or the caller's configured `output-path`), and writes to `$GITHUB_OUTPUT`.
The following classes of issues are in scope:

- **Shell/command injection** — any `ref-name`, `changelog-path`, or
  `output-path` value that causes code execution beyond the intended
  `awk`/`sed` extraction (for example, breaking out of the quoted filename
  arguments those commands receive).
- **`$GITHUB_OUTPUT` injection** — a `ref-name` value containing embedded
  newlines or control characters that causes extra `key=value` lines to be
  written to `$GITHUB_OUTPUT`, altering outputs the action did not intend
  to set.
- **Path traversal** — a `changelog-path` or `output-path` value that
  causes the action to read or write outside the caller's intended
  directory, when those values are not themselves attacker-controlled by
  the caller's own design (see out of scope below).

The following are **out of scope**:

- A caller's workflow passing an untrusted, attacker-controlled value as
  `changelog-path` or `output-path` (for example, sourced directly from a
  pull request's body). Supplying trusted path values is the calling
  workflow's responsibility, not this action's.
- Vulnerabilities in `softprops/action-gh-release` or other actions a
  caller's workflow composes this action with — report those to their
  respective maintainers.
- A caller pinning this action to a mutable tag (`@v1`) instead of a
  commit SHA. Pinning to a SHA is recommended in `README.md` but is the
  caller's choice to make.

## Disclosure Policy

Once a fix is released, a GitHub Security Advisory will be published with
full details. The typical timeline from report to public disclosure is
30 days, though this may be extended by mutual agreement when a fix
requires significant changes.
