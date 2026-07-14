# `<go-order>`

Since `v1.20.0`

The order components display purchase confirmation details after a successful checkout. When `<go-order>` loads, and again whenever its `token` changes to a new order, it empties the shopping cart — the purchase is complete — and ends a guest session.

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
- `.go-order-item-quantities` — the `quantity x label` price rows
- `.go-order-item-participants` — participants line of a tour booking _(Since `v4.3.0`)_
- `.go-cart-item-date`, `.go-cart-item-time` — date and time of dated items
- `.go-ticket-download`, `.go-ticket-personalization` — PDF download and personalization links
- `.go-order-breakdown-passbook` — Apple Wallet cell
- `.go-order-breakdown-ical` — iCal link cell
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

Renders the order's line items followed by the order total. Timeslot and day tickets render one row per ticket, each with its own PDF download link and, when available, an Apple Wallet pass. Annual tickets render one row linking to personalization (vouchers link to a PDF download instead). Events render one row per booking with a `quantity x label` line per price and a PDF download link. Rows with a date also offer an iCal link when the order provides one.

Tour bookings added via `go.cart.addTour()` render one row per booking _(Since `v4.3.0`)_: count `1`, the tour title, a participants line, the booking's date and time, and a `quantity x label` line per price. Tours have no PDF download — the iCal link is the only attachment.

### `<go-order-invoice-id>`

Displays the order's invoice ID.

## Localization

| Key                      | Description                                     | Dynamic Values\*                           |
| ------------------------ | ----------------------------------------------- | ------------------------------------------ |
| `common.table.count`     | Count column header                             | -                                          |
| `common.table.product`   | Product column header                           | -                                          |
| `common.table.price`     | Price column header                             | -                                          |
| `common.table.total`     | Total row label                                 | {"{{value}}"} - the calculated order total |
| `common.download`        | Text for download button                        | -                                          |
| `common.calendar`        | Text for calendar link                          | -                                          |
| `common.personalize`     | Text for the annual-ticket personalization link | -                                          |
| `cart.item.participants` | Participants line of a tour booking             | {"{{count}}"} - the number of participants |

- {"{{value}}"} — words in double brackets are automatically replaced with real values when the text is displayed, as long as the translation supports it.
