# Clair

Clair is a native macOS Markdown editor for writing clearer, better-sourced technical articles.

The goal is not to build an AI truth machine. Clair is designed as a local-first writing workflow that helps writers notice weak claims, unclear paragraphs, missing sources, and risky statements before publishing.

## Why Clair exists

Writing technical content is not only about style. It is also about precision, nuance, sources, and trust.

When writing articles, documentation, newsletters, or technical notes, it is easy to make statements that are too broad, outdated, unsourced, or hard to verify. Clair aims to make those weak spots visible directly inside the writing flow, paragraph by paragraph.

## Core principles

- **Native macOS first**: Clair is built as a real desktop app, not a web wrapper.
- **Local-first by default**: documents should stay on the user's machine.
- **Markdown as source of truth**: files should remain portable and readable outside Clair.
- **Assisted review, not automated truth**: Clair helps detect risky claims, but it does not guarantee factual correctness.
- **Transparent development**: the code is public while the project is being designed and prototyped.
- **Free to use**: the project is intended to remain free.

## Planned features

### Writing

- Markdown editor
- Local document and folder management
- Paragraph detection
- Writing quality checks
- Suggestions to make text clearer, safer, or more concise

### Reliability review

- Detection of weak or risky claims
- Detection of unsourced statements
- Paragraph-level reliability indicators
- Source-aware review workflow
- Manual source attachment in early versions

### Translation

- Translate selected paragraphs
- Translate complete Markdown documents by chunks
- Preserve Markdown structure, links, lists, and code blocks
- Optional glossary for technical terms

### Export

- Markdown export
- PDF export
- Later: HTML or other publishing formats

### AI providers

- Apple Foundation Models for native local tasks where available
- Optional local model support through tools such as Ollama
- Mock provider for development and testing

## What Clair is not

Clair is not a replacement for professional fact-checking.

It does not certify that an article is true. It does not replace sources, research, editorial judgment, or domain expertise.

A better way to describe Clair is:

> A writing assistant that helps you spot weak claims before you publish.

## Roadmap

### v0.1 — Project foundation

- Public README and project scope
- Native macOS SwiftUI app skeleton
- Local Markdown document storage
- Three-panel editor layout
- Unit tests and CI foundation

### v0.2 — Paragraph analysis prototype

- Paragraph splitting
- Paragraph hashing
- Mocked analysis workflow
- Reliability status model
- Right-panel issue display

### v0.3 — First AI-assisted writing checks

- Writing quality check
- Claim extraction
- Safer rewrite suggestions
- Basic analysis profiles

### v0.4 — Markdown translation

- Translate selected text
- Translate documents by chunks
- Preserve Markdown structure
- Add glossary support

### v0.5 — Source-assisted review

- Attach sources manually
- Compare claims with source excerpts
- Display source support status
- Export review report

## Development status

Clair is currently in the earliest design and prototyping phase.

The repository is public for transparency while the project is being built. External contributions may be considered later, but the product direction is intentionally curated during the first versions.

## Running the project

Setup instructions will be added once the first macOS project skeleton is available.

Expected stack:

- Swift 6.x
- SwiftUI
- macOS native app target
- Unit tests
- GitHub Actions CI

## Testing

Testing infrastructure will be added early in the project.

Initial test targets should cover:

- Markdown paragraph splitting
- Paragraph hash generation
- Document model encoding and decoding
- Analysis status mapping
- Settings and profile validation

## License

License choice is not finalized yet.

Until a license is explicitly added, the source code is public for transparency and learning purposes, but reuse, redistribution, and modification rights are not granted automatically.
