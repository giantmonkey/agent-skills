# `<go-order>`

Since `v1.20.0`

The order components display purchase confirmation details after a successful checkout. When `<go-order>` loads, and again whenever its `token` changes to a new order, it empties the shopping cart — the purchase is complete — and ends a guest session. A donation in the cart is cleared too, so `<go-donation-checkbox>` unchecks and the next purchase doesn't charge it again _(Since `v4.16.0`)_.

## Examples

A full confirmation page — order breakdown plus invoice number:

```html
<go-order token="your-order-token">
  <go-order-breakdown></go-order-breakdown>
  <go-order-invoice-id></go-order-invoice-id>
</go-order>
```

## Attributes

`<go-order>` fetches the order and provides it to the subcomponents nested inside it:

| Attribute | Type   | Default | Description                                                                 |
| --------- | ------ | ------- | --------------------------------------------------------------------------- |
| `token`   | string | —       | The order token identifying the order to display (from checkout). Required. |

`<go-order-breakdown>` and `<go-order-invoice-id>` take no attributes.

## Events

These components emit no custom events.

## Styling

Everything renders in light DOM — target the tags and these classes:

- `.go-order-breakdown-count`, `.go-order-breakdown-product`, `.go-order-breakdown-item-price` — cells of each line item
- `.go-order-item-title` — product title
- `.go-order-item-subtitle` — ticket subtitle, shown under the title when the ticket has one _(Since `v4.11.0`)_
- `.go-order-item-quantities` — the `quantity x label` price rows
- `.go-order-item-participants` — participants line of a tour booking _(Since `v4.3.0`)_
- `.go-cart-item-date`, `.go-cart-item-time` — date and time of dated items
- `.go-ticket-download`, `.go-ticket-personalization` — PDF download and personalization links
- `.go-order-breakdown-passbook` — Apple Wallet cell
- `.go-ticket-passbook` — the Apple Wallet pass link inside that cell, a plain text link (add an icon via CSS, e.g. a `::before` background image)
- `.go-order-breakdown-ical` — iCal link cell
- `.go-order-breakdown-donation` — a donation row _(Since `v4.15.0`)_
- `.go-order-breakdown-footer` — total row

```css
go-order-breakdown .go-order-item-title {
  font-weight: 600;
}
```

## Nesting

`<go-order>` is standalone — no required parent. `<go-order-breakdown>` and `<go-order-invoice-id>` must be placed inside `<go-order>`.

## Subcomponents

### `<go-order-breakdown>`

Renders the order's line items followed by the order total. Timeslot and day tickets render one row per ticket, each with its own PDF download link and, when available, an Apple Wallet pass — a plain text link (`.go-ticket-passbook`, label from the `common.wallet` translation key, default "Add to wallet") that integrators can decorate with an icon via CSS. Annual tickets render one row linking to personalization (vouchers link to a PDF download instead). Tickets configured with a subtitle show it beneath the title on every row _(Since `v4.11.0`)_. Events render one row per booking with a `quantity x label` line per price and a PDF download link. Rows with a date also offer an iCal link when the order provides one.

Tour bookings added via `go.cart.addItem({ filter: 'tour', … })` render one row per booking _(Since `v4.3.0`)_: count `1`, the tour title, a participants line, the booking's date and time, and a `quantity x label` line per price. Tours have no PDF download — the iCal link is the only attachment.

Coupon and merchandise items render a plain row with quantity, title, and price _(Since `v4.15.0`)_. A coupon's price cell shows `attributes.value_cents` when it's a positive number (value vouchers carry their amount there and have `price_cents` of `0`), otherwise the order item's `price_cents` (fixed-price coupons carry it there instead). Each coupon row also links to the coupon's PDF document — the voucher the customer bought — via the same `.go-ticket-download` link tickets use _(Since `v4.15.0`)_.

Donations aren't order items — they come from `order.donations` and render one row per entry after the item rows, with `donation_cents` as the price _(Since `v4.15.0`)_. The row is labelled with the donation campaign's name from the shop configuration; when the donation has no campaign (or the campaign is no longer configured), the generic `common.table.donation` label is used instead. These rows carry an extra `.go-order-breakdown-donation` class so they can be styled or queried independently of the item rows above them.

### `<go-order-invoice-id>`

Displays the order's invoice ID.

## Localization

| Key                      | Description                                                                         | Dynamic Values\*                           |
| ------------------------ | ----------------------------------------------------------------------------------- | ------------------------------------------ |
| `common.table.count`     | Count column header                                                                 | -                                          |
| `common.table.product`   | Product column header                                                               | -                                          |
| `common.table.price`     | Price column header                                                                 | -                                          |
| `common.table.total`     | Total row label                                                                     | {"{{value}}"} - the calculated order total |
| `common.download`        | Text for download button                                                            | -                                          |
| `common.calendar`        | Text for calendar link                                                              | -                                          |
| `common.personalize`     | Text for the annual-ticket personalization link                                     | -                                          |
| `common.table.donation`  | Fallback label for a donation row without a configured campaign _(Since `v4.15.0`)_ | -                                          |
| `cart.item.participants` | Participants line of a tour booking                                                 | {"{{count}}"} - the number of participants |

- {"{{value}}"} — words in double brackets are automatically replaced with real values when the text is displayed, as long as the translation supports it.
