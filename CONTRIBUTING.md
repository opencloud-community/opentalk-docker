# Contributing to OpenTalk Docker

Thank you for your interest in contributing to the OpenTalk Docker project! This document provides guidelines for contributions.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion for improvement:

1. Check if the issue already exists in the [GitHub Issues](https://github.com/opencloud-community/opentalk-docker/issues)
2. If not, create a new issue with a clear description and steps to reproduce

### Code Contributions

1. Fork the repository
2. Create a feature branch: `git checkout -b my-new-feature`
3. Make your changes
4. Commit your changes following the [commit message guidelines](#commit-messages)
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request

### Commit Messages

Please follow these guidelines for commit messages:

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests after the first line

## Development Guidelines

### Docker Compose Files

- Keep the main `docker-compose.yml` as clean as possible
- Use environment variables with sensible defaults
- Document all services and configuration options
- Ensure all volumes are properly named

### Documentation

- Update documentation when adding or changing features
- Keep documentation in sync with the code
- Write clear, concise documentation that is easy to follow

### Testing

Before submitting a pull request, make sure to:

1. Test your changes locally
2. Verify that all services start correctly
3. Check that environment variables work as expected
4. Ensure your changes are properly documented

## Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/). By participating, you are expected to uphold this code.

## License

By contributing to this project, you agree that your contributions will be licensed under the project's [EUPL-1.2 license](LICENSE).