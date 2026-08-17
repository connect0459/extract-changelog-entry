<!-- # PULL_REQUEST_TEMPLATE -->

<!-- Remove unnecessary sections to keep the review focused -->

## Related Links

- Issues
  - <!-- <https://github.com/connect0459/extract-changelog/issues/xxx> -->
- PRs
  - <!-- <https://github.com/connect0459/extract-changelog/pull/xxx> -->

## [Required] Overview

- Describe the problem being solved, its background, and what changes when this PR is merged.
- Links to fixtures, issues, or other references are welcome.

```txt
It is difficult to review without knowing the specifications and background.
```

## Scope of Change

- [ ] `action.yml`
- [ ] `tests/fixtures/`
- [ ] Tooling / CI
- [ ] Documentation

## Breaking Changes

- [ ] No breaking changes
- [ ] Breaking changes (describe below)

<!--
If this changes action.yml's inputs/outputs (README.md's Inputs/Outputs tables), describe what breaks and why the breakage is justified.
-->

## Deferred Items and TODOs

- Items intentionally deferred and the reasons why.

```txt
If you deferred something due to time constraints, document it here.
Reviewers cannot tell whether something was intentionally skipped or overlooked
without this information.
```

## Test Items

- Describe the fixture(s) added or updated, and which scenario each one characterizes.
- Confirm `pre-commit run --all-files` passes.
- Confirm `act -j fixture` passes, if Docker is available; otherwise note that this PR's own CI run is the first execution.

## [Required] Quality Checklist

**Please check all items before merging.**

- [ ] **CI Workflow Execution**: All checks passed on the [CI workflow](../actions/workflows/ci.yml) for this PR.
- [ ] **Code Comments**: Limited to non-obvious WHY/WHY-NOT explanations, per this project's comment policy (see `AGENTS.md`).
- [ ] **Reference Docs**: `README.md`'s Inputs/Outputs tables and CHANGELOG.md format requirements are updated for any behavior change.

> **Important**: This checklist ensures quality. Please verify all items before requesting review.
