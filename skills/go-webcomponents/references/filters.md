# Ticket-selection filters

Filters drive what `<go-ticket-selection>` renders. Pass them via the `filters` attribute (comma-separated). The same value also flows down to `<go-ticket-segment filters="...">`.

"Conditional" means that picker appears once its prerequisite (Requires) is met.

| Filter | Calendar | Timeslots | Tickets | Requires |
| --- | --- | --- | --- | --- |
| `ticket:timeslot` | always | conditional | conditional | a selected date, a selected timeslot |
| `ticket:day` | always | conditional | conditional | a selected date |
| `ticket:annual` | conditional | conditional | always | — |
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

Sell time-slot tickets — visitors pick a date, a time slot, then quantities.

**Use when:** your shop sells museum admission with a specific entry time (timed entry tickets).

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

### `ticket:day`

# `ticket:day`

Sell day tickets — visitor picks a date, then quantities. Valid all day, no time slot.

**Use when:** your shop sells day-pass tickets without a specific entry time.

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

### `ticket:annual`

# `ticket:annual`

Sell annual tickets — no date or time picker, tickets are shown directly.

**Use when:** your shop sells annual passes (memberships, year tickets).

**Renders:** `<go-tickets>`.

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

### `event:admission`

# `event:admission`

Sell admission tickets for a single event — visitor picks date, time slot, then ticket types (Adult, Reduced, …).

**Use when:** you want to sell standard admission tickets attached to one specific event, regardless of `ticket_type`. For finer control split by type, use `event:admission:day` (day tickets, `ticket_type=normal`) and/or `event:admission:timeslot` (timed tickets, `ticket_type=time_slot`) instead.

**Required attribute:** `event-ids` on `<go-ticket-selection>` — ID of the event whose admission tickets to sell.

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

Admission tickets attached to a single event, restricted to **day tickets** (`ticket_type=normal`, no entry-time slot).

**Use when:** the event sells admission tickets that are valid for the whole day. Pair with `event:admission:timeslot` in two segments when an event sells both kinds.

**Required attributes:**
- `event-ids` on `<go-ticket-selection>` — ID of the event.
- A picked date is required (driven by `<go-calendar>`); no timeslot is needed.

**Backend filter applied:** `by_ticket_ids[]=event.tickets&by_ticket_types[]=normal&valid_at=YYYY-MM-DD&by_bookable=true` against `/api/v4/tickets/list_and_quotas`. The backend's `by_ticket_types` scope keeps only tickets where `entry_duration IS NULL` (and not annual / not archived).

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

Admission tickets attached to a single event, restricted to **timed-entry tickets** (`ticket_type=time_slot`).

**Use when:** the event sells timed-admission tickets where the visitor picks a specific entry time. Pair with `event:admission:day` in two segments when the event sells both kinds.

**Required attributes:**
- `event-ids` on `<go-ticket-selection>` — ID of the event.
- A picked date and timeslot are required (driven by `<go-calendar>` then `<go-timeslots>`).

**Backend filter applied:** `by_ticket_ids[]=event.tickets&by_ticket_type=time_slot&valid_at=YYYY-MM-DD&by_bookable=true` against `/api/v4/tickets/list_and_quotas`. The backend's `by_ticket_type=time_slot` scope keeps only tickets where `entry_duration IS NOT NULL` (and not annual / not archived).

`loadTimeslots` runs the same scoped query and feeds the resulting quotas into `capacityManager`, so the `<go-timeslots>` picker only shows entry times for this event's timed tickets — not unrelated shop-wide timeslot tickets.

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
<go-ticket-selection
  filters="event:admission:day, event:admission:timeslot"
  event-ids="263"
>
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

Multi-event listing showing each event's admission tickets (`event.tickets[]`) for the selected date + time window.

**Use when:** the shop offers a "What's on today" listing where the events sell admission tickets (Adult, Reduced, …) rather than date-level scaled prices. For scaled / flat date-prices, use `events:price` instead. To split day vs timed admission tickets across two segments, use `events:admission:day` and `events:admission:timeslot`.

**Required attributes:**
- `selected-date` is required (driven by `<go-calendar>`).
- `selected-timeslot` is required (driven by `<go-timeslots>`); the loader picks all event-dates whose `start_time` falls within a 2-hour window from the selected time.

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

Multi-event listing showing each event's **day admission tickets** (`ticket_type=normal`). Same data flow as `events:admission` but restricted to non-timeslot tickets.

**Use when:** "What's on today" listing where events sell day tickets only. For mixed flows, pair with `events:admission:timeslot`.

**Required attributes:**
- `selected-date` and `selected-timeslot` are required (the timeslot narrows the listing to event-dates whose `start_time` falls within a 2h window from the selected time).

**Backend filter applied per event-date in window:** `by_ticket_ids[]=event.tickets&by_ticket_types[]=normal&valid_at=YYYY-MM-DD&by_bookable=true`.

**Renders:** `<go-calendar>`, `<go-timeslots>`, `<go-tickets>`.

### `events:admission:timeslot`

# `events:admission:timeslot`

Multi-event listing showing each event's **timed admission tickets** (`ticket_type=time_slot`). Same data flow as `events:admission` but restricted to entry-time tickets.

**Use when:** "What's on today" listing where events sell timed entry tickets only. For mixed flows, pair with `events:admission:day`.

**Required attributes:**
- `selected-date` and `selected-timeslot` (the timeslot is also used to narrow the listing to event-dates whose `start_time` falls within a 2h window from the selected time).

**Backend filter applied per event-date in window:** `by_ticket_ids[]=event.tickets&by_ticket_type=time_slot&valid_at=YYYY-MM-DD&by_bookable=true`.

**Renders:** `<go-calendar>`, `<go-timeslots>`, `<go-tickets>`.

### `events:price`

# `events:price`

Browse many events on a chosen day and time, then book any of them. Mixes flat and tiered pricing.

**Use when:** you want a "what's on today" view — visitor picks a day and time, sees a list of bookable events starting in that window.

**Optional attributes:**
- `museum-ids` on `<go-ticket-selection>` — limit listing to specific museums.
- `query` on `<go-ticket-segment>` — free-text filter on price title.
- `language-ids`, `catch-word-ids`, `limit` on `<go-ticket-segment>` — further narrow the listing.

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
