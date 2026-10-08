# Ticket-selection filters

Filters drive what `<go-ticket-selection>` renders. Pass them via the `filters` attribute (comma-separated). The same value also flows down to `<go-ticket-segment filters="...">`.

"Conditional" means that picker appears once its prerequisite (Requires) is met.

| Filter | Calendar | Timeslots | Tickets | Requires |
| --- | --- | --- | --- | --- |
| `ticket:timeslot` | always | conditional | conditional | a selected date, a selected timeslot |
| `ticket:day` | always | conditional | conditional | a selected date |
| `ticket:annual` | conditional | conditional | always | — |
| `ticket:flex` | conditional | conditional | always | — |
| `event:admission` | always | conditional | conditional | the `event-ids` attribute, a selected date |
| `event:admission:day` | always | conditional | conditional | the `event-ids` attribute, a selected date |
| `event:admission:timeslot` | always | conditional | conditional | the `event-ids` attribute, a selected date, a selected timeslot |
| `event:price` | conditional | conditional | conditional | the `event-ids` attribute, a selected date |
| `events:admission` | always | always | always | a selected date, a selected timeslot |
| `events:admission:day` | always | always | always | a selected date, a selected timeslot |
| `events:admission:timeslot` | always | always | always | a selected date, a selected timeslot |
| `events:price` | always | always | always | a selected date, a selected timeslot |

## Filter details (from source documentation)

### `ticket:timeslot`

# `ticket:timeslot`

Sell timeslot tickets — visitor picks a date, a timeslot, then quantities.

**Use when:** your shop sells museum admission with a specific entry time (timed-entry tickets).

**Required attributes:**

- `selected-date` on `<go-ticket-selection>` — set when the visitor picks a date in `<go-calendar>`; the timeslot picker stays hidden until then.
- `selected-timeslot` on `<go-ticket-selection>` — set when the visitor picks an entry time in `<go-timeslots>`; ticket quantities render only after.

**Renders:** `<go-calendar>`, `<go-timeslots>`, `<go-tickets>`.

## Example

```html
<go-ticket-selection filters="ticket:timeslot">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="ticket:timeslot">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

## Scripted add to cart

Since `v4.14.0`

When you build the date and time pickers yourself, add a timeslot ticket straight to the cart. A `time` — the start of the chosen timeslot as a full ISO date-time — is required; sold-out or over-capacity requests reject:

```js
const uuid = await go.cart.addItem({
  filter: 'ticket:timeslot',
  id: 351,
  quantity: 2,
  time: '2026-12-24T14:30:00+01:00',
})
```

### `ticket:day`

# `ticket:day`

Sell day tickets — visitor picks a date, then quantities. Valid all day, no time slot.

**Use when:** your shop sells day-pass tickets without a specific entry time.

**Required attributes:**

- `selected-date` on `<go-ticket-selection>` — set when the visitor picks a date in `<go-calendar>`; tickets appear only after.

**Renders:** `<go-calendar>`, `<go-tickets>`.

## Example

```html
<go-ticket-selection filters="ticket:day">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="ticket:day">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

## Scripted add to cart

Since `v4.14.0`

When you build the date picker yourself, add a day ticket straight to the cart. A `date` is required; sold-out or over-capacity requests reject:

```js
const uuid = await go.cart.addItem({
  filter: 'ticket:day',
  id: 351,
  quantity: 2,
  date: '2026-12-24',
})
```

### `ticket:annual`

# `ticket:annual`

Sell annual tickets — no date or time picker, tickets are shown directly.

**Use when:** your shop sells annual passes (memberships, year tickets).

**Renders:** `<go-tickets>`.

The quantity is bounded only by the ticket's minimum and maximum persons — no quota or timeslot capacity applies. The maximum covers the whole cart line for that ticket, so the quantity stepper in `<go-ticket-segment>` offers only what's left after the quantity already in the cart. In `<go-cart>`, the line's own stepper still goes up to the full maximum. Bundle tickets (Mantelticket) are the exception: each add becomes its own cart line, so they always offer the full maximum.

## Example

```html
<go-ticket-selection filters="ticket:annual">
  <go-tickets>
    <go-ticket-segment filters="ticket:annual">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

## Scripted add to cart

Since `v4.14.0`

Add an annual ticket straight to the cart — no date or time needed. Unknown or non-bookable ticket IDs and non-positive quantities reject. Repeated calls for the same ticket merge into one cart line, and that line can't go above the ticket's maximum persons: a call whose quantity would push it past the maximum rejects with `only N left`, and the cart line stays as it was. A bundle ticket (Mantelticket) never merges — each call adds its own line, checked against the full maximum:

```js
const uuid = await go.cart.addItem({
  filter: 'ticket:annual',
  id: 351,
  quantity: 2,
})
```

### `ticket:flex`

# `ticket:flex`

Since `v4.28.0`

Sell flex tickets — tickets booked without a date or entry time. No calendar, no timeslots; tickets are shown directly.

**Use when:** your shop sells flex tickets (tickets with _Flex Ticket_ enabled in gomus).

**Renders:** `<go-tickets>`.

In a selection whose only filter is `ticket:flex`, `<go-calendar>` and `<go-timeslots>` render nothing. For `<go-if>`, `data.ticketSelection.isCalendarVisible` and `isTimeslotsVisible` stay `false`, and `isTicketsVisible` is `true` from the start, so a page template built for the dated filters works unchanged.

In the cart and in the order breakdown (`<go-order-breakdown>` inside `<go-order>`), a flex line shows its title with no date or time, and the order breakdown offers no iCal link for it.

Only `ticket:flex` offers flex tickets. `ticket:day` and all event-admission filters (`event:admission`, `events:admission` and their `:day` / `:timeslot` variants) leave them out. They also don't count towards a date's availability in the `ticket:day` calendar, so flex tickets alone never make a date look bookable.

## Example

```html
<go-ticket-selection filters="ticket:flex">
  <go-tickets>
    <go-ticket-segment filters="ticket:flex">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Narrowed to one museum's flex tickets, with per-ticket info buttons. `ticket:flex` honors `museum-ids`, `exhibition-ids`, `ticket-ids` and `ticket-group-ids` on `<go-ticket-selection>`, and `museum-ids` / `ticket-group-ids` on `<go-ticket-segment>` override the selection's:

```html
<go-ticket-selection filters="ticket:flex" museum-ids="11">
  <go-tickets>
    <go-ticket-segment filters="ticket:flex" with-content>
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Alongside day tickets, in a second segment. The calendar serves `ticket:day`. Flex tickets show right away, day tickets once a date is picked, and one `<go-add-to-cart-button>` adds both:

```html
<go-ticket-selection filters="ticket:day,ticket:flex">
  <go-calendar></go-calendar>
  <go-tickets>
    <go-ticket-segment filters="ticket:day">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
    <go-ticket-segment filters="ticket:flex">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Picking or changing the date reloads every segment of the selection, so flex quantities the visitor chose before that reset to `0`. To keep them, give `ticket:flex` its own `<go-ticket-selection>` and `<go-add-to-cart-button>`.

## Scripted add to cart

Add a flex ticket straight to the cart — no date or time. The call rejects with `not available` when the ID is unknown, not bookable, or not a flex ticket (add dated tickets with `ticket:day` or `ticket:timeslot`):

```js
const uuid = await go.cart.addItem({
  filter: 'ticket:flex',
  id: 475,
  quantity: 2,
})
```

### `event:admission`

# `event:admission`

Sell admission tickets for a single event — visitor picks a date, a timeslot, then ticket types (Adult, Reduced, …).

**Use when:** you want to sell standard admission tickets attached to one specific event, regardless of `ticket_type`. For finer control split by type, use `event:admission:day` (day tickets) and/or `event:admission:timeslot` (timed-entry tickets) instead.

**Required attributes:**

- `event-ids` on `<go-ticket-selection>` — ID of the event whose admission tickets to sell.
- `selected-date` on `<go-ticket-selection>` — set when the visitor picks a date in `<go-calendar>`; timeslots and tickets only load once it is set.

**Renders:** `<go-calendar>`, `<go-timeslots>`, `<go-tickets>`.

## Example

```html
<go-ticket-selection filters="event:admission" event-ids="258">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="event:admission">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

### `event:admission:day`

# `event:admission:day`

Admission tickets attached to a single event, restricted to **day tickets** (valid all day, no fixed entry time).

**Use when:** the event sells admission tickets that are valid for the whole day. Pair with `event:admission:timeslot` in two segments when an event sells both kinds.

**Required attributes:**

- `event-ids` on `<go-ticket-selection>` — ID of the event.
- `selected-date` on `<go-ticket-selection>` — the visit date (`YYYY-MM-DD`). Set automatically when the visitor picks a date in `<go-calendar>`, or pre-set it to skip the calendar. No timeslot is needed.

**Ticket scope:** loads the event's admission tickets for the selected date, restricted to day tickets — timed-entry and annual tickets never appear here (use `event:admission:timeslot` for timed entry). Only currently bookable tickets are shown.

**Renders:** `<go-calendar>`, `<go-tickets>` (no `<go-timeslots>`).

## Example

```html
<go-ticket-selection filters="event:admission:day" event-ids="263">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="event:admission:day">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

### `event:admission:timeslot`

# `event:admission:timeslot`

Admission tickets attached to a single event, restricted to **timed-entry tickets** (tickets bound to a fixed entry time).

**Use when:** the event sells timed-admission tickets where the visitor picks a specific entry time. Pair with `event:admission:day` in two segments when the event sells both kinds.

**Required attributes:**

- `event-ids` on `<go-ticket-selection>` — ID of the event.
- `selected-date` on `<go-ticket-selection>` — set when the visitor picks a date in `<go-calendar>`.
- `selected-timeslot` on `<go-ticket-selection>` — set when the visitor picks an entry time in `<go-timeslots>`.

**Ticket scope:** only tickets attached to the event that are timed-entry — not day or annual tickets — and bookable on the selected date are offered.

The `<go-timeslots>` picker is scoped the same way — it only shows entry times for this event's timed tickets, not unrelated shop-wide timeslot tickets.

**Renders:** `<go-calendar>`, `<go-timeslots>`, `<go-tickets>`.

## Example

```html
<go-ticket-selection filters="event:admission:timeslot" event-ids="263">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="event:admission:timeslot">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

## Combined with day tickets

```html
<go-ticket-selection filters="event:admission:day, event:admission:timeslot" event-ids="263">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <h3>Day tickets</h3>
      <go-ticket-segment filters="event:admission:day">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
      <h3>Timed entry</h3>
      <go-ticket-segment filters="event:admission:timeslot">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

After the visitor picks a date the day-ticket segment renders immediately. The timeslot segment fills in once they pick a slot.

### `event:price`

# `event:price`

Sell tickets for one specific event-date when the date is already known (e.g. visitor came from an event list).

**Use when:** you already have an event ID and a date ID and want to render the ticket picker directly. Renders whatever the backend returns for that date — flat or scaled.

**Required attributes:**

- `event-ids` on `<go-ticket-selection>` — ID of the event.
- `date-id` on `<go-ticket-segment>` — ID of the chosen event-date.

**Renders:** `<go-tickets>`.

## Example

```html
<go-ticket-selection filters="event:price" event-ids="74">
  <go-tickets>
    <go-ticket-segment filters="event:price" date-id="3788">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

### `events:admission`

# `events:admission`

Multi-event listing showing each event's admission tickets for the selected date + time window.

**Use when:** the shop offers a "What's on today" listing where the events sell admission tickets (Adult, Reduced, …) rather than date-level scaled prices. For scaled / flat date-prices, use `events:price` instead. To split day vs timed admission tickets across two segments, use `events:admission:day` and `events:admission:timeslot`.

**Required attributes:**

- `selected-date` and `selected-timeslot` on `<go-ticket-selection>` — normally set when the visitor picks in `<go-calendar>` and `<go-timeslots>`; the timeslot also narrows the listing to event-dates starting within a 2-hour window after the selected time. Sold-out event-dates are skipped.

**Optional attributes:**

- `museum-ids`, `event-ids`, `exhibition-ids` on `<go-ticket-selection>` — limit the listing to specific museums, events, or exhibitions.
- `museum-ids` on `<go-ticket-segment>` — overrides the selection-level `museum-ids` for this segment.
- `language-ids`, `catch-word-ids` on `<go-ticket-segment>` — further narrow the listing.
- `limit` on `<go-ticket-segment>` — caps the number of event-dates fetched for the listing (default 30).

**Renders:** `<go-calendar>`, `<go-timeslots>`, `<go-tickets>`.

## Example

```html
<go-ticket-selection filters="events:admission" museum-ids="2">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="events:admission">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

### `events:admission:day`

# `events:admission:day`

Multi-event listing showing each event's **day admission tickets** for the selected date + time window. Same data flow as `events:admission`, but restricted to day (non-timed) admission tickets.

**Use when:** "What's on today" listing where events sell day tickets only. For mixed flows, pair with `events:admission:timeslot`.

**Required attributes:**

- `selected-date` and `selected-timeslot` on `<go-ticket-selection>` — normally set when the visitor picks in `<go-calendar>` and `<go-timeslots>`; the timeslot also narrows the listing to event-dates starting within a 2-hour window after the selected time. Sold-out event-dates are skipped.

**Optional attributes:**

- `museum-ids`, `event-ids`, `exhibition-ids` on `<go-ticket-selection>` — limit the listing to specific museums, events, or exhibitions.
- `museum-ids` on `<go-ticket-segment>` — overrides the selection-level `museum-ids` for this segment.
- `language-ids`, `catch-word-ids` on `<go-ticket-segment>` — further narrow the listing.
- `limit` on `<go-ticket-segment>` — caps the number of event-dates fetched for the listing (default 30).

**Renders:** `<go-calendar>`, `<go-timeslots>`, `<go-tickets>`.

## Example

```html
<go-ticket-selection filters="events:admission:day" museum-ids="2">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="events:admission:day">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

For a combined day + timed listing in one page, see `events:admission:timeslot`.

### `events:admission:timeslot`

# `events:admission:timeslot`

Multi-event listing showing each event's **timed admission tickets** — admission tickets bound to an entry time. Same data flow as `events:admission`, but restricted to timed tickets.

**Use when:** "What's on today" listing where events sell timed-entry tickets only. For mixed flows, pair with `events:admission:day`.

**Required attributes:**

- `selected-date` and `selected-timeslot` on `<go-ticket-selection>` — normally set when the visitor picks in `<go-calendar>` and `<go-timeslots>`; the timeslot also narrows the listing to event-dates starting within a 2-hour window after the selected time. Sold-out event-dates are skipped.

**Optional attributes:**

- `museum-ids`, `event-ids`, `exhibition-ids` on `<go-ticket-selection>` — limit the listing to specific museums, events, or exhibitions.
- `museum-ids` on `<go-ticket-segment>` — overrides the selection-level `museum-ids` for this segment.
- `language-ids`, `catch-word-ids` on `<go-ticket-segment>` — further narrow the listing.
- `limit` on `<go-ticket-segment>` — caps the number of event-dates fetched for the listing (default 30).

**Renders:** `<go-calendar>`, `<go-timeslots>`, `<go-tickets>`.

## Example

```html
<go-ticket-selection filters="events:admission:timeslot" museum-ids="2">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="events:admission:timeslot">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

## Combined with day tickets

```html
<go-ticket-selection filters="events:admission:day,events:admission:timeslot" museum-ids="2">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="events:admission:day">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
      <go-ticket-segment filters="events:admission:timeslot">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```

### `events:price`

# `events:price`

Browse many events on a chosen day and time, then book any of them. Mixes flat and tiered pricing.

**Use when:** you want a "What's on today" listing — visitor picks a day and time, sees a list of bookable events starting in that window.

**Required attributes:**

- `selected-date` and `selected-timeslot` on `<go-ticket-selection>` — normally set when the visitor picks in `<go-calendar>` and `<go-timeslots>`; the timeslot also narrows the listing to event-dates starting within a 2-hour window after the selected time.

**Optional attributes:**

- `museum-ids`, `event-ids`, `exhibition-ids` on `<go-ticket-selection>` — limit the listing to specific museums, events, or exhibitions.
- `museum-ids` on `<go-ticket-segment>` — overrides the selection-level `museum-ids` for this segment.
- `query` on `<go-ticket-segment>` — free-text filter on price title.
- `language-ids`, `catch-word-ids` on `<go-ticket-segment>` — further narrow the listing.
- `limit` on `<go-ticket-segment>` — caps the number of event-dates fetched for the listing (default 30).

**Renders:** `<go-calendar>`, `<go-timeslots>`, `<go-tickets>`.

## Example

```html
<go-ticket-selection filters="events:price" museum-ids="2">
  <go-if when="data.ticketSelection.isCalendarVisible" then="show">
    <go-calendar></go-calendar>
  </go-if>
  <go-if when="data.ticketSelection.isTimeslotsVisible" then="show">
    <go-timeslots></go-timeslots>
  </go-if>
  <go-if when="data.ticketSelection.isTicketsVisible" then="show">
    <go-tickets>
      <go-ticket-segment filters="events:price">
        <go-ticket-segment-body></go-ticket-segment-body>
      </go-ticket-segment>
    </go-tickets>
    <go-add-to-cart-button></go-add-to-cart-button>
  </go-if>
</go-ticket-selection>
```
