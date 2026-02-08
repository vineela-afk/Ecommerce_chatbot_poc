name: Feature Request
description: Suggest an idea for this project
title: "[FEATURE]: "
labels: ["enhancement"]
assignees:
  - 

body:
  - type: markdown
    attributes:
      value: |
        Thanks for suggesting a feature! Please fill out this form to help us understand your request.

  - type: textarea
    id: description
    attributes:
      label: Description
      description: A clear and concise description of what you want to happen
      placeholder: |
        I think it would be useful if...
    validations:
      required: true

  - type: textarea
    id: use-case
    attributes:
      label: Use Case
      description: Describe the problem you're trying to solve
      placeholder: |
        Currently, I have to... but I wish I could...
    validations:
      required: true

  - type: textarea
    id: proposed-solution
    attributes:
      label: Proposed Solution
      description: How do you think this feature should work?
      placeholder: |
        One way to implement this would be...

  - type: textarea
    id: alternatives
    attributes:
      label: Alternative Solutions
      description: Have you considered any other solutions or features?

  - type: textarea
    id: additional-context
    attributes:
      label: Additional Context
      description: Any other context, examples, or screenshots
      placeholder: Add any other context about the feature request here

  - type: checkboxes
    id: terms
    attributes:
      label: Confirmation
      options:
        - label: This feature would benefit multiple users
          required: false
        - label: I have checked for similar feature requests
          required: true
        - label: I'm willing to contribute to implement this feature
          required: false
