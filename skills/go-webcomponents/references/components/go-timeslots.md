# `<go-timeslots>`

Since `v1.0.0`

Renders the start times available for the date the visitor picked in `<go-calendar>`,
as a list of radio options; selecting one drives the rest of `<go-ticket-selection>`.
It renders nothing until a date is chosen and the active filter calls for a timeslot
step, so it is safe to leave in the markup unconditionally.

## Examples

Basic:

```html
<go-timeslots></go-timeslots>
```

Inside a ticket selection — the calendar picks the date, timeslots the time, tickets the products:

```html
<go-ticket-selection filters="ticket:timeslot" event-ids="263">
  <go-calendar></go-calendar>
  <go-timeslots></go-timeslots>
  <go-tickets></go-tickets>
</go-ticket-selection>
```

## Attributes

This component takes no attributes. Which slots appear — and whether the picker
shows at all — comes from the parent `<go-ticket-selection>`: its `filters` and the
date selected in `<go-calendar>`.

## Events

| Event                | Description                                                                                       | `detail`                                                                                                                            | bubbles |
| -------------------- | ------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `go-timeslot-select` | A timeslot becomes selected — by a click, or auto-selected when the date has only one usable slot | `{ selected }` — the chosen slot's start time as an ISO 8601 string (e.g. `"2024-05-22T14:00:00+02:00"`), or `undefined` if cleared | yes     |

The event bubbles, so listen on the enclosing `<go-ticket-selection>`:

```js
document
  .querySelector('go-ticket-selection')
  .addEventListener('go-timeslot-select', e => console.log(e.detail.selected))
```

The radio inputs also emit the standard DOM `change` event.

### Auto-selection

When the date offers exactly one usable slot, it is selected automatically and
`go-timeslot-select` fires without any user interaction — single-slot offers (common
for day tickets) skip a redundant click. A lone slot that is sold out is left
unselected so the visitor is not trapped on a dead end.

## Styling

Each slot is an `<li>` wrapping a `<label>` (the formatted time) and a radio `<input>`:

- `.go-timeslot` — each slot
- `.go-timeslot.is-selected` — the selected slot
- `.go-timeslot.is-sold-out` — sold out (zero capacity)
- `.go-timeslot.is-disabled` — not selectable (sold out or otherwise unavailable); its `<input>` is also `disabled`

```css
.go-timeslot.is-selected label {
  font-weight: 600;
}
.go-timeslot.is-sold-out {
  opacity: 0.5;
}
```

## Nesting

Must be placed inside `<go-ticket-selection>` — it has no standalone behavior.

## Subcomponents

None.

## Conditional rendering with `<go-if>`

`<go-timeslots>` already hides itself until a timeslot step applies, so you rarely
need to gate it directly. Use `<go-if>` for the surrounding markup — a heading, a
hint — so it appears only once a date is picked:

```html
<go-if when="data.ticketSelection.selectedDate">
  <h3>Choose a time</h3>
  <go-timeslots></go-timeslots>
</go-if>
```

Reveal the next step only after a slot is chosen:

```html
<go-if when="data.ticketSelection.selectedTimeslot">
  <go-tickets></go-tickets>
</go-if>
```
