# Ticket Selection Component

The `go-ticket-selection` component wraps all scenarios of selecting a ticket.

## Example

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

## Properties

| Property           | Attribute            | Description                                                  | Type                                                                                                                                | Default     |
|--------------------|----------------------|--------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------|:------------|
| `filters`          | `filters`            | Comma-separated list of filters to apply (see Filters below) | `string`                                                                                                                            | `required`  |
| `selectedDate`     | `selected-date`      | Selected date for filtering the tickets                      | `string \| undefined`                                                                                                               | `undefined` |
| `selectedTimeslot` | `selected-timeslot`  | Selected timeslot id                                         | `string \| undefined`                                                                                                               | `undefined` |
| `eventIds`         | `event-ids`          | Comma-separated list of event IDs to filter by               | `string \| undefined`                                                                                                               | `undefined` |
| `museumIds`        | `museum-ids`         | Comma-separated list of museum IDs to filter by              | `string \| undefined`                                                                                                               | `undefined` |
| `exhibitionIds`    | `exhibition-ids`     | Comma-separated list of exhibition IDs to filter by          | `string \| undefined`                                                                                                               | `undefined` |
| `ticketIds`        | `ticket-ids`         | Comma-separated list of specific ticket IDs to include       | `string \| undefined`                                                                                                               | `undefined` |
| `ticketGroupIds`   | `ticket-group-ids`   | Comma-separated list of specific ticket group IDs to include | `string \| undefined`                                                                                                               | `undefined` |
| `details`          | -                    | The state of the ticket selection process                    | [`TicketSelectionDetails`](https://app.unpkg.com/@gomusdev/web-components/files/dist-js/components/ticketSelection/lib.svelte.d.ts) | -           |

### filters
Comma-separated filter names that determine which selection flow runs and which tickets are shown.
Each filter declares its calendar/timeslot/ticket visibility, what it loads, and which fields it requires.

Available filter names:

| Name                  | Calendar source | Description                                                                                  |
|-----------------------|-----------------|----------------------------------------------------------------------------------------------|
| `ticket:timeslot`     | tickets         | Time-slot tickets. Calendar + timeslots required, then tickets shown.                        |
| `ticket:day`          | tickets         | Day tickets (`normal` ticket type). Calendar required, no timeslots.                         |
| `ticket:annual`       | tickets         | Annual tickets. No calendar, tickets shown directly.                                         |
| `event:admission`     | events          | Single event admission tickets, all types combined. Requires `eventIds`.                     |
| `event:admission:day` | events          | Single event, day admission tickets only (`ticket_type=normal`). Calendar, no timeslot.      |
| `event:admission:timeslot` | events     | Single event, timed admission tickets only (`ticket_type=time_slot`). Calendar + timeslot.   |
| `event:price`         | events          | Single event, any price type (flat or scaled). Requires `eventIds` + segment `dateId`.       |
| `events:admission`    | events          | Multiple events, each event's admission tickets. Calendar + timeslot + tickets all visible.  |
| `events:admission:day` | events         | Multiple events, day admission tickets only (`ticket_type=normal`).                          |
| `events:admission:timeslot` | events    | Multiple events, timed admission tickets only (`ticket_type=time_slot`).                     |
| `events:price`        | events          | Multiple events, any price type. Calendar + timeslot + tickets all visible.                  |

### Segment filters and inheritance

The `filters` attribute on `<go-ticket-segment>` is **optional**. When omitted (or empty), the segment
inherits the filter list from its parent `<go-ticket-selection>` and runs all of them. Set it explicitly
only when you want a segment to be a *subset* of the selection's filters.

Multiple filters may be passed comma-separated; each runs and their results merge into the segment's
preCart.

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

<!-- Split admission by ticket_type: day tickets render once date is picked,
     timeslot tickets fill in once a slot is picked -->
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
Optional date string. When provided, only tickets available on this date will be shown.
e.g., `"2021-05-20"`

### selectedTimeslot
Optional timeslot id (ISO datetime, e.g. `"2026-07-01T14:00:00+02:00"`). When provided, that
timeslot is pre-selected. The attribute is reflected: it stays in sync with the live selection —
it updates when the visitor picks a slot and clears when they change the day — so you can read the
current timeslot directly from the element via `el.getAttribute('selected-timeslot')`.

## Sub components

These subcomponnts work and interact with each other when they are placed inside the `Ticket Selection` component.
- Calendar
- Timeslots
- Tickets
