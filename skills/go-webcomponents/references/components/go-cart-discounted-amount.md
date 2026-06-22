# `<go-cart>`

Since `v1.0.0`

The `go-cart` is a **composable** shopping basket. It is a shell that coordinates
a set of subcomponents, each rendering one slice of the cart (items, coupons,
totals). Place the subcomponents you need as direct children of `<go-cart>`.

## Examples

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

Compose only the parts you want, in any order. The cart subcomponents read their
state from the parent `<go-cart>`, so wrap order is up to you.

```html
<go-cart>
  <go-cart-items></go-cart-items>
  <go-cart-coupons></go-cart-coupons>
  <go-cart-subtotal-amount></go-cart-subtotal-amount>
  <go-cart-discounted-amount></go-cart-discounted-amount>
  <go-cart-total-amount></go-cart-total-amount>
</go-cart>
```

`<go-cart-counter>` is standalone — drop it anywhere (e.g. a header badge) to show
how many items are in the cart:

```html
<span class="cart-badge"><go-cart-counter></go-cart-counter></span>
```

## Attributes

| Attribute | Type    | Default | Description                                                                                                | Since    |
| --------- | ------- | ------- | ---------------------------------------------------------------------------------------------------------- | -------- |
| `preview` | boolean | `false` | Read-only cart view — hides each item's quantity selector and remove button, and the coupon remove buttons | `v1.3.0` |

## Styling

Each subcomponent renders stable class hooks:

- `.go-cart-item` — one per cart line; `.go-cart-item-price-original` (struck-through pre-discount price) and `.go-cart-item-price-discounted` appear when a line is discounted
- `.go-cart-remove` — the ✕ button on items and coupons
- `.go-cart-coupon` — one per coupon row
- `.go-cart-coupon.go-cart-coupon-inactive` — a coupon the backend did not apply (`Since v1.53.0`); style it greyed-out / struck-through
- `.go-cart-subtotal-amount`, `.go-cart-discounted-amount`, `.go-cart-total-amount` — the three amount spans; `.go-cart-discounted-amount-sign` wraps the leading `−`

```css
.go-cart-coupon.go-cart-coupon-inactive {
  opacity: 0.5;
  text-decoration: line-through;
}
```

## Nesting

The cart's display subcomponents — `<go-cart-items>`, `<go-cart-coupons>`,
`<go-cart-subtotal-amount>`, `<go-cart-discounted-amount>`, and
`<go-cart-total-amount>` — must be placed inside `<go-cart>`; they read the
re-priced cart from it and render nothing on their own. `<go-cart-counter>` and
`<go-cart-empty>` read the cart directly and can be placed anywhere on the page.

## Subcomponents

| Tag                           | Renders                                                                   |
| ----------------------------- | ------------------------------------------------------------------------- |
| `<go-cart-items>`             | Item table (header + line per item, with quantity selector + remove)      |
| `<go-cart-coupons>`           | One row per coupon. Inactive coupons get `go-cart-coupon-inactive`        |
| `<go-cart-subtotal-amount>`   | Pre-discount total (sum of original line prices)                          |
| `<go-cart-discounted-amount>` | Saved amount, prefixed with a `−` sign                                    |
| `<go-cart-total-amount>`      | Final amount to pay after coupon and voucher projection                   |
| `<go-cart-counter>`           | A live count of the number of items in the cart — text only, no markup    |
| `<go-cart-empty>`             | Shows its own children only while the cart has no items (`Since v1.11.0`) |

Each subcomponent is independently mountable and renders nothing when its data is
absent (e.g. `go-cart-coupons` is empty until a coupon is added).

## Coupons & action token redemption

Coupons (a.k.a. **action tokens**) are redeemed by the user through
`<go-coupon-redemption>`, and removed with the ✕ button each row renders. While at
least one coupon is active, `<go-cart>` re-prices the cart and shows the discounted
figures.

`<go-cart-coupons>` renders one row per coupon currently in the cart:

- Coupons the backend **applies** render normally.
- Coupons the backend **does not apply** render with the `go-cart-coupon-inactive`
  class — useful for greyed-out / strikethrough styling.

The `<go-cart-subtotal-amount>`, `<go-cart-discounted-amount>`, and
`<go-cart-total-amount>` reflect the projected pricing. They render nothing when
their respective amount is zero, so an empty discount row stays empty rather than
showing `0,00 €`.

### Value vouchers (Wertgutschein)

A **Wertgutschein** redeemed through `<go-coupon-redemption>` is gift-card credit
rather than an order discount: its balance is subtracted from the payable total.
Because it is applied client-side (the backend never echoes it), it always renders
active in `<go-cart-coupons>` — never with the `go-cart-coupon-inactive` class. Its
credit is folded into `<go-cart-discounted-amount>` and reflected in
`<go-cart-total-amount>`.

## Conditional rendering with `<go-if>`

`<go-if>` placed inside `<go-cart>` reads the live cart projection through
`data.cartView`:

| Handle                                | Type      | Description                                       |
| ------------------------------------- | --------- | ------------------------------------------------- |
| `data.cartView.isDiscounted`          | `boolean` | `true` when a coupon or voucher reduced the total |
| `data.cartView.subtotalPriceCents`    | `number`  | Pre-discount total                                |
| `data.cartView.totalPriceCents`       | `number`  | Final amount to pay                               |
| `data.cartView.discountedAmountCents` | `number`  | Subtotal − total, clamped to ≥ 0                  |

To gate on whether the cart is empty, use the `data.cart.items.length` handle (this
is what `<go-cart-empty>` itself uses internally).

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

Place a `<go-submit>` inside `<go-cart>` to act as the checkout button. Clicking it
first applies any coupon code still sitting unsubmitted in a
`<go-coupon-redemption>` field. If a coupon is invalid, that component shows the
error inline and `go-submit` **does not fire** — the customer stays on the cart.
Otherwise the cart dispatches a `go-submit` event on the `<go-cart>` host. The cart
does **not** navigate or proceed on its own — you wire the next step (e.g. show the
checkout form, redirect to a payment page) in the listener.

`<go-submit>` placed inside `<go-coupon-redemption>` is ignored (that one is the
coupon's own apply button).

```html
<go-cart>
  ...
  <go-coupon-redemption></go-coupon-redemption>
  <go-submit>To Payment</go-submit>
</go-cart>

<script>
  document.querySelector('go-cart').addEventListener('go-submit', () => {
    // go-submit only fires once any pending coupon has applied cleanly, so it is
    // safe to proceed straight to checkout here.
    showCheckoutForm()
  })
</script>
```

## Events

| Event                  | Description                                                                                                                                          | `detail`                    | bubbles                       | Since    |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- | ----------------------------- | -------- |
| `go-cart-item-added`   | An item was added to the cart                                                                                                                        | the new item count (number) | fires on `document`           |          |
| `go-cart-item-removed` | An item was removed from the cart                                                                                                                    | the new item count (number) | fires on `document`           |          |
| `go-submit`            | The cart is ready to check out — fires after a `<go-submit>` click once any pending coupon applies cleanly; does **not** fire if a coupon is invalid | `{ ok: true }`              | yes (on the `<go-cart>` host) | `v3.0.0` |

The item-count events fire on `document`, so listen there:

```js
document.addEventListener('go-cart-item-added', event => {
  // event.detail is the new number of items in the cart
  console.log(event.detail)

})
```

The `go-submit` event is covered in _Submitting the cart_ above.

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
