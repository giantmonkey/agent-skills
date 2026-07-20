# `<go-checkout-form>`

Since `v1.1.0`

Checkout leads the customer to payment. There are two independent components, one per
auth state, plus a legacy alias:

- **`<go-checkout-guest>`** _(Since `v4.5.0`)_ — for signed-out visitors. Collects
  the identity fields, creates a guest account on submit, then checks out.
- **`<go-checkout-user>`** _(Since `v4.5.0`)_ — for signed-in customers. Skips
  identity collection and goes straight to checkout.
- **`<go-checkout-form>`** — the legacy tag, kept for backward compatibility. It behaves
  exactly like `<go-checkout-guest>`.

Each component is self-contained — it does **not** switch on auth state itself. Pick
which one to render with `<go-if>` (see
[Conditional rendering](#conditional-rendering-with-go-if)).

## Examples

Guest checkout (default):

```html
<go-checkout-form></go-checkout-form>
```

With no children it renders the guest fields; `<go-checkout-guest>` is identical.

Signed-in checkout:

```html
<go-checkout-user></go-checkout-user>
```

While the customer holds a valid session, `<go-checkout-user>` renders only the fields
needed to finalize checkout.

Custom fields:

```html
<go-checkout-guest custom>
  <go-field key="email" required></go-field>
  <go-field key="newsletter" required></go-field>
  <go-submit>Submit</go-submit>
</go-checkout-guest>

<go-checkout-user custom>
  <go-field key="acceptTerms" required></go-field>
  <go-field key="paymentMode" required></go-field>
  <go-submit>Pay now</go-submit>
</go-checkout-user>
```

Add the `custom` attribute and supply your own fields; the legacy
`<go-checkout-form custom>` works the same way. Define any extra fields first:

```js
go.defineConfig({
  fields: {
    newsletter: {
      key: 'newsletter',
      type: 'checkbox',
      label: 'Shop newsletter',
      required: false,
      value: false,
    },
  },
})
```

See the Forms documentation for the field system.

## Attributes

| Attribute | Type    | Default | Description                                                                               |
| --------- | ------- | ------- | ----------------------------------------------------------------------------------------- |
| `custom`  | boolean | `false` | Opt out of the built-in fields and supply your own markup (`<go-field>` + `<go-submit>`). |

The built-in (non-`custom`) fields are:

- **`<go-checkout-guest>` / `<go-checkout-form>`:** `firstName`, `lastName`, `email`,
  `confirmEmail`, `acceptTerms`, `paymentMode`.
- **`<go-checkout-user>`:** `acceptTerms`, `paymentMode`.

## Events

This component emits no custom events. Once the order is created, it routes the
customer by the checkout outcome, using the `navigateTo` handler you configure via
`go.defineConfig(...)`:

- **Payment via redirect** — `navigateTo` receives the payment provider's URL.
- **Payment via POST** (some embedded providers) — the component submits a hidden
  POST form to the provider directly; `navigateTo` is not called.
- **Completed without payment** (e.g. a zero-total order) — `navigateTo` receives
  the shop's checkout-success page URL.
- **Failed, or no payment target returned** — `navigateTo` receives the shop's
  checkout-failure page URL.

If the checkout request itself is rejected, no redirect happens — the errors render
on the form.

## Styling

No style hooks beyond the root element (`go-checkout-guest`, `go-checkout-user`,
`go-checkout-form`). Fields render through `<go-form>` — style them with the Forms hooks
(`.go-field`, `.go-submit`, …). See the Forms documentation.

## Nesting

Standalone — no required parent. Initialize the shop with `go.init(...)` first.

## Subcomponents

None. In `custom` mode you compose `<go-field>` and `<go-submit>` yourself.

## Conditional rendering with `<go-if>`

The components don't switch on auth themselves — gate them with `<go-if>`, which exposes
the current sign-in state as `data.auth.isLoggedIn` _(Since `v4.5.0`)_ (also
`data.auth.isAuthenticated` and `data.auth.isGuest`) and reactively shows / hides its
content as the state changes:

```html
<go-if when="!data.auth.isLoggedIn">
  <go-checkout-guest></go-checkout-guest>
</go-if>

<go-if when="data.auth.isLoggedIn">
  <go-checkout-user></go-checkout-user>
</go-if>
```

`data.auth.isLoggedIn` is true once the customer signs in with an account (e.g. via
`<go-sign-in>`); `data.auth.isGuest` is true while only a guest token is held, and
`data.auth.isAuthenticated` is true for either. `<go-checkout-guest>` always creates a
fresh guest account on submit.

## Callbacks

`beforeSubmit` runs after a successful checkout request, right before the payment
redirect. Configure it per form id so the guest and signed-in flows can differ:

```js
go.defineConfig({
  forms: {
    checkoutGuest: {
      beforeSubmit: formData => {
        // runs after guest signup + checkout, before the payment redirect
      },
    },
    checkoutUser: {
      beforeSubmit: formData => {
        // runs for signed-in customers, before the payment redirect
      },
    },
  },
})
```

## Localization

| Key                            | Description                 |
| ------------------------------ | --------------------------- |
| `cart.detail.actions.checkout` | Label for the submit button |
