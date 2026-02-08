name: Pull Request
description: Create a pull request to contribute to the project
title: "[PR]: "
labels: ["review"]

body:
  - type: markdown
    attributes:
      value: |
        Thanks for your contribution! Please fill out this form to help us review your PR faster.

  - type: textarea
    id: description
    attributes:
      label: Description
      description: A clear and concise description of your changes
      placeholder: |
        This PR addresses issue #123 by implementing...
    validations:
      required: true

  - type: textarea
    id: related-issues
    attributes:
      label: Related Issues
      description: Link any related issues (e.g., Fixes #123)
      placeholder: |
        Fixes #
        Related to #

  - type: textarea
    id: changes
    attributes:
      label: Key Changes
      description: Summary of the key changes made
      placeholder: |
        - Changed X to Y
        - Added new feature Z
        - Fixed bug in module A
    validations:
      required: true

  - type: textarea
    id: testing
    attributes:
      label: Testing Done
      description: Describe the testing you've performed
      placeholder: |
        - [x] Unit tests pass
        - [x] Integration tests pass
        - [x] Manual testing completed
    validations:
      required: true

  - type: checkboxes
    id: checklist
    attributes:
      label: Checklist
      options:
        - label: I have read the CONTRIBUTING.md
          required: true
        - label: My code follows the style guidelines of this project
          required: true
        - label: I have performed a self-review of my own code
          required: true
        - label: I have commented my code, particularly in hard-to-understand areas
          required: false
        - label: I have made corresponding changes to the documentation
          required: false
        - label: My changes generate no new warnings
          required: false
        - label: I have added tests that prove my fix is effective or that my feature works
          required: false
        - label: New and existing unit tests passed locally with my changes
          required: true

  - type: textarea
    id: notes
    attributes:
      label: Additional Notes
      description: Any additional context or notes for reviewers
      placeholder: |
        - This PR requires special attention to...
        - Migration steps:
        - Performance impact: ...
