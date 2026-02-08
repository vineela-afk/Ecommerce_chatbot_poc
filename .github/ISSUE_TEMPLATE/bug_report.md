name: Bug Report
description: File a bug report
title: "[BUG]: "
labels: ["bug"]
assignees:
  - 

body:
  - type: markdown
    attributes:
      value: |
        Thanks for taking the time to fill out this bug report!

  - type: textarea
    id: description
    attributes:
      label: Description
      description: A clear and concise description of what the bug is
      placeholder: |
        I encountered a bug where...
    validations:
      required: true

  - type: textarea
    id: steps-to-reproduce
    attributes:
      label: Steps to Reproduce
      description: Steps to reproduce the behavior
      placeholder: |
        1. Go to '...'
        2. Click on '...'
        3. See error
    validations:
      required: true

  - type: textarea
    id: expected-behavior
    attributes:
      label: Expected Behavior
      description: A clear and concise description of what you expected to happen
    validations:
      required: true

  - type: textarea
    id: actual-behavior
    attributes:
      label: Actual Behavior
      description: What actually happened instead
    validations:
      required: true

  - type: textarea
    id: logs-or-error
    attributes:
      label: Logs or Error Messages
      description: If applicable, add logs or error messages
      render: markdown
      placeholder: |
        ```
        [ERROR] Error message here
        ```

  - type: input
    id: environment
    attributes:
      label: Environment
      description: OS, service, version, etc.
      placeholder: macOS 12.1, Docker 20.10, Python 3.10

  - type: textarea
    id: additional-context
    attributes:
      label: Additional Context
      description: Any other context about the problem
      placeholder: Add any other context about the problem here

  - type: checkboxes
    id: terms
    attributes:
      label: Confirmation
      options:
        - label: I have read the README
          required: false
        - label: I have checked existing issues
          required: true
        - label: This issue is about the code, not deployment/infrastructure
          required: false
