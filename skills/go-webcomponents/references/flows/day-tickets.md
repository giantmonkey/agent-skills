# Day tickets

Sell all-day admission: the visitor picks a date in a calendar, sets quantities, and adds the
tickets to the cart — no timeslot involved. The flow is driven by the `ticket:day` filter on
`<go-ticket-selection>`.

## Building blocks

| Component                                    | Role                                                             |
| -------------------------------------------- | ---------------------------------------------------------------- |
| `<go-ticket-selection filters="ticket:day">` | Wraps the flow and holds the selected date                       |
| `<go-calendar>`                              | Date picker — availability reflects the day tickets on sale      |
| `<go-tickets>` + `<go-ticket-segment>`       | Lists the tickets valid on the picked date, one quantity per row |
| `<go-add-to-cart-button>`                    | Moves the selection into the cart                                |
| `<go-if>`                                    | Reveals each step only once it applies                           |

## The complete flow

Load the library and initialize it once per page (see **The Go Interface**), then:

```html
<go-ticket-selection filters="ticket:day">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <h2>Choose a date</h2>
    <go-calendar></go-calendar>
  </go-if>

  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <h2>Choose your tickets</h2>
    <go-tickets>
      <go-ticket-segment filters="ticket:day">
        <go-ticket-segment-body></go-ticket-segment-body>
        <go-ticket-segment-sum></go-ticket-segment-sum>
      </go-ticket-segment>
    </go-tickets>
    <go-tickets-empty>
      <p>No tickets available for this date.</p>
    </go-tickets-empty>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

The segment's `filters` attribute may be omitted — it then inherits `ticket:day` from the
selection. Set it explicitly only when the selection runs several filters and the segment
should be a subset.

## How the flow behaves

- The calendar shows availability for the day tickets on sale — dates without any are not
  selectable. With `ticket:day` the calendar is always visible and timeslots never are.
- The ticket list stays hidden until a date is picked: `data.ticketSelection.isTicketsVisible`
  flips to `true` with the first selected date, and the list reloads whenever the date changes.
- Only tickets valid on the picked date are listed; a ticket sold out for that date is dropped
  from the list entirely. When nothing is available, `<go-tickets-empty>` shows your fallback
  content instead.
- `<go-add-to-cart-button>` stays disabled until at least one quantity is above `0`. Clicking
  it copies the selection into the cart, resets all quantities to `0`, and — when you
  configured `go.config({ urls: { cart: () => '…' } })` — navigates to your cart page. Its
  label comes from the `common.actions.cart` translation key.

## Variations

Fixed date — no calendar. Preselect the date with `selected-date` (`YYYY-MM-DD`) and drop the
calendar; the tickets render immediately:

```html
<go-ticket-selection filters="ticket:day" selected-date="2026-12-24">
  <go-tickets>
    <go-ticket-segment>
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Narrow the offer. `museum-ids`, `exhibition-ids`, `ticket-ids`, and `ticket-group-ids` on
`<go-ticket-selection>` limit both the calendar's availability and the listed tickets
(comma-separated IDs). A segment may override `museum-ids` / `ticket-group-ids` for its own
rows:

```html
<go-ticket-selection filters="ticket:day" museum-ids="1,2" ticket-group-ids="7">
  <go-calendar></go-calendar>
  <go-tickets>
    <go-ticket-segment>
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Day and timed tickets side by side. Run several filters on one selection and give each segment
its own — the calendar serves both, the timeslot picker appears only for the timeslot filter:

```html
<go-ticket-selection filters="ticket:day, ticket:timeslot">
  <go-calendar></go-calendar>
  <go-timeslots></go-timeslots>
  <go-tickets>
    <h3>Day tickets</h3>
    <go-ticket-segment filters="ticket:day">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
    <h3>Timed entry</h3>
    <go-ticket-segment filters="ticket:timeslot">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

## Cart handoff

The button only fills the cart — render the cart itself with `<go-cart>`, usually on its own
page that `go.config({ urls: { cart } })` points to:

```html
<go-cart>
  <go-cart-items></go-cart-items>
  <go-cart-total-amount></go-cart-total-amount>
  <go-submit>To Payment</go-submit>
</go-cart>
<go-cart-empty>
  <p>Your cart is empty.</p>
</go-cart-empty>
```

`<go-cart-counter>` is standalone — drop it in your site header as a live item-count badge.
See **Components / Cart** for the full cart and checkout markup.

## Adding day tickets from your own UI

When you build the date/ticket picker yourself, skip the selection markup and book directly
with `go.cart.addItem` — the same `ticket:day` rules apply (price and availability come from
the backend; sold-out or over-capacity requests reject; identical lines merge):

```js
const uuid = await go.cart.addItem({
  filter: 'ticket:day',
  id: 351,
  quantity: 2,
  date: '2026-12-24',
})
```

See **The Go Interface** for queueing calls before the bundle loads and error handling.

## Related docs

- **Components / Ticket Selection / Filters / ticket:day** — the filter's reference page
- **Components / Ticket Selection** — all `<go-ticket-selection>` attributes
- **Components / Calendar** — styling hooks, `go-date-select`, `availability-override`
- **Flows / Timeslot Booking** — the same journey with an entry time
