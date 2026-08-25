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

The element also exposes a read-only
[`details`](https://app.unpkg.com/@gomusdev/web-components/files/dist-js/components/ticketSelection/lib.svelte.d.ts)
property — the live selection state, the same object `<go-if>` sees as `data.ticketSelection`.

### filters

Comma-separated filter names that determine which selection flow runs and which tickets are shown.
Each filter declares its calendar/timeslot/ticket visibility, what it loads, and which fields it requires.

Available filter names:

| Name                        | Calendar source | Description                                                                                                 |
| --------------------------- | --------------- | ----------------------------------------------------------------------------------------------------------- |
| `ticket:timeslot`           | tickets         | Timeslot tickets (timed entry). Calendar + timeslots required, then tickets shown.                          |
| `ticket:day`                | tickets         | Day tickets — valid all day. Calendar required, no timeslots.                                               |
| `ticket:annual`             | tickets         | Annual tickets. No calendar, tickets shown directly.                                                        |
| `event:admission`           | events          | Single event admission tickets, all types combined. Requires `event-ids`.                                   |
| `event:admission:day`       | events          | Single event, day admission tickets only (valid all day). Calendar, no timeslot.                            |
| `event:admission:timeslot`  | events          | Single event, timed-entry admission tickets only. Calendar + timeslot.                                      |
| `event:price`               | events          | Single event, any price type (flat or scaled). Requires `event-ids` and a `date-id` on the segment.         |
| `events:admission`          | events          | Multiple events, each event's admission tickets. Calendar + timeslot + tickets all visible.                 |
| `events:admission:day`      | events          | Multiple events, day admission tickets only (valid all day).                                                |
| `events:admission:timeslot` | events          | Multiple events, timed-entry admission tickets only.                                                        |
| `events:price`              | events          | Multiple events, any price type. Calendar + timeslot + tickets all visible.                                 |
| `coupon`                    | —               | Purchasable gift-card coupons (fixed value), listed directly — no calendar or timeslots. _(Since `v3.6.0`)_ |

The `ticket:*` filters can also add a ticket to the cart programmatically via
`go.cart.addItem({ filter, … })` — see **The Go Interface** doc. One extra filter name, `tour`,
exists solely for that programmatic path (group-tour bookings): it lists nothing inside a ticket
selection, so don't use it in the `filters` attribute. _(Since `v4.14.0`)_

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

Both events originate in the subcomponents and bubble, so you can listen for them on
`<go-ticket-selection>` itself:

| Event                | Description                                                                                      | `detail`                                                                                                        | bubbles |
| -------------------- | ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------- | ------- |
| `go-date-select`     | The selected date changes; also fires once on load, before anything is selected                  | `{ selected }` — the picked date, `undefined` before the first selection; `String(selected)` gives `YYYY-MM-DD` | yes     |
| `go-timeslot-select` | A timeslot becomes selected — by a click, or auto-selected when the date's only slot is bookable | `{ selected }` — the chosen slot's start time as an ISO 8601 string                                             | yes     |

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

## `<go-add-to-cart-button>`

Since `v1.0.0`

The button that completes the selection. It stays disabled until at least one ticket in the
selection has a quantity above zero. Clicking it moves every selected ticket into the cart, resets
all quantities in the selection back to zero, and — if you configured
`go.config({ urls: { cart: () => '…' } })` — navigates to your cart page. Must be placed inside
`<go-ticket-selection>`.

```html
<go-add-to-cart-button></go-add-to-cart-button>
```

It renders a single `<button data-add-to-cart-button>`; style the inactive state via the standard
`[disabled]` attribute:

```css
go-add-to-cart-button button[data-add-to-cart-button][disabled] {
  opacity: 0.5;
}
```

The label comes from the `common.actions.cart` translation key (default: "Add to basket").
