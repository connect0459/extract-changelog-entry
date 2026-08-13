---
name: Bug Report
about: Report a bug
---

## [Required] Bug Summary

## [Required] Affected Area

- [ ] `action.yml` extraction logic
- [ ] CI workflow (`.github/workflows/ci.yml`)
- [ ] Other

## [Required] Minimal Reproduction

Ideally shaped like a `tests/fixtures/<case>/` fixture: a minimal
`CHANGELOG.md` plus the `with:` inputs (`ref-name`, `changelog-path`,
`output-path`) that trigger the issue.

```yaml
# CHANGELOG.md
## [Unreleased]

## [1.0.0] - 2026-01-01

### Added

- ...
```

```yaml
# with: inputs
ref-name: v1.0.0
```

## [Required] Expected Behavior

<!-- What should the generated release notes contain, or what should the action's outputs be? -->

## [Required] Actual Behavior

## Environment

- Action version (tag or SHA) in use:
- Runner OS (e.g. `ubuntu-latest`, or local via `act`):

## Impact

<!-- How does this affect other consumers of this action? -->
