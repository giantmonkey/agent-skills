# Donations Component

The `go-donations` component allows customers to add optional donations to their cart during the checkout flow. Donations are tied to **campaigns** configured in the backend, each with preset amounts and optional free-form input.

## Example

```html
<go-donations></go-donations>
```

## User Flow

1. **View campaigns** -- All available campaigns are displayed as clickable cards with an image and description.
2. **Select a campaign** -- Clicking a card highlights it and reveals the amount selector. If only one campaign exists, it is auto-selected on mount.
3. **Choose an amount** -- The user picks a preset amount button or enters a custom value (if `free_donations` is enabled).
4. **Add to cart or skip** -- The "Add to Cart" button is disabled until an amount is selected. The user can also continue without donating.

## Localization

**Global translation keys (from shop translations):**

| Key                                              | Description                    |
|--------------------------------------------------|--------------------------------|
| `donations.actions.continueWithoutDonation`      | Skip donation button text      |
| `donations.actions.addToCart`                     | Add to cart button text        |
| `donations.selection.title`                      | Amount selection heading       |
| `donations.selection.custom.label`               | Custom amount label            |
| `donations.selection.custom.input.placeholder`   | Custom amount input placeholder|

**Per-campaign translation keys (from `campaign.translations`):**

| Key                      | Description              |
|--------------------------|--------------------------|
| `donations.headline`     | Campaign title           |
| `donations.shop.info`    | Campaign description     |
