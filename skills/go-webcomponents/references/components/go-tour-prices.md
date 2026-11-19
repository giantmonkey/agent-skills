# `<go-tour-prices>`

Since `v4.35.0`

The prices of a group tour booking for the picked day, start time, headcount and language: the
group price or the prices per person, the surcharges, and the subtotal. The visitor splits the
group over the prices per person and takes optional surcharges here. It renders nothing until a
start time is picked.

## Examples

Basic:

```html
<go-ticket-selection filters="tour" tour-id="188">
  <go-calendar></go-calendar>
  <go-tour-timeslots></go-tour-timeslots>
  <go-tour-prices></go-tour-prices>
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

Showing the subtotal somewhere else on the page:

```html
<p>Your tour: <output id="tour-total"></output></p>
<script>
  document.querySelector('go-ticket-selection').addEventListener('go-tour-price-change', event => {
    const cents = event.detail.totalPriceCents
    // No price any more, e.g. after another day was picked: show nothing.
    document.getElementById('tour-total').textContent = cents === undefined ? '' : (cents / 100).toFixed(2)
  })
</script>
```

## Attributes

This component takes no attributes. Everything it prices comes from the parent
`<go-ticket-selection>`.

## Events

| Event                  | Description                                                                                                                                                                                                                   | `detail`                                                                                                                                                                                                                                                                     | bubbles |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `go-tour-price-change` | The priced booking changed: new prices have loaded, the visitor changed a quantity, or the booking has no price any more (another day, a booked tour, prices that could not be loaded). Nothing fires while prices load again | `{ totalPriceCents, quantities, surcharges }` — the subtotal in cents; people per scale price id (`undefined` for a tour with a group price); quantity per surcharge id (`undefined` when none is charged). All three are `undefined` when the booking has no price any more | yes     |

## Styling

A `<div class="go-tour-prices">` holding the alerts, a `<ul class="go-tour-price-list">` with one
`<li>` per price, the split hint and the status region:

- `.go-tour-prices` — root element; `[aria-busy='true']` while loading
- `.go-tour-price` — a price row; `[data-kind]` is `group`, `scale` or `surcharge`
- `.go-tour-price-title`, `.go-tour-price-description` — the name of the price and its description
- `.go-tour-price-unit` — the unit price, per booking or per person
- `.go-tour-price-quantity` — the select or checkbox of a row
- `.go-tour-price-fixed` — a fixed quantity, e.g. `× 2`
- `.go-tour-price-total` — the row's amount
- `.go-tour-prices-hint` — the hint while the split does not add up
- `.go-tour-prices-status` — the status region; `.go-tour-prices-loading` is the loading text, `.go-tour-prices-total` the subtotal with its tax note
- `.go-tour-prices-error`, `.go-tour-prices-unavailable` — the alerts

```css
.go-tour-price {
  display: grid;
  grid-template-columns: 1fr auto auto auto;
  gap: 1rem;
}
.go-tour-prices-total strong {
  font-size: 1.25rem;
}
```

## Nesting

Must be placed inside `<go-ticket-selection>` with `filters="tour"` and a `tour-id`.

## Subcomponents

None.

## Conditional rendering with `<go-if>`

The component hides itself until a start time is picked. Use `<go-if>` for the markup around it:

```html
<go-if when="data.ticketSelection.selectedTimeslot">
  <h3>Prices</h3>
  <go-tour-prices></go-tour-prices>
</go-if>
```

## Price rows

Each price is one row. How its quantity is set depends on the price:

| Price                                    | Quantity                                                 |
| ---------------------------------------- | -------------------------------------------------------- |
| Group price                              | fixed: charged once per booking                          |
| Several prices per person (scale prices) | a select per price, from 0 to the headcount              |
| One price per person                     | fixed at the headcount                                   |
| Mandatory surcharge                      | fixed: once per booking, or once per person              |
| Mandatory surcharge above a headcount    | fixed: charged for the people above that headcount       |
| Optional surcharge per person            | a select, from 0 to the headcount                        |
| Optional surcharge per booking           | a checkbox                                               |
| Optional surcharge above a headcount     | a checkbox: taken, it is charged for the people above it |

- **The split follows the headcount** until the visitor changes it: the whole group starts on the
  first price per person. After a change the split is kept, and while it does not add up to the
  headcount a hint asks for it (`.go-tour-prices-hint`) and `<go-add-to-cart-button>` is disabled.
  For a smaller group no price keeps more people than the group has.
- **Picks are kept** when the prices load again, for example for another language or headcount.
  They are cleared after a booking and when the selection gets another `tour-id`.
- **The subtotal carries a tax note**: whether the prices include tax or tax is added.
- **Loading and the subtotal are announced.** One status region (`role="status"`) holds the loading
  text and then the subtotal, so a screen reader reads every new subtotal. While loading, the root
  has `aria-busy="true"`.
- **A failure is an alert.** When the prices cannot be loaded, an error text with `role="alert"`
  shows and the button is disabled.
- **A tour without a language cannot be booked online.** An alert says so, no prices are asked for
  and the button stays disabled. The same goes for a tour with several languages on a page without
  `<go-select data="tour:language">`; a console warning names the missing select.

## Localization

| Key                       | Purpose                                          | Dynamic values                |
| ------------------------- | ------------------------------------------------ | ----------------------------- |
| `tour.prices.group`       | Name of the group price (the backend sends none) | -                             |
| `tour.prices.perBooking`  | Unit of a price charged once per booking         | -                             |
| `tour.prices.perPerson`   | Unit of a price charged per person               | -                             |
| `tour.prices.subtotal`    | Label of the subtotal                            | -                             |
| `tour.prices.taxIncluded` | Tax note when the prices include tax             | -                             |
| `tour.prices.taxExcluded` | Tax note when tax is added                       | -                             |
| `tour.prices.split`       | Hint while the split does not add up             | {"{{count}}"} - the headcount |
| `tour.prices.loading`     | Status text while the prices load                | -                             |
| `tour.prices.failed`      | Error text when the prices could not be loaded   | -                             |
| `tour.prices.unavailable` | Alert for a tour that cannot be booked online    | -                             |

All keys ship English and German defaults; your shop's own translations override them.
