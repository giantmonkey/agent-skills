# Ticket Selection Component

Since `v1.0.0`

The `go-tickets` component lists tickets to be added to the cart.

This component is a subcomponent of `go-ticket-selection` component, and will only function when it is placed inside one.

## Styling

The component dynamically applies CSS classes based on its visibility state:

- `is-visible` - applied when the component is shown
- `is-hidden` - applied when the component is hidden

The component's `display` style property is automatically set to `block` when visible and `none` when hidden.

### Quantity control

Each listed ticket renders an accessible `− qty +` quantity stepper
(`.go-quantity-stepper`, containing the `.go-quantity-stepper-button` buttons —
`.go-quantity-stepper-decrement` / `.go-quantity-stepper-increment` individually —
and a `.go-quantity-stepper-value` editable spinbutton input). Pressing `+` from `0` jumps straight to the ticket's
minimum party size, and `−` at that minimum returns to `0`. Set
`go.config({ quantityStepper: false })` to render the legacy
`.go-tickets-item-select` `<select>` instead. _(Since `UNRELEASED`)_

## Localization

| Translation Key                 | Default Value |
| ------------------------------- | ------------- |
| `product.detail.table.title`    | Title         |
| `product.detail.table.desc`     | Description   |
| `product.detail.table.price`    | Price         |
| `product.detail.table.quantity` | Quantity      |
| `common.actions.cart`           | Add to Basket |

## Sub components

These subcomponents work and interact with each other when they are placed inside the `Tickets` component.

### `go-ticket-segment`

The `go-ticket-segment` component filters tickets based on the selected filters. A `go-ticket` can have multiple `go-ticket-segment` components.

#### `timeslot`

Loads time slot based tickets for a specific date and time.

| Attribute           | Required | Applies to                                  |
| ------------------- | -------- | ------------------------------------------- |
| `selected-date`     | Yes      | `go-ticket-selection`                       |
| `selected-timeslot` | Yes      | `go-ticket-selection`                       |
| `filters`           | Yes      | `go-ticket-selection`                       |
| `museum-ids`        | No       | `go-ticket-selection` / `go-ticket-segment` |
| `exhibition-ids`    | No       | `go-ticket-selection`                       |
| `ticket-ids`        | No       | `go-ticket-selection`                       |
| `ticket-group-ids`  | No       | `go-ticket-selection` / `go-ticket-segment` |
| `with-content`      | No       | `go-ticket-segment`                         |

**Note:** `filters` must include `ticket:timeslot`. Segment's `ticket-group-ids` overrides parent.

#### `day`

Loads day tickets (normal ticket type) for a specific date.

| Attribute          | Required | Applies to                                  |
| ------------------ | -------- | ------------------------------------------- |
| `selected-date`    | Yes      | `go-ticket-selection`                       |
| `filters`          | Yes      | `go-ticket-selection`                       |
| `museum-ids`       | No       | `go-ticket-selection` / `go-ticket-segment` |
| `exhibition-ids`   | No       | `go-ticket-selection`                       |
| `ticket-ids`       | No       | `go-ticket-selection`                       |
| `ticket-group-ids` | No       | `go-ticket-selection` / `go-ticket-segment` |
| `with-content`     | No       | `go-ticket-segment`                         |

**Note:** `filters` must include `ticket:day`. Segment's `museum-ids` and `ticket-group-ids` override parent.

#### `annual`

Loads annual/membership tickets (no date/time requirements).

| Attribute          | Required | Applies to                                  |
| ------------------ | -------- | ------------------------------------------- |
| `filters`          | Yes      | `go-ticket-selection`                       |
| `ticket-ids`       | No       | `go-ticket-selection`                       |
| `ticket-group-ids` | No       | `go-ticket-selection` / `go-ticket-segment` |
| `with-content`     | No       | `go-ticket-segment`                         |

**Note:** `filters` must include `ticket:annual`. Segment's `ticket-group-ids` overrides parent.

#### `with-content` (per-ticket info button)

Since `UNRELEASED`

Add `with-content` to a `go-ticket-segment` to fetch each ticket's extra content
attributes (batched) and merge them onto the tickets. When a ticket carries a
reduction reason, the row renders an accessible toggle button
(`button.go-ticket-info-icon`, with `aria-expanded` / `aria-controls`) that expands
a panel showing the **translated** reduction reason — the value is an i18n key,
resolved in your active locale, never shown raw.

Works for any segment whose filter loads standard tickets — the `ticket:*` filters
(`ticket:timeslot`, `ticket:day`, `ticket:annual`) and the event-admission filters
(`event:admission`, `event:admission:day`, `event:admission:timeslot`, and their
`events:` multi-date variants). Not supported for `event:price` / `events:price`:
those are priced event tickets and carry no content.

Omit the attribute and no extra request is made. The content is best-effort: a
failed or empty fetch simply renders no info buttons and never blanks the ticket
list.

```html
<go-ticket-segment filters="ticket:day" with-content></go-ticket-segment>
<go-ticket-segment filters="event:admission" with-content></go-ticket-segment>
```

### Event Ticket Types

Event tickets come in two subtypes, both represented by a single `Event` product type:

- **flat** — single fixed price per ticket.
- **scale** — price scales by attribute (e.g. age group), keyed by `scale_price_id`.

The subtype is selected automatically from the API response (`scale_price_id` present → `scale`, absent → `flat`). Integrators do not choose it; the filters below determine which API endpoint is queried.

#### `event:admission`

Loads an event's admission tickets for a specific date and time.

| Attribute       | Required | Applies to            |
| --------------- | -------- | --------------------- |
| `event-ids`     | Yes      | `go-ticket-selection` |
| `selected-date` | Yes      | `go-ticket-selection` |
| `selected-time` | Yes      | `go-ticket-selection` |
| `with-content`  | No       | `go-ticket-segment`   |

**Note:** `filters` must include `event:admission`. Only supports one event ID.

#### `event:price`

Loads the price tickets for a single event date (flat or scaled, per the event's configuration).

| Attribute   | Required | Applies to            |
| ----------- | -------- | --------------------- |
| `event-ids` | Yes      | `go-ticket-selection` |
| `filters`   | Yes      | `go-ticket-selection` |
| `date-id`   | Yes      | `go-ticket-segment`   |

**Note:** `filters` must include `event:price`. Only supports one event ID.

#### `events:price`

Loads price tickets across multiple event dates (flat or scaled, per each event's configuration).

| Attribute        | Required | Applies to                                  |
| ---------------- | -------- | ------------------------------------------- |
| `selected-date`  | Yes      | `go-ticket-selection`                       |
| `selected-time`  | Yes      | `go-ticket-selection`                       |
| `filters`        | Yes      | `go-ticket-selection`                       |
| `museum-ids`     | No       | `go-ticket-selection` / `go-ticket-segment` |
| `exhibition-ids` | No       | `go-ticket-selection`                       |
| `event-ids`      | No       | `go-ticket-selection`                       |
| `limit`          | No       | `go-ticket-segment`                         |
| `query`          | No       | `go-ticket-segment`                         |
| `language-ids`   | No       | `go-ticket-segment`                         |
| `catch-word-ids` | No       | `go-ticket-segment`                         |

**Note:** `filters` must include `events:price`. Segment's `limit` defaults to 30. `query` filters tickets by title.

#### `custom`

Custom filter with no automatic ticket loading.

No attributes required. Requires manual implementation.

#### Styling

The `go-ticket-segment` component dynamically applies CSS classes based on the number of tickets in the cart:

- `is-empty` - applied when there are no tickets selected (numTickets === 0)

### `go-ticket-segment-sum`:

Shows the price sum of all selected tickets in the ticket group.
it has to be placed inside a `go-ticket-segment` component.

### `go-tickets-sum`:

Show the price sum of all selected tickets.

### Empty Tickets Component

The `go-tickets-empty` component displays content when no tickets are available or visible in the ticket selection interface.

This is a subcomponent of `go-ticket-selection` component. It automatically shows or hides based on ticket availability and visibility state.

#### Example

```html
<go-tickets-empty>
  <p>No tickets available for the selected date and time.</p>
</go-tickets-empty>
```
