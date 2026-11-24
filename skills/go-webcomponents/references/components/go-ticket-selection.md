# `<go-ticket-selection>`

Since `v1.0.0`

The `go-ticket-selection` component wraps all scenarios of selecting a ticket.

## Examples

```html
<go-ticket-selection filters="ticket:timeslot">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <h2>Calendar</h2>
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <h2>Timeslots</h2>
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <h2>Tickets</h2>
    <go-tickets>
      <!-- segment inherits filters from <go-ticket-selection> when filters attr is omitted -->
      <go-ticket-segment>
        <go-ticket-segment-body></go-ticket-segment-body>
        <div class="sum-container">
          <h4>Sum</h4>
          <h4>
            <go-ticket-segment-sum></go-ticket-segment-sum>
          </h4>
        </div>
      </go-ticket-segment>
      <div class="sum-container">
        <h3>Total for all tickets</h3>
        <h3>
          <go-tickets-sum></go-tickets-sum>
        </h3>
      </div>
    </go-tickets>

    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

With a seating plan instead of the price list (a seated event date). Visitors pick seats in the plan. The sum, the empty state and the add-to-cart button work with the picked seats:

```html
<go-ticket-selection filters="event:price" event-ids="280">
  <go-seating-plan event-id="280" date-id="3788"></go-seating-plan>
  <go-tickets-empty><p>There are no seats for this date.</p></go-tickets-empty>
  <p>Selected: <go-tickets-sum></go-tickets-sum></p>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

A group tour booking. `tour-id` names the tour; the visitor chooses the headcount, the language, a
day and a start time, sees the prices and adds the booking to the cart — see _Group tours_ below:

```html
<go-ticket-selection filters="tour" tour-id="188">
  <go-participants></go-participants>
  <go-select data="tour:language"></go-select>
  <go-select data="tour:age-group"></go-select>
  <go-select data="tour:grade"></go-select>
  <go-calendar></go-calendar>
  <go-tour-timeslots></go-tour-timeslots>
  <go-tour-prices></go-tour-prices>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

## Attributes

| Attribute           | Type   | Default | Description                                                            | Since     |
| ------------------- | ------ | ------- | ---------------------------------------------------------------------- | --------- |
| `filters`           | string | —       | **Required.** Comma-separated list of filters to apply (see below)     |           |
| `event-ids`         | string | —       | Comma-separated event IDs to filter by — required by `event:*` filters | `v1.21.0` |
| `museum-ids`        | string | —       | Comma-separated museum IDs to filter by                                |           |
| `exhibition-ids`    | string | —       | Comma-separated exhibition IDs to filter by                            |           |
| `ticket-ids`        | string | —       | Comma-separated ticket IDs to include                                  |           |
| `ticket-group-ids`  | string | —       | Comma-separated ticket group IDs to include                            | `v1.4.0`  |
| `selected-date`     | string | —       | Pre-selects a date (`YYYY-MM-DD`); reflected — see below               | `v1.22.0` |
| `selected-timeslot` | string | —       | Pre-selects a timeslot (ISO datetime); reflected — see below           | `v1.25.0` |
| `tour-id`           | string | —       | The group tour to book — required by the `tour` filter; see below      | `v4.35.0` |

The element also exposes a read-only
[`details`](https://app.unpkg.com/@gomusdev/web-components/files/dist-js/components/ticketSelection/lib.svelte.d.ts)
property — the live selection state, the same object `<go-if>` sees as `data.ticketSelection`.

### filters

Comma-separated filter names that determine which selection flow runs and which tickets are shown.
Each filter declares its calendar/timeslot/ticket visibility, what it loads, and which fields it requires.

Available filter names:

| Name                        | Calendar source | Description                                                                                                                           |
| --------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `ticket:timeslot`           | tickets         | Timeslot tickets (timed entry). Calendar + timeslots required, then tickets shown.                                                    |
| `ticket:day`                | tickets         | Day tickets — valid all day. Calendar required, no timeslots.                                                                         |
| `ticket:annual`             | —               | Annual tickets. No calendar, tickets shown directly.                                                                                  |
| `ticket:flex`               | —               | Flex tickets — no date or entry time. No calendar, tickets shown directly. _(Since `v4.28.0`)_                                        |
| `event:admission`           | events          | Single event admission tickets, all types combined. Requires `event-ids`.                                                             |
| `event:admission:day`       | events          | Single event, day admission tickets only (valid all day). Calendar, no timeslot.                                                      |
| `event:admission:timeslot`  | events          | Single event, timed-entry admission tickets only. Calendar + timeslot.                                                                |
| `event:price`               | events          | Single event, any price type (flat or scaled). Requires `event-ids` and a `date-id` on the segment.                                   |
| `events:admission`          | events          | Multiple events, each event's admission tickets. Calendar + timeslot + tickets all visible.                                           |
| `events:admission:day`      | events          | Multiple events, day admission tickets only (valid all day).                                                                          |
| `events:admission:timeslot` | events          | Multiple events, timed-entry admission tickets only.                                                                                  |
| `events:price`              | events          | Multiple events, any price type. Calendar + timeslot + tickets all visible.                                                           |
| `events:price:day`          | events          | Multiple events on the chosen day, any price type. Calendar, no timeslot; pairs with `ticket:day`. _(Since `v4.36.0`)_             |
| `coupon`                    | —               | Purchasable gift-card coupons (fixed value), listed directly — no calendar or timeslots. _(Since `v3.6.0`)_                           |
| `tour`                      | tour            | A group tour booking. Requires `tour-id`; uses the tour components instead of `<go-tickets>` — see _Group tours_. _(Since `v4.35.0`)_ |

The `ticket:*` filters and `tour` can also add to the cart programmatically via
`go.cart.addItem({ filter, … })` — see **The Go Interface** doc. _(Since `v4.14.0`)_

### Segment filters and inheritance

The `filters` attribute on `<go-ticket-segment>` is **optional**. When omitted (or empty), the segment
inherits the filter list from its parent `<go-ticket-selection>` and runs all of them. Set it explicitly
only when you want a segment to be a _subset_ of the selection's filters.

Multiple filters may be passed comma-separated; each runs and their results merge into the segment's
ticket list.

```html
<!-- Inherits ticket:timeslot from the selection — no filters attr needed -->
<go-ticket-selection filters="ticket:timeslot">
  <go-tickets>
    <go-ticket-segment>
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
</go-ticket-selection>

<!-- Multi-filter selection: segment overrides which filter runs there -->
<go-ticket-selection filters="event:admission, event:price" event-ids="74">
  <go-tickets>
    <go-ticket-segment filters="event:admission">…</go-ticket-segment>
    <go-ticket-segment filters="event:price" date-id="3788">…</go-ticket-segment>
  </go-tickets>
</go-ticket-selection>

<!-- Split admission by ticket kind: day tickets render once a date is picked,
     timed-entry tickets fill in once a slot is picked -->
<go-ticket-selection filters="event:admission:day, event:admission:timeslot" event-ids="263">
  <go-tickets>
    <h3>Day tickets</h3>
    <go-ticket-segment filters="event:admission:day">…</go-ticket-segment>
    <h3>Timed entry</h3>
    <go-ticket-segment filters="event:admission:timeslot">…</go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

See **Components / Ticket Selection / Filters / Overview** for the full filter list and combined patterns,
and the per-filter stories under that group for working examples of each one.

### eventIds

Optional comma-separated string. Required by `event:*` filters. When provided, only tickets associated with these events will be shown.

### museumIds

Optional comma-separated string of museum IDs (e.g., `"1,2,3"`). When provided, only tickets associated with these museums will be shown.

### exhibitionIds

Optional comma-separated string of exhibition IDs (e.g., `"1,2,3"`). When provided, only tickets associated with these exhibitions will be shown.

### ticketIds

Optional comma-separated string of specific ticket IDs (e.g., `"10,20,30"`). When provided, only these specific tickets will be available for selection.

### ticketGroupIds

Optional comma-separated string of specific ticket group IDs (e.g., `"10,20,30"`). When provided, only these specific tickets from those ticket groups will be available for selection.

### tourId

The id of the group tour to book, a positive integer (e.g. `"188"`). Used with `filters="tour"`.
Anything else is ignored with a console warning, and without a tour the tour components and the
calendar render nothing.

### selectedDate

Optional date string (`YYYY-MM-DD`, e.g. `"2026-05-20"`). When provided, that date is pre-selected
and the selection behaves as if the visitor had picked it in `<go-calendar>`: a nested calendar
opens at that date's month with the day shown as selected, follows later changes to the attribute,
and keeps a `selected-timeslot` you provide alongside it. _(Calendar preselection since
`v4.20.1`.)_ The attribute is reflected: it updates when the visitor picks a day, so you can
read the current date from the element via `el.getAttribute('selected-date')`.

### selectedTimeslot

Optional timeslot id (ISO datetime, e.g. `"2026-07-01T14:00:00+02:00"`). When provided, that
timeslot is pre-selected. The attribute is reflected: it stays in sync with the live selection —
it updates when the visitor picks a slot and clears when they change the day — so you can read the
current timeslot directly from the element via `el.getAttribute('selected-timeslot')`.

## Events

The events originate in the subcomponents and bubble, so you can listen for them on
`<go-ticket-selection>` itself:

| Event                  | Description                                                                                      | `detail`                                                                                                        | bubbles |
| ---------------------- | ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------- | ------- |
| `go-date-select`       | The selected date changes; also fires once on load, before anything is selected                  | `{ selected }` — the picked date, `undefined` before the first selection; `String(selected)` gives `YYYY-MM-DD` | yes     |
| `go-timeslot-select`   | A timeslot becomes selected — by a click, or auto-selected when the date's only slot is bookable | `{ selected }` — the chosen slot's start time as an ISO 8601 string                                             | yes     |
| `go-tour-price-change` | The prices of a group tour booking changed — see `<go-tour-prices>` _(Since `v4.35.0`)_          | `{ totalPriceCents, quantities, surcharges }`                                                                   | yes     |

```js
document
  .querySelector('go-ticket-selection')
  .addEventListener('go-date-select', e => console.log(String(e.detail.selected)))
```

## Styling

The element renders no markup of its own — the visible parts come from its subcomponents, which
document their own hooks. Its state attributes (`selected-date`, `selected-timeslot`, `filters`)
are reflected, so attribute selectors work on the element itself:

```css
/* dim the selection until a date is picked */
go-ticket-selection:not([selected-date]) {
  opacity: 0.9;
}
```

## Nesting

Standalone — no required parent.

## Subcomponents

- `<go-calendar>`
- `<go-timeslots>`
- `<go-tickets>` (with `<go-ticket-segment>`, `<go-ticket-segment-body>`, `<go-ticket-segment-sum>`, `<go-tickets-sum>`)
- `<go-add-to-cart-button>`
- `<go-participants>`, `<go-select>`, `<go-tour-timeslots>`, `<go-tour-prices>`: the parts of a group tour booking — see _Group tours_. _(Since `v4.35.0`)_
- `<go-seating-plan>`: a seat map for a seated event date, used in place of `<go-tickets>`. Picked seats count for `<go-tickets-sum>` and `<go-add-to-cart-button>`, and `<go-tickets-empty>` shows when the date has no seats. _(Since `v4.34.0`)_

## Conditional rendering with `<go-if>`

The selection exposes its state as `data.ticketSelection`, so `<go-if>` can gate each step — that
is the pattern shown in the example above. Useful handles:

- `data.ticketSelection.isCalendarVisible` / `isTimeslotsVisible` / `isTicketsVisible` — whether the active filters call for that step right now
- `data.ticketSelection.selectedDate` / `selectedTimeslot` — the visitor's current picks

```html
<go-if when="data.ticketSelection.selectedDate && data.ticketSelection.selectedTimeslot">
  <p>Almost there — pick your tickets below.</p>
</go-if>
```

## Group tours

Since `v4.35.0`

With `filters="tour"` and a `tour-id`, the selection books one group tour. A tour has no ticket
list: the booking is put together from these parts, each documented on its own page. A `tour-id`
without the `tour` filter is ignored, with a console warning: such a selection sells its tickets
as before.

A tour is booked on its own. Next to `tour` every other filter in `filters` is ignored
(`filters="tour, ticket:day"` is a tour selection), and tickets listed by a `<go-ticket-segment>`
inside it are not added to the cart. To sell tickets on the same page, put them in a second
`<go-ticket-selection>`.

| Component                 | What the visitor does there                                            |
| ------------------------- | ---------------------------------------------------------------------- |
| `<go-participants>`       | chooses the headcount, within the tour's smallest and largest group    |
| `<go-select>`             | chooses the language, the age group and the school class               |
| `<go-calendar>`           | picks a day the tour has a start time on                               |
| `<go-tour-timeslots>`     | picks one of the day's start times                                     |
| `<go-tour-prices>`        | sees the prices, splits the group over them, takes optional surcharges |
| `<go-add-to-cart-button>` | adds the booking to the cart                                           |

- **Each choice narrows the next.** The calendar and the start times follow the headcount and the
  picked language; the prices follow all four choices and are asked for again when one changes.
- **The booking goes into the cart as one line** with its total, like one added with
  `go.cart.addItem({ filter: 'tour', … })`. The cart line and the order page name the headcount,
  the start, the language, age group and school class, and the surcharges the visitor took.
- **Afterwards the start time is cleared**, and so are the split over the prices and the optional
  surcharges. The headcount and the selects are kept, so the visitor can book the same tour for
  another start time.
- **Leave out what you don't need.** A part you leave off the page is not asked for — apart from the
  language select for a tour with several languages, and `<go-tour-prices>` for a tour with several
  prices per person, which the visitor needs to split the group.

The headcount is `data.ticketSelection.participants` in `<go-if>`, next to `selectedDate` and
`selectedTimeslot`.

## `<go-add-to-cart-button>`

Since `v1.0.0`

The button that completes the selection. It stays disabled until at least one ticket in the
selection has a quantity above zero, or a seat is picked in `<go-seating-plan>`. Clicking it moves
every selected ticket and picked seat into the cart, resets all quantities in the selection back to
zero, and — if you configured
`go.config({ urls: { cart: () => '…' } })` — navigates to your cart page. Must be placed inside
`<go-ticket-selection>`.

```html
<go-add-to-cart-button></go-add-to-cart-button>
```

A time-slot ticket can be bought until its entry window ends (slot start plus the ticket's entry
duration). A slot stays on the page after that, for example when the page was left open, and an
order on it would be refused. So the click checks the picked slot against the visitor's clock: once
the window has ended, nothing goes into the cart (other tickets selected alongside it included),
the cart page is not opened and an error shows under the button (`.go-add-to-cart-error`,
translation key `timeslots.ended`). Screen readers announce it, again on every refused click. The
selection is left as it is: the quantities are kept, and the slot stays selected and stays listed
in `<go-timeslots>`, so the visitor has to pick another slot. The error goes away when the visitor
picks another time slot or clicks the button again. Day, annual and flex tickets have no entry
window and are added as before. The check trusts the device's clock: with a wrong clock it can let
an ended slot through (the order is then refused) or refuse a slot that is still open.
_(Since `v4.34.1`)_

An event price, or a seat of a seating plan, is checked in the same way against the start of its
event date. The event dates on the page are loaded once, so a page that was left open can still show
a date that has started since. Once the date has started, the click adds nothing (other tickets
selected alongside it included), the cart page is not opened and the error shows under the button
(translation key `events.started`). The selection is left as it is. The error goes away when the
visitor clicks the button again or picks another time slot.
_(Since `v4.36.1`)_

For a group tour (`filters="tour"`) the button works on the booking instead _(Since `v4.35.0`)_:

- It is enabled once a start time is picked, and disabled again when the booking cannot be made: the
  prices could not be loaded, the split over the prices per person does not add up, the tour has
  no language, or it has several and the page has no `<go-select data="tour:language">`.
- A click with a blank `<go-select>` adds nothing. Each blank select shows its error, and the focus
  moves to the first one.
- A click while prices are still loading — for example right after the visitor picked a language —
  is not lost: the booking is added once the new prices have arrived, with those prices.
- A click on a start time that has passed while the page stood open adds nothing and shows the
  error of an ended time slot (`timeslots.ended`), judged by the visitor's clock.
- A booking the cart refuses adds nothing either. The start time stays picked and an error shows
  under the button (translation key `tour.booking.failed`); the reason is in the console.
- After the booking is added, the start time, the split and the optional surcharges are cleared.

It renders a `<button data-add-to-cart-button>` followed by a
`<div class="go-add-to-cart-error-live" role="alert">`. That div is always there and empty until an
error shows; then it holds an unstyled `<p class="go-add-to-cart-error">`. Keep the div rendered (no
`display: none`): screen readers announce a message most reliably when it arrives in a region that
was already on the page. Style the inactive state via the standard `[disabled]` attribute:

```css
go-add-to-cart-button button[data-add-to-cart-button][disabled] {
  opacity: 0.5;
}

go-add-to-cart-button .go-add-to-cart-error {
  color: #b00020;
}
```

The label comes from the `common.actions.cart` translation key (default: "Add to cart"), the error
text from `timeslots.ended` (default: "This time slot is no longer available. Please choose another
one."), from `events.started` for an event date that has started (default: "This event has already
started. Please choose another one." _(Since `v4.36.1`)_) or, for a group tour the cart refused,
from `tour.booking.failed` (default: "The tour could not be added to the cart. Please try again."
_(Since `v4.35.0`)_). All ship English and German
defaults; your shop's own translations override them.
