# `<go-tickets>`

Since `v1.0.0`

The ticket list of a ticket selection. `<go-tickets>` wraps one or more `<go-ticket-segment>` elements that load and render the selectable tickets, together with per-segment and overall price sums and empty states. Place it inside `<go-ticket-selection>` — it only functions there.

## Examples

Basic — one segment, inheriting the selection's filters:

```html
<go-ticket-selection filters="ticket:timeslot">
  <go-calendar></go-calendar>
  <go-timeslots></go-timeslots>
  <go-tickets>
    <go-ticket-segment>
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Multiple segments with their own filters, sums and empty states:

```html
<go-ticket-selection filters="ticket:day,ticket:annual" selected-date="2026-07-01">
  <go-calendar></go-calendar>
  <go-tickets>
    <go-ticket-segment filters="ticket:day" ticket-group-ids="12">
      <go-ticket-segment-body></go-ticket-segment-body>
      <go-ticket-segment-sum></go-ticket-segment-sum>
      <go-ticket-segment-empty>
        <p>No day tickets available.</p>
      </go-ticket-segment-empty>
    </go-ticket-segment>
    <go-ticket-segment filters="ticket:annual">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
    <go-tickets-sum></go-tickets-sum>
  </go-tickets>
  <go-tickets-empty>
    <p>No tickets available for the selected date.</p>
  </go-tickets-empty>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Event prices for a single event date:

```html
<go-ticket-selection filters="event:price" event-ids="263">
  <go-tickets>
    <go-ticket-segment date-id="1234">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

## Attributes

`<go-tickets>`, `<go-tickets-empty>`, `<go-tickets-sum>`, `<go-ticket-segment-body>`, `<go-ticket-segment-empty>` and `<go-ticket-segment-sum>` take no attributes.

`<go-ticket-segment>`:

| Attribute          | Type    | Default   | Description                                                                                  | Since     |
| ------------------ | ------- | --------- | -------------------------------------------------------------------------------------------- | --------- |
| `filters`          | string  | inherited | Comma-separated filter list for this segment; falls back to the parent selection's `filters` |           |
| `date-id`          | number  | —         | Event date to load prices for — required by the `event:price` filter                         | `v1.21.0` |
| `museum-ids`       | string  | inherited | Comma-separated museum IDs; overrides the parent selection's                                 | `v1.34.0` |
| `ticket-group-ids` | string  | inherited | Comma-separated ticket-group IDs; overrides the parent selection's                           | `v1.34.0` |
| `language-ids`     | string  | —         | Comma-separated language IDs (`events:price`)                                                | `v1.34.0` |
| `catch-word-ids`   | string  | —         | Comma-separated catchword IDs (`events:price`)                                               | `v1.34.0` |
| `query`            | string  | —         | Only keep tickets whose title contains this text (`events:price`)                            |           |
| `limit`            | number  | `30`      | Maximum number of event dates fetched (`events:price`)                                       | `v1.34.0` |
| `with-content`     | boolean | off       | Fetch extra ticket content and render per-ticket info buttons — see below                    | `v3.11.0` |

The segment reloads its tickets automatically whenever one of these attributes — or the parent selection's date or timeslot — changes.

## Events

These components emit no custom events.

## Styling

The component dynamically applies CSS classes based on its visibility state:

- `is-visible` - applied when the component is shown
- `is-hidden` - applied when the component is hidden

The component's `display` style property is automatically set to `block` when visible and `none` when hidden.

### Ticket list

Inside a segment, `go-ticket-segment-body` renders the ticket table with these hooks:

- `.go-tickets` — the list element
- `.go-tickets-header` — the header row, with `.go-tickets-header-title`, `.go-tickets-header-description`, `.go-tickets-header-price` and `.go-tickets-header-quality` cells
- `.go-tickets-item` — one ticket row; gets `.is-booked-out` when the ticket is sold out
- `.go-tickets-item-title`, `.go-tickets-item-description`, `.go-tickets-item-price`, `.go-tickets-item-quality` — the row's cells
- `.go-tickets-item-title-event-title` / `.go-tickets-item-title-product-title` — for event tickets, the event title (with time) and the price title inside the title cell

### Ticket subtitle

Since `v4.11.0`

When a ticket carries a subtitle, it renders inside the row's title cell as its own
`span.go-tickets-item-subtitle`, so you can style it independently of the title:

```css
.go-tickets-item-subtitle {
  display: block;
  font-size: 0.85em;
}
```

### Quantity control

Each listed ticket renders an accessible `− qty +` quantity stepper
(`.go-quantity-stepper`, containing the `.go-quantity-stepper-button` buttons —
`.go-quantity-stepper-decrement` / `.go-quantity-stepper-increment` individually —
and a `.go-quantity-stepper-value` editable spinbutton input). Pressing `+` from `0` jumps straight to the ticket's
minimum party size, and `−` at that minimum returns to `0`. Set
`go.config({ quantityStepper: false })` to render the legacy
`.go-quantity-select` `<select>` instead. _(Since `v4.0.0`)_

## Nesting

All components on this page must be placed inside `<go-ticket-selection>`. `<go-ticket-segment-body>`, `<go-ticket-segment-sum>` and `<go-ticket-segment-empty>` additionally belong inside a `<go-ticket-segment>`.

## Subcomponents

- `<go-ticket-segment>` — loads and holds one group of tickets
- `<go-ticket-segment-body>` — renders the segment's ticket rows
- `<go-ticket-segment-sum>` — the segment's price sum
- `<go-ticket-segment-empty>` — your empty state for one segment
- `<go-tickets-sum>` — the price sum across all segments
- `<go-tickets-empty>` — your empty state for the whole ticket list

The sections below describe each in detail.

### `go-ticket-segment`

Since `v1.9.0`

The `go-ticket-segment` component loads one group of tickets, driven by its `filters` (inherited from the parent `go-ticket-selection` when not set). A `go-tickets` can contain multiple `go-ticket-segment` components, each with its own filters. The segment renders nothing by itself — add a `go-ticket-segment-body` child to show the ticket rows.

Which filters exist, what each one loads, and which attributes it needs — on the selection or on the segment — is documented per filter under **Components / Ticket Selection / Filters**. The attributes table above lists every segment-level attribute.

#### `with-content` (per-ticket info button)

Since `v3.11.0`

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

#### Bundle tickets (Mantelticket)

Since `v4.0.0`

When a selectable ticket is a bundle ticket (Mantelticket), it carries a fixed set of sub-tickets that the visitor composes before adding the bundle to the cart. This renders automatically — there is no extra attribute to set.

Once the bundle's quantity is set to `1` or more, an indented list of its sub-tickets appears directly beneath the ticket row, one row per sub-ticket. Each row lets the visitor pick that sub-ticket's quantity to compose the bundle, bounded by the sub-ticket's minimum and maximum persons (only a sub with a minimum of `0` can be set to `0`); a sub-ticket whose minimum and maximum are equal is shown as fixed (read-only) instead of a selector. Lowering the bundle quantity back to `0` hides the sub-ticket rows. Adding the bundle to the cart carries the chosen composition, and checkout submits it as a single line.

The selection markup is unchanged — bundles render inside the usual `<go-tickets>` / `<go-ticket-segment>`:

```html
<go-ticket-selection filters="ticket:timeslot" selected-date="2026-07-01" selected-timeslot="2026-07-01T11:00:00+02:00">
  <go-tickets>
    <go-ticket-segment filters="ticket:timeslot">
      <go-ticket-segment-body></go-ticket-segment-body>
      <go-ticket-segment-sum></go-ticket-segment-sum>
    </go-ticket-segment>
  </go-tickets>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

Set the bundle's quantity to `1` and its sub-ticket rows appear beneath it (the styling hooks are listed under [Styling](#styling)):

#### Styling

The `go-ticket-segment` component dynamically applies CSS classes based on the tickets it has loaded:

- `is-empty` - applied while the segment has no tickets to show

Bundle tickets (Mantelticket) render their sub-ticket rows with these hooks:

- `.go-sub-tickets` — the indented list wrapping a bundle's sub-ticket rows
- `.go-sub-ticket` — each sub-ticket row
- `.go-sub-ticket.is-fixed` — a sub-ticket whose quantity is fixed (shown as text, not a selector)
- `.go-sub-ticket.is-empty` — a sub-ticket whose quantity is currently `0`
- `.go-sub-ticket-title` — the sub-ticket title
- `.go-sub-ticket-description` — the sub-ticket description (present only when set)
- editable sub-tickets render the shared quantity control — the `.go-quantity-stepper` stepper by default, or a `.go-quantity-select` `<select>` with `go.config({ quantityStepper: false })`
- `.go-sub-ticket-quantity` — the quantity text shown for a fixed sub-ticket

```css
.go-sub-tickets {
  margin-left: 1.5rem;
}
.go-sub-ticket.is-empty {
  opacity: 0.6;
}
```

### `go-ticket-segment-body`

Since `v1.9.0`

Renders the segment's ticket rows — a header row plus one row per loaded ticket with title, description, price and a quantity control. Must be placed inside a `go-ticket-segment`; without it the segment shows no tickets.

### `go-ticket-segment-sum`

Since `v1.9.0`

Shows the price sum of all selected tickets in the ticket group. Must be placed inside a `go-ticket-segment` component.

### `go-ticket-segment-empty`

Since `v1.34.0`

Wraps your own empty state for a single segment: shown while that segment has no tickets (or while the tickets step is hidden), hidden as soon as tickets load. Toggles `is-visible` / `is-hidden` classes and its `display` style. Must be placed inside a `go-ticket-segment`.

### `go-tickets-sum`

Shows the price sum of all selected tickets across every segment.

### `go-tickets-empty`

Since `v1.31.0`

The `go-tickets-empty` component displays your own markup while no tickets are available (or while the tickets step is hidden), and hides as soon as any segment has tickets. It toggles the same `is-visible` / `is-hidden` classes and `display` style as `go-tickets`.

#### Example

```html
<go-tickets-empty>
  <p>No tickets available for the selected date and time.</p>
</go-tickets-empty>
```

## Conditional rendering with `<go-if>`

`<go-tickets>` shows and hides itself, so it rarely needs gating. To gate your own surrounding markup on the tickets step, use the selection's handle:

```html
<go-if when="data.ticketSelection.isTicketsVisible">
  <h2>Choose your tickets</h2>
</go-if>
```

## Localization

| Key                             | Purpose                                       |
| ------------------------------- | --------------------------------------------- |
| `product.detail.table.title`    | Header — title column                         |
| `product.detail.table.desc`     | Header — description column                   |
| `product.detail.table.price`    | Header — price column                         |
| `product.detail.table.quantity` | Header — quantity column                      |
| `quantity.decrease`             | Accessible name of the stepper's `−` button   |
| `quantity.increase`             | Accessible name of the stepper's `+` button   |
| `ticket.list.additionalInfo`    | Accessible name of the per-ticket info button |
