# Checkout Form

The `go-checkout-form` presents the checkout form which leads to payment.

## Example

```html
<go-checkout-form></go-checkout-form>
```

## Properties

This component doesn't have any properties.

## Standard inputs

For a Guest Checkout this inputs are available as standard:

- `firstName`
- `lastName`
- `email`
- `confirmEmail`
- `currentPassword`
- `acceptTerms`

## Customization

To define additional fields:

```ts
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

and then to have a custom form:

```html
<go-checkout-form custom>
  <go-field key="email" required />
  <go-field key="newsletter" required />
  <go-submit>Submit</go-submit>
</go-checkout-form>
```

More details in the Forms documentation.

## Callbacks

`beforeSubmit` callback will be called before submitting the form

```ts
go.defineConfig({
  forms: {
    checkoutGuest: {
      beforeSubmit: (formData: Record<string, unknown>) => {
        // ...
      },
    },
  },
})
```

## Localization

| Key                            | Description             |
| ------------------------------ | ----------------------- |
| `cart.detail.actions.checkout` | Label for submit button |
