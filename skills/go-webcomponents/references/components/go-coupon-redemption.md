# `<go-coupon-redemption>`

Since `v1.35.0`

The `go-coupon-redemption` component lets users redeem a coupon by entering its barcode/token. What happens depends on the coupon: an **action token** applies an order discount, a **service voucher** (Leistungsgutschein) adds its associated ticket to the cart at zero cost, and a **Wertgutschein** (value voucher) adds gift-card credit that is deducted from the payable total.

## Examples

Basic:

```html
<go-coupon-redemption></go-coupon-redemption>
```

Inside a cart, so its pending token is applied before checkout:

```html
<go-cart>
  <go-coupon-redemption></go-coupon-redemption>
  <go-submit>To Payment</go-submit>
</go-cart>
```

The coupon code is case-insensitive — whatever the user types is normalized to uppercase before it is sent, so `wg-1234` and `WG-1234` redeem the same coupon.

## Attributes

This component takes no attributes.

## Events

| Event        | Description                                                                                                                                                          | `detail` | bubbles |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- |
| `go-success` | Fires after a coupon is redeemed successfully — an action token's discount is applied, a service voucher's ticket is added, or a Wertgutschein's credit is recorded. | none     | yes     |

## Styling

The component renders a single `<go-form>`; it adds no wrapper class of its own. Style through the form's hooks:

- `go-coupon-redemption` — the custom element itself
- `.go-field` — the token input row
- `.go-field.is-invalid` — present while the token field has a validation error; the messages render in `.go-field-errors`
- `.go-feedback` — the error/success message area
- `go-submit button` — the redeem button

```css
go-coupon-redemption .go-field {
  margin-block: 1rem;
}
```

## Nesting

Standalone — no required parent. Placed directly inside `<go-cart>`, a pending (typed-but-not-yet-submitted) token is automatically applied when the cart's `<go-submit>` is clicked, so users don't have to press the coupon's own button first. If that pending token is invalid, the error is shown inline and the cart's submit does not fire — checkout never proceeds with an unredeemed coupon.

## Subcomponents

None.

## Conditional rendering with `<go-if>`

Offer coupon redemption only once the cart has items:

```html
<go-if when="data.cart.items.length > 0">
  <go-coupon-redemption></go-coupon-redemption>
</go-if>
```

Inside `<go-cart>`, show a note once an action token's discount or a Wertgutschein's credit has been applied:

```html
<go-cart>
  <go-coupon-redemption></go-coupon-redemption>
  <go-if when="data.cartView.isDiscounted">
    <p>Your discount has been applied.</p>
  </go-if>
</go-cart>
```

## Localization

Translation keys used by the component:

| Key                                | Purpose                                 |
| ---------------------------------- | --------------------------------------- |
| `cart.coupon.form.submit`          | Submit button text                      |
| `cart.coupon.form.code`            | Label text                              |
| `cart.coupon.form.errors.notValid` | Error message when coupon is not valid  |
| `cart.coupon.form.errors.error`    | Error message when something else fails |
