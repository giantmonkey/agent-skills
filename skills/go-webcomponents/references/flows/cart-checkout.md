# Cart & checkout

The end-to-end purchase journey: items go into the cart, the customer reviews
them, checks out, pays, and lands on a confirmation page. This guide wires the
pieces together across pages — each component's full reference is linked under
[Related docs](#related-docs).

## The journey at a glance

| Step      | Page             | Components                                                                     |
| --------- | ---------------- | ------------------------------------------------------------------------------ |
| Select    | product page     | `<go-ticket-selection>` + `<go-add-to-cart-button>`, or `go.cart.addItem(...)` |
| Review    | cart page        | `<go-cart>` + subcomponents, `<go-coupon-redemption>`, `<go-submit>`           |
| Check out | checkout page    | `<go-checkout-guest>` / `<go-checkout-user>`, gated with `<go-if>`             |
| Pay       | payment provider | handled for you — redirect or provider form                                    |
| Confirm   | success page     | `<go-order>` with `<go-order-breakdown>` + `<go-order-invoice-id>`             |

The cart lives in the customer's browser and persists across pages and reloads
(it expires about 15 minutes after the last change), so a plain multi-page shop
needs no state passing between steps. All steps can also share a single page —
see [Single-page setups](#single-page-setups).

## 1. Set up every page

Every page that renders a `go-*` component loads the bundle and initializes the
shop (see **The Go Interface** for the loader snippet):

```js
go.load({ version: 'latest' })
go.init({ shop: 'your-shop-id', api: 'api.gomus.de', locale: 'de' })
```

Configure the flow's page URLs on every page, so the components can move the
customer forward:

```js
go.config({
  urls: {
    cart: () => '/cart',
    checkoutSuccess: token => `/order-complete?token=${token}`,
    checkoutFailure: error => `/order-failed?error=${error}`,
  },
})
```

- `cart` — where `<go-add-to-cart-button>` sends the customer after adding
  items. Omit it to keep the customer on the page.
- `checkoutSuccess` — receives the order token, returns your confirmation page
  URL. Used when checkout completes without a payment step (e.g. a zero-total
  order).
- `checkoutFailure` — receives an error message (may be empty), returns your
  failure page URL.

Navigation is a plain location change by default; set
`go.config({ navigateTo })` if your site routes differently (e.g. a SPA
router).

## 2. Add items to the cart

The usual source is a `<go-ticket-selection>` with a `<go-add-to-cart-button>`:
clicking the button moves the selected quantities into the cart and, when
`urls.cart` is configured, navigates to your cart page.

```html
<go-ticket-selection filters="ticket:timeslot">
  <go-calendar></go-calendar>
  <go-timeslots></go-timeslots>
  <go-tickets>
    <go-ticket-segment>
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Shops that book through their own UI add items programmatically with
`go.cart.addItem({ filter, … })` instead — see **The Go Interface**.

A `<go-cart-counter>` can sit anywhere (e.g. a header badge) and shows the live
item count on every page:

```html
<span class="cart-badge"><go-cart-counter></go-cart-counter></span>
```

The `go-cart-item-added` / `go-cart-item-removed` events fire on `document`
whenever the count changes, if you render your own badge.

## 3. The cart page

`<go-cart>` is a composable shell — place the subcomponents you need inside it.
A `<go-submit>` inside the cart is the checkout button: clicking it first
applies any coupon code still typed into `<go-coupon-redemption>`; if the
coupon is invalid, the error renders inline and nothing else happens. Otherwise
the cart dispatches a `go-submit` event on the `<go-cart>` host — the cart does
**not** navigate on its own, you wire the next step:

```html
<go-cart>
  <go-cart-items></go-cart-items>
  <go-cart-coupons></go-cart-coupons>
  <go-coupon-redemption></go-coupon-redemption>
  <go-if when="data.cartView.isDiscounted">
    <go-cart-subtotal-amount></go-cart-subtotal-amount>
    <go-cart-discounted-amount></go-cart-discounted-amount>
  </go-if>
  <go-cart-total-amount></go-cart-total-amount>
  <go-submit>To checkout</go-submit>
</go-cart>

<go-cart-empty>
  <p>Your cart is empty.</p>
</go-cart-empty>

<script>
  document.querySelector('go-cart').addEventListener('go-submit', () => {
    window.location.assign('/checkout')
  })
</script>
```

`<go-cart-empty>` shows its children only while the cart has no items, so the
page covers both states. See **Components / Cart** for all subcomponents,
bundle tickets, tour lines, and donations; see **Components / Coupon
Redemption** for coupon and voucher behavior.

## 4. The checkout page

Checkout is one form component per auth state — the components don't switch on
auth themselves, so gate them with `<go-if>` on `data.auth.isLoggedIn`. A
read-only cart (`<go-cart preview>`) alongside gives the customer a final look
at what they're paying for:

```html
<go-cart preview>
  <go-cart-items></go-cart-items>
  <go-cart-total-amount></go-cart-total-amount>
</go-cart>

<go-if when="!data.auth.isLoggedIn">
  <go-checkout-guest></go-checkout-guest>
</go-if>

<go-if when="data.auth.isLoggedIn">
  <go-checkout-user></go-checkout-user>
</go-if>
```

On submit, `<go-checkout-guest>` creates a guest account from the identity
fields and places the order; `<go-checkout-user>` places it under the signed-in
customer directly. Then the component routes the customer by the outcome:

- **Payment via redirect** — the customer is sent to the payment provider.
- **Payment via POST** (some embedded providers) — a provider form is submitted
  automatically.
- **Completed without payment** (e.g. a zero-total order) — the customer is
  sent to your `checkoutSuccess` URL, with the order token.
- **Failed, or no payment target returned** — the customer is sent to your
  `checkoutFailure` URL.
- **Checkout request rejected** — no redirect; the errors render on the form.

Custom checkout fields, the `beforeSubmit` callback, and the legacy
`<go-checkout-form>` tag are covered in **Components / Checkout Form**.

## 5. The confirmation page

After paying, the customer returns to the checkout-success page configured for
your shop in gomus, with the order token in the `ORDERID` query parameter (the
client-side no-payment path uses whatever parameter your `checkoutSuccess`
builder produces). Pass the token to `<go-order>`; some payment providers
prefix it with `GO_`, so strip that first:

```html
<go-order>
  <go-order-breakdown></go-order-breakdown>
  <go-order-invoice-id></go-order-invoice-id>
</go-order>

<script>
  const params = new URLSearchParams(window.location.search)
  const token = (params.get('token') ?? params.get('ORDERID') ?? '').replace(/^GO_/, '')
  document.querySelector('go-order').setAttribute('token', token)
</script>
```

`<go-order>` fetches the order, renders the confirmation, and — the purchase
being complete — empties the cart and ends a guest session. The next visit
starts fresh. See **Components / Order** for the breakdown's rows, download
links, and styling hooks.

## Single-page setups

The same components work on one page. Keep the checkout form hidden until the
cart's `go-submit` fires, and gate the whole block on the cart having items:

```html
<go-if when="data.cart.items.length > 0">
  <go-cart>
    <go-cart-items></go-cart-items>
    <go-cart-total-amount></go-cart-total-amount>
    <go-submit>To checkout</go-submit>
  </go-cart>
</go-if>

<div id="checkout" hidden>
  <go-if when="!data.auth.isLoggedIn">
    <go-checkout-guest></go-checkout-guest>
  </go-if>
  <go-if when="data.auth.isLoggedIn">
    <go-checkout-user></go-checkout-user>
  </go-if>
</div>

<script>
  document.querySelector('go-cart').addEventListener('go-submit', () => {
    document.getElementById('checkout').hidden = false
  })
</script>
```

Payment still leaves the page — point `checkoutSuccess` back at a confirmation
section or a dedicated success page with `<go-order>`.

## Related docs

- **Components / Cart** — `<go-cart>` and its subcomponents
- **Components / Coupon Redemption** — `<go-coupon-redemption>`, action tokens and vouchers
- **Components / Checkout Form** — `<go-checkout-guest>` / `<go-checkout-user>` in depth
- **Components / Order** — `<go-order>` and the confirmation breakdown
- **The Go Interface** — `go.load` / `go.init` / `go.config` / `go.cart.addItem`
