# `<go-donations>`

Since `v1.0.0`

The `go-donations` component allows customers to add optional donations to their cart during the checkout flow. Donations are tied to **campaigns** configured in the backend, each with preset amounts and optional free-form input.

## Examples

```html
<go-donations></go-donations>
```

## Attributes

This component takes no attributes. Campaigns, preset amounts and limits all
come from the shop's donation configuration.

## Events

This component emits no custom events.

## Styling

- `.go-donations-list` — root element
- `.go-donation-campaign` — a campaign card; `.go-donation-campaign.selected` marks the selected campaign
- `.donation-selection` — the amount selector, revealed once a campaign is selected
- `.donation-options` — the preset amount buttons; the chosen one carries `.selected`
- `.donation-custom` — the custom-amount input group
- `.donation-actions` — the "continue without donation" / "add to cart" button row

```css
.go-donation-campaign.selected {
  outline: 2px solid currentColor;
}
```

## Nesting

Standalone — no required parent.

## Subcomponents

None.

## User Flow

1. **View campaigns** — All available campaigns are displayed as clickable cards with an image and description.
2. **Select a campaign** — Clicking a card highlights it and reveals the amount selector. If only one campaign exists, it is auto-selected on mount.
3. **Choose an amount** — The user picks a preset amount button or enters a custom value (if the campaign allows custom amounts). Amounts are shown in the shop's currency, formatted according to the `locale` you set on `<go-init>` — e.g. a Swiss shop needs `locale="de-CH"` to get `CHF 10.00`-style formatting instead of `10,00 CHF`. When the campaign has a guest limit, custom amounts above it are rejected.
4. **Add to cart or skip** — The "Add to Cart" button is disabled until an amount is selected. The user can also continue without donating. Either action takes the visitor to the shop's cart page.

## Localization

**Global translation keys (from shop translations):**

| Key                                            | Purpose                         |
| ---------------------------------------------- | ------------------------------- |
| `donations.actions.continueWithoutDonation`    | Skip donation button text       |
| `donations.actions.addToCart`                  | Add to cart button text         |
| `donations.selection.title`                    | Amount selection heading        |
| `donations.selection.custom.label`             | Custom amount label             |
| `donations.selection.custom.input.placeholder` | Custom amount input placeholder |

**Per-campaign translation keys (from `campaign.translations`):**

| Key                   | Purpose              |
| --------------------- | -------------------- |
| `donations.headline`  | Campaign title       |
| `donations.shop.info` | Campaign description |

## `<go-donation-checkbox>`

Since `v4.16.0`

A lightweight fixed-amount opt-in — a single checkbox that adds or removes one
donation and syncs live with the cart, no navigation. Use it when the shop is
built from these components (the full `<go-donations>` page targets the classic
shop's cart instead). Typically placed right next to `<go-cart>` or on the
checkout page:

```html
<go-donation-checkbox campaign-id="1" amount-cents="200"></go-donation-checkbox>
```

### Attributes

| Attribute      | Type   | Default | Description                                                                      |
| -------------- | ------ | ------- | -------------------------------------------------------------------------------- |
| `campaign-id`  | number | —       | The donation campaign id from the shop's donation configuration                  |
| `amount-cents` | number | —       | The fixed amount the checkbox adds, in cents                                     |
| `describedby`  | string | —       | Id of your own description element, forwarded to the input as `aria-describedby` |

Two checkboxes with the same `campaign-id` and `amount-cents` mirror the same
cart donation — checking either checks both.

See the _Donation Checkbox Component_ documentation for custom labels, styling
and behavior details.
