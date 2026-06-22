# If Component

The `go-if` component performs action based on a condition.

## Example

```html
<go-if when="true" then="show">Hallo</go-if>
```

## Properties

| Property | Attribute | Description                                 | Type                                     | Default       |
|----------|-----------|---------------------------------------------|:-----------------------------------------|:--------------|
| `when`   | `when`    | The condition                               | String (expression) \| undefined          | `'undefined'` |
| `data`   | -         | The data available to the `when` expression | see below                                | `'undefined'` |

### when
Is the expression that the component evaluates:

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

### data
The `when` expression is fed with `data`. It contains different values based on the context that the `if` component is located in:

- in a Ticket Selection Component
  `data.ticketSelection:` [TicketSelectionDetails](https://app.unpkg.com/@gomusdev/web-components/files/dist-js/components/ticketSelection/lib.svelte.d.ts)

- in a go-forms
  `formData?: Record<string, any>`
