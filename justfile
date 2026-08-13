# Setup after clone
setup:
    pre-commit install

# Run all pre-commit hooks (formatting, markdownlint, actionlint, shellcheck)
lint:
    pre-commit run --all-files

# Run the fixture matrix locally via act (requires Docker)
test:
    act -j fixture

# Verify code quality and behavior (matches CI; test requires Docker)
verify: lint test
