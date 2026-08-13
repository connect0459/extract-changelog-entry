# Changelog

<!--
When cutting a new release, update THREE places in this file:

1. Rename [Unreleased] to [X.Y.Z] with today's date (above), and add a fresh empty [Unreleased] section above it.
2. Update the reference links at the very bottom of this file:
    - Change [Unreleased] to compare the new tag against HEAD.
    - Add [X.Y.Z] comparing the new tag against the previous tag (or, for the first release, linking directly to the tag).
3. After the PR is merged, push the release tag. Pull main first so HEAD is the merge commit:

    ```console
    git checkout main && git pull origin main
    git tag vX.Y.Z && git push origin vX.Y.Z
    ```

   Pushing the tag triggers `.github/workflows/release.yml`, which extracts this file's `[X.Y.Z]` section and creates the GitHub Release from it automatically. Do not run `gh release create` manually; it would create the tag/Release ahead of the workflow with hand-pasted notes instead of the CHANGELOG-derived ones.

This project is itself consumed as a GitHub Action (`uses: connect0459/extract-changelog@vMAJOR`), so also re-point the movable major tag at the new commit (or create it, for a new major version):

    ```console
    git tag -f vMAJOR vX.Y.Z && git push origin vMAJOR --force
    ```
-->

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-08-13

### Added

- Composite GitHub Action that extracts a single version's section from a Keep a Changelog `CHANGELOG.md` and appends a "Full Changelog" link, producing a file suitable for `softprops/action-gh-release`'s `body_path` input.
- `ref-name` input selects the version to extract, matched after stripping a leading `v`; `changelog-path` and `output-path` inputs default to `CHANGELOG.md` and `release-notes.md`.
- `promote-headings` input (default `true`) promotes each entry subsection heading by one level, so the extracted notes read as a normal document instead of starting at H3; set to `false` to keep the source's heading levels as-is.
- `release-notes-path` and `version` outputs, for chaining into a release step.
- A version's "Full Changelog" link reuses the compare URL already recorded in `CHANGELOG.md`'s own reference-link section, falling back to the tag's commit history for a first release with no prior tag to compare against.
- Fails with a clear error when no section matches `ref-name`, rather than producing an empty or misleading release body.

---

[Unreleased]: <https://github.com/connect0459/extract-changelog/compare/v1.0.0...HEAD>
[1.0.0]: <https://github.com/connect0459/extract-changelog/releases/tag/v1.0.0>
