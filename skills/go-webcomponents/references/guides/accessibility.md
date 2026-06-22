# Accessibility

These are the WCAG rules that our components are checked against to ensure compliance with WCAG 2.1 AA and EN 301 549 standards.

It is important to note that while we deliver the correct markup of the components, we are only responsible for rules related to
the markup. Many accessibility violations, such as color contrast issues, are caused by incorrect styling, which is outside our control and responsibility.

We have an automatic testing of components using [axe-core](https://www.deque.com/axe/) which continuously tests for accessibility issues.
In addition to that, we test the components manually for violations that are not possible to test automatically.

## Rules for all components
These rules apply to all components.

| # | Number | Name                   | Description                                                                                                                                                           | Link                                                                                  |
|---|--------|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| 1 | 1.1.1  | Non-text Content       | All non-text content has a text alternative that serves the equivalent purpose.                                                                                       | [WCAG 1.1.1](https://www.w3.org/WAI/WCAG22/Understanding/non-text-content.html)       |
| 1 | 1.3.1  | Info and Relationships | Information, structure, and relationships conveyed through presentation can be programmatically determined or are available in text.                                  | [WCAG 1.3.1](https://www.w3.org/WAI/WCAG22/Understanding/info-and-relationships.html) |
| 2 | 2.1.1  | Keyboard               | All functionality is operable through a keyboard interface without requiring specific timings.                                                                        | [WCAG 2.1.1](https://www.w3.org/WAI/WCAG22/Understanding/keyboard.html)               |
| 3 | 2.5.3  | Label in Name          | For UI components with visible text labels, the accessible name contains the visible text.                                                                            | [WCAG 2.5.3](https://www.w3.org/WAI/WCAG22/Understanding/label-in-name.html)          |
| 4 | 4.1.2  | Name, Role, Value      | All UI components have accessible name, role, states, properties, and values that can be programmatically determined.                                                 | [WCAG 4.1.2](https://www.w3.org/WAI/WCAG22/Understanding/name-role-value.html)        |
| 5 | 4.1.3  | Status Messages        | Status messages can be programmatically determined through role or properties so they can be presented to the user by assistive technologies without receiving focus. | [WCAG 4.1.3](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html)        |

## Rules for form components
These apply to every component that has a form.

| # | Number | Name                                      | Description                                                                                                                                         | Link                                                                                                 |
|---|--------|-------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| 2 | 1.3.5  | Identify Input Purpose                    | The purpose of each input field collecting user information can be programmatically determined.                                                     | [WCAG 1.3.5](https://www.w3.org/WAI/WCAG22/Understanding/identify-input-purpose.html)                |
| 3 | 3.2.2  | On Input                                  | Changing the setting of any UI component does not automatically cause a change of context unless the user has been advised beforehand.              | [WCAG 3.2.2](https://www.w3.org/WAI/WCAG22/Understanding/on-input.html)                              |
| 4 | 3.3.1  | Error Identification                      | If an input error is automatically detected, the item in error is identified and the error is described to the user in text.                        | [WCAG 3.3.1](https://www.w3.org/WAI/WCAG22/Understanding/error-identification.html)                  |
| 5 | 3.3.2  | Labels or Instructions                    | Labels or instructions are provided when content requires user input.                                                                               | [WCAG 3.3.2](https://www.w3.org/WAI/WCAG22/Understanding/labels-or-instructions.html)                |
| 6 | 3.3.3  | Error Suggestion                          | If an input error is automatically detected and suggestions for correction are known, the suggestions are provided to the user.                     | [WCAG 3.3.3](https://www.w3.org/WAI/WCAG22/Understanding/error-suggestion.html)                      |
| 7 | 3.3.4  | Error Prevention (Legal, Financial, Data) | For pages that cause legal commitments or financial transactions, submissions are reversible, checked, or confirmed.                                | [WCAG 3.3.4](https://www.w3.org/WAI/WCAG22/Understanding/error-prevention-legal-financial-data.html) |
| 8 | 3.3.7  | Redundant Entry                           | Information previously entered by or provided to the user that is required to be entered again is either auto-populated or available for selection. | [WCAG 3.3.7](https://www.w3.org/WAI/WCAG22/Understanding/redundant-entry.html)                       |
| 9 | 3.3.8  | Accessible Authentication (Minimum)       | A cognitive function test is not required for any step in an authentication process unless an alternative or assistance mechanism is provided.      | [WCAG 3.3.8](https://www.w3.org/WAI/WCAG22/Understanding/accessible-authentication-minimum.html)     |
