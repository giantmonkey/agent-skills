# Calendar Component

The `go-calendar` component renders a calendar widget to select dates with available tickets.

## Example

```html
<go-calendar></go-calendar>
```

## Styling

The `go-calendar` component provides multiple data attributes for styling and customization.

### CSS Selectors

* `[data-calendar-root]`: Root container.
* `[data-calendar-header]`: Calendar header area.
* `[data-calendar-grid]`: Grid layout for dates.
* `[data-calendar-cell]`: Each date cell.
* `[data-calendar-cell][data-unavailable]`: Marks unavailable dates.
* `[data-calendar-cell][data-disabled]`: Marks disabled dates.
* `[data-calendar-cell][data-selected]`: Styles for the selected date.
* `[data-calendar-cell][data-today]`: Highlights the current day.
* `[data-calendar-cell][data-outside-month]`: Hidden days outside the current month.

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

The `CalendarUI` component emits the following events for interaction handling:

| Event Name | Description                                        | Payload                           |
| ---------- | -------------------------------------------------- | --------------------------------- |
| `select`   | Triggered when a date is selected.                 | `{ value: CalendarDate }`         |

## Sub component

This component is a subcomponent of `go-ticket-selection` component, and will only
function when it is placed inside one.
