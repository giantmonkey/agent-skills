# Component nesting graph

Each row lists the child tags directly nested inside the parent, observed across canonical Storybook snippets. This is the structure integrators should reproduce — children are projected as light-DOM children, not via the parent's internal template.

| Parent | Children |
| --- | --- |
| `<go-cart>` | `<go-cart-coupons>`, `<go-cart-discounted-amount>`, `<go-cart-items>`, `<go-cart-subtotal-amount>`, `<go-cart-total-amount>` |
| `<go-feedback>` | `<go-errors-feedback>`, `<go-success-feedback>` |
| `<go-form>` | `<go-feedback>`, `<go-field>`, `<go-submit>` |
| `<go-signup-form>` | `<go-errors-feedback>`, `<go-field>`, `<go-submit>`, `<go-success-feedback>` |
| `<go-ticket-segment>` | `<go-ticket-segment-body>` |
| `<go-ticket-selection>` | `<go-calendar>`, `<go-ticket-segment>`, `<go-tickets>` |
| `<go-tickets>` | `<go-ticket-segment>` |
| `<go-withdrawal-form>` | `<go-errors-feedback>`, `<go-field>`, `<go-submit>`, `<go-success-feedback>` |
