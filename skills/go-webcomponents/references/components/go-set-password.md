# `<go-set-password>`

Since `v4.9.0`

The set-new-password form — the landing step of the password-reset flow. The link in the reset e-mail redirects the visitor back to your shop with one-time credentials in the URL query string; you read those parameters on your page, pass them in as attributes, and the visitor picks a new password (with confirmation) — no current password needed. On success the visitor is signed in automatically.

## Examples

Basic — read the credentials from the reset-link query parameters and pass them in (hide the element when they are absent):

```html
<go-set-password id="set-password" hidden></go-set-password>

<script>
  var params = new URLSearchParams(location.search)
  if (params.get('reset_password') === 'true') {
    var el = document.getElementById('set-password')
    el.setAttribute('access-token', params.get('access-token'))
    el.setAttribute('client', params.get('client'))
    el.setAttribute('uid', params.get('uid'))
    el.removeAttribute('hidden')
  }
</script>
```

Together with the request form — one page handles both steps of the flow (`<go-password-reset>` requests the e-mail; its `redirect-url` points the mail link back to this page):

```html
<go-password-reset redirect-url="https://your-shop.example/password-reset"></go-password-reset>
<go-set-password id="set-password"></go-set-password>
```

## Attributes

| Attribute      | Type   | Default | Description                                                                  |
| -------------- | ------ | ------- | ---------------------------------------------------------------------------- |
| `access-token` | string | —       | One-time token from the reset-link `access-token` query parameter. Required. |
| `client`       | string | —       | Client id from the reset-link `client` query parameter. Required.            |
| `uid`          | string | —       | The customer's e-mail from the reset-link `uid` query parameter. Required.   |

The reset link appends these query parameters to your page's URL: `access-token`, `client`, `uid`, `expiry`, `reset_password=true`, `reset_password_token`, `token`, `client_id`, `config`. Only the three attributes above are needed. If they are missing or expired, submitting shows an authorization error — the visitor can request a fresh e-mail.

## Events

| Event        | Description                            | `detail` | bubbles |
| ------------ | -------------------------------------- | -------- | ------- |
| `go-success` | Fires after the new password was saved | —        | yes     |

```html
<go-set-password id="set-password"></go-set-password>

<script>
  document.getElementById('set-password').addEventListener('go-success', function () {
    window.location.href = '/account'
  })
</script>
```

## Styling

No style hooks beyond the root element — the rendered form uses the shared form classes (`.go-field`, `.go-field.is-invalid`, `.go-form-feedback`).

## Nesting

Standalone — no required parent.

## Subcomponents

None.

## Localization

| Key                                        | Purpose                     |
| ------------------------------------------ | --------------------------- |
| `user.passwordReset.actions.resetPassword` | Submit button label         |
| `user.registration.form.password`          | New-password field label    |
| `user.registration.form.confirmPassword`   | Confirmation field label    |
| `user.fieldErrors.passwordMatch`           | Passwords-don't-match error |
| `user.fieldErrors.passwordTooShort`        | Minimum-length error        |
