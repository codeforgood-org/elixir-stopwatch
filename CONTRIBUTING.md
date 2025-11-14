# Contributing to Elixir Stopwatch

First off, thank you for considering contributing to Elixir Stopwatch! It's people like you that make this tool better for everyone.

## Code of Conduct

This project and everyone participating in it is governed by mutual respect and professionalism. By participating, you are expected to uphold this standard.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** - Include code samples, command-line output, or screenshots
- **Describe the behavior you observed** and what behavior you expected to see
- **Include details about your environment**:
  - Elixir version (`elixir --version`)
  - Erlang/OTP version
  - Operating system and version

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **A clear and descriptive title**
- **A detailed description of the proposed functionality**
- **Examples of how the enhancement would be used**
- **Why this enhancement would be useful** to most users

### Pull Requests

1. Fork the repository and create your branch from `main`
2. If you've added code that should be tested, add tests
3. If you've changed APIs, update the documentation
4. Ensure the test suite passes
5. Make sure your code follows the existing style
6. Write a clear commit message

## Development Setup

### Prerequisites

- Elixir 1.14 or higher
- Erlang/OTP 24 or higher
- Git

### Setting Up Your Environment

1. Fork and clone the repository:
   ```bash
   git clone https://github.com/your-username/elixir-stopwatch.git
   cd elixir-stopwatch
   ```

2. Install dependencies:
   ```bash
   mix deps.get
   ```

3. Run tests to ensure everything works:
   ```bash
   mix test
   ```

4. Build the escript:
   ```bash
   mix escript.build
   ```

## Development Workflow

### Running Tests

```bash
# Run all tests
mix test

# Run tests with coverage
mix test --cover

# Run a specific test file
mix test test/stopwatch_test.exs

# Run tests in watch mode (requires mix_test_watch)
mix test.watch
```

### Code Formatting

This project uses Elixir's built-in formatter:

```bash
# Format all files
mix format

# Check if files are formatted
mix format --check-formatted
```

### Documentation

Generate and view documentation locally:

```bash
mix docs
open doc/index.html  # or xdg-open on Linux
```

### Code Quality

While not mandatory, we encourage running additional quality checks:

```bash
# Static analysis (if using Dialyzer)
mix dialyzer

# Linting (if using Credo)
mix credo --strict
```

## Code Style Guidelines

### General Principles

- Follow the [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide)
- Write clear, self-documenting code
- Keep functions small and focused
- Use pattern matching effectively
- Prefer functional patterns over imperative

### Specific Guidelines

1. **Documentation**
   - Add `@moduledoc` to all modules
   - Add `@doc` to all public functions
   - Include examples in documentation
   - Add `@spec` type specifications

2. **Testing**
   - Write tests for all new functionality
   - Maintain or improve test coverage
   - Use descriptive test names
   - Group related tests with `describe` blocks

3. **Error Handling**
   - Use tagged tuples (`{:ok, result}`, `{:error, reason}`)
   - Provide clear error messages
   - Handle edge cases explicitly

4. **Naming Conventions**
   - Use descriptive variable names
   - Follow Elixir naming conventions
   - Use `snake_case` for functions and variables
   - Use `PascalCase` for modules

5. **Module Organization**
   ```elixir
   defmodule MyModule do
     @moduledoc """
     Module documentation
     """

     # Module attributes
     @constant_value "value"

     # Type definitions
     @type t :: %__MODULE__{}

     # Struct definition
     defstruct [:field1, :field2]

     # Public functions
     def public_function do
       # ...
     end

     # Private functions
     defp private_function do
       # ...
     end
   end
   ```

## Commit Message Guidelines

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement
- **test**: Adding or updating tests
- **chore**: Changes to build process or auxiliary tools

### Examples

```
feat(formatter): add milliseconds-only display format

Add a new format option to display only milliseconds without
seconds/minutes/hours for very short durations.

Closes #123
```

```
fix(stopwatch): correct pause time calculation

The pause duration was not being properly accumulated when
pausing multiple times. Fixed by tracking total_paused time.

Fixes #456
```

## Testing Guidelines

### What to Test

- All public API functions
- Edge cases and error conditions
- State transitions
- Integration between modules

### Test Structure

```elixir
defmodule MyModuleTest do
  use ExUnit.Case
  doctest MyModule

  describe "function_name/arity" do
    test "describes what it tests" do
      # Arrange
      input = create_input()

      # Act
      result = MyModule.function_name(input)

      # Assert
      assert result == expected
    end
  end
end
```

### Best Practices

- One logical assertion per test
- Use descriptive test names
- Keep tests independent
- Don't test implementation details
- Use fixtures for complex test data

## Documentation Guidelines

### Module Documentation

```elixir
@moduledoc """
Brief description of the module.

Longer description with more details about what the module does,
how it's used, and any important concepts.

## Examples

    iex> MyModule.function()
    :result
"""
```

### Function Documentation

```elixir
@doc """
Brief description of what the function does.

Returns detailed information about return values.

## Parameters

  - `param1` - Description of first parameter
  - `param2` - Description of second parameter

## Examples

    iex> MyModule.function(arg1, arg2)
    {:ok, result}

## Options

  - `:option1` - Description (default: `value`)
  - `:option2` - Description
"""
@spec function(arg1_type, arg2_type) :: return_type
def function(param1, param2) do
  # ...
end
```

## Release Process

1. Update version in `mix.exs`
2. Update `CHANGELOG.md` with changes
3. Commit changes: `git commit -am "chore: bump version to x.y.z"`
4. Tag the release: `git tag -a vx.y.z -m "Release x.y.z"`
5. Push changes: `git push && git push --tags`

## Questions?

Feel free to open an issue with your question, or reach out to the maintainers directly.

## Recognition

Contributors will be recognized in the project's README and release notes. Thank you for your contributions!

---

Happy coding! 🚀
