# Donations

How a visitor adds an optional donation to a purchase — from the campaign you configure in gomus, through the cart and checkout, to the order confirmation. This page walks the whole journey; each component's own doc has the full API.

## The flow at a glance

| Stage        | Component(s)                                 | What happens                                                                       |
| ------------ | -------------------------------------------- | ---------------------------------------------------------------------------------- |
| Offer        | `<go-donation-checkbox>` or `<go-donations>` | The visitor opts into a donation for a campaign                                    |
| Cart         | `<go-cart>`                                  | The donation shows as a removable row and is included in the totals                |
| Checkout     | `<go-checkout-guest>` / `<go-checkout-user>` | The donation is submitted with the order and charged as part of the order total    |
| Confirmation | `<go-order>` with `<go-order-breakdown>`     | The donation renders as its own breakdown row; the cart's held donation is cleared |

## Campaigns

Donations are tied to **campaigns** configured for your shop in gomus — ask your gomus contact to enable donations and set up at least one campaign. Each campaign carries:

- an **id** — what you pass to `campaign-id` on `<go-donation-checkbox>`
- a **name** and translated headline/description
- **preset amounts** (in cents) and optionally a **free-amount input**
- a **guest limit** — the maximum a visitor without a full customer account may donate (`0` means unlimited, see [Guest limits](#guest-limits))
- an **image**, shown on the `<go-donations>` campaign cards

Without a matching campaign the donation components render nothing — a wrong `campaign-id` degrades to "no checkbox", never an error.

## Offering a donation

There are two entry points.

### Fixed amount, inline — `<go-donation-checkbox>`

_(Since `v4.16.0`)_ The recommended way in a shop built from these components. A single opt-in checkbox for one fixed amount: checking it adds the donation to the cart immediately, unchecking removes it — no confirm step, no navigation. It reflects the cart, so it survives page reloads and unchecks when the donation is removed elsewhere.

Typically placed right next to the cart:

```html
<go-donation-checkbox campaign-id="1" amount-cents="200"></go-donation-checkbox> <go-cart></go-cart>
```

With custom label markup, on a checkout page:

```html
<go-cart></go-cart>

<go-donation-checkbox campaign-id="1" amount-cents="200" describedby="donation-info">
  <strong>Support us</strong> <span>+2,00 €</span>
</go-donation-checkbox>
<p id="donation-info">Voluntary contribution. You can remove it anytime.</p>

<go-if when="data.auth.isLoggedIn">
  <go-checkout-user></go-checkout-user>
</go-if>
<go-if when="!data.auth.isLoggedIn">
  <go-checkout-guest></go-checkout-guest>
</go-if>
```

Two checkboxes with the same `campaign-id` and `amount-cents` mirror the same cart donation — checking either checks both. Full API, styling, and accessibility notes: **Components / Donation Checkbox**.

### Campaign chooser page — `<go-donations>`

A full campaign picker: all campaigns render as cards with image and description; selecting one reveals an amount selector with the campaign's preset amounts (plus a free-amount input when the campaign allows it). "Add to cart" and "Continue without donation" both navigate the browser to the shop's cart page.

```html
<go-donations></go-donations>
```

**`<go-donations>` targets the classic gomus shop pages.** It stores the chosen donation for the classic shop's cart and navigates there — the donation does **not** appear in a `<go-cart>` component and is **not** submitted by the checkout components. In a shop built from these components, use `<go-donation-checkbox>` instead.

## In the cart

_(Since `v4.16.0`)_ A donation added via `<go-donation-checkbox>` renders inside `<go-cart>` as its own row:

- Titled with the campaign's name (falls back to the `cart.donation.title` translation if the campaign is no longer configured), amount in the sum column, no unit price × quantity.
- Removable via the row's remove button — same effect as unchecking the matching checkbox. In `preview` mode the remove button is hidden.
- Included in `<go-cart-subtotal-amount>` and `<go-cart-total-amount>`.
- **Not an item**: it doesn't increment `<go-cart-counter>` and doesn't count toward the cart's empty state.
- **Never voucher-paid**: a value voucher in the cart only covers the items total — the donation always rides on top of the amount to pay.
- Persisted with the cart in local storage, so it survives a page reload.

## Checkout

The checkout components (`<go-checkout-guest>`, `<go-checkout-user>`, legacy `<go-checkout-form>`) submit every donation held in the cart with the order _(Since `v4.16.0`)_; the donation amount is part of the charged order total. An order may consist of donations only — no ticket required.

## Order confirmation

_(Since `v4.15.0`)_ On the confirmation page, `<go-order-breakdown>` renders one row per donation, labelled with the campaign's name (or the generic `common.table.donation` label when the campaign is unknown), with the amount as the price:

```html
<go-order token="your-order-token">
  <go-order-breakdown></go-order-breakdown>
  <go-order-invoice-id></go-order-invoice-id>
</go-order>
```

When `<go-order>` loads it also clears the donations held in the cart _(Since `v4.16.0`)_ — a paid donation unchecks its `<go-donation-checkbox>` and never rides into the next order.

## Guest limits

A campaign's guest limit caps what visitors **without a full customer account** may donate — anonymous visitors and guest checkouts both count. `0` means unlimited.

- `<go-donation-checkbox>` renders nothing while its `amount-cents` exceeds the limit; it appears once the visitor signs in.
- `<go-donations>` caps the free-amount input at the limit and refuses over-limit donations.

## Conditional rendering with `<go-if>`

The cart handle exposes held donations, so you can gate markup on them:

```html
<go-if when="data.cart.donations.length > 0">
  <p>Thank you for your support!</p>
</go-if>
```

Offer a larger fixed amount only to signed-in customers (e.g. above the campaign's guest limit):

```html
<go-if when="data.auth.isLoggedIn">
  <go-donation-checkbox campaign-id="1" amount-cents="5000"></go-donation-checkbox>
</go-if>
```

## Related docs

- **Components / Donation Checkbox** — `<go-donation-checkbox>` API, custom labels, styling, accessibility
- **Components / Donations** — the `<go-donations>` campaign page
- **Components / Cart** — donation rows, totals, the `Donations` section
- **Components / Order** — the confirmation breakdown
