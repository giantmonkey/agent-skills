# `<go-if>`

Since `v1.0.0`

Conditionally renders its children. While the `when` expression is falsy, the child elements are removed from the document; once it turns truthy they are re-inserted (the same elements — their state is preserved). The expression re-evaluates automatically as the shop state changes.

## Examples

Basic — show a link only while the cart has items:

```html
<go-if when="data.cart.items.length > 0">
  <a href="/checkout">Go to checkout</a>
</go-if>
```

Inside a ticket selection — reveal the tickets once a date and timeslot are picked:

```html
<go-ticket-selection filters="ticket:timeslot" event-ids="263">
  <go-calendar></go-calendar>
  <go-timeslots></go-timeslots>
  <go-if when="data.ticketSelection.selectedDate && data.ticketSelection.selectedTimeslot">
    <go-tickets></go-tickets>
  </go-if>
</go-ticket-selection>
```

Sign-in gate — show the sign-in form only to visitors who aren't signed in:

```html
<go-if when="!data.auth.isLoggedIn">
  <go-sign-in></go-sign-in>
</go-if>
```

## Attributes

| Attribute | Type   | Default | Description                                                                                          |
| --------- | ------ | ------- | ---------------------------------------------------------------------------------------------------- |
| `when`    | string | —       | The condition expression (see below). Children render while it is truthy; omitted = children hidden. |
| `then`    | string | `show`  | What to do while the condition is truthy. `show` is the only supported value.                        |

### when

The expression the component evaluates. Examples:

- `when="2===2"`
- `when="data.ticketSelection.selectedDate"`
- `when="data.ticketSelection.selectedDate && data.ticketSelection.selectedTimeslot"`
- `when="showAlert(data)"`

Supported expression subset:

- comparisons: `==`, `===`, `!=`, `!==`, `>`, `<`, `>=`, `<=`
- boolean operators: `&&`, `||`, `!`
- property paths from `data` (including optional chaining like `data.formData?.language_id`)
- `.length` checks (for example `data.cart.items.length === 0`)
- calling existing global functions (for example `showAlert(data)`)

Not supported:

- statements or side effects (`a = 1`, `if (...) {}`)
- constructors and arbitrary JS runtime features (`new Date()`, inline arrow functions, etc.)

For more complex conditions, define a function in your app and call it from `when`, for example:

```html
<go-if when="isCheckoutReady(data)">...</go-if>
```

```js
window.isCheckoutReady = data => {
  return Boolean(data?.ticketSelection?.selectedDate && data?.ticketSelection?.selectedTimeslot)
}
```

Security / CSP:

- `go-if` uses a parser-based evaluator (no `eval` / `new Function`)
- this means you do not need `script-src 'unsafe-eval'` for `go-if`

## Events

This component emits no custom events.

## Styling

No style hooks beyond the root element.

## Nesting

Standalone — no required parent. Some `data` handles only exist inside specific parents — see below.

## Subcomponents

None.

## The `data` scope

The `when` expression reads from `data`, a scope assembled from the component's surroundings. It re-evaluates automatically whenever these values change (cart updates, date selection, sign-in, …). Handles that don't apply in the current context are `undefined` — use optional chaining (`data.formData?.language_id`) when a handle may be absent.

Available everywhere:

- `data.cart` — the shared cart _(Since `v1.25.0`)_. Useful reads: `data.cart.items.length`, `data.cart.totalQuantity`, `data.cart.totalPriceCents`
- `data.auth` — sign-in state, plain booleans _(Since `v4.5.0`)_: `data.auth.isAuthenticated` (guest or account), `data.auth.isLoggedIn` (account only), `data.auth.isGuest` (guest checkout only)

Available only inside a specific parent:

- `data.ticketSelection` — inside `<go-ticket-selection>`: `selectedDate`, `selectedTimeslot`, `isCalendarVisible`, `isTimeslotsVisible`, `isTicketsVisible`
- `data.formData` — inside `<go-form>` _(Since `v1.6.0`)_: the form's current field values by field name, e.g. `data.formData?.language_id`
- `data.cartView` — inside `<go-cart>` _(Since `v3.0.0`)_: `totalPriceCents`, `subtotalPriceCents`, `discountedAmountCents`, `isDiscounted`
- `data.personalizationDetails` — inside `<go-annual-ticket-personalization>` _(Since `v1.46.0`)_: `order`, `ticketSale`
