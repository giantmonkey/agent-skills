# `<go-tour-timeslots>`

Since `v4.35.0`

The start times of a group tour on the day the visitor picked in `<go-calendar>`, as a list of
radio options. Only start times that fit the chosen headcount and language are listed. It renders
nothing until a day is picked, so it is safe to leave in the markup unconditionally.

## Examples

Basic:

```html
<go-ticket-selection filters="tour" tour-id="188">
  <go-calendar></go-calendar>
  <go-tour-timeslots></go-tour-timeslots>
</go-ticket-selection>
```

Inside a whole group tour booking:

```html
<go-ticket-selection filters="tour" tour-id="188">
  <go-participants></go-participants>
  <go-select data="tour:language"></go-select>
  <go-calendar></go-calendar>
  <go-tour-timeslots></go-tour-timeslots>
  <go-tour-prices></go-tour-prices>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

## Attributes

This component takes no attributes. The tour, the day, the headcount and the language come from
the parent `<go-ticket-selection>`.

## Events

This component emits no custom events. The radio inputs emit the standard DOM `change` event. The
picked start time is reflected on the parent as its `selected-timeslot` attribute (an ISO 8601
date-time such as `2026-07-01T14:00:00+02:00`).

## Styling

A `<div class="go-tour-timeslots">` holding the status region, the error text and a `<ul>` with one
`<li>` per start time; each `<li>` wraps a `<label>` (the formatted time) and a radio `<input>`:

- `.go-tour-timeslots` — root element; `[aria-busy='true']` while loading
- `.go-tour-timeslots-status` — the status region with the loading and the empty text
- `.go-tour-timeslots-error` — the error text
- `.go-timeslot` — each start time
- `.go-timeslot.is-selected` — the picked start time

```css
.go-timeslot.is-selected label {
  font-weight: 600;
}
```

## Nesting

Must be placed inside `<go-ticket-selection>` with `filters="tour"` and a `tour-id`.

## Subcomponents

None.

## Conditional rendering with `<go-if>`

The component hides itself until a day is picked. Use `<go-if>` for the markup around it:

```html
<go-if when="data.ticketSelection.selectedDate">
  <h3>Choose a start time</h3>
  <go-tour-timeslots></go-tour-timeslots>
</go-if>
```

## What it shows

- **Nothing is picked for the visitor.** Unlike `<go-timeslots>`, a day with a single start time
  does not select it.
- **The list follows the booking.** When the headcount or the language changes, the start times of
  the day are asked for again. A picked start time that is still offered stays picked; one that is
  no longer offered is dropped.
- **Loading and empty are announced.** A status region (`role="status"`) says that the start times
  are loading, and that the day has no start time. While loading, the root has `aria-busy="true"`.
- **A failure is an alert.** When the start times cannot be loaded, an error text with
  `role="alert"` takes the place of the list.
- **After a booking the start time is cleared**, ready for the next booking.

## Localization

| Key                           | Purpose                                             |
| ----------------------------- | --------------------------------------------------- |
| `tour.timeslots.label`        | Accessible name of the list                         |
| `tour.timeslots.loading`      | Status text while the start times load              |
| `tour.timeslots.failed`       | Error text when the start times could not be loaded |
| `ticket.timeSlot.noAvailable` | Status text when the day has no start time          |

All keys ship English and German defaults; your shop's own translations override them.
