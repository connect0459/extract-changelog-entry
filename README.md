# extract-changelog-entry

[![CI](https://github.com/connect0459/extract-changelog-entry/actions/workflows/ci.yml/badge.svg)](https://github.com/connect0459/extract-changelog-entry/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/connect0459/extract-changelog-entry/blob/main/LICENSE)
[![GitHub Marketplace](https://img.shields.io/badge/GitHub-Marketplace-blue.svg?logo=github&logoColor=white)](https://github.com/marketplace/actions/extract-changelog-entry)

A composite GitHub Action that extracts a single version's section from a [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) -formatted `CHANGELOG.md` and appends a "Full Changelog" link, producing a file suitable for `softprops/action-gh-release`'s `body_path` input.

This action only extracts the release notes text. Creating the GitHub Release itself is left to the caller's workflow.

## Motivation

A changelog entry and a release's notes are the same text wearing two hats: the entry gets written and reviewed at PR time, well before any tag exists, and by release time it already says everything the release notes need to. Hand-copying it into the release (or maintaining a separate script to slice it out) just gives the two a chance to drift.

- **Release notes for free.** The changelog entry already written for the version is reused as-is — no second draft to author for the GitHub Release.
- **No drift.** There's exactly one place a version's notes live, so the changelog and the release can't end up saying different things.
- **Fits into an existing release workflow.** Chain it ahead of `softprops/action-gh-release` (see [Usage](#usage) below) and a tag push produces both the changelog entry and the release, unattended.

## Usage

```yaml
- name: Extract changelog section
  id: changelog
  uses: connect0459/extract-changelog-entry@v1
  with:
    ref-name: ${{ github.ref_name }}

- name: Create GitHub Release
  uses: softprops/action-gh-release@v3
  with:
    name: ${{ github.ref_name }}
    body_path: ${{ steps.changelog.outputs.release-notes-path }}
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `ref-name` | Yes | — | Git ref name of the release tag (e.g. `v1.2.3` or `1.2.3`). A leading `v` is stripped when matching the CHANGELOG.md version heading. |
| `changelog-path` | No | `CHANGELOG.md` | Path to the CHANGELOG.md file. |
| `output-path` | No | `release-notes.md` | Path to write the extracted release notes to. |
| `promote-headings` | No | `true` | Whether to promote entry headings so the shallowest one present becomes an H2, preserving every other heading's depth relative to it. Set to `false` to keep the CHANGELOG.md's original heading levels as-is. |

## Outputs

| Name | Description |
| --- | --- |
| `release-notes-path` | Path to the generated release notes file (same as `output-path`). |
| `version` | The release version with any leading `v` stripped. |

## CHANGELOG.md format requirements

- Follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/): version sections are headed `## [X.Y.Z] - YYYY-MM-DD`, with entry subsections (`### Added`, `### Fixed`, etc.) nested one level deeper. By default, headings in the output are promoted so the shallowest one found in the entry body becomes `##`, with every other heading — including the KaC subsection heading itself — shifted by that same amount to preserve its depth relative to that one; set `promote-headings: false` to keep the original levels. This means the subsection heading isn't always promoted: it keeps its original level when the shallowest heading present is already `##`, and shifts deeper instead of being promoted if the body contains a heading shallower than that.
- An `## [Unreleased]` section is expected above the latest version. If no section matching `ref-name` is found (for example, `[Unreleased]` was not retitled before tagging), the action fails with an error.
- A version's section ends at the next `## [` heading, or at a `---` horizontal rule (used ahead of the reference-link block at the end of the file — this is how the oldest version's section is terminated, since there is no earlier heading to stop at).
- A fenced code block (` ``` ` or `~~~`) inside an entry is treated as literal content: `#`-prefixed lines, `## [` headings, and `---` dividers inside it are never promoted or treated as a section boundary. Fence and heading recognition both follow CommonMark's document-root indentation limit (up to 3 leading spaces) — an indented heading inside a list item's continuation text is still recognized (and shifts by the same rule as any other heading in the body, per above), and a fence indented further than that — for example inside a more deeply nested list item — is not recognized, leaving its content unprotected.
- A reference-style link `[X.Y.Z]: <url>` at the bottom of the file is used to build the "Full Changelog" link. If the link is a compare URL (`.../compare/vA...vB`), it's used directly; if it points at the tag itself (the first release has no prior tag to compare against), the link falls back to the tag's commit history. If no reference link exists for the version, no "Full Changelog" section is appended.

See [`tests/fixtures/standard`](tests/fixtures/standard) for a worked example: a `CHANGELOG.md` and `ref-name` input paired with the `release-notes.md` this action produces from them.

## Contributing

See [CONTRIBUTING.md](https://github.com/connect0459/extract-changelog-entry/blob/main/CONTRIBUTING.md).

## License

[MIT](https://github.com/connect0459/extract-changelog-entry/blob/main/LICENSE)
