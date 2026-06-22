# `<go-sign-in>`

Since `v1.1.0`

The sign-in form. Renders email and password fields with a submit button, authenticates the
visitor against the shop, and fires `go-success` once they are signed in. Drop it anywhere on the
page — it needs no parent.

## Examples

Basic — the default email/password form:

```html
<go-sign-in></go-sign-in>
```

React to a successful sign-in (redirect, reveal account UI, …):

```html
<go-sign-in></go-sign-in>

<script>
  document.querySelector('go-sign-in').addEventListener('go-success', () => {
    window.location.href = '/account'
  })
</script>
```

Custom layout — supply your own markup instead of the default fields:

```html
<go-sign-in custom>
  <go-field key="email" required></go-field>
  <go-field key="password" required></go-field>
  <go-errors-feedback></go-errors-feedback>
  <go-submit>Sign in</go-submit>
</go-sign-in>
```

## Attributes

| Attribute | Type    | Default | Description                                                                                                                      |
| --------- | ------- | ------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `custom`  | boolean | `false` | When present, the default fields, feedback, and submit button are not rendered — you supply your own markup (see Custom layout). |

## Events

| Event        | Description                                             | `detail` | bubbles |
| ------------ | ------------------------------------------------------- | -------- | ------- |
| `go-success` | Fires once the visitor has been successfully signed in. | —        | yes     |

A failed sign-in emits no event; the API errors are shown inline through the form's feedback area.

## Styling

The form renders through the shared form subcomponents; style their hooks:

- `go-sign-in` — root element
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

None of its own. In `custom` mode you compose the `<go-form>` subcomponents yourself —
`<go-field>`, `<go-submit>`, `<go-errors-feedback>`, `<go-success-feedback>`. See the `<go-form>`
doc.

## Conditional rendering with `<go-if>`

`<go-sign-in>` is a form, so a `<go-if>` placed inside it (in `custom` mode) can read the live
field values from `data.formData`, keyed by each field's `apiKey`. For the sign-in fields the
`apiKey` matches the field key, so the values are `data.formData?.email` and
`data.formData?.password`:

```html
<go-sign-in custom>
  <go-field key="email" required></go-field>
  <go-field key="password" required></go-field>
  <go-if when="data.formData?.email">
    <p>Ready to sign in.</p>
  </go-if>
  <go-submit>Sign in</go-submit>
</go-sign-in>
```

## Localization

| Key                               | Description                                    |
| --------------------------------- | ---------------------------------------------- |
| `common.actions.login`            | Label for submit button                        |
| `user.registration.form.email`    | Email field label                              |
| `user.registration.form.password` | Password field label                           |
| `common.fieldErrors.required`     | Validation message for an empty required field |
| `user.fieldErrors.emailValid`     | Validation message for an invalid email        |
