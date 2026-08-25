# `<go-profile-password>`

Since `v1.34.0`

Change-password form for the signed-in customer. Renders current-password, new-password, and confirm-password fields, validates them, and shows a success or error message after submitting. Without a signed-in customer, submitting shows a "Not signed in" error.

## Examples

Basic:

```html
<go-profile-password></go-profile-password>
```

On an account page together with the profile details form:

```html
<go-profile-details></go-profile-details> <go-profile-password></go-profile-password>
```

## Attributes

This component takes no attributes.

## Events

This component emits no custom events.

## Styling

The component renders a preconfigured `<go-form>`, so the shared form hooks apply:

- `.go-field` — each field wrapper; `.go-field.is-invalid` while the field has errors
- `[data-testid="currentPassword"]` / `[data-testid="password"]` / `[data-testid="confirmPassword"]` — the individual fields
- `.go-field-errors` — the per-field error list
- `.go-feedback` — the form-level feedback areas; the error feedback carries `is-invalid` and a `data-num-errors` attribute with the current error count
- `.go-success-feedback.is-successful` — present after the password was changed

```css
.go-field.is-invalid input {
  border-color: red;
}
```

## Nesting

Standalone — no required parent.

## Subcomponents

None.

## Conditional rendering with `<go-if>`

Show the form only to signed-in customers:

```html
<go-if when="data.auth.isLoggedIn">
  <go-profile-password></go-profile-password>
</go-if>
```

## Localization

| Key                                      | Purpose                                                    |
| ---------------------------------------- | ---------------------------------------------------------- |
| `user.registration.form.password`        | Label of the current-password and new-password fields      |
| `user.registration.form.confirmPassword` | Label of the confirm-password field                        |
| `Submit`                                 | Label of the submit button                                 |
| `common.fieldErrors.required`            | Error under a required field left empty                    |
| `user.fieldErrors.passwordMatch`         | Error when the confirmation doesn't match the new password |
| `forms.errorSummary`                     | Form-level validation summary (takes `{{count}}`)          |
| `user.passwordSuccess.desc.title`        | Success message after the password was changed             |
| `Not signed in`                          | Error when no customer is signed in                        |
