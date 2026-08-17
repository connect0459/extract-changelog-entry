# extract-changelog

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
  uses: connect0459/extract-changelog@v1
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
| `promote-headings` | No | `true` | Whether to promote entry subsection headings (`###`, `####`, ...) by one level. Set to `false` to keep the CHANGELOG.md's original heading levels as-is. |

## Outputs

| Name | Description |
| --- | --- |
| `release-notes-path` | Path to the generated release notes file (same as `output-path`). |
| `version` | The release version with any leading `v` stripped. |

## CHANGELOG.md format requirements

- Follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/): version sections are headed `## [X.Y.Z] - YYYY-MM-DD`, with entry subsections (`### Added`, `### Fixed`, etc.) nested one level deeper. These subsections are promoted one heading level in the output by default; set `promote-headings: false` to keep the original levels.
- An `## [Unreleased]` section is expected above the latest version. If no section matching `ref-name` is found (for example, `[Unreleased]` was not retitled before tagging), the action fails with an error.
- A version's section ends at the next `## [` heading, or at a `---` horizontal rule (used ahead of the reference-link block at the end of the file — this is how the oldest version's section is terminated, since there is no earlier heading to stop at).
- A reference-style link `[X.Y.Z]: <url>` at the bottom of the file is used to build the "Full Changelog" link. If the link is a compare URL (`.../compare/vA...vB`), it's used directly; if it points at the tag itself (the first release has no prior tag to compare against), the link falls back to the tag's commit history. If no reference link exists for the version, no "Full Changelog" section is appended.

See [`tests/fixtures/standard`](tests/fixtures/standard) for a worked example: a `CHANGELOG.md` and `ref-name` input paired with the `release-notes.md` this action produces from them.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
