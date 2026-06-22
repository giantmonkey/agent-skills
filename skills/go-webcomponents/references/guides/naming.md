# Naming Guidelines

## Conventions
- **Prefix**
  - All names are prefixed with `go`, shorthanding `gomus`
- **Meaningful Names**
  - Avoid overly specific or overly abstract names
  - Should clearly indicate the component's purpose

- **Keep It Short**
  - Maximum of 2-3 words after the `go-` prefix

- **Pronounceable**
  - Names should be easy to pronounce in conversation

- **Semantic Naming**
  - Semantic naming means naming things based on their role or meaning, not their style or technical specs.
  - Example: Instead of `.blue-text-right`, you'd write something like `.go-error-message`

## Components

- Structure: `go-{name}`
- Examples: `go-card`, `go-museum-selection`

## Component Props
We use standard HTML kebab-case prop names

```html
<go-calendar current-date="..." />
```

## HTML Classes

- Naming Structure: `.{prefix}-{name}-{selector}`,`.is-{status}` and `.has-{something}`

- examples: `.go-calendar-header`, `.go-card-submit`, `.is-loading`, `.has-events`

## HTML Events

- Naming Structure: `prefix-subject-verb`

- examples: `go-date-select`, `go-timeslot-select`
