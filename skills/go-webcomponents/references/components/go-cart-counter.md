# Cart Component

The `go-cart` is a **composable** shopping basket. It is now a shell that
coordinates a set of subcomponents, each rendering one slice of the cart
(items, coupons, totals). Place the subcomponents you need as direct
children of `<go-cart>`.

## Example

The minimal HTML markup that produces the layout above:

```html
<go-cart>
  <div class="cart-grid">
    <div class="cart-main">
      <section>
        <header>Your items</header>
        <go-cart-items></go-cart-items>
      </section>

      <section>
        <header>Coupons</header>
        <go-cart-coupons></go-cart-coupons>
        <go-coupon-redemption></go-coupon-redemption>
      </section>
    </div>

    <aside>
      <header>Summary</header>
      <dl>
        <go-if when="data.cartView.isDiscounted">
          <div>
            <dt>Subtotal</dt>
            <dd><go-cart-subtotal-amount></go-cart-subtotal-amount></dd>
          </div>
        </go-if>
        <div>
          <dt>Discount</dt>
          <dd><go-cart-discounted-amount></go-cart-discounted-amount></dd>
        </div>
        <div>
          <dt>Total</dt>
          <dd><go-cart-total-amount></go-cart-total-amount></dd>
        </div>
      </dl>
      <go-submit>To Payment</go-submit>
    </aside>
  </div>
</go-cart>

<go-cart-empty>
  <h3>Cart is empty</h3>
</go-cart-empty>
```

### Custom layout

Compose only the parts you want, in any order. Subcomponents read their
state from the parent `<go-cart>` via context, so wrap order is up to you.

```html
<go-cart>
  <go-cart-items></go-cart-items>
  <go-cart-coupons></go-cart-coupons>
  <go-cart-subtotal-amount></go-cart-subtotal-amount>
  <go-cart-discounted-amount></go-cart-discounted-amount>
  <go-cart-total-amount></go-cart-total-amount>
</go-cart>
```

## Subcomponents

| Tag                         | Renders                                                              |
| --------------------------- | -------------------------------------------------------------------- |
| `go-cart-items`             | Item table (header + line per item, with quantity selector + remove) |
| `go-cart-coupons`           | One row per coupon. Inactive coupons get `go-cart-coupon-inactive`   |
| `go-cart-subtotal-amount`   | Pre-discount total (sum of original line prices)                     |
| `go-cart-discounted-amount` | Saved amount, prefixed with a `−` sign                               |
| `go-cart-total-amount`      | Final total after coupon projection                                  |

Each subcomponent is independently mountable and renders nothing when its
data is absent (e.g. `go-cart-coupons` is empty until a coupon is added).

## Properties

| Property  | Attribute | Description                                                     | Type      | Default |
| --------- | --------- | --------------------------------------------------------------- | :-------- | :------ |
| `preview` | `preview` | Read-only cart preview (no quantity selector, no remove button) | `boolean` | `false` |

## Empty Cart Component

Use the `go-cart-empty` component to show a message when the cart is empty.

## Coupons & Action Token Redemption

Coupons (a.k.a. **action tokens**) are added via `cart.addCoupon(code)` and
removed via `cart.removeCoupon(code)`. While at least one coupon is active,
`<go-cart>` fetches a projected view from `/api/v4/cart` that reflects the
discounted pricing.

`<go-cart-coupons>` renders one row per coupon currently in the cart:

- Coupons the backend **honors** (echoed on a projected line) render normally.
- Coupons the backend **ignores** (no echo) render with the
  `go-cart-coupon-inactive` class — useful for greyed-out / strikethrough
  styling.

The `<go-cart-subtotal-amount>`, `<go-cart-discounted-amount>`, and
`<go-cart-total-amount>` reflect the projected pricing. They render nothing
when their respective amount is zero, so an empty discount row stays empty
rather than showing `0,00 €`.

## Conditional rendering with `<go-if>`

`<go-if>` placed inside `<go-cart>` can read the cart projection via
`data.cartView`, which exposes the `CartDetails` instance:

| Field                   | Type      | Description                            |
| ----------------------- | --------- | -------------------------------------- |
| `isDiscounted`          | `boolean` | `true` when a coupon reduced the total |
| `subtotalPriceCents`    | `number`  | Pre-discount total                     |
| `totalPriceCents`       | `number`  | Final total                            |
| `discountedAmountCents` | `number`  | `subtotal − total`, clamped to ≥ 0     |

Example — show the subtotal row only when a coupon actually discounts the cart:

```html
<go-cart>
  <go-cart-items></go-cart-items>
  <go-cart-coupons></go-cart-coupons>
  <go-if when="data.cartView.isDiscounted">
    <go-cart-subtotal-amount></go-cart-subtotal-amount>
  </go-if>
  <go-cart-discounted-amount></go-cart-discounted-amount>
  <go-cart-total-amount></go-cart-total-amount>
</go-cart>
```

## Submitting the cart

Place a `<go-submit>` inside `<go-cart>` to act as the checkout button.
Clicking it flushes any pending `<go-coupon-redemption>` (applying an
unsubmitted token before checkout reads `cart.coupons`) and then dispatches
a `go-submit` event on the `<go-cart>` host. The cart does **not**
navigate or proceed on its own — the integrator wires the next step
(e.g. show the checkout form, redirect to a payment page) in the listener.

`<go-submit>` placed inside `<go-coupon-redemption>` is ignored (that one
is the coupon's own apply button).

```html
<go-cart>
  ...
  <go-coupon-redemption></go-coupon-redemption>
  <go-submit>To Payment</go-submit>
</go-cart>

<script>
  document.querySelector('go-cart').addEventListener('go-submit', event => {
    // event.detail.ok === false → at least one coupon-redemption rejected its
    // token. The user-facing error is already shown by that component; you
    // can simply abort the next step.
    if (!event.detail.ok) return

    // Coupons are flushed into cart.coupons by this point; proceed.
    showCheckoutForm()
  })
</script>
```

## Events

These events are fired on the document node:

- `go-cart-item-added` when an item is added.
- `go-cart-item-removed` when an item is removed.

```ts
document.addEventListener('go-cart-item-added', (event: CustomEvent) => {
  // event.detail contains the new cart length
  alert(event.detail)
})
```

The cart also dispatches a `go-submit` event on the `<go-cart>` host
when its `<go-submit>` is clicked — see _Submitting the cart_ above.

## Localization

The `go-cart` component uses the following translation keys for its interface and validation:

### Cart Table

| Key                           | Default Description             |
| ----------------------------- | ------------------------------- |
| `cart.content.table.desc`     | Description/Title column header |
| `cart.content.table.price`    | Price column header             |
| `cart.content.table.quantity` | Quantity column header          |
| `cart.content.table.total`    | Total column header             |
| `cart.content.table.edit`     | Quantity-selector aria-label    |
| `cart.item.remove`            | Item remove-button aria-label   |
| `cart.coupons.remove`         | Coupon remove-button aria-label |
