# Ticket Selection Component

The `go-ticket` component lists tickets to be added to the cart.

This component is a subcomponent of `go-ticket-selection` component, and will only function when it is placed inside one.

## Styling

The component dynamically applies CSS classes based on its visibility state:

- `is-visible` - applied when the component is shown
- `is-hidden` - applied when the component is hidden

The component's `display` style property is automatically set to `block` when visible and `none` when hidden.

## Localization

| Translation Key                 | Default Value |
|---------------------------------|---------------|
| `product.detail.table.title`    | Title         |
| `product.detail.table.desc`     | Description   |
| `product.detail.table.price`    | Price         |
| `product.detail.table.quantity` | Quantity      |
| `common.actions.cart`           | Add to Basket |

## Sub components

These subcomponnts work and interact with each other when they are placed inside the `Tickets` component.
### `go-ticket-segment`
The `go-ticket-segment` component filters tickets based on the selected filters. A `go-ticket` can have multiple `go-ticket-segment` components.

#### `timeslot`

Loads time slot based tickets for a specific date and time.

| Attribute           | Required | Applies to                                  |
|---------------------|----------|---------------------------------------------|
| `selected-date`     | Yes      | `go-ticket-selection`                       |
| `selected-timeslot` | Yes      | `go-ticket-selection`                       |
| `filters`           | Yes      | `go-ticket-selection`                       |
| `museum-ids`        | No       | `go-ticket-selection` / `go-ticket-segment` |
| `exhibition-ids`    | No       | `go-ticket-selection`                       |
| `ticket-ids`        | No       | `go-ticket-selection`                       |
| `ticket-group-ids`  | No       | `go-ticket-selection` / `go-ticket-segment` |

**Note:** `filters` must include "timeslot". Segment's `ticket-group-ids` overrides parent.

#### `day`

Loads day tickets (normal ticket type) for a specific date.

| Attribute          | Required | Applies to                                  |
|--------------------|----------|---------------------------------------------|
| `selected-date`    | Yes      | `go-ticket-selection`                       |
| `filters`          | Yes      | `go-ticket-selection`                       |
| `museum-ids`       | No       | `go-ticket-selection` / `go-ticket-segment` |
| `exhibition-ids`   | No       | `go-ticket-selection`                       |
| `ticket-ids`       | No       | `go-ticket-selection`                       |
| `ticket-group-ids` | No       | `go-ticket-selection` / `go-ticket-segment` |

**Note:** `filters` must include "day". Segment's `museum-ids` and `ticket-group-ids` override parent.

#### `annual`

Loads annual/membership tickets (no date/time requirements).

| Attribute          | Required | Applies to                                  |
|--------------------|----------|---------------------------------------------|
| `filters`          | Yes      | `go-ticket-selection`                       |
| `ticket-ids`       | No       | `go-ticket-selection`                       |
| `ticket-group-ids` | No       | `go-ticket-selection` / `go-ticket-segment` |

**Note:** `filters` must include "annual". Segment's `ticket-group-ids` overrides parent.

### Event Ticket Types

Event tickets come in two subtypes, both represented by a single `Event` product type:

- **flat** — single fixed price per ticket.
- **scale** — price scales by attribute (e.g. age group), keyed by `scale_price_id`.

The subtype is selected automatically from the API response (`scale_price_id` present → `scale`, absent → `flat`). Integrators do not choose it; the filters below determine which API endpoint is queried.

#### `event:ticket`

Loads regular tickets for a single event on a specific date.

| Attribute       | Required | Applies to            |
|-----------------|----------|-----------------------|
| `event-ids`     | Yes      | `go-ticket-selection` |
| `selected-date` | Yes      | `go-ticket-selection` |
| `selected-time` | Yes      | `go-ticket-selection` |
| `date-id`       | No       | `go-ticket-segment`   |

**Note:** Only supports one event ID.

#### `event:scaled-price`

Loads scaled price tickets for a single event date.

| Attribute   | Required | Applies to            |
|-------------|----------|-----------------------|
| `event-ids` | Yes      | `go-ticket-selection` |
| `filters`   | Yes      | `go-ticket-selection` |
| `date-id`   | Yes      | `go-ticket-segment`   |

**Note:** `filters` must include "event:scaled-price". Only supports one event ID.

#### `events:scaled-price`

Loads scaled price tickets across multiple events.

| Attribute        | Required | Applies to                                  |
|------------------|----------|---------------------------------------------|
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

**Note:** `filters` must include "events:scaled-price". Segment's `limit` defaults to 30. `query` filters tickets by title.

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
