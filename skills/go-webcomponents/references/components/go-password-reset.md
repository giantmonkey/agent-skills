# `<go-password-reset>`

Since `v1.16.0`

The request step of the password-reset flow: a form where the visitor enters their e-mail address to receive a reset link. The link in that e-mail redirects back to your shop, where `<go-set-password>` lets the visitor choose a new password.

The full flow:

1. The visitor submits their e-mail here — the reset e-mail is sent.
2. The link in the e-mail leads back to the page given by `redirect-url` (or the shop's configured password-reset page), with one-time credentials in the URL query string.
3. On that page, `<go-set-password>` uses the credentials to save the new password.

## Examples

Basic:

```html
<go-password-reset></go-password-reset>
```

With the reset e-mail linking back to your own page (recommended — the page should host `<go-set-password>`):

```html
<go-password-reset redirect-url="https://your-shop.example/password-reset"></go-password-reset>
```

## Attributes

| Attribute      | Type   | Default | Description                                                                                                          | Since    |
| -------------- | ------ | ------- | -------------------------------------------------------------------------------------------------------------------- | -------- |
| `redirect-url` | string | —       | Where the reset-mail link sends the visitor back to. Must be on your shop's domain; otherwise the shop root is used. | `v4.9.0` |

Without `redirect-url` the shop's configured password-reset page is used — if none is configured, the mail link lands on the shop root, where nothing handles the reset. Prefer setting `redirect-url`.

## Events

| Event        | Description                           | `detail` | bubbles |
| ------------ | ------------------------------------- | -------- | ------- |
| `go-success` | Fires after the reset e-mail was sent | —        | yes     |

## Styling

The form renders through the shared form subcomponents; style their hooks:

- `go-password-reset` — root element
- `.go-field` / `.go-field.is-invalid` — each field and its invalid state
- `.go-form-feedback` — feedback area
- `.go-success-feedback` — success message
- `.go-error-feedback-api-errors` — API error messages

```css
.go-field.is-invalid {
  border-color: #c00;
}
```

## Nesting

Standalone — no required parent.

## Subcomponents

None.

## Localization

| Key                                               | Purpose                    |
| ------------------------------------------------- | -------------------------- |
| `user.passwordReset.actions.requestPasswordReset` | Submit button label        |
| `user.registration.form.email`                    | E-mail field label         |
| `common.fieldErrors.required`                     | Empty required-field error |
| `user.fieldErrors.emailValid`                     | Invalid-e-mail error       |
