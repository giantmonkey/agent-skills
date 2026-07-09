# `<go-membership-activation>`

Since `v4.2.0`

A standalone, single-field form that lets a customer activate a membership for the online shop. The customer enters the email address used for their membership personalization; the component validates it, posts to the gomus membership-activation endpoint, and dispatches `go-success` once the request succeeds.

## Examples

Basic — the default layout (email field + submit button):

```html
<go-membership-activation></go-membership-activation>
```

Custom layout — pass `custom` and provide your own markup. The component still owns submission, validation, and success/error dispatching; you only control the layout:

```html
<go-membership-activation custom>
  <go-field key="email" required></go-field>

  <go-success-feedback></go-success-feedback>
  <go-errors-feedback></go-errors-feedback>
  <go-submit>Activate membership</go-submit>
</go-membership-activation>
```

## Attributes

| Attribute | Type    | Default | Description                                                                                                                                 |
| --------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `custom`  | boolean | `false` | Opt out of the default field layout and provide your own children (see the custom-layout example). Submission and validation stay built-in. |

## Events

| Event        | Description                                                            | `detail` | bubbles |
| ------------ | ---------------------------------------------------------------------- | -------- | ------- |
| `go-success` | The activation request returned a 2xx response (a `204` with no body). | none     | yes     |

The endpoint answers `204 No Content` on success and `404` (empty body) when no membership matches the email. A non-2xx response does **not** fire `go-success` — a generic error message is surfaced through `<go-errors-feedback>` instead.

## Fields

Each field's `apiKey` is the property name used in the posted body and in `<go-if>` `formData` expressions (`data.formData?.<apiKey>`).

| Field key | Required | API key | Type  |
| --------- | -------- | ------- | ----- |
| `email`   | yes      | `email` | email |

## Styling

The form renders through the shared form subcomponents; style their hooks:

- `go-membership-activation` — root element
- `.go-field` / `.go-field.is-invalid` — the field, and its invalid state
- `.go-field-errors` — per-field validation messages
- `.go-form-feedback`, `.go-success-feedback`, `.go-error-feedback-api-errors` — feedback blocks

```css
.go-field.is-invalid {
  border-color: #c00;
}
```

## Nesting

Standalone — no required parent.

## Subcomponents

In custom mode you compose the form building blocks:

- `<go-field>`
- `<go-submit>`
- `<go-success-feedback>`
- `<go-errors-feedback>`

## Localization

| Key                                               | Description                                        |
| ------------------------------------------------- | -------------------------------------------------- |
| `membership.activation.actions.submit`            | Submit button label                                |
| `membership.activation.form.errors.requestFailed` | Error message when no membership matches the email |
| `user.registration.form.email`                    | Email field label                                  |
