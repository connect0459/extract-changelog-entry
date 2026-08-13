# extract-changelog

A composite GitHub Action that extracts a single version's section from a
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)-formatted
`CHANGELOG.md` and appends a "Full Changelog" link, producing a file
suitable for `softprops/action-gh-release`'s `body_path` input.

This action only extracts the release notes text. Creating the GitHub
Release itself is left to the caller's workflow.

## Usage

```yaml
- name: Extract changelog section for this version
  id: changelog
  uses: connect0459/extract-changelog@v1
  with:
    ref-name: ${{ github.ref_name }}

- name: Create GitHub Release
  uses: softprops/action-gh-release@3d0d9888cb7fd7b750713d6e236d1fcb99157228 # v3.0.2
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

- Follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/): version
  sections are headed `## [X.Y.Z] - YYYY-MM-DD`, with entry subsections
  (`### Added`, `### Fixed`, etc.) nested one level deeper. These
  subsections are promoted one heading level in the output by default; set
  `promote-headings: false` to keep the original levels.
- An `## [Unreleased]` section is expected above the latest version. If no
  section matching `ref-name` is found (for example, `[Unreleased]` was not
  retitled before tagging), the action fails with an error.
- A version's section ends at the next `## [` heading, or at a `---`
  horizontal rule (used ahead of the reference-link block at the end of the
  file — this is how the oldest version's section is terminated, since
  there is no earlier heading to stop at).
- A reference-style link `[X.Y.Z]: <url>` at the bottom of the file is used
  to build the "Full Changelog" link. If the link is a compare URL
  (`.../compare/vA...vB`), it's used directly; if it points at the tag
  itself (the first release has no prior tag to compare against), the link
  falls back to the tag's commit history. If no reference link exists for
  the version, no "Full Changelog" section is appended.

## Testing

`.github/workflows/ci.yml` runs the action against the fixtures under
[`tests/fixtures/`](tests/fixtures), each pairing a `CHANGELOG.md` and
`ref-name` with either an `expected.md` (the action must succeed and match)
or no `expected.md` (the action must fail).
