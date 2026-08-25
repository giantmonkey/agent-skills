# Order confirmation

The post-checkout journey: after a customer pays (or completes a zero-total order), they land on your confirmation page, where `<go-order>` fetches the finished order and renders its summary — line items with ticket downloads via `<go-order-breakdown>`, the invoice number via `<go-order-invoice-id>`. This guide wires the whole flow; the component reference lives in **Components / Order**.

## How the customer gets here

Checkout (`<go-checkout-guest>` / `<go-checkout-user>` / `<go-checkout-form>`) creates the order and then routes the customer by outcome:

- **No payment needed** (e.g. a zero-total order) — the customer is sent straight to your checkout-success URL, which receives the order token.
- **Payment via redirect or POST** — the customer completes payment at the provider, then returns to the confirmation link configured for your shop in the gomus backend. The order token arrives in the URL query string (by default as `ORDERID`).
- **Failure** — the customer is sent to your checkout-failure URL instead; it receives an error message (may be empty).

Set your own confirmation and failure pages with `go.config`:

```js
go.config({
  urls: {
    checkoutSuccess: token => `/order-complete?token=${token}`,
    checkoutFailure: error => `/order-failed?error=${error}`,
  },
})
```

For the payment round-trip, ask your gomus contact to point the shop's payment-return link at the same confirmation page, so both routes land in one place.

## The confirmation page

The page is a normal page of your site: load the bundle, initialize, read the token from the URL, and hand it to `<go-order>`.

```html
<go-order>
  <go-order-invoice-id></go-order-invoice-id>
  <go-order-breakdown></go-order-breakdown>
</go-order>

<script>
  go.init({ shop: 'your-shop.gomus.de', api: 'your-shop.gomus.de', locale: 'de' })

  const params = new URLSearchParams(window.location.search)
  const token = params.get('token') ?? params.get('ORDERID')
  document.querySelector('go-order').setAttribute('token', token)
</script>
```

`<go-order>` fetches the order for its `token` and provides it to the subcomponents nested inside it — order matters only for layout, so arrange them freely:

- `<go-order-invoice-id>` — the invoice number, typically shown in a "Thank you, your order number is …" heading.
- `<go-order-breakdown>` — the line items (tickets with PDF download / Apple Wallet / iCal links, events, tours, coupons, merchandise, donations) followed by the order total.

You can also write the token into the markup server-side instead of using the script:

```html
<go-order token="AB12CD34">
  <go-order-breakdown></go-order-breakdown>
</go-order>
```

## What loading the order does

Rendering `<go-order>` with a valid token marks the purchase as complete on the client:

- the shopping cart is emptied,
- redeemed coupons and a paid donation are cleared, so the next purchase starts clean,
- a guest session (created by `<go-checkout-guest>`) is ended.

This runs once per token — reloading the page is safe. Because of this cleanup, only render `<go-order>` on the confirmation page itself, never alongside an active cart.

## Follow-ups from the confirmation page

- **Ticket PDFs** — each timeslot / day ticket row in `<go-order-breakdown>` links to its PDF; the customer downloads tickets right here. No extra markup needed.
- **Annual passes** — annual-ticket rows link to the personalization page instead of a PDF. That page hosts `<go-annual-ticket-personalization>` — see **Flows / Annual Passes**.
- **Vouchers** — purchased coupons link to their voucher PDF.

## Styling

The confirmation page renders in light DOM — style it with your own CSS via the tags and the `.go-order-*` hooks listed in **Components / Order**. Example:

```css
go-order-invoice-id {
  font-size: 1.5rem;
  font-weight: 600;
}
go-order-breakdown .go-order-breakdown-footer {
  border-top: 2px solid currentColor;
}
```

## Related docs

- **Components / Order** — attributes, all styling hooks, localization keys.
- **Components / Checkout Form** — the step before this one, including the `checkoutSuccess` / `checkoutFailure` URL configuration.
- **Flows / Cart & Checkout** — how the order gets built.
- **Flows / Annual Passes** — personalization after purchase.
