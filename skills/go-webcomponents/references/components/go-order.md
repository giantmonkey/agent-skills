# Order Component

The order components display purchase confirmation details after a successful checkout.

## Example

```html
<go-order token="your-order-token">
  <go-order-breakdown></go-order-breakdown>
  <go-order-invoice-id></go-order-invoice-id>
</go-order>
```

## Components

### `go-order`

The parent wrapper that fetches order data and provides it to child components.

| Property | Attribute | Description                          | Type     | Default |
|----------|-----------|--------------------------------------|:---------|:--------|
| `token`  | `token`   | The order token used to fetch data   | `string` | —       |

### `go-order-breakdown`

Renders the order line items (tickets and events) in a table with quantities and prices.

### `go-order-invoice-id`

Displays the order's invoice ID.

## Localization

| Key                    | Description              | Dynamic Values*                    |
|------------------------|--------------------------|------------------------|
| `common.table.count`   | Count column header      | - |
| `common.table.product` | BaseProduct column header    | - |
| `common.table.price`   | Price column header      | - |
| `common.table.total`   | Total row label          | {"{{value}}"} - the calculated order total |
| `common.download`      | Text for download button | - |
| `common.calendar`      | Text for calendar link   | - |

* {"{{value}}"} — words in double brackets are automatically replaced with real values when the text is displayed, as long as the translation supports it.
