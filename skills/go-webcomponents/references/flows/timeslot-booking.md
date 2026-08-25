# Timeslot booking

The timed-entry purchase flow: the visitor picks a date, then an entry time, then
ticket quantities, and adds everything to the cart. The `ticket:timeslot` filter
drives it — it sells your shop's timeslot admission tickets. For timed entry
scoped to a single event, see [Timed entry for an event](#timed-entry-for-an-event).

## The steps

| Step          | Component                 | Appears when                              |
| ------------- | ------------------------- | ----------------------------------------- |
| 1. Date       | `<go-calendar>`           | always                                    |
| 2. Entry time | `<go-timeslots>`          | a date is selected                        |
| 3. Quantities | `<go-tickets>`            | a date **and** a timeslot are selected    |
| 4. Add        | `<go-add-to-cart-button>` | always (disabled until a quantity is > 0) |

Everything sits inside one `<go-ticket-selection filters="ticket:timeslot">`. It
holds the shared state — selected date, selected timeslot, chosen quantities — that
the steps read and write. `<go-timeslots>` and `<go-tickets>` render nothing until
their step applies, so you can leave them in the markup unconditionally; use
`<go-if>` with the selection's visibility handles only to gate your own surrounding
markup (headings, hints).

## Full page

A complete booking page. The `<head>` snippet initializes the library once per page
(see **The Go Interface** for the loader in detail); the body is the flow:

```html
<!doctype html>
<html>
  <head>
    <script>
      ;(function (w) {
        let _queue = []
        let stub = method => options => _queue.push({ method, options })
        let go = {
          _queue,
          init: stub('init'),
          config: stub('config'),
          cart: { addItem: stub('cart.addItem') },
        }
        go.load = function (options) {
          var s = document.createElement('script')
          s.src =
            window._go_src ??
            'https://unpkg.com/@gomusdev/web-components@' + options.version + '/dist-js/gomus-webcomponents.iife.js'
          document.head.appendChild(s)
        }
        window.go = go
      })(window)

      go.load({ version: 'latest' }) // pin a version in production

      go.init({
        shop: 'your-shop-id',
        api: 'api.gomus.de',
        locale: 'en',
      })
    </script>
  </head>
  <body>
    <go-ticket-selection filters="ticket:timeslot">
      <go-if when="data.ticketSelection.isCalendarVisible" then="show">
        <h2>Choose a date</h2>
        <go-calendar></go-calendar>
      </go-if>

      <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
        <h2>Choose a time</h2>
        <go-timeslots></go-timeslots>
      </go-if>

      <go-if when="data.ticketSelection.isTicketsVisible" then="show">
        <h2>Choose your tickets</h2>
        <go-tickets>
          <!-- the segment inherits ticket:timeslot from the selection -->
          <go-ticket-segment>
            <go-ticket-segment-body></go-ticket-segment-body>
            <go-ticket-segment-sum></go-ticket-segment-sum>
          </go-ticket-segment>
        </go-tickets>
        <go-tickets-empty>
          <p>No tickets available for the selected date and time.</p>
        </go-tickets-empty>
        <go-add-to-cart-button></go-add-to-cart-button>
      </go-if>
    </go-ticket-selection>
  </body>
</html>
```

`<go-tickets-empty>` renders its children only when the ticket step has nothing to
show; placing it inside the `isTicketsVisible` gate limits it to the "this time has
no tickets" case.

## How the steps chain

- Picking a date loads the entry times for that day and reveals `<go-timeslots>`.
  Changing the date clears the timeslot selection.
- When a date offers exactly one usable slot, it is selected automatically — the
  visitor skips a redundant click. A lone slot that is sold out stays unselected.
- Picking a timeslot loads the tickets available at that time into `<go-tickets>`.
- Each step announces itself with a bubbling event you can listen for on the
  enclosing `<go-ticket-selection>` — useful for analytics or scrolling the next
  step into view:

```js
const selection = document.querySelector('go-ticket-selection')
selection.addEventListener('go-date-select', e => console.log('date', String(e.detail.selected)))
selection.addEventListener('go-timeslot-select', e => console.log('time', e.detail.selected))
```

## Sold-out handling

Capacity is enforced live, per timeslot:

- Sold-out slots stay visible but disabled — `.go-timeslot.is-sold-out` /
  `.go-timeslot.is-disabled` are the styling hooks.
- Each ticket row's quantity control is capped at the remaining capacity for the
  chosen time. Tickets already in the cart count against that cap, so a visitor
  cannot oversell by adding in two rounds.

## Cart handoff

`<go-add-to-cart-button>` is disabled until at least one quantity is above zero.
Clicking it moves every chosen quantity into the shared cart and resets the
selection's quantity controls to zero, ready for another date or time.

By default the page stays where it is. To send the visitor to your cart page after
adding, configure the cart URL:

```js
go.config({
  urls: {
    cart: () => '/cart.html',
  },
})
```

The cart persists across pages, so a `<go-cart>` on a separate page shows the added
tickets, and a `<go-cart-counter>` in your site header updates as items are added —
see **Components / Cart**.

## Pre-selecting date and time

Deep-link into the flow by setting the selection's `selected-date` and
`selected-timeslot` attributes — e.g. from a campaign landing page:

```html
<go-ticket-selection filters="ticket:timeslot" selected-date="2026-07-01" selected-timeslot="2026-07-01T11:00:00+02:00">
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

`selected-timeslot` stays in sync with the live selection, so you can also read the
visitor's current choice back from the element.

## Narrowing the offer

By default the flow lists every bookable timeslot ticket in the shop. Scope it
with the selection's filter attributes: `museum-ids`, `exhibition-ids`,
`ticket-ids`, `ticket-group-ids` (all comma-separated) — see
**Components / Ticket Selection** for details.

```html
<go-ticket-selection filters="ticket:timeslot" ticket-group-ids="12"> ... </go-ticket-selection>
```

## Timed entry for an event

The same date → time → tickets flow, restricted to one event's timed-admission
tickets: use the `event:admission:timeslot` filter with `event-ids`. The markup is
identical apart from the filter name:

```html
<go-ticket-selection filters="event:admission:timeslot" event-ids="263">
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

- `events:admission:timeslot` is the multi-event variant (omit `event-ids` or list
  several).
- An event that sells both day and timed tickets can combine
  `event:admission:day, event:admission:timeslot` in two segments — see the
  `event:admission:timeslot` filter documentation for the combined pattern.

## Related docs

- **Components / Ticket Selection** — the `<go-ticket-selection>` container, its attributes and filter list
- **Components / Calendar** — date picking, availability overrides, styling hooks
- **Components / Timeslots** — the time picker, `go-timeslot-select`, auto-selection
- **Components / Ticket Selection / Tickets** — ticket rows, segments, quantity controls, bundles
- The `ticket:timeslot` and `event:admission:timeslot` filter pages under
  **Components / Ticket Selection / Filters**
- **Flows / Cart & Checkout** — what happens after the handoff
