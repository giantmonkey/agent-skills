# `<go-sign-up>`

Since `v1.6.0`

A standalone form that registers a new customer account in your shop. It collects the customer's name, email (with confirmation), a password (with confirmation), and acceptance of the terms, validates the input, submits the registration, and dispatches `go-success` once the account is created.

## Examples

Basic — the default field layout (first name, last name, email, email confirmation, password, password confirmation, accept terms, submit button):

```html
<go-sign-up></go-sign-up>
```

Interactive — edit the markup and re-run to preview changes live:

Custom layout — pass `custom` and provide your own markup. The component still owns submission, validation, and success/error dispatching; you only control the layout:

```html
<go-sign-up custom>
  <go-field key="firstName" required></go-field>
  <go-field key="lastName" required></go-field>
  <go-field key="email" required></go-field>
  <go-field key="confirmEmail" required></go-field>
  <go-field key="newPassword" required></go-field>
  <go-field key="confirmPassword" required></go-field>
  <go-field key="acceptTerms" required></go-field>

  <go-success-feedback></go-success-feedback>
  <go-errors-feedback></go-errors-feedback>
  <go-submit>Register</go-submit>
</go-sign-up>
```

## Attributes

| Attribute | Type    | Default | Description                                                                                                                                 |
| --------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `custom`  | boolean | `false` | Opt out of the default field layout and provide your own children (see the custom-layout example). Submission and validation stay built-in. |

## Events

| Event        | Description                                             | `detail` | bubbles |
| ------------ | ------------------------------------------------------- | -------- | ------- |
| `go-success` | The registration succeeded and the account was created. | none     | yes     |

A failed registration does **not** fire `go-success` — field errors are surfaced through `<go-errors-feedback>` instead.

## Fields

All seven default fields are required. Each field's `apiKey` is the property name used in the submitted body and in `<go-if>` `formData` expressions (`data.formData?.<apiKey>`).

| Field key         | Required | API key                 | Type     |
| ----------------- | -------- | ----------------------- | -------- |
| `firstName`       | yes      | `name`                  | text     |
| `lastName`        | yes      | `surname`               | text     |
| `email`           | yes      | `email`                 | email    |
| `confirmEmail`    | yes      | `email_confirmation`    | email    |
| `newPassword`     | yes      | `password`              | password |
| `confirmPassword` | yes      | `password_confirmation` | password |
| `acceptTerms`     | yes      | `terms`                 | checkbox |

## Styling

The form renders through the shared form subcomponents; style their hooks:

- `go-sign-up` — root element
- `.go-field` / `.go-field.is-invalid` — each field, and its invalid state
- `.go-field-errors` — per-field validation messages
- `.go-form-feedback`, `.go-success-feedback`, `.go-error-feedback-api-errors` — feedback blocks

Per field, pass `label-class` / `input-class` on a `<go-field>` to set the label and control classes directly.

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

## Conditional rendering with `<go-if>`

Inside the form, `<go-if>` evaluates its `when` expression against a `data` object whose `formData` holds the filled field values, keyed by each field's `apiKey`. Gate markup on what the customer has entered — for example, reveal the password confirmation only once a password is set:

```html
<go-sign-up custom>
  <go-field key="newPassword" required></go-field>
  <go-if when="data.formData?.password">
    <go-field key="confirmPassword" required></go-field>
  </go-if>
  <go-submit>Register</go-submit>
</go-sign-up>
```

## Localization

| Key                                      | Description                 |
| ---------------------------------------- | --------------------------- |
| `common.actions.register`                | Submit button label         |
| `user.registration.form.name`            | First name field label      |
| `user.registration.form.surname`         | Last name field label       |
| `user.registration.form.email`           | Email field label           |
| `user.registration.form.confirmEmail`    | Email confirmation label    |
| `user.registration.form.password`        | Password field label        |
| `user.registration.form.confirmPassword` | Password confirmation label |
| `user.registration.form.accept`          | Accept-terms field label    |
