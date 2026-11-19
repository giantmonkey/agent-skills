# `<go-participants>`

Since `v4.35.0`

The headcount of a group tour booking: a select that runs from the tour's smallest group to its
largest. It reads the tour from the `tour-id` of the surrounding `<go-ticket-selection>`. The
calendar, the start times and the prices follow the chosen headcount.

## Examples

Basic:

```html
<go-ticket-selection filters="tour" tour-id="188">
  <go-participants></go-participants>
</go-ticket-selection>
```

A whole group tour booking — headcount and language first, then day, start time and prices:

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

This component takes no attributes. The tour comes from the `tour-id` of the parent
`<go-ticket-selection>`.

## Events

This component emits no custom events. Its `<select>` emits the standard DOM `change` event; the
chosen headcount is `participants` on the selection's `details` (`data.ticketSelection.participants`
in `<go-if>`).

## Styling

A `<div class="go-participants">` holding a `<label>`, the `<select>` and the hint:

- `.go-participants` — root element
- `.go-participants-hint` — the hint under the select; it has `role="alert"` when the tour could not be loaded
- the `<select>` is `[disabled]` until the tour has loaded

```css
.go-participants-hint[role='alert'] {
  color: #b00020;
}
```

## Nesting

Must be placed inside `<go-ticket-selection>` with `filters="tour"` and a `tour-id`.

## Subcomponents

None.

## Conditional rendering with `<go-if>`

The headcount is set once the tour has loaded, so it can gate the steps that need it:

```html
<go-if when="data.ticketSelection.participants">
  <h3>Choose a day</h3>
  <go-calendar></go-calendar>
</go-if>
```

## What it shows

| State                          | Select                                    | Hint (`.go-participants-hint`)                    |
| ------------------------------ | ----------------------------------------- | ------------------------------------------------- |
| The tour is loading            | disabled, no options                      | empty                                             |
| The tour has loaded            | every group size, the smallest one chosen | the range, e.g. "1 to 20 people per booking"      |
| The tour has one group size    | that one size                             | "Exactly 5 people per booking"                    |
| The tour could not be loaded   | disabled, no options                      | an error text, with `role="alert"`                |
| The selection has no `tour-id` | nothing renders                           | — (a console warning names the missing `tour-id`) |

A tour whose smallest group is above its largest (old tours can be set up that way) offers the
smallest group only, with a console warning.

## Localization

| Key                        | Purpose                                      | Dynamic values                                            |
| -------------------------- | -------------------------------------------- | --------------------------------------------------------- |
| `tour.participants.label`  | Label of the select                          | -                                                         |
| `tour.participants.range`  | Hint for a tour with several group sizes     | {"{{min}}"}, {"{{max}}"} - the smallest and largest group |
| `tour.participants.exact`  | Hint for a tour with one group size          | {"{{count}}"} - the group size                            |
| `tour.participants.failed` | Error text when the tour could not be loaded | -                                                         |

All keys ship English and German defaults; your shop's own translations override them.
