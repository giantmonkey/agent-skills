# `<go-seating-plan>`

Since `v4.34.0`

A room plan where visitors pick seats for one date of a seated event. Visitors click a seat, choose a price, and the
seat is held for them. Place it inside `<go-ticket-selection>`: picked seats are part of the selection like tickets,
so `<go-tickets-sum>` totals them and `<go-add-to-cart-button>` moves them into the cart.

## Examples

Basic, inside a ticket selection with a total and the add-to-cart button:

```html
<go-ticket-selection filters="event:price" event-ids="280">
  <go-seating-plan event-id="280" date-id="51234"></go-seating-plan>
  <p>Selected: <go-tickets-sum></go-tickets-sum></p>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

With a message for a date that has no seats:

```html
<go-ticket-selection filters="event:price" event-ids="280">
  <go-seating-plan event-id="280" date-id="51234"></go-seating-plan>
  <go-tickets-empty><p>There are no seats for this date.</p></go-tickets-empty>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Next to the cart. Seats already in the cart stay marked as the visitor's own on the plan. Each seat is one cart
line that shows the seat and its category:

```html
<go-ticket-selection filters="event:price" event-ids="280">
  <go-seating-plan event-id="280" date-id="51234"></go-seating-plan>
  <p>Selected: <go-tickets-sum></go-tickets-sum></p>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>

<go-cart>
  <go-cart-items></go-cart-items>
  <p>Total: <go-cart-total-amount></go-cart-total-amount></p>
</go-cart>
```

Setting the date from a script, for example after the visitor picks a date in your own list:

```js
const plan = document.querySelector('go-seating-plan')
plan.setAttribute('event-id', '280')
plan.setAttribute('date-id', String(dateId))
```

## Attributes

| Attribute  | Type   | Default | Description                                              |
| ---------- | ------ | ------- | -------------------------------------------------------- |
| `event-id` | number | —       | The seated event                                         |
| `date-id`  | number | —       | The date of that event whose room plan and seats to show |

The plan shows once both are set. When you change either one, the plan for the new date loads.

### How picking works

- **Click or keyboard.** Visitors click a seat, or press Enter or Space on it. The arrow keys move to the nearest free
  seat in that direction.
- **Prices.** A seat whose category has one price is picked at once. If it has several, a dialog asks which one.
  Opening a seat that is already picked lets the visitor change its price or release it.
- **Holds.** A seat is held for the visitor before it counts as picked. If someone else took it a moment earlier,
  the plan shows a notice instead. Held seats stay held while the visitor is on your site, also after they go into
  the cart. A seat whose hold ran out is removed, and the plan names it.
- **Taken seats.** Seats booked or held by others turn grey within a few seconds. Seats the same visitor holds in
  another tab count as taken too.
- **Limit.** If the date has a seat limit per order, seats in the cart count toward it. Once it is reached, no more
  free seats can be picked, and the plan says so.
- **Zoom.** The `+`, `−` and `⤢` buttons zoom the hall. So does Ctrl/⌘ + mouse wheel. Visitors can drag the hall
  while it is zoomed in.

## Events

This component emits no custom events.

## Styling

All default rules use `:where()`, so your own CSS wins without fighting specificity.

- `.go-seating-plan`: root element
- `.go-seating-plan__toolbar`: the legend and zoom buttons above the hall
- `.go-seating-plan__legend`: the category list with colours and lowest prices
- `.go-seating-plan__swatch`: a colour chip in the legend. It has `data-state="selected"` or `data-state="blocked"` for
  the "Your seats" and "Taken" chips.
- `.go-seating-plan__zoom`: the zoom buttons
- `.go-seating-plan__canvas`: the hall. `.is-zoomed` while zoomed in, `.is-busy` while a seat is being held.
- `[data-go-seat]`: each seat shape in the hall, with `data-state="available"`, `"selected"` or `"blocked"`
- `.go-seating-plan__summary`: the picked seats, their total and notices
- `.go-seating-plan__total`: the count and total line
- `.go-seating-plan__dialog`: the price dialog. `.go-seating-plan__actions` holds its buttons, and the confirm button
  has `.is-primary`.
- `.go-seating-plan__error`: error text and notices
- `.go-seating-plan__muted`: secondary text

Colours and shapes come from custom properties on `go-seating-plan`:

| Property               | Default   | Used for                              |
| ---------------------- | --------- | ------------------------------------- |
| `--go-seat-selected`   | `#15803d` | Picked seats, the confirm button      |
| `--go-seat-blocked`    | `#d4d4d8` | Taken seats                           |
| `--go-seat-focus`      | `#1d4ed8` | Keyboard focus ring on a seat         |
| `--go-seating-surface` | `#fafafa` | Hall background                       |
| `--go-seating-border`  | `#e4e4e7` | Borders of the hall, rows and buttons |
| `--go-seating-muted`   | `#71717a` | Secondary text                        |
| `--go-seating-radius`  | `12px`    | Corner radius of the hall and dialog  |

Each seat takes its category's colour from the backend through `--go-seat-color`. A category without a colour gets a
grey of its own, darker than a taken seat.

```css
go-seating-plan {
  --go-seat-selected: #7c3aed;
  --go-seating-radius: 4px;
}
go-seating-plan [data-go-seat][data-state='selected'] {
  stroke: #000;
}
```

## Nesting

Must be placed inside `<go-ticket-selection>`. Without one, visitors can pick seats, but nothing moves them into the
cart.

## Subcomponents

None.

## Localization

| Key                            | Purpose                                                |
| ------------------------------ | ------------------------------------------------------ |
| `seatingPlan.legend.label`     | Accessible name of the legend                          |
| `seatingPlan.legend.from`      | Lowest price of a category (`{{price}}`)               |
| `seatingPlan.legend.selected`  | Legend entry and colour for picked seats               |
| `seatingPlan.legend.taken`     | Legend entry for taken seats, also read out on them    |
| `seatingPlan.zoom.label`       | Accessible name of the zoom buttons                    |
| `seatingPlan.zoom.in`          | Zoom in button                                         |
| `seatingPlan.zoom.out`         | Zoom out button                                        |
| `seatingPlan.zoom.reset`       | Show the whole hall button                             |
| `seatingPlan.canvas.label`     | Accessible name of the hall, with keyboard hint        |
| `seatingPlan.loading`          | Shown while the room plan loads                        |
| `seatingPlan.error`            | Shown when the room plan cannot be loaded              |
| `seatingPlan.selection.empty`  | Shown when no seat is picked yet                       |
| `seatingPlan.selection.count`  | Number of picked seats (`{{count}}`)                   |
| `seatingPlan.selection.remove` | Accessible name of a seat's × button (`{{seat}}`)      |
| `seatingPlan.limit`            | Seat limit per order is reached (`{{max}}`)            |
| `seatingPlan.seat.taken`       | Someone else took the seat a moment ago (`{{seat}}`)   |
| `seatingPlan.seat.lost`        | Seats removed because their hold ran out (`{{seats}}`) |
| `seatingPlan.dialog.price`     | Price dialog: heading of the price choice              |
| `seatingPlan.dialog.release`   | Price dialog: release a picked seat                    |
| `seatingPlan.dialog.cancel`    | Price dialog: close without changes                    |
| `seatingPlan.dialog.confirm`   | Price dialog: pick the seat at the chosen price        |
