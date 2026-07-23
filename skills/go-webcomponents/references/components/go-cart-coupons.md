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

| Attribute | Type    | Default | Description                                                                                               | Since    |
| --------- | ------- | ------- | --------------------------------------------------------------------------------------------------------- | -------- |
| `preview` | boolean | `false` | Read-only cart view — hides each item's quantity control and remove button, and the coupon remove buttons | `v1.3.0` |

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

The `go-submit` event is covered in _Submitting the cart_ below.

## Styling

Each subcomponent renders stable class hooks:

- `.go-cart-item` — one per cart line; `.go-cart-item-price-original` (struck-through pre-discount price) and `.go-cart-item-price-discounted` appear when a line is discounted
- `.go-cart-item-participants` — the participant-count label on a tour line; `.go-cart-item-custom` — one per `key: value` custom-field line (`Since UNRELEASED`)
- `.go-quantity-stepper` — each item's `− qty +` quantity stepper (the default control): `.go-quantity-stepper-button` (both buttons; `.go-quantity-stepper-decrement` / `.go-quantity-stepper-increment` target each) and `.go-quantity-stepper-value` (the editable spinbutton input). `−` can take a line down to `0` without removing it — only the ✕ removes a line. With `go.config({ quantityStepper: false })` the item renders a `.go-quantity-select` `<select>` instead (`Since UNRELEASED`)
- `.go-cart-remove` — the ✕ button on items and coupons
- `.go-cart-coupon` — one per coupon row
- `.go-cart-coupon.go-cart-coupon-inactive` — a coupon the backend did not apply (`Since v1.53.0`); style it greyed-out / struck-through
- `.go-cart-subtotal-amount`, `.go-cart-discounted-amount`, `.go-cart-total-amount` — the three amount spans; `.go-cart-discounted-amount-sign` wraps the leading `−`

Bundle-ticket (Mantelticket) lines render an indented list of sub-ticket rows beneath the line (`Since UNRELEASED`):

- `.go-sub-tickets` — the `<ul>` wrapping a bundle line's sub-ticket rows
- `.go-sub-ticket` — one row per sub-ticket; state classes: `.is-fixed` (quantity is fixed, shown as text), `.is-empty` (quantity is `0`), `.is-preview` (read-only, inside `<go-cart preview>`)
- `.go-sub-ticket-title` — the sub-ticket's name
- `.go-sub-ticket-description` — its optional description
- editable sub-rows render the shared quantity control — the `.go-quantity-stepper` stepper by default, or a `.go-quantity-select` `<select>` with `go.config({ quantityStepper: false })`
- `.go-sub-ticket-quantity` — the quantity shown as text (fixed or preview rows)

```css
.go-cart-coupon.go-cart-coupon-inactive {
  opacity: 0.5;
  text-decoration: line-through;
}

.go-sub-tickets {
  margin-left: 1.5rem;
}
.go-sub-ticket.is-empty {
  opacity: 0.5;
}
```

## Nesting

The cart's display subcomponents — `<go-cart-items>`, `<go-cart-coupons>`,
`<go-cart-subtotal-amount>`, `<go-cart-discounted-amount>`, and
`<go-cart-total-amount>` — must be placed inside `<go-cart>`; they read the
re-priced cart from it and render nothing on their own. `<go-cart-counter>` and
`<go-cart-empty>` read the cart directly and can be placed anywhere on the page.

## Subcomponents

| Tag                           | Renders                                                                                                                                                    |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `<go-cart-items>`             | Item table (header + line per item, with quantity stepper + remove). Bundle-ticket lines also render editable sub-ticket rows — see _Bundle tickets_ below |
| `<go-cart-coupons>`           | One row per coupon. Inactive coupons get `go-cart-coupon-inactive`                                                                                         |
| `<go-cart-subtotal-amount>`   | Pre-discount total (sum of original line prices)                                                                                                           |
| `<go-cart-discounted-amount>` | Saved amount, prefixed with a `−` sign                                                                                                                     |
| `<go-cart-total-amount>`      | Final amount to pay after coupon and voucher projection                                                                                                    |
| `<go-cart-counter>`           | A live count of the number of items in the cart — text only, no markup                                                                                     |
| `<go-cart-empty>`             | Shows its own children only while the cart has no items (`Since v1.11.0`)                                                                                  |

Each subcomponent is independently mountable and renders nothing when its data is
absent (e.g. `go-cart-coupons` is empty until a coupon is added).

All prices in the cart — line prices, sums, and the amount subcomponents — are
formatted in your shop's configured currency, using the `locale` you pass to
`go.init({ locale })` for the number format (e.g. a Swiss shop with
`locale: 'de-CH'` renders `CHF 12.34`). Without a configured currency or locale,
formatting falls back to EUR in German conventions (`12,34 €`) (`Since UNRELEASED`).

### Bundle tickets (Mantelticket)

Since `v4.0.0`

When a cart line is a **bundle ticket** (a Mantelticket — a ticket composed of
several sub-tickets), `<go-cart-items>` renders the normal line and, indented
beneath it, one editable row per sub-ticket so the visitor can compose the bundle
(e.g. _2 Adult, 1 Child_). This happens automatically for bundle products — there
is no attribute to enable it.

Each sub-row carries a quantity selector; changing it re-prices the whole cart and
updates the line and totals. The selector is bounded by the sub-ticket's minimum
and maximum persons — only a sub with a minimum of `0` can be set to `0`. A
sub-ticket whose quantity is fixed (its minimum equals its maximum) shows the
count as plain text instead of a selector. In a read-only cart
(`<go-cart preview>`) every sub-row shows its count as text.

The bundle still checks out as a **single** cart item carrying the chosen
composition — your `go-submit` handler and checkout flow are unchanged.

You author only `<go-cart-items>` — a bundle line renders its editable sub-ticket
rows automatically (the styling hooks are listed under [Styling](#styling)):

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
showing a formatted zero (e.g. `0,00 €`).

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

## Tour lines

Since `v4.3.0`

Guided-group-tour bookings added programmatically via `go.cart.addTour()`
(documented under _The Go Interface_) render as regular lines in
`<go-cart-items>`. The title cell shows the tour title, the participant count,
the start date and time, and one `key: value` line per custom field passed to
`addTour()`. Three things differ from ticket lines:

- **Fixed participant count.** The quantity cell shows the booking's participant
  count as plain text — no stepper or select, even with
  `go.config({ quantityStepper: false })`. Participants are fixed when the booking
  is added; to change them, remove the line and add a new booking.
- **Your total, unmultiplied.** The line's price and sum are the `totalPriceCents`
  passed to `addTour()` — the participant count does not multiply them.
- **One line per booking.** Every `addTour()` call adds its own line; two identical
  bookings render as two separately removable lines (the ✕ removes the whole
  booking). A booking counts as one item in `<go-cart-counter>`, regardless of
  participants.

## Localization

The `go-cart` component uses the following translation keys for its interface and validation:

### Cart Table

| Key                           | Default Description              |
| ----------------------------- | -------------------------------- |
| `cart.content.table.desc`     | Description/Title column header  |
| `cart.content.table.price`    | Price column header              |
| `cart.content.table.quantity` | Quantity column header           |
| `cart.content.table.total`    | Total column header              |
| `cart.content.table.edit`     | Quantity-selector aria-label     |
| `cart.item.participants`      | Participant count on a tour line |
| `cart.item.remove`            | Item remove-button aria-label    |
| `cart.coupons.remove`         | Coupon remove-button aria-label  |
