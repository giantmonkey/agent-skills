# Annual passes

How to sell annual passes (year tickets, memberships) end to end: list the passes, take them
through cart and checkout, confirm the order, and let the buyer personalize each pass — holder
data, start date, and (when required) a photo per pass. Annual passes need no date or timeslot,
so the selection shows no calendar; the personalization step is what makes this flow different
from day or timeslot tickets.

## The journey at a glance

| Step               | Page              | Components                                                                      |
| ------------------ | ----------------- | ------------------------------------------------------------------------------- |
| 1. Offer           | product page      | `<go-ticket-selection filters="ticket:annual">` with `<go-tickets>`             |
| 2. Cart & checkout | cart page         | `<go-cart>`, `<go-checkout-guest>` / `<go-checkout-user>`                       |
| 3. Confirmation    | success page      | `<go-order>` with `<go-order-breakdown>`                                        |
| 4. Personalization | two pages you own | `<go-annual-ticket-personalization>`, `<go-annual-ticket-personalization-form>` |

Steps 3 and 4 identify the purchase by the **order token** — checkout redirects to the URL you
configure as `urls.checkoutSuccess(token)`, and you pass that token on to each component (see
[Wiring the pages together](#wiring-the-pages-together)).

## 1. Offer the passes

Use the `ticket:annual` filter. It shows the tickets directly — no calendar, no timeslots:

```html
<go-ticket-selection filters="ticket:annual">
  <go-tickets>
    <go-ticket-segment>
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Without further narrowing this lists **every bookable annual ticket** of the shop. Narrow it with
`ticket-ids` or `ticket-group-ids`:

```html
<go-ticket-selection filters="ticket:annual" ticket-ids="351,352">
  <go-tickets>
    <go-ticket-segment>
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

If your site has its own product UI, skip the selection and add a pass programmatically
_(Since `v4.14.0`)_:

```js
const uuid = await go.cart.addItem({ filter: 'ticket:annual', id: 351, quantity: 2 })
```

The ticket is resolved live against the shop API — price and availability come from the backend,
and the call rejects when the ticket is unknown or sold out. See **The Go Interface** for the
queueing rules.

## 2. Cart and checkout

Nothing annual-specific here — the pass sits in the cart like any other ticket:

```html
<go-cart></go-cart>

<go-if when="data.cart.items.length > 0">
  <go-if when="data.auth.isLoggedIn">
    <go-checkout-user></go-checkout-user>
  </go-if>
  <go-if when="!data.auth.isLoggedIn">
    <go-checkout-guest></go-checkout-guest>
  </go-if>
</go-if>
```

See the **Components / Cart** and **Components / Checkout Form** docs for the full checkout
options. After payment, checkout redirects to your `urls.checkoutSuccess(token)` page with the
order token.

## 3. Confirm the order

On the success page, read the token from the URL and hand it to `<go-order>`:

```html
<go-order>
  <go-order-breakdown></go-order-breakdown>
  <go-order-invoice-id></go-order-invoice-id>
</go-order>

<script>
  const token = new URLSearchParams(location.search).get('token')
  document.querySelector('go-order').setAttribute('token', token)
</script>
```

In the breakdown, each annual pass renders one row whose link (class
`.go-ticket-personalization`, label from the `common.personalize` translation key) points to your
personalization list page — the URL you configure as `urls.annualTicketPersonalizationList(token)`.
Annual passes sold as vouchers link to a PDF download instead and skip personalization.

## 4. Personalize the passes

Personalization happens on two pages you host, both keyed by the order token.

**The list page** shows every annual pass in the order, with a link for each pass that still
needs holder data:

```html
<go-annual-ticket-personalization token="ORDER_TOKEN"></go-annual-ticket-personalization>
```

Each pass renders as a `.go-annual-ticket` list. The link's target comes from
`urls.annualTicketPersonalizationForm(token, ticketSaleId)` and disappears once the pass is fully
personalized.

**The form page** collects the pass's start date plus the holder data for every personalization
on it. You supply **one** `<go-personalization-form>` template; the component clones it once per
holder (a pass covering three people renders your block three times):

```html
<go-annual-ticket-personalization-form token="ORDER_TOKEN" ticket-sale-id="123">
  <go-form form-id="ticketPersonalization" custom>
    <go-field key="startAt" required></go-field>

    <go-personalization-form>
      <go-form form-id="personalization" custom>
        <go-field key="firstName" required></go-field>
        <go-field key="lastName" required></go-field>
        <go-field key="dateOfBirth" required></go-field>
        <go-field key="email" required></go-field>
        <go-field key="confirmEmail" required></go-field>
      </go-form>
    </go-personalization-form>

    <go-submit>Submit personalizations</go-submit>
  </go-form>
</go-annual-ticket-personalization-form>
```

In a real page you read `token` and `ticket-sale-id` from your route (they are the two arguments
your `urls.annualTicketPersonalizationForm` builder received) and set them as attributes, like the
`<go-order>` snippet above.

When the pass requires a photo, add a file field `<go-field key="photo" required>` inside
`<go-personalization-form>` — one photo is uploaded per holder and the submit is blocked until
every required photo is present. After a successful submit the form navigates to
`urls.annualTicketPersonalizationFormSubmit(token)` — point it back at the list page so the buyer
sees the remaining passes.

See **Components / Annual Ticket Personalization** for the full field list, styling hooks, and
translation keys.

## Wiring the pages together

The flow spans several pages of your site; the components find them through the URL builders you
set with `go.config({ urls: { … } })`:

| URL builder                                            | Used by                                               | Points at                  |
| ------------------------------------------------------ | ----------------------------------------------------- | -------------------------- |
| `checkoutSuccess(token)`                               | checkout redirect after payment                       | your confirmation page     |
| `annualTicketPersonalizationList(token)`               | annual rows in `<go-order-breakdown>`                 | your personalization list  |
| `annualTicketPersonalizationForm(token, ticketSaleId)` | per-pass link in `<go-annual-ticket-personalization>` | your personalization form  |
| `annualTicketPersonalizationFormSubmit(token)`         | the form, after a successful submit                   | back to the list (usually) |

```js
go.config({
  urls: {
    checkoutSuccess: token => `/checkout/success?token=${token}`,
    annualTicketPersonalizationList: token => `/passes/personalize?token=${token}`,
    annualTicketPersonalizationForm: (token, ticketSaleId) =>
      `/passes/personalize/form?token=${token}&ticket_sale_id=${ticketSaleId}`,
    annualTicketPersonalizationFormSubmit: token => `/passes/personalize?token=${token}`,
  },
})
```

Unset builders fall back to the legacy gomus shop paths — always set them when the flow runs on
your own pages.

## Related docs

- **Components / Ticket Selection / Filters / ticket:annual** — the filter
- **Components / Ticket Selection** — selection markup and attributes
- **Components / Cart**, **Components / Checkout Form** — cart and checkout
- **Components / Order** — the confirmation page
- **Components / Annual Ticket Personalization** — list and form components in detail
- **The Go Interface** — `go.config` URL builders and `go.cart.addItem`
