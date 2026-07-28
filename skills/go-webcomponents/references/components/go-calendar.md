# Calendar Component

The `go-calendar` component renders a calendar widget to select dates with available tickets.

## Example

```html
<go-calendar></go-calendar>
```

## Attributes

| Attribute               | Type   | Default | Description                                                                   | Since        |
| ----------------------- | ------ | ------- | ----------------------------------------------------------------------------- | ------------ |
| `availability-override` | string | —       | Name of a global function that overrides each date's availability — see below | `v4.12.0` |

### availability-override

By default a date is clickable when gomus has tickets on sale for it, and blocked otherwise.
`availability-override` lets you overrule that, one date at a time.

Your function is called for every rendered date. It receives the date as `YYYY-MM-DD` plus the
availability gomus arrived at on its own, and returns one of:

| Return value     | Effect                                                                           |
| ---------------- | -------------------------------------------------------------------------------- |
| `'available'`    | Date is clickable                                                                |
| `'sold_out'`     | Date is shown but not selectable — gets `data-unavailable` and `.is-unavailable` |
| `'unavailable'`  | Date is blocked — gets `data-disabled` and `.is-disabled`                        |
| `'pass_through'` | Don't override this date — keep what gomus decided                               |

There are two ways to supply it. As an attribute naming a global function — use this when your page
is plain HTML or comes out of a CMS:

```html
<script>
  window.shopAvailability = function (date, defaultAvailability) {
    // keep Christmas Eve closed, whatever gomus says
    if (date.endsWith('-12-24')) return 'unavailable'
    return 'pass_through'
  }
</script>

<go-ticket-selection filters="ticket:timeslot">
  <go-calendar availability-override="shopAvailability"></go-calendar>
</go-ticket-selection>
```

Or as a property on the element, which keeps the function out of the global scope:

```html
<go-ticket-selection filters="ticket:timeslot">
  <go-calendar id="calendar"></go-calendar>
</go-ticket-selection>

<script>
  var boxOfficeOnly = ['2026-08-01', '2026-08-02']

  customElements.whenDefined('go-calendar').then(function () {
    document.getElementById('calendar').availabilityOverride = function (date, defaultAvailability) {
      // open the dates that are bookable at the box office only, so you can show your own note
      if (boxOfficeOnly.indexOf(date) !== -1) return 'available'
      return 'pass_through'
    }
  })
</script>
```

Use **one or the other** on a given calendar, not both. Setting the attribute _and_ assigning the
property to the same element leaves the two fighting over one value, and which one wins depends on
when your script runs relative to the component bundle.

Things to know:

- The function must be **synchronous and fast**. It is asked about every cell of the grid, including
  the neighbouring-month days that fill out the first and last week, more than once each per render —
  a few hundred calls for one month view. Never fetch inside it.
- **The calendar only repaints when the value you gave it changes.** If your rule depends on data you
  load yourself, the calendar will not notice that data arriving — assign the property again, with a
  new function, once you have it:

  ```html
  <script>
    fetch('/my/closed-days.json')
      .then(function (r) {
        return r.json()
      })
      .then(function (closed) {
        document.getElementById('calendar').availabilityOverride = function (date, defaultAvailability) {
          return closed.indexOf(date) !== -1 ? 'unavailable' : 'pass_through'
        }
      })
  </script>
  ```

  Replacing the **global function** the attribute names does not repaint anything. The name is looked
  up again on every call, so a swapped global only takes effect the next time the calendar repaints
  for some other reason. Use the property form when your rule depends on data you load.

- `defaultAvailability` is what gomus knows **at that moment**. Any date gomus has said nothing about
  — the availability request is still in flight, or the date is outside the range it loaded — comes
  through as `'available'`; the calendar re-renders with the real values once the response arrives.
  Rules that branch on `defaultAvailability` see both passes.
- **Dates before today stay blocked.** The calendar disables them regardless of your override, so
  returning `'available'` for a past date has no effect.
- **Opening a date does not create tickets for it.** A date gomus has nothing on sale for becomes
  clickable with an empty timeslot picker and an empty ticket list — which is the point. Use
  `<go-if>` to render your own "please call us" note for those dates.
- A function that **throws**, or returns anything else — including nothing at all, or a `Promise` from
  an `async` function — falls back to the gomus default for that date. A faulty override never breaks
  the calendar. Each kind of problem is reported with a **single** `console.error`, not one per date,
  so one message stands for the whole grid.
- An `availability-override` that does not name a function on `window` logs a single `console.warn`;
  the gomus defaults are used.

## Styling

The `go-calendar` component provides multiple data attributes for styling and customization.

### CSS Selectors

- `[data-calendar-root]`: Root container.
- `[data-calendar-header]`: Calendar header area.
- `[data-calendar-grid]`: Grid layout for dates.
- `[data-calendar-cell]`: Each date cell.
- `[data-calendar-cell][data-unavailable]`: Marks sold-out dates.
- `[data-calendar-cell][data-disabled]`: Marks disabled dates.
- `[data-calendar-cell][data-value]`: The cell's date as `YYYY-MM-DD`.
- `[data-calendar-cell][data-selected]`: Styles for the selected date.
- `[data-calendar-cell][data-today]`: Highlights the current day.
- `[data-calendar-cell][data-outside-month]`: Hidden days outside the current month.

### Class hooks

Each day also carries classes, which `availability-override` drives:

- `.go-calendar-day`: Every day.
- `.go-calendar-day.is-disabled`: Blocked day (`'unavailable'`).
- `.go-calendar-day.is-unavailable`: Sold-out day (`'sold_out'`).
- `.go-calendar-day.is-selected`: The selected day.

### CSS Example

```css
[data-calendar-grid] {
  //css
}

[data-calendar-cell][data-selected] {
  background-color: #12826A;
  color: #fff;
}
```

## Events

| Event            | Description                                                                         | `detail`                                                                                                         | bubbles |
| ---------------- | ----------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ------- |
| `go-date-select` | Fires when the selected date changes, and once on load before anything is selected. | `{ selected }` — the picked date, `undefined` before the first selection. `String(selected)` gives `YYYY-MM-DD`. | yes     |

## Conditional rendering with `<go-if>`

A date you opened with `availability-override` has no timeslots and no tickets behind it, so pair it
with your own note. Give `<go-if>` a global function and it gets the current selection:

```html
<go-ticket-selection filters="ticket:timeslot">
  <go-calendar availability-override="shopAvailability"></go-calendar>
  <go-if when="isBoxOfficeDate(data)" then="show">
    <p>This date is only bookable at our box office — please call us.</p>
  </go-if>
  <go-timeslots></go-timeslots>
  <go-tickets></go-tickets>
</go-ticket-selection>
```

```js
window.boxOfficeOnly = ['2026-08-01', '2026-08-02']

window.isBoxOfficeDate = function (data) {
  var selected = data.ticketSelection.selectedDate
  return !!selected && window.boxOfficeOnly.indexOf(String(selected)) !== -1
}
```

## Sub component

This component is a subcomponent of `go-ticket-selection` component, and will only
function when it is placed inside one.
