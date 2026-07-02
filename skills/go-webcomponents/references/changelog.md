# Changelog

What changed for integrators, newest first. Each entry lists New / Changed / Deprecated / Breaking → migration for one library version.

---

# v3.10.1

_Released 2026-07-02_

Fixes stale capacity in `<go-ticket-selection>` when the cart changes on the same page.

## Fixed

- `<go-ticket-selection>`: ticket rows and the timeslot picker now refresh their available capacity live when the cart changes. Previously, on a page embedding the selection next to `<go-cart>`, editing or removing a cart item never re-derived the selection's capacity: a row that went booked-out stayed at quantity `0` even after the visitor freed the seats (until a date change or reload), and the timeslot picker kept showing already-consumed slots as available — and freed slots as sold-out. No markup or attribute changes — embeds need no updates.

---

# v3.10.0

_Released 2026-07-01_

Item quantities in `<go-tickets>` and `<go-cart>` are now picked with an accessible `− qty +` stepper instead of a `<select>` dropdown — on by default, with a config flag to opt back out.

## New

- `go.config({ quantityStepper })` — toggles the item quantity control library-wide. Defaults to `true` (the new stepper); set it to `false` to keep the legacy `<select>` dropdown in `<go-tickets>` and `<go-cart>`.

## Changed (behavior)

- The per-item quantity control in `<go-tickets>` and `<go-cart>` is now a `− qty +` stepper built to the WAI-ARIA spinbutton pattern: the value is an editable `role="spinbutton"` field (type a number, or use `↑` / `↓` / `Home` / `End`) and the `−` / `+` buttons disable at the available bounds. Pressing `+` from `0` jumps to the ticket's minimum party size; `−` at that minimum returns to `0`.
- In `<go-cart>`, `−` can now take a line down to `0` without removing it — the line stays in the cart at `0`, and only the ✕ button removes it. (The legacy `<select>` had no `0` option; removal was ✕-only.)

## Breaking → migration

### Quantity control markup changed from `<select>` to a stepper

`<go-tickets>` and `<go-cart>` now render the quantity control as a `− qty +` stepper by default, so the old `<select>` style hooks (`.go-tickets-item-select`, `.go-cart-item-select`) no longer match. Restyle against the new hooks, or opt back out of the stepper.

Before:

```css
.go-tickets-item-select {
  /* … */
}
.go-cart-item-select {
  /* … */
}
```

After:

```css
.go-quantity-stepper {
  /* the − qty + wrapper (role="group") */
}
.go-quantity-stepper-decrement,
.go-quantity-stepper-increment {
  /* the − and + buttons */
}
.go-quantity-stepper-value {
  /* the editable spinbutton input */
}
```

Or, drop-in (restore the old `<select>` and its classes):

```js
go.config({ quantityStepper: false })
```

---

# v3.9.0

_Released 2026-06-30_

A new opt-in per-ticket info button: a `<go-ticket-segment>` can now fetch and show
each ticket's extra content — such as a reduction reason — behind an accessible toggle.

## New

- `<go-ticket-segment>` gains a `with-content` attribute — an opt-in per-ticket info
  button for any segment that loads standard tickets: the `ticket:*` filters
  (`ticket:timeslot`, `ticket:day`, `ticket:annual`) and the event-admission filters
  (`event:admission`, `event:admission:day`, `event:admission:timeslot`, and their
  `events:` multi-date variants). The price filters (`event:price`, `events:price`)
  are excluded — those tickets carry no content. When a ticket carries a reduction
  reason, the row renders an accessible toggle button (`button.go-ticket-info-icon`,
  with `aria-expanded` / `aria-controls`) that expands a panel showing the translated
  reason. Off by default — no extra request is made unless you add the attribute, and
  the content is best-effort, so a failed fetch simply renders no info buttons and
  never blanks the ticket list.

---

# v3.8.3

_Released 2026-06-30_

Loading the components under a strict Content Security Policy no longer triggers a violation — you no longer need `'unsafe-eval'` in your `script-src`.

## Fixed

- Embedding the components on a page with a strict CSP (`script-src` without `'unsafe-eval'`) no longer raises a `securitypolicyviolation`. The bundle previously probed for runtime code evaluation as it loaded, which strict policies reported as a violation; it no longer does. If `'unsafe-eval'` was in your `script-src` only for the gomus components, you can remove it.

---

# v3.8.2

_Released 2026-06-22_

Fixes an `event:admission` segment listing tickets that don't belong to the event.

## Fixed

- `event:admission`: the segment now offers **only the selected event's own admission tickets**. Previously its product loader fetched every bookable shop ticket valid that day (other events, general admission), so an unrelated ticket sharing the event's timeslot could appear in the segment — and could be added to the cart as if it admitted to the event. The loader now scopes its request to the event's tickets, matching the timeslot picker and the `event:admission:day` / `event:admission:timeslot` filters. No markup or attribute changes — embeds need no updates.

---

# v3.8.1

_Released 2026-06-22_

Fixes the timeslot picker showing slots that belong to a different ticket segment or selection on the page.

## Fixed

- `<go-timeslots>`: the picker no longer shows timeslots that belong to another segment or to a different `<go-ticket-selection>` on the page. Previously, when a selection combined a timeslot segment with a day-ticket segment (e.g. an audio guide), the day ticket's quota — typically a single slot at midnight — surfaced in the timeslot picker as a bogus selectable time; slots from a second selection or a previous page could leak in the same way. The picker now shows only the timeslots loaded for that selection. No markup or attribute changes — embeds need no updates.

---

# v3.8.0

_Released 2026-06-22_

Gift-card vouchers (Wertgutschein) can now be redeemed in the cart, and their credit is deducted from the amount left to pay.

## New

- `<go-coupon-redemption>` now redeems **Wertgutschein** (value-voucher) codes — gift-card credit applied toward the cart total — in addition to action tokens and service vouchers.

## Changed (behavior)

- Cart totals now account for value-voucher credit: `<go-cart-total-amount>` shows the amount left to pay after subtracting any redeemed Wertgutschein balance, and that credit is included in `<go-cart-discounted-amount>`.
- A value voucher always renders active in `<go-cart-coupons>` (never `go-cart-coupon-inactive`), because it is applied client-side and the backend never echoes it back.
- `go-submit` no longer fires when a coupon redemption fails. An invalid code now blocks checkout — `<go-coupon-redemption>` shows the error inline and the cart stays put. (Previously `go-submit` fired with `detail.ok === false`, leaving each integrator to detect and abort.)

---

# v3.5.0

_Released 2026-06-15_

Fixes a deep-link dead end in `<go-ticket-selection>` and a wrong-day bug in cart and order dates for visitors outside Central European Time, and reflects `selected-timeslot` back to the DOM attribute.

## Changed (behavior)

- `<go-ticket-selection>` now reflects `selected-timeslot` back to the DOM attribute as the selection changes — it updates when a timeslot is picked and clears when the visitor changes the day (parity with `selected-date`). Read the live selection via `el.getAttribute('selected-timeslot')`.

## Fixed

- `<go-ticket-selection>`: a deep-linked `selected-timeslot` was silently re-applied after the visitor picked a different day, flipping the ticket section visible and filtering the new day's tickets against the previous day's slot — stranding the visitor on a visible-but-empty ticket list until reload. The slot is now cleared on a day change, so the ticket section stays hidden until a timeslot for the new day is picked.
- Cart lines and the order confirmation now show the visit date in the museum's timezone (Europe/Berlin). Previously the date was formatted in the visitor's browser timezone while the time stayed pinned to Berlin, so visitors outside Central European Time could see a day that disagreed with the time shown next to it (e.g. an 08:30 slot showing the previous day).

---

# v3.4.0

_Released 2026-06-15_

Documentation and tooling release — no changes to the `<go-*>` components themselves.

## Fixed

- Documentation examples corrected: the cart event listener uses `event.detail` (not `event.details`); the password component is `<go-profile-password>` (the doc previously showed a non-existent tag name); the checkout-form custom example uses `<go-submit>` (not a non-existent `<go-submit-button>`).
- The `<go-sign-in>` documentation now covers the `custom` attribute and the `go-success` event (both available since `v1.1.0`) alongside styling, nesting, and `<go-if>` usage.

---

# v3.3.4

_Released 2026-06-08_

Patch release fixing a blank title on scaled event tickets.

## Fixed

- Scaled event ticket titles now render correctly in `<go-tickets>`. The event name was previously blank for any `event:price` ticket backed by a scale price; it now displays as intended.

---

# v3.3.3

_Released 2026-06-04_

Fixes timeslot availability state: slots that were never offered (zero total capacity) are now correctly distinguished from sold-out slots.

## New

- `<go-timeslots>` gains an `is-unavailable` class on slots whose total capacity is 0 — slots that were never offered, as opposed to slots that sold out. Style it independently of `is-sold-out` if needed.

## Fixed

- `<go-timeslots>` previously marked slots with zero total capacity as `is-sold-out`. They are now marked `is-unavailable` instead — `is-sold-out` is reserved for slots that had capacity and are now exhausted.

## Changed (behavior)

- On `<go-timeslots>`, `is-sold-out` is no longer applied to slots whose total capacity is 0. If your CSS targets `.go-timeslot.is-sold-out` to suppress these slots, add a matching rule for `.go-timeslot.is-unavailable`.

---

# v3.3.2

_Released 2026-06-03_

Patch fixing a sold-out false positive in `<go-timeslots>` when an unrelated ticket type had zero capacity.

## Fixed

- A timeslot could appear sold out in `<go-timeslots>` when one ticket type on that slot
  had zero remaining capacity, even if other ticket types still had availability. The slot
  is now shown as bookable whenever any of its ticket types can still be booked.

---

# v3.3.1

_Released 2026-06-02_

Patch release removing two components that were unintentionally included in the production bundle.

## Fixed

- `<go-mainnav>` and `<gomus-paypal>` are no longer registered by the bundle. Both were accidentally bundled in v3.3.0 and have been removed; they are not part of the supported integration surface.

---

# v3.3.0

_Released 2026-06-02_

Adds `<go-withdrawal-form>` — a ready-made form for customers to submit an order-cancellation (withdrawal) request.

## New

- `<go-withdrawal-form>` — renders a withdrawal request form collecting the customer's first name, last name, email address, order number, and an optional note. Submits to the gomus withdrawal endpoint and dispatches `go-success` on a 2xx response.
- `custom` attribute on `<go-withdrawal-form>` — suppresses the default field layout; compose your own children (`<go-field>`, `<go-submit>`, `<go-success-feedback>`, `<go-errors-feedback>`) while the component still owns submission, validation, and event dispatching.

## Fixed

- `<go-field>` with `type="textarea"` now renders a `<textarea>` element instead of nothing. This was a prerequisite for the `withdrawalNote` field in `<go-withdrawal-form>` but also affects any custom form that uses a textarea field.

---

# v3.2.0

_Released 2026-06-02_

Security fix: ticket descriptions are now sanitized before rendering.

## Fixed

- Ticket descriptions rendered inside `[data-go-tickets-description]` are now
  sanitized with DOMPurify — `<script>` tags and inline event handlers (`onerror`,
  `onclick`, etc.) are stripped. Safe formatting markup (`<p>`, `<strong>`, `<em>`,
  `<img>` without handlers) is preserved.

---

# v3.1.1

_Released 2026-05-26_

Patch release: stale cart items are now reliably purged on page load regardless of ticket type.

## Fixed

- Day tickets and event tickets whose date has passed are now removed from the persisted cart on page load, instead of reappearing as stale items. Previously only timeslot tickets were evicted; day and event tickets with a past date survived across sessions.

---

# v3.1.0

_Released 2026-05-26_

Coupon codes are now normalized to uppercase on entry, and cross-tab auth sync fires immediately instead of with up to a one-second delay.

## Changed (behavior)

- `<go-coupon-redemption>` now stores coupon codes as uppercase — a user who types
  `promo2024` will have `PROMO2024` recorded in the cart. The backend treats codes as
  case-insensitive, so this is transparent for most users, but any code displayed back
  to the user (e.g. via `<go-if>` or a custom summary) will appear in uppercase.

## Fixed

- Cross-tab authentication sync now fires immediately when another tab signs in or
  out, instead of waiting up to one second. No markup change required.

---

# v3.0.0

_Released 2026-05-26_

`<go-cart>` is now a composable shell: you assemble the cart from subcomponents instead of one self-rendering tag. Coupon styling hooks were renamed, and `<go-if>` can read the cart projection.

## New

- `<go-cart-items>`, `<go-cart-coupons>`, `<go-cart-subtotal-amount>`, `<go-cart-discounted-amount>`, `<go-cart-total-amount>` — place these as children of `<go-cart>` to compose the cart layout yourself. Each renders one slice and renders nothing when its data is absent (an empty coupon list or a zero discount stays empty).
- `<go-if>` placed inside `<go-cart>` exposes the cart projection as `data.cartView`, with fields `isDiscounted` (true when a coupon reduced the total), `subtotalPriceCents`, `totalPriceCents`, and `discountedAmountCents`. Use it to show rows conditionally, e.g. `data.cartView.isDiscounted`.
- `<go-cart>` dispatches a `go-submit` event on its own host when an inner `<go-submit>` is clicked. Before dispatching it flushes any pending `<go-coupon-redemption>` so an unsubmitted token is applied first; `event.detail.ok === false` signals a coupon was rejected. The cart does not navigate on its own — wire the next step in your listener.

## Changed (behavior)

- Coupon codes are validated on `go-after-validation`, not only on form submit. A user who enters a bad coupon alongside a missing required field now sees the invalid-coupon error immediately, instead of only after fixing the field and resubmitting.
- Coupons the backend ignores now render with the `go-cart-coupon-inactive` class on their row, so you can grey out or strike through coupons that did not apply.

## Breaking → migration

### `<go-cart>` is now a composable shell

`<go-cart></go-cart>` no longer renders the standard layout on its own — it coordinates subcomponents you place inside it. There is no drop-in attribute; compose the subcomponents you need.

Before:

```html
<go-cart></go-cart>
```

After:

```html
<go-cart>
  <go-cart-items></go-cart-items>
  <go-cart-coupons></go-cart-coupons>
  <go-cart-subtotal-amount></go-cart-subtotal-amount>
  <go-cart-discounted-amount></go-cart-discounted-amount>
  <go-cart-total-amount></go-cart-total-amount>
</go-cart>
```

### Coupon row classes renamed

Coupon rows are no longer rendered as cart-item rows. Update your CSS selectors: the row, the code label, and the remove button each have dedicated classes, and the remove button also carries the shared `.go-cart-remove` class (used by item and coupon remove buttons alike).

Before:

```css
.go-cart-item.go-cart-coupon-inactive {
} /* inactive coupon row */
.go-cart-item-title {
} /* coupon code (shared with item titles) */
.go-cart-item-remove button {
} /* coupon remove button */
```

After:

```css
.go-cart-coupon {
} /* coupon row */
.go-cart-coupon.go-cart-coupon-inactive {
} /* coupon the backend ignored */
.go-cart-coupon-code {
} /* coupon code label */
.go-cart-coupon-remove {
} /* coupon remove button (also carries .go-cart-remove) */
```

---

# v3.0.0-next.3

_Released 2026-05-21_

Preview release on the `next` channel. This increment drops the short-lived `default`
attribute on `<go-cart>` introduced in the previous preview — you now always compose
the cart from its subcomponents — and hardens the order ticket-download view against a
missing barcode.

## Fixed

- The `<go-order>` ticket list no longer crashes rendering a sale line when a ticket has
  no barcode for a given slot; the download link is simply omitted for that entry.

## Breaking → migration

### `<go-cart default>` removed

The `default` attribute (shipped in `v3.0.0-next.2`) is gone. `<go-cart>` no longer
injects a standard layout — always compose the subcomponents yourself.

Before:

```html
<go-cart default></go-cart>
```

After:

```html
<go-cart>
  <go-cart-items></go-cart-items>
  <go-cart-coupons></go-cart-coupons>
  <go-cart-total-amount></go-cart-total-amount>
</go-cart>
```

---

# v3.0.0-next.2

_Released 2026-05-21_

Preview release on the `next` channel — no integration-facing changes since v3.0.0-next.1.

---

# v3.0.0-next.1

_Released 2026-05-11_

Preview release on the `next` channel — the first cut of the v3.0.0 composable-cart rewrite. `<go-cart>` becomes a shell you fill with subcomponents instead of one self-rendering tag, coupon styling hooks are renamed, and `<go-if>` can read the cart projection.

## New

- `<go-cart-items>`, `<go-cart-coupons>`, `<go-cart-subtotal-amount>`, `<go-cart-discounted-amount>`, `<go-cart-total-amount>` — place these as children of `<go-cart>` to compose the cart layout yourself, in any order. Each renders one slice and renders nothing when its data is absent (an empty coupon list, or a zero discount, stays empty rather than printing `0,00 €`).
- `<go-cart>` gains a `default` attribute — `<go-cart default>` injects the standard subcomponents (items, coupons, total) when it has no children, so existing single-tag usage keeps working.
- `<go-if>` placed inside `<go-cart>` exposes the cart projection as `data.cartView`, with fields `isDiscounted` (true when a coupon reduced the total), `subtotalPriceCents`, `totalPriceCents`, and `discountedAmountCents`. Use it to show rows conditionally, e.g. `data.cartView.isDiscounted`.

## Changed (behavior)

- Coupon codes are validated on `go-after-validation`, not only on form submit. A user who enters a bad coupon alongside a missing required field now sees the invalid-coupon error immediately, instead of only after fixing the field and resubmitting.
- Coupons the backend ignores now render with the `go-cart-coupon-inactive` class on their row, so you can grey out or strike through coupons that did not apply.

## Fixed

- A coupon token typed into `<go-coupon-redemption>` but not submitted is now flushed before checkout, instead of being silently dropped — the discount is applied, or an invalid token aborts checkout with the error surfaced on the form and the typed value left intact for correction.

## Breaking → migration

### `<go-cart>` is now a composable shell

`<go-cart></go-cart>` no longer renders the standard layout on its own — it coordinates subcomponents you place inside it. Compose the subcomponents you need, or add the `default` attribute as a drop-in.

Before:

```html
<go-cart></go-cart>
```

After:

```html
<go-cart>
  <go-cart-items></go-cart-items>
  <go-cart-coupons></go-cart-coupons>
  <go-cart-subtotal-amount></go-cart-subtotal-amount>
  <go-cart-discounted-amount></go-cart-discounted-amount>
  <go-cart-total-amount></go-cart-total-amount>
</go-cart>
```

Or, drop-in:

```html
<go-cart default></go-cart>
```

### Coupon row classes renamed

Coupon rows are no longer rendered as cart-item rows. Update your CSS selectors: the row, the code label, and the remove button each have dedicated classes, and the remove button also carries the shared `.go-cart-remove` class (used by item and coupon remove buttons alike).

Before:

```css
.go-cart-item.go-cart-coupon-inactive {
} /* inactive coupon row */
.go-cart-item-title {
} /* coupon code (shared with item titles) */
.go-cart-item-remove button {
} /* coupon remove button */
```

After:

```css
.go-cart-coupon {
} /* coupon row */
.go-cart-coupon.go-cart-coupon-inactive {
} /* coupon the backend ignored */
.go-cart-coupon-code {
} /* coupon code label */
.go-cart-coupon-remove {
} /* coupon remove button (also carries .go-cart-remove) */
```

---

# v2.1.1

_Released 2026-05-21_

Patch fixing a crash in the order confirmation breakdown when a ticket's barcode list is shorter than its quantity.

## Fixed

- `<go-order>` no longer crashes when rendering the ticket breakdown for an order where
  the number of barcodes returned is less than the ticket quantity — the download link
  now renders safely for each ticket row.

---

# v2.1.1-next.1

_Released 2026-05-08_

Preview release on the `next` channel — no integration-facing changes.

---

# v2.1.0

_Released 2026-05-05_

Maintenance release — no integration-facing changes.

---

# v2.0.0

_Released 2026-05-05_

The ticket-selection filter system was reworked into per-filter modules. Every filter token was renamed, the standalone `event:ticket`/`*-scaled-price` filters became the new `*:admission`/`*:price` set, a segment can now run several filters at once, and a segment without `filters` now inherits from its parent instead of erroring.

## New

- `event:admission` — sells one event's own admission tickets (Adult, Reduced, …); the time-slot capacity is scoped to that event's ticket IDs. Replaces the old `event:ticket`.
- `events:admission` — multi-event "what's on today" listing of each event's admission tickets for a selected date and time window.
- `event:admission:day` and `event:admission:timeslot` — split a single event's admission flow by ticket type: day tickets vs timed-entry tickets. Pair them in two `<go-ticket-segment>`s when an event sells both.
- `events:admission:day` and `events:admission:timeslot` — the same day/timed split for the multi-event listing.
- `<go-ticket-segment filters="a,b">` accepts multiple comma-separated filter tokens — it runs each filter in parallel and merges the resulting tickets into one segment.
- `<go-ticket-segment>` may now omit `filters` entirely to inherit the tokens from the parent `<go-ticket-selection filters="…">`.

## Changed (behavior)

- A `<go-ticket-segment>` with no `filters` attribute now inherits the parent `<go-ticket-selection>` filters instead of throwing (see Breaking).
- Unknown filter tokens are now skipped with a console warning that lists the valid filter names, rather than silently doing nothing. This applies to both `<go-ticket-selection filters>` and `<go-ticket-segment filters>`.

## Deprecated

- The `mode` attribute on `<go-ticket-selection>` is deprecated and ignored; setting it logs a deprecation warning. Drive everything through `filters` instead (e.g. `filters="ticket:timeslot"`).

## Breaking → migration

### All ticket filter tokens were renamed

The flat/scaled-price split filters were dropped and every token was renamed to a namespaced form. Rename the tokens in both `<go-ticket-selection filters="…">` and `<go-ticket-segment filters="…">`. The mapping:

| Before                | After             |
| --------------------- | ----------------- |
| `timeslot`            | `ticket:timeslot` |
| `day`                 | `ticket:day`      |
| `annual`              | `ticket:annual`   |
| `event:ticket`        | `event:admission` |
| `event:scaled-price`  | `event:price`     |
| `events:scaled-price` | `events:price`    |

Before:

```html
<go-ticket-selection filters="timeslot" ticket-ids="12">
  <go-tickets>
    <go-ticket-segment filters="timeslot"></go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

After:

```html
<go-ticket-selection filters="ticket:timeslot" ticket-ids="12">
  <go-tickets>
    <go-ticket-segment filters="ticket:timeslot"></go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

### `event:ticket` is now `event:admission`

The single-event admission filter was renamed and now scopes time-slot capacity to the event's own ticket IDs.

Before:

```html
<go-ticket-selection filters="event:ticket" event-ids="258">
  <go-tickets>
    <go-ticket-segment filters="event:ticket"></go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

After:

```html
<go-ticket-selection filters="event:admission" event-ids="258">
  <go-tickets>
    <go-ticket-segment filters="event:admission"></go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

### A `<go-ticket-segment>` without `filters` no longer errors

Previously a `<go-ticket-segment>` with no `filters` attribute threw `filters is required`. It now inherits the parent `<go-ticket-selection>` filters. If you relied on the error to catch a missing attribute, set the segment filters explicitly; if you want inheritance, you can now drop the attribute.

Before:

```html
<!-- threw: "filters is required" -->
<go-ticket-selection filters="ticket:timeslot" ticket-ids="12">
  <go-tickets>
    <go-ticket-segment></go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

After:

```html
<!-- inherits ticket:timeslot from the parent -->
<go-ticket-selection filters="ticket:timeslot" ticket-ids="12">
  <go-tickets>
    <go-ticket-segment></go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

---

# v1.57.4

_Released 2026-06-08_

Fixes a rendering bug where scaled-price event ticket rows showed a blank event name.

## Fixed

- Scaled-price ticket rows now display the event name in the `.go-tickets-item-title-event-title` span. Previously the span rendered empty (showing only ` - HH:MM`) because the title was read from a non-existent property; it now reads the correct value from the API response.

---

# v1.57.3

_Released 2026-06-05_

Stale cart and seat-availability data persisted across sessions is now automatically discarded on load.

## Fixed

- Cart items and coupon codes stored in the browser are now expired after 15 minutes. A returning visitor whose stored cart is older than 15 minutes starts with a clean cart rather than seeing stale items or incorrect availability.
- Seat and quota data cached in the browser is expired by the same 15-minute window. Stale capacity no longer causes tickets to appear sold-out (or available) based on a session from a previous visit.

---

# v1.57.2

_Released 2026-06-04_

Fixes a timeslot CSS class misclassification where slots with zero total capacity were marked sold out instead of unavailable.

## Fixed

- `<go-timeslots>` now marks a timeslot with zero total capacity (a slot that never offered seats) as `.is-unavailable` rather than `.is-sold-out`. Previously both cases produced `.is-sold-out`, making it impossible to distinguish a never-available slot from one that sold out. The new `.is-unavailable` class is mutually exclusive with `.is-sold-out`.

---

# v1.57.1

_Released 2026-06-03_

Fixes a timeslot availability bug where a sold-out ticket's quota could incorrectly mark other bookable tickets' timeslots as unavailable.

## Fixed

- `<go-timeslots>` no longer shows a timeslot as sold out when only one of the tickets available at that slot is fully booked. The slot now stays selectable as long as any ticket with remaining capacity is offered at that time.

---

# v1.57.0

_Released 2026-05-04_

Annual ticket personalization gains optional photo upload support.

## New

- `<go-field key="photo">` — add this field inside `<go-personalization-form>` to collect a
  photo for each annual ticket holder. Renders as `<input type="file" accept="image/*">`.
  When the ticket sale requires a photo (`photo_mandatory`), the form uploads each image
  before finalizing; missing or failed uploads block submission and surface an error.
- After a file is selected, an image preview renders automatically below the input:
  `.go-file-preview` (the `<img>`) and `.go-file-preview-caption` (the filename) are the
  styling hooks; the wrapping `<figure>` carries `data-field-preview="photo"`.

```html
<go-annual-ticket-personalization-form token="…" ticketSaleId="…">
  <go-form form-id="ticketPersonalization" custom>
    <go-field key="startAt" required></go-field>

    <go-personalization-form>
      <go-form form-id="personalization" custom>
        <go-field key="firstName" required></go-field>
        <go-field key="lastName" required></go-field>
        <go-field key="email" required></go-field>
        <go-field key="confirmEmail" required></go-field>

        <!-- Add when photo upload is required -->
        <go-field key="photo" required></go-field>
      </go-form>
    </go-personalization-form>

    <go-submit>Submit</go-submit>
  </go-form>
</go-annual-ticket-personalization-form>
```

---

# v1.56.1

_Released 2026-04-28_

Maintenance release — no integration-facing changes.

---

# v1.56.0

_Released 2026-04-28_

Event tickets now support flat (fixed) pricing in addition to scaled pricing — both
subtypes are handled transparently by the existing `event:price` and `events:price`
filters.

## Changed (behavior)

- `event:price` and `events:price` now load both flat and scaled event tickets. A
  flat event ticket has a single fixed price per ticket; a scaled one prices by
  attribute (e.g. age group). The subtype is determined automatically from the backend
  response — no filter or markup change is required.

---

# v1.55.3

_Released 2026-04-27_

Fixes a guest-session leak: `<go-order>` now clears the guest auth state on the order confirmation page.

## Fixed

- `<go-order>` now signs out guest accounts when it mounts, so a guest session created during checkout does not persist on the order confirmation page. Logged-in users are unaffected.

---

# v1.55.2

_Released 2026-04-21_

Fixes the checkout form sending the wrong payment ID to the order API.

## Fixed

- `<go-checkout-form>` now correctly passes the selected payment mode to the order. Previously the payment mode chosen in the form was not written to the cart before checkout, so the order was submitted without it.

## Changed (behavior)

- The `beforeSubmit` callback in `<go-checkout-form>` configuration may now return a `Promise`. Previously only synchronous (`void`) callbacks were supported; async hooks are now awaited before the form submits.

---

# v1.55.1

_Released 2026-04-20_

Patch fixing an incorrect date display on annual ticket cart items.

## Fixed

- Annual tickets in the cart no longer show a date next to the ticket title. A selected date was previously carried through to the cart item even though annual tickets are not date-specific.

---

# v1.55.0

_Released 2026-04-20_

`<go-if>` now evaluates `when` expressions with a parser-based engine — no `eval` or `new Function`, so you no longer need `script-src 'unsafe-eval'` in your CSP.

## New

- `<go-if>` is now CSP-safe: `when` expressions are evaluated without `eval` or `new Function`. Remove `'unsafe-eval'` from `script-src` if `<go-if>` was the only reason it was present.
- `when` supports optional chaining (`data.formData?.language_id`), `.length` checks (`data.cart.items.length === 0`), comparisons (`===`, `!==`, `>`, `<`, `>=`, `<=`), boolean operators (`&&`, `||`, `!`), and calls to global functions (`showAlert(data)`).

## Changed (behavior)

- Expressions that use unsupported JS constructs — `new Date()`, inline arrow functions, bracket notation (`data.a?.[0]`), assignments (`a = 1`), and similar — now return `undefined` and log a console error instead of executing. If you relied on any of these forms, move the logic into a global function and call it from `when`:

```html
<go-if when="isCheckoutReady(data)">...</go-if>
```

```js
window.isCheckoutReady = data => {
  return Boolean(data?.ticketSelection?.selectedDate && data?.ticketSelection?.selectedTimeslot)
}
```

---

# v1.54.2

_Released 2026-04-17_

Patch release with two cart fixes: fewer unnecessary network requests and cross-tab
cart sync disabled.

## Changed (behavior)

- `<go-cart>` no longer synchronises cart contents across browser tabs. Previously,
  opening the shop in a second tab would update the first tab's cart via a
  `localStorage` storage event; that sync is now off. Each tab holds its own cart
  state independently.

## Fixed

- `<go-cart>` no longer calls the backend to compute a coupon projection when no
  coupons are applied. The cart renders directly from local state in that case,
  eliminating a redundant network request on every page load.

---

# v1.54.1

_Released 2026-04-16_

Patch fix for cart display when an event uses multiple scale-price tiers.

## Fixed

- When an event offers multiple scale prices (e.g. "Adult" and "Reduced"), each
  price tier now shows its correct final price in `<go-cart>`. Previously, lines
  sharing the same product ID but different scale-price tiers could not be
  distinguished, causing some tiers to display the wrong price.

---

# v1.54.0

_Released 2026-04-16_

Timeslot picker now auto-selects when only one bookable slot is available, and correctly disables unavailable slots.

## Fixed

- `<go-timeslots>` now auto-selects the single available slot and fires `go-timeslot-select` without requiring a user click — single-slot offers (common for day tickets) no longer stall the selection flow. A lone slot with zero capacity is left unselected.
- `<go-timeslots>` now marks a slot as `disabled` (and adds `.is-disabled`) whenever it is unavailable, not only when its capacity is exactly zero. The `aria-disabled` attribute follows the same rule.

---

# v1.53.0

_Released 2026-04-14_

Cart gains live coupon and action-token support: active tokens now appear as removable rows in the cart, discounted lines show the original and final price side by side, and cross-tab cart sync switches from polling to the native `storage` event.

## New

- `<go-cart>` renders each active coupon/action-token as a row in the cart list. When
  coupons are present the cart fetches a projected view from the API and reflects the
  discounted pricing automatically.
- Discounted cart lines show a strikethrough original price (`.go-cart-item-price-original`)
  and the final price (`.go-cart-item-price-discounted`) side by side. Undiscounted
  lines render only `.go-cart-item-price-discounted`.
- `<go-coupon-redemption>` now handles action tokens that apply an order-level discount
  (tokens with `value_action: ApplyOrderDiscount`), in addition to the existing
  voucher-for-ticket flow.

## Fixed

- Cross-tab cart sync now uses the browser `storage` event instead of a one-second
  polling interval — changes made in another tab are reflected immediately.
- The `go-cart-item-removed` custom event name was corrected in the documentation
  (was previously listed with a typo as `go-cart-item-remoced`).

## Breaking → migration

### `data-go-cart-*` attribute selectors removed

The `data-go-cart-header`, `data-go-cart-item`, `data-go-cart-footer`, and their
child variants (`data-go-cart-header-title`, `data-go-cart-item-price`,
`data-go-cart-item-count`, `data-go-cart-item-remove`, `data-go-cart-item-sum`,
`data-go-cart-footer-sum`, `data-go-cart-sum`, etc.) are no longer rendered. Replace
any CSS rules or JS `querySelector` calls that target these attributes with their
class equivalents.

Before:

```css
[data-go-cart-item] {
}
[data-go-cart-item-price] {
}
[data-go-cart-item-count] {
}
[data-go-cart-item-remove] {
}
[data-go-cart-item-sum] {
}
[data-go-cart-footer-sum],
[data-go-cart-sum] {
}
```

After:

```css
.go-cart-item {
}
.go-cart-item-price {
}
.go-cart-item-count {
}
.go-cart-item-remove {
}
.go-cart-item-sum {
}
.go-cart-footer-sum {
}
```

---

# v1.52.0

_Released 2026-04-13_

Adds a built-in payment mode selector to the form system and wires it into the default guest checkout flow.

## New

- `paymentMode` field key — a new built-in field type that renders a radio group of payment modes
  configured in the gomus backend. Available via `<go-field key="paymentMode">` in any custom form.
  - When only one payment mode is configured, the radio input is auto-selected and hidden so the
    user never sees it.
  - Icons for each mode (e.g. `mastercard`, `apple_pay`, `google_pay`, `paypal`) are rendered from
    the CDN when configured in the backend.

## Changed (behavior)

- `<go-checkout-form>` (guest checkout) now includes `paymentMode` as a required field. Shoppers
  are prompted to select a payment mode before submitting. If you rely on the backend's default
  payment mode being selected silently, the checkout form will now require an explicit user
  selection instead.
- The `payment_mode_id` submitted at checkout now reflects the value the user selected in the
  `paymentMode` field, falling back to the shop's configured default only when no selection has
  been made.

---

# v1.51.1

_Released 2026-03-31_

Maintenance release — no integration-facing changes.

---

# v1.51.0

_Released 2026-03-30_

Fixes `go.config` form field overrides not applying when the library loads after the config call.

## Fixed

- `go.config({ forms: { signUp: { fields: [...] } } })` now reliably updates `<go-sign-up>`'s rendered fields even when the config is applied before the library has finished loading. Previously, fields defined via `go.config` were silently ignored and the default field set was rendered instead.

---

# v1.50.1

_Released 2026-03-30_

Fixes timeslot ordering in `<go-timeslots>` when the backend returns slots in non-chronological order.

## Fixed

- `<go-timeslots>` now always renders available time slots in chronological order, regardless of the order the server returns them.

---

# v1.50.0

_Released 2026-03-26_

Improves form accessibility: error announcements are now reliably read by screen readers, and `aria-describedby` on inputs is only set when it points to real content.

## Changed (behavior)

- `<go-errors-feedback>` always renders its screen-reader live region in the DOM (previously the entire element was conditionally rendered, so screen readers could miss errors added after initial paint).
- `<go-errors-feedback>` now reflects validation state on its own host element: the `is-invalid` and `go-feedback` CSS classes, and a new `data-num-errors` attribute, are set directly on `<go-errors-feedback>` instead of on an inner `<div>`. The inner `.go-error-feedback` div and its classes no longer exist. Update any CSS that targets `.go-error-feedback` or `go-errors-feedback > div.go-feedback`.
- `aria-describedby` on `<go-field>` inputs is now omitted when there is no description and no active errors, instead of always being present with IDs that pointed to non-existent elements.
- The field error list (`<ul class="go-field-errors">`) no longer carries `role="alert"`. Error announcement for screen readers is handled exclusively by `<go-errors-feedback>`.

## Fixed

- Screen readers now reliably hear the error summary count when a form is submitted with validation errors, because the `aria-live="assertive"` paragraph is permanently in the DOM rather than being injected on error.

---

# v1.49.0

_Released 2026-03-24_

Timeslot prices in the cart now reflect per-timeslot dynamic pricing, and stale past-dated tickets are reliably cleared on page reload.

## Changed (behavior)

- When a ticket has per-timeslot dynamic pricing configured, the price shown in the cart updates to the price for the selected timeslot. Previously the cart always displayed the ticket's base price regardless of the chosen time.

## Fixed

- Timeslot tickets from a previous session were not removed from the restored cart on page reload; the past-date check was reading from the wrong field. They are now correctly discarded when their timeslot has already passed.
- Event tickets with a past date were never checked on cart restore and would linger across page reloads. They are now removed on restore alongside timeslot tickets.

---

# v1.48.0

_Released 2026-03-19_

The cart quantity selector no longer offers "0" as a choice — items can only be removed via the delete button.

## Changed (behavior)

- The quantity `<select>` inside each cart item now starts at `1`, not `0`. Selecting a quantity of zero to remove an item is no longer possible; use the remove (×) button instead.

---

# v1.47.1

_Released 2026-03-19_

Maintenance release — no integration-facing changes.

---

# v1.47.0

_Released 2026-03-17_

Donations are now available: `<go-donations>` ships in the bundle and can be embedded in shop pages.

## New

- `<go-donations>` — displays all active donation campaigns as selectable cards, lets the
  customer pick a preset or custom amount, and adds the donation to the cart. Place it in the
  checkout flow where you want the donation prompt to appear:

  ```html
  <go-donations></go-donations>
  ```

  Default styles (`.go-donation-campaign`, `.donation-selection`, `.donation-options`) are
  included in the library CSS and can be overridden in your shop stylesheet.

## Fixed

- `<go-donations>` no longer throws when the component mounts before a campaign has been
  selected — optional-chaining guards were added to the campaign accessor, so the selector
  and amount inputs render safely in their empty state.

---

# v1.46.0

_Released 2026-03-06_

`<go-if>` gains access to annual-ticket personalization state via a new `data.personalizationDetails` property.

## New

- `<go-if>` now exposes `data.personalizationDetails` when placed inside a
  `<go-annual-ticket-personalization>` context — use it in `when` expressions to
  branch on personalization state, e.g.
  `when="data.personalizationDetails.isBmcTicket"`.

---

# v1.45.0

_Released 2026-03-04_

Adds `custom` layout support to the sign-in and sign-up forms, and fixes form
configuration merging so that a `fields` override fully replaces the previous
field list instead of being deep-merged.

## New

- `<go-sign-in>` gains a `custom` attribute — opt into fully custom layout by
  providing your own child `<go-field>` / `<go-submit-button>` elements, exactly
  as `<go-checkout-form custom>` already supports.
- `<go-sign-up>` gains a `custom` attribute — same composable layout support.

## Fixed

- When `go.defineConfig({ forms: { … } })` is called with a `fields` array, the
  array now fully replaces the previously configured fields for that form instead
  of being deep-merged. Calling `defineConfig` twice for the same form no longer
  produces a union of both field lists.

---

# v1.44.0

_Released 2026-03-04_

Order breakdown adds iCal download links per item and replaces all hardcoded English labels with locale-aware translations.

## New

- `<go-order-breakdown>` now renders a `.go-order-breakdown-ical` list item per order item. When the backend provides a calendar URL for that item, it contains an anchor you can style to let the visitor add the event to their calendar.

## Changed (behavior)

- Column headers ("Count", "Product", "Price") and the total row label ("Total:") in `<go-order-breakdown>` are now driven by the shop's active locale strings instead of hardcoded English. Sites that relied on those exact English strings for CSS content selectors should verify their selectors still match.
- The "Download" and "Personalize" link labels inside `<go-order-breakdown>` are now locale-translated. The links retain their existing classes (`.go-ticket-download`, `.go-ticket-personalization`) and behavior.

---

# v1.43.0

_Released 2026-03-03_

Maintenance release — no integration-facing changes.

---

# v1.42.0

_Released 2026-03-02_

Cart item quantities are now interactive dropdowns bounded by live capacity, capacity state is preserved across page reloads and browser tabs, and the date picker calendar button is now labelled for assistive technology.

## Changed (behavior)

- Cart item quantities are now rendered as a `<select>` dropdown inside `[data-go-cart-item-count]`, replacing the static text. The available options are bounded by the seat/quota capacity for that item. In `preview` mode the quantity remains a plain `<span>`.
- Capacity data is now persisted in `localStorage` (key `go-capacity`) when seats or quotas are loaded, and is restored on page reload. Changes in one tab are reflected in other open tabs via the browser `storage` event.

## Fixed

- The minimum quantity option in the cart item dropdown no longer appears blank when the backend omits the `min` field — it defaults to `0`, allowing removal via the selector.
- The calendar open button inside the date picker now carries `aria-labelledby`, so screen readers announce the field label when the button receives focus.

---

# v1.41.0

_Released 2026-02-25_

`<go-timeslots>` now exposes a booked-out count so you can conditionally show messaging when some timeslots on the selected date are sold out.

## New

- `<go-if>` expressions can now read `data.ticketSelection.timeslotDetails?.boockedOutCount` — the number of timeslots on the currently selected date whose capacity is zero. Use it to show a notice when at least one timeslot is sold out:

  ```html
  <go-ticket-selection mode="ticket" filter="timeslot">
    <go-timeslots></go-timeslots>
    <go-if when="data.ticketSelection.timeslotDetails?.boockedOutCount > 0" then="show">
      Some timeslots are fully booked.
    </go-if>
  </go-ticket-selection>
  ```

  The value is `0` before a date is selected, and updates reactively when the selected date changes.

---

# v1.40.0

_Released 2026-02-24_

Introduces the `go` snippet interface — a queue-based bootstrap pattern that lets you load, configure, and initialize the library before the bundle has finished loading.

## New

- **`go` snippet** — a lightweight inline script you embed before the bundle. Provides `go.load()`, `go.config()`, and `go.init()` as a command queue; commands issued before the bundle is ready are replayed in order once it arrives.

  ```html
  <script>
    ;(function (w) {
      let _queue = []
      let stub = method => options => _queue.push({ method, options })
      let go = { _queue, init: stub('init'), config: stub('config') }
      go.load = function (options) {
        let s = document.createElement('script')
        s.src =
          window._go_src ??
          'https://unpkg.com/@gomusdev/web-components@' + options.version + '/dist-js/gomus-webcomponents.iife.js'
        document.head.appendChild(s)
      }
      window.go = go
    })(window)

    go.load({ version: '1.40.0' })
    go.config({ navigateTo: url => window.location.assign(url) })
    go.init({ shop: 'your-shop', api: 'api.gomus.de', locale: 'de' })
  </script>
  ```

- `go.load({ version })` — loads the bundle from the unpkg CDN. Set `window._go_src` to a full URL to override the CDN path.
- `go.config(options)` — passes configuration options (same shape as the previous `defineConfig` call; see migration below).
- `go.init({ shop, api, locale })` — connects to the gomus API and initializes the shop.

## Breaking → migration

### `window.go.defineConfig()` replaced by `go.config()`

The `window.go` object previously exposed a `defineConfig(options)` method directly (set by the bundle at load time). It is now replaced by the snippet-based `go.config(options)` method, which works both before and after the bundle loads.

Before:

```js
window.go.defineConfig({
  navigateTo: url => window.location.assign(url),
  urls: {
    cart: () => '/cart',
  },
})
```

After:

```js
go.config({
  navigateTo: url => window.location.assign(url),
  urls: {
    cart: () => '/cart',
  },
})
```

The configuration object shape (`urls`, `navigateTo`, `forms`, `fields`) is unchanged — only the method name differs. If you call `go.config()` before the snippet is replaced by the real bundle, the call is queued and replayed automatically.

---

# v1.39.5

_Released 2026-02-17_

Patch fixing two display issues in scaled-price event ticket rows and improving date
field behavior.

## Fixed

- For `events:price` scaled-price tickets, the event start time is now shown next to
  the event title in each ticket row (e.g. "Concert - 14:00"). Previously only the
  event title appeared.
- For `events:price` scaled-price tickets, only events starting within 2 hours of the
  selected timeslot are now listed. Previously all events on the same day at or after
  the selected time were shown regardless of how far ahead they were.
- `<go-field>` date fields now respect the shop locale when formatting the date picker,
  disable past dates, and start weeks on Monday.

---

# v1.39.4

_Released 2026-02-16_

Patch release fixing a form error-display bug that caused spurious console errors when the backend returned field validation messages.

## Fixed

- Form components (`<go-form>`, `<go-field>`) no longer log a spurious "Field not found" console error when the backend error response includes a `full_messages` key. Previously a trailing space in an internal guard string prevented the key from being skipped, causing the error handler to try (and fail) to match it against a form field.

---

# v1.39.3

_Released 2026-02-12_

Patch fixing sold-out event dates showing as bookable in multi-date scaled-price ticket segments.

## Fixed

- Event dates with no available seats are no longer offered as bookable options in `event:price` segments — previously, sold-out dates could appear and be selected before failing at cart creation.

---

# v1.39.2

_Released 2026-02-05_

Fixes two places where text was hardcoded in English instead of using the shop's active locale.

## Fixed

- `<go-annual-ticket-personalization>` now renders the personalization count label and the "Personalize" link in the shop's active language, instead of always showing English text. Requires the translation keys `ticket.annual.personalization.detail.title` and `ticket.annual.personalization.list.personalize.add` to be present in your translations.
- The language selector in registration and profile forms now shows translated language names (e.g. "Deutsch", "English") instead of raw locale codes (e.g. `de`, `en`). Requires `languages.<locale>` keys in your translations.

---

# v1.39.1

_Released 2026-01-26_

Fixes a spurious Apple Wallet badge appearing in the order breakdown for tickets that have no Passbook URL.

## Fixed

- The Apple Wallet download link in `<go-order-breakdown>` no longer renders for tickets that do not have a Passbook URL — previously it appeared (with a broken link) whenever a barcode was present, regardless of whether a Passbook was available.

---

# v1.39.0

_Released 2026-01-23_

`<go-ticket-segment>` can now override the parent selection's `museum-ids` on a per-segment basis.

## New

- `<go-ticket-segment>` gains a `museum-ids` attribute — when set, it overrides the `museum-ids` on the enclosing `<go-ticket-selection>` for that segment only. Applies to the `timeslot`, `day`, and `events:scaled-price` filters. Useful when a single ticket selection needs to show tickets from different museums in separate segments.

---

# v1.38.0

_Released 2026-01-23_

Fixes a bug where `<go-timeslots>` could show the wrong capacity when the same start time was covered by more than one quota.

## Fixed

- `<go-timeslots>` now shows the correct timeslot capacity when multiple quotas cover the same start time — previously, the highest capacity could win, letting visitors attempt to book a slot that was actually constrained to fewer seats.

---

# v1.37.1

_Released 2026-01-23_

Fixes missing locale and shop-domain headers on all write requests (cart creation, checkout, form submissions, coupon redemption).

## Fixed

- The `locale` query parameter and `X-Shop-Url` header were not included in POST, PUT, and DELETE requests due to a parameter-nesting bug. All write operations — adding to cart, checkout, form submissions, coupon redemption — now correctly send these values to the backend.

---

# v1.37.0

_Released 2026-01-20_

The `date-id` attribute on `<go-ticket-segment>` now scopes ticket results to a
specific event date when using the `event:ticket` filter.

## Changed (behavior)

- `<go-ticket-segment date-id="…">` now forwards the date ID to the backend when
  loading tickets with the `event:ticket` filter. Previously the attribute was
  accepted but had no effect on the ticket query; tickets were returned across all
  dates for the event. Set `date-id` to a specific event date ID to restrict results
  to that date.

---

# v1.36.0

_Released 2026-01-19_

Form submit buttons are now localized: built-in forms display translated labels instead of the hard-coded "Submit" text, and you can set a custom label key on any form you define.

## New

- `submitLabel` option in `go.defineConfig({ forms: { myForm: { submitLabel: 'my.i18n.key' } } })` and the `Forms.defineForm()` call — sets the i18n key rendered as the submit button text for that form. Falls back to `"Submit"` when omitted.

## Changed (behavior)

- Submit buttons on the built-in forms now display localized text instead of the generic "Submit" string. The keys used by each form are:

  | Form                     | i18n key                                          |
  | ------------------------ | ------------------------------------------------- |
  | `<go-sign-in>`           | `common.actions.login`                            |
  | `<go-sign-up>`           | `common.actions.register`                         |
  | `<go-password-reset>`    | `user.passwordReset.actions.requestPasswordReset` |
  | `<go-checkout-form>`     | `cart.detail.actions.checkout`                    |
  | `<go-coupon-redemption>` | `cart.coupon.form.submit`                         |

  Override any of these via your i18n translation tables or by passing a `submitLabel` in your own `go.defineConfig`.

---

# v1.35.0

_Released 2026-01-16_

Adds a coupon-redemption form component and wires coupon tokens into the cart and checkout flow.

## New

- `<go-coupon-redemption>` — renders a token input form that validates a voucher barcode
  against the backend, adds the associated ticket to the cart at zero cost, and dispatches
  a `go-success` event on the host element when redemption succeeds.

## Changed (behavior)

- The `go-cart` `localStorage` key now stores `{ "items": [...], "coupons": [...] }` instead
  of a plain array. The library reads both the old (array) and new (object) formats on load,
  so existing carts are migrated transparently — but any code that reads or writes `go-cart`
  directly must handle the new shape.
- Coupon tokens collected via `<go-coupon-redemption>` are now included in the checkout
  payload automatically; no additional markup is required.

---

# v1.34.0

_Released 2026-01-16_

Introduces three profile components for authenticated users and extends `<go-ticket-segment>` with new filtering attributes and a bulk scaled-price filter token.

## New

- `<go-profile-overview>` — displays the authenticated user's full name and email. Renders the `user.login.desc.text` translation when no user is signed in. CSS hooks: `.go-profile-fullname`, `.go-profile-email`.
- `<go-profile-details>` — renders an editable account-details form (salutation, first/last name, email, language) pre-filled with the current user's data on mount. Requires the user to be authenticated.
- `<go-profile-password>` — renders a change-password form (current password, new password, confirmation). Requires the user to be authenticated.
- `<go-ticket-segment>` gains new optional attributes for narrowing ticket queries:
  - `ticket-group-ids` — comma-separated ticket-group IDs; restricts which tickets are loaded (applies to the `timeslot` filter).
  - `query` — free-text filter on ticket title (applies to the `events:scaled-price` filter).
  - `limit` — maximum number of tickets to load.
  - `language-ids` — comma-separated language IDs (applies to `events:scaled-price`).
  - `catch-word-ids` — comma-separated catch-word IDs (applies to `events:scaled-price`).
- `<go-ticket-segment filters="events:scaled-price">` — new filter token that loads scaled-price tickets across multiple event dates matching the selection's date and time. Combine with `query`, `language-ids`, and `catch-word-ids` to narrow results.
- `<go-ticket-segment-empty>` — new companion element that is visible when `<go-ticket-segment>` has no tickets to display (or when the ticket-selection's tickets panel is hidden). Place it alongside `<go-ticket-segment-body>` inside a `<go-ticket-segment>` to show a custom empty state.
- `<go-form>` now dispatches a native `submit` event (bubbling, composed) on the host element after all validations pass. You can listen for it on the surrounding element without any changes to existing markup.

## Changed (behavior)

- The auth session is now loaded immediately when the library initialises, instead of waiting for the first polling interval (up to 1 second). Components that display user data — including the new profile components — are populated faster on page load.

## Fixed

- `<go-form>` no longer fires its submit-related events when validation fails. Previously, a submit attempt with invalid fields could still propagate events before the validation state was settled.

---

# v1.33.1

_Released 2026-01-15_

Maintenance release — no integration-facing changes.

---

# v1.33.0

_Released 2026-01-08_

Maintenance release — no integration-facing changes.

---

# v1.32.0

_Released 2026-01-05_

Adds an `is-empty` styling hook to `<go-ticket-segment>` so you can style the segment differently when no tickets are selected.

## New

- `<go-ticket-segment>` gains an `is-empty` CSS class — applied when the segment has no tickets selected, removed when at least one ticket is selected. Use it to hide or restyle the segment in the empty state.

---

# v1.31.2

_Released 2026-01-05_

Patch fixing the calendar's selected-day highlight.

## Fixed

- `is-selected` is now correctly applied to the active day in `<go-ticket-selection>`'s
  calendar. Previously the class was never set after picking a date, so any CSS rules
  targeting `.is-selected` had no effect.

---

# v1.31.1

_Released 2026-01-05_

Patch release fixing unwanted whitespace in event cart item rows.

## Fixed

- Event cart item rows (`<go-cart>`) no longer render extra whitespace between the
  event title, ticket title, date, and time spans — the spans are now adjacent with
  no inter-element space nodes.

---

# v1.31.0

_Released 2026-01-05_

Adds a new empty-state slot component for the ticket list and aligns timeslot CSS class names with the rest of the library.

## New

- `<go-tickets-empty>` — place inside `<go-ticket-selection>` to render a slot-based
  empty state when no tickets are available for the selected date and time. Shows when
  `<go-tickets>` is hidden or its segments produce no items; hides otherwise.
  Carries `is-visible` / `is-hidden` classes and a `display` inline style
  matching the visibility state.

  ```html
  <go-ticket-selection filters="ticket:timeslot">
    <go-tickets>...</go-tickets>
    <go-tickets-empty>
      <p>No tickets available for the selected date and time.</p>
    </go-tickets-empty>
  </go-ticket-selection>
  ```

- `<go-tickets>` now toggles `is-visible` / `is-hidden` CSS classes alongside the
  existing inline `display` style — use these classes to drive CSS transitions or
  show/hide companion elements without a `MutationObserver` on the style attribute.

- Each timeslot `<li>` element inside `<go-timeslots>` now carries the `go-timeslot`
  base class, making it selectable without a positional CSS rule.

## Breaking → migration

### Timeslot state classes renamed

The bundled library CSS and rendered HTML previously used `.finished` (unavailable
timeslot) and `.available` (available timeslot). Both have been replaced with
semantic names that match the rest of the library. Update any custom CSS that
targeted these classes.

Before:

```css
go-timeslots li.finished {
  opacity: 0.4;
}
go-timeslots li.available {
  border-color: green;
}
```

After:

```css
go-timeslots li.is-sold-out,
go-timeslots li.is-disabled {
  opacity: 0.4;
}
```

The `.available` class is no longer applied — style the default (unmodified) `li`
or the `go-timeslot` base class instead:

```css
go-timeslots li.go-timeslot {
  border-color: green;
}
```

---

# v1.30.0

_Released 2025-12-29_

Event-price tickets now display both the event title and the price-tier title as separate, targetable spans in the ticket selector and cart; two data-attribute selectors were removed.

## New

- Event-price ticket rows in `<go-tickets>` now render the event title and the price-tier
  title as two separate spans inside `.go-tickets-item-title`:
  - `.go-tickets-item-title-event-title` — the parent event's name
  - `.go-tickets-item-title-product-title` — the scale-price tier name (e.g. "Standard", "Reduced")

- Event-price cart items now render the same split inside `.go-cart-item-title`:
  - `.go-cart-item-title-event-title` — the parent event's name
  - `.go-cart-item-title-ticket-title` — the scale-price tier name

## Changed (behavior)

- Ticket item rows in `<go-tickets>` and cart item rows no longer have
  `white-space: nowrap; overflow: hidden; text-overflow: ellipsis` applied by the
  bundled stylesheet. Long titles now wrap instead of truncating with an ellipsis.
  If your shop relied on the ellipsis truncation, add the following to your own CSS:

  ```css
  .go-tickets-item-title,
  [data-go-cart-item] > li {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  ```

## Breaking → migration

### `data-go-ticket` removed from ticket item `<article>` elements

The `<article>` elements rendered by `<go-tickets>` no longer carry the `[data-go-ticket]`
attribute. Use the `.go-tickets-item` class instead.

Before:

```css
go-tickets article[data-go-ticket] {
  /* custom styles */
}
```

After:

```css
go-tickets article.go-tickets-item {
  /* custom styles */
}
```

### `data-go-tickets-title` removed from ticket title `<li>` elements

The title `<li>` inside each ticket row no longer carries the `[data-go-tickets-title]`
attribute. Use the `.go-tickets-item-title` class instead.

Before:

```css
[data-go-tickets-title] {
  font-weight: bold;
}
```

After:

```css
.go-tickets-item-title {
  font-weight: bold;
}
```

---

# v1.29.0

_Released 2025-12-29_

Timeslot state is now expressed as CSS classes, calendar day cells gain state classes, and the add-to-cart button label is localizable.

## New

- `<go-calendar>` calendar day elements (`.go-calendar-day`) now carry `is-unavailable`, `is-disabled`, and `is-selected` state classes — you can style them directly with CSS.
- `<go-add-to-cart-button>` label is now driven by the translation key `common.actions.cart` (default: "Add to Basket"), so it respects your localization setup like other text in the library.

## Breaking → migration

### `<go-timeslots>` timeslot state moved from `data-*` attributes to CSS classes

Each timeslot `<li>` previously used a `data-go-selected` attribute for the selected state and a `sold-out` class for zero-capacity slots. These are replaced by the `is-selected`, `is-sold-out`, and `is-disabled` CSS classes on `<li>`. Every `<li>` also gains the `go-timeslot` base class. Update any CSS that targeted the old attribute or class names.

Before:

```css
li[data-go-selected] {
  font-weight: 600;
}
li.sold-out {
  opacity: 0.5;
}
label.disabled {
  color: grey;
}
```

After:

```css
li.go-timeslot.is-selected {
  font-weight: 600;
}
li.go-timeslot.is-sold-out {
  opacity: 0.5;
}
li.go-timeslot.is-disabled {
  color: grey;
}
```

### `<go-timeslots>` list selector changed

The `data-go-timeslots` attribute on the `<ul>` inside `<go-timeslots>` is removed. Update any CSS or JS that selected by that attribute.

Before:

```css
ul[data-go-timeslots] {
  max-width: 650px;
}
```

After:

```css
go-timeslots > ul {
  max-width: 650px;
}
```

---

# v1.28.0

_Released 2025-12-25_

Forms now handle conditional fields correctly and surface validation errors in real time.

## Changed (behavior)

- `<go-errors-feedback>` updates its error count and `is-invalid` class continuously
  as the user edits fields, instead of only on submit. The `data-num-errors` attribute
  and `.is-invalid` class on the element now reflect the live validation state.

## Fixed

- `<go-field>` elements inside `<go-if>` blocks are now correctly included in (or
  excluded from) form validation and submission as the condition changes. Previously,
  a field that appeared or disappeared at runtime could be missing from `formData` or
  hold a stale required-error after it was hidden.

---

# v1.27.2

_Released 2025-12-25_

Patch fixing two edge cases in form error handling: API field errors are now counted in the error summary, and a spurious backend key no longer triggers a console error.

## Fixed

- Fields that carry API-returned errors (e.g. from a failed checkout submission) are now included in the form's invalid-field count, so the `forms.errorSummary` message shows the correct number and the submit button state reflects all errors — not only client-side validation errors.
- A `full_messages` key with a trailing space, returned by some backend responses, is now silently skipped during API error mapping instead of emitting a console error about a field not found.

---

# v1.27.1

_Released 2025-12-25_

Fixes the checkout form ignoring async `beforeSubmit` callbacks.

## Fixed

- `<go-checkout-form>` now correctly awaits the `beforeSubmit` callback before
  redirecting to payment. Previously, if your `beforeSubmit` returned a `Promise`
  (e.g. an analytics call or a data-layer push), the redirect fired immediately
  without waiting for it to complete.

---

# v1.27.0

_Released 2025-12-24_

Form fields, cart headers, and ticket table headers are now driven by the shop's
translation layer; sold-out timeslots are now visible; and `<go-cart>` gains CSS
classes alongside its existing `data-*` hooks.

## New

- `<go-cart>` header and footer rows now carry CSS classes (`.go-cart-header`,
  `.go-cart-footer`, `.go-cart-header-title`, `.go-cart-header-price`,
  `.go-cart-header-count`, `.go-cart-header-remove`, `.go-cart-header-sum`,
  `.go-cart-footer-sum`) in addition to the existing `data-go-cart-*` attributes.
  Style with either; both are stable.
- `<go-cart>` item rows now carry CSS classes (`.go-cart-item`,
  `.go-cart-item-price`, `.go-cart-item-count`, `.go-cart-item-remove`,
  `.go-cart-item-sum`) alongside the existing `data-go-cart-item-*` attributes.
- `<go-tickets>` (ticket segment) rows now carry CSS classes (`.go-tickets`,
  `.go-tickets-header`, `.go-tickets-item`, `.go-tickets-header-title`,
  `.go-tickets-header-description`, `.go-tickets-header-price`,
  `.go-tickets-header-quality`, `.go-tickets-item-title`,
  `.go-tickets-item-description`, `.go-tickets-item-price`,
  `.go-tickets-item-quality`) alongside the existing `data-go-tickets-*` attributes.
- `<go-field>` now sets `data-testid` on its host element equal to the field `key`
  (e.g. `key="email"` → `data-testid="email"`), making scripting-layer queries easier.
- Sold-out timeslots in `<go-timeslots>` now receive `class="sold-out"` on their
  `<li>` and `disabled` / `aria-disabled` on their `<input>`, so you can style and
  target them in CSS without hiding them.

## Changed (behavior)

- Form field labels (salutation, first name, last name, email, password, address
  fields, etc.) are now resolved through the shop's translation layer. The rendered
  label text depends on the translations you provide; shops without a full translation
  set will see the i18n key string (e.g. `user.registration.form.name`) instead of the
  previous hardcoded English label.
- Form validation error messages (required-field, invalid email, password too short,
  passwords/emails do not match) are likewise now translation keys. Shops must supply
  the corresponding keys in their translations to show human-readable errors.
- Cart column headers ("Product", "Price", "Count", "Sum") are now filled from
  translations (`cart.content.table.*`). Shops without those keys will see the raw key.
- Ticket table column headers ("Title", "Description", "Price", "Quantity") are now
  filled from translations (`product.detail.table.*`).
- `select`-type fields now render a disabled placeholder option at the top of the
  dropdown. Its label is resolved from the `common.choose` translation key.
- When a translation key is missing, `shop.translate()` now returns the key string
  itself instead of an empty string. This means missing translations surface as visible
  key tokens rather than blank text — useful for debugging, but verify your translation
  coverage before upgrading.

## Fixed

- Sold-out timeslots are now displayed in `<go-timeslots>`. Previously they were
  filtered out entirely; they are now shown as disabled so the user can see the full
  day's schedule.

## Breaking → migration

### Built-in `<go-field key="rememberMe">` removed

The `rememberMe` built-in field definition has been removed from the default field
registry. If your checkout or sign-in form uses `<go-field key="rememberMe">`, the
field will no longer render.

Before:

```html
<go-form>
  <go-field key="rememberMe"></go-field>
</go-form>
```

After — register a custom field that matches your needs:

```js
window.go.defineFields({
  rememberMe: {
    key: 'rememberMe',
    type: 'checkbox',
    label: 'Remember me',
    required: false,
    placeholder: '',
    description: '',
    autocomplete: 'off',
  },
})
```

```html
<go-form>
  <go-field key="rememberMe"></go-field>
</go-form>
```

### `<go-cart>` no longer renders a built-in checkout button

The "Checkout" anchor link (`.go-cart-checkout-button`) that `<go-cart>` previously
rendered at the bottom of a non-preview cart has been removed. If you relied on this
element being present — or on its click navigating to the checkout URL — you must add
your own control.

Before (implicit, rendered automatically):

```html
<go-cart></go-cart>
<!-- ↳ rendered a <a class="go-cart-checkout-button"> at the bottom -->
```

After — add your own checkout control inside `<go-cart>`:

```html
<go-cart>
  <!-- …items, coupons, totals… -->
  <go-submit>Checkout</go-submit>
</go-cart>
```

---

# v1.26.3

_Released 2025-12-16_

The calendar now distinguishes fully-booked dates from unavailable dates using separate styling hooks.

## Changed (behavior)

- `[data-calendar-cell][data-unavailable]` is now set only on **fully-booked** dates (sold
  out, no remaining capacity). Previously it was set on all non-bookable dates.
- `[data-calendar-cell][data-disabled]` is now set on dates that are unavailable for
  booking (outside the event's date range or otherwise not offered), in addition to
  past dates. Previously only past dates received `data-disabled`.

If you styled all non-bookable dates identically, no change is needed. If you styled
`[data-unavailable]` expecting it to cover every non-bookable day, update your CSS to
also target `[data-disabled]`.

---

# v1.26.2

_Released 2025-12-15_

Fixes day tickets showing incorrect availability when a venue's quota capacity starts at a time other than 10:00.

## Fixed

- Day tickets with `ticket:day` now read capacity from the correct time slot. Previously, capacity was checked against a hardcoded `10:00` start time, causing tickets to appear sold out (or with wrong remaining capacity) at venues whose day-ticket quotas begin at a different time.

---

# v1.26.1

_Released 2025-12-15_

Patch release fixing a checkout submission failure that could occur after the cart was reset during a session.

## Fixed

- `<go-checkout-form>` no longer silently fails to submit when the cart has been replaced during the session. Previously the form held a stale reference to the old cart object, causing checkout to do nothing or use outdated order data; it now always reads the current cart.

---

# v1.26.0

_Released 2025-12-15_

Fixes seat availability counts for events where the cart contains multiple different ticket types.

## Fixed

- `<go-tickets>` no longer shows artificially low seat availability when the cart contains items from a different ticket type sharing the same seat pool. Previously the entire cart quantity was deducted from available seats regardless of ticket type; now only quantities of matching tickets are counted.

---

# v1.25.4

_Released 2025-12-11_

Fixes missing event date and time display in both the cart and the order confirmation.

## Fixed

- Event ticket items in `<go-cart>` now show the booked date and time next to the ticket title, matching the behaviour already present for standard timeslot tickets.
- Event ticket items in `<go-order>` (order confirmation breakdown) now show the event's date and start time next to the item title; they were previously omitted entirely.

---

# v1.25.3

_Released 2025-12-11_

Patch fixing a cart rendering bug and removing debug log noise from the browser console.

## Fixed

- `<go-cart>` no longer renders stale item lists or totals when the cart object is replaced or
  first initialised — items and the `[data-go-cart-sum]` total now always reflect the current
  cart state.
- `<go-cart-counter>` no longer throws when rendered before the cart has been initialised; it
  safely renders nothing instead.
- Internal debug messages (`console.log`) that were leaking into the browser console during
  ticket selection, timeslot loading, quota calculation, and quantity-option generation have
  been removed from the shipped bundle.

---

# v1.25.2

_Released 2025-12-10_

Fixes a stale-timeslot display bug: `<go-timeslots>` now always reflects the selected date.

## Fixed

- `<go-timeslots>` was showing timeslots from the previously selected date after the user picked a new date. Timeslots are now correctly refreshed whenever the date changes.

---

# v1.25.1

_Released 2025-12-09_

Fixes a PDF download bug: every ticket in a multi-ticket order now gets its own correct Download link.

## Fixed

- In the order breakdown, only the first ticket in a multi-ticket line item had a Download link; the rest were silently omitted. Every ticket now shows its own Download link, and each link correctly downloads that specific ticket's PDF.

---

# v1.25.0

_Released 2025-12-09_

Introduces centralized capacity management: ticket quantity selectors are now capped by live quota data, sold-out tickets are hidden automatically, and a new `selected-timeslot` attribute lets you pre-select a timeslot via markup.

## New

- `<go-ticket-selection>` gains a `selected-timeslot` attribute — sets the initially selected timeslot on mount (accepts an ISO datetime string, e.g. `"2025-12-09T10:00:00+01:00"`).

## Changed (behavior)

- Ticket rows with no remaining capacity for the selected timeslot are now hidden entirely instead of rendering with a full quantity range. Previously all tickets were always rendered.
- The quantity selector on each `[data-go-ticket]` row is now bounded by the real remaining quota capacity. Selecting a quantity in one ticket row reduces the available maximum in other rows that share the same quota.
- `[data-go-ticket]` articles now receive the `is-booked-out` CSS class when the ticket's quota is exhausted by other in-progress selections (capacity is 0 but the row is still rendered). Previously no such class was applied.

## Fixed

- The `.is-unavailable` utility class (`pointer-events: none; cursor: not-allowed; opacity: 0.5`) is now included in the default stylesheet. Elements that receive this class (e.g. disabled ticket controls) are styled consistently without requiring custom CSS from the integration.

---

# v1.24.1

_Released 2025-12-03_

Patch release fixing timeslot ticket visibility when a specific timeslot is selected.

## Fixed

- Timeslot tickets with no capacity at the selected timeslot are now hidden from the
  ticket list, instead of appearing as unavailable options alongside valid tickets.

---

# v1.24.0

_Released 2025-12-02_

Adds stable CSS class hooks to the calendar, reflects `filters` and `selected-date` back onto `<go-ticket-selection>`, and improves calendar pre-fetching to cover three months at once.

## New

- `<go-ticket-selection>` now reflects `filters` and `selected-date` back to the DOM attribute as the user interacts — you can read the current selection state directly from the element (e.g. `el.getAttribute('selected-date')`).
- Calendar elements expose stable CSS class hooks: `go-calendar-root`, `go-calendar-prev-button`, `go-calendar-heading`, `go-calendar-next-button`, `go-calendar-grid`, `go-calendar-grid-head`, `go-calendar-grid-row`, `go-calendar-grid-body`, `go-calendar-cell`, `go-calendar-day` — use these to style the date picker from your own stylesheet.

## Changed (behavior)

- The calendar now pre-fetches three months of availability data on each render (previously one month), reducing visible loading gaps when the user pages forward or backward.
- A `<go-link>` pointing to an unconfigured route now logs a `console.warn` and cancels navigation instead of silently invoking an undefined URL handler.

---

# v1.23.0

_Released 2025-11-30_

Adds an `event:ticket` segment filter for loading flat event tickets by date, renames the
`scaled-price` segment filter to `event:scaled-price`, and fixes the quantity selector for
scaled-price event tickets to respect the event's actual seat limits.

## New

- `<go-ticket-segment filters="event:ticket">` — loads the regular tickets attached to a
  single event for the selected date, filtered to those with available capacity. Requires
  `event-ids` on the parent `<go-ticket-selection>` and a `selected-date` on the selection.

## Fixed

- The quantity selector on scaled-price event ticket rows now correctly reflects the event's
  `max_per_registration` and `available` seat values, instead of always capping at 18.

## Breaking → migration

### `scaled-price` filter token renamed to `event:scaled-price`

The `filters` attribute value `scaled-price` on `<go-ticket-segment>` has been renamed to
`event:scaled-price`. Update every `<go-ticket-segment>` and `<go-ticket-selection>` that
passes this token.

Before:

```html
<go-ticket-selection filters="timeslot, scaled-price" mode="event" event-ids="123">
  <go-tickets>
    <go-ticket-segment filters="scaled-price" date-id="17">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

After:

```html
<go-ticket-selection filters="timeslot, event:scaled-price" mode="event" event-ids="123">
  <go-tickets>
    <go-ticket-segment filters="event:scaled-price" date-id="17">
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

### `event:scaled-price` now requires `selected-date`

Previously the `scaled-price` segment would render tickets regardless of whether a date
was selected on `<go-ticket-selection>`. Now `event:scaled-price` (and `event:ticket`)
only shows tickets once `selected-date` is set; without it the segment renders empty.

Before:

```html
<!-- tickets appeared even without selected-date -->
<go-ticket-selection filters="event:scaled-price" mode="event" event-ids="123"></go-ticket-selection>
```

After:

```html
<!-- selected-date is required; segment stays empty until a date is chosen -->
<go-ticket-selection
  filters="event:scaled-price"
  mode="event"
  event-ids="123"
  selected-date="2025-12-21"
></go-ticket-selection>
```

---

# v1.22.3

_Released 2025-11-26_

Fixes `<go-order-breakdown>` silently dropping event line items from the order summary.

## Fixed

- `<go-order-breakdown>` now renders event items (title, scale-price quantities, and download link) alongside ticket items. Previously, any order item of type `Event` was silently omitted from the breakdown.

---

# v1.22.2

_Released 2025-11-26_

Patch release fixing stale cart contents persisting after checkout.

## Fixed

- `<go-order>` now clears the cart when it mounts, so items from a completed purchase no longer linger if the order confirmation page is displayed on the same browsing session.

---

# v1.22.1

_Released 2025-11-26_

Patch release fixing crashes in the ticket quantity selector and in the auth store when `localStorage` is unavailable.

## Fixed

- The ticket quantity dropdown inside `<go-ticket-selection>` and `<go-cart>` no longer throws an error when a ticket's effective capacity is zero or below its minimum (e.g. a fully-booked timeslot). The selector now renders an empty/disabled state instead of crashing.
- The auth store no longer throws a reference error on page load in environments where `localStorage` is unavailable (e.g. server-side rendering or restrictive iframe sandboxes).

---

# v1.22.0

_Released 2025-11-25_

Adds a `selected-date` attribute to `<go-ticket-selection>` so you can pre-seed the
selected date from your markup instead of waiting for user interaction.

## New

- `<go-ticket-selection>` gains a `selected-date` attribute — an optional `YYYY-MM-DD`
  date string that initializes the component with that date already selected. The
  attribute stays in sync as the user picks a different date via the calendar, so you
  can also read it back to track the current selection.

  ```html
  <go-ticket-selection mode="ticket" filters="timeslot" selected-date="2025-11-27"> … </go-ticket-selection>
  ```

---

# v1.21.0

_Released 2025-11-25_

Adds a new `<go-link>` navigation tag, introduces scaled-price event support in ticket segments, and fixes form API-error handling on repeated submissions.

## New

- `<go-link>` — renders an anchor to a named URL registered in the go config. Set the `to` attribute to the route name (e.g. `to="checkoutForm"`). The element uses your configured `navigateTo` handler on click and updates its `href` reactively when the config changes.
- `<go-ticket-segment>` gains a `date-id` attribute — required when using the new `scaled-price` filter to identify which event date the segment loads prices for.
- `scaled-price` filter token for `<go-ticket-segment>` — loads per-date scaled event prices. Use in combination with `event-ids` on the enclosing `<go-ticket-selection>`.

## Fixed

- Submitting a form a second time now clears API errors from the previous submission before showing the new ones. Previously, stale field errors from a prior failed submission could linger alongside new errors.

## Breaking → migration

### `event-id` renamed to `event-ids` on `<go-ticket-selection>`

The attribute now accepts a comma- or space-separated list of IDs (consistent with `museum-ids`, `ticket-ids`, etc.). Single-event usage works by passing one ID.

Before:

```html
<go-ticket-selection event-id="42" ...></go-ticket-selection>
```

After:

```html
<go-ticket-selection event-ids="42" ...></go-ticket-selection>
```

### Form validation event renamed from `after-validation` to `go-after-validation`

If you listen for the form validation event to run custom logic after the form validates (e.g. to inspect field errors or guard a custom submit flow), update your listener name.

Before:

```js
form.addEventListener('after-validation', handler)
```

After:

```js
form.addEventListener('go-after-validation', handler)
```

---

# v1.20.1

_Released 2025-11-24_

Patch fixing two rendering bugs in the date-picker field and the donation campaign card.

## Fixed

- `<go-field>` with a date-picker input: values passed to `label-class` and `input-class` were not applied — the rendered elements received a literal `$labelClass` / `$inputClass` string instead of the actual class names. CSS selectors targeting those classes now match correctly.
- The title inside each `.go-donation-campaign` card now shows the campaign's configured headline (from the campaign's translation data) instead of the raw internal campaign name.

---

# v1.20.0

_Released 2025-11-19_

Introduces three new `<go-order>` components for rendering a completed order's details on a confirmation or receipt page.

## New

- `<go-order token="...">` — root context element for a completed order. Supply the
  order `token` attribute; all child `<go-order-*>` components read from it.
- `<go-order-breakdown>` — renders the full item list for the order, including ticket
  title, date/time (for timeslot and day tickets), per-item price, a download link for
  each ticket, and an Apple Wallet passbook link where available. The footer row shows
  the order total. Must be placed inside `<go-order>`.
- `<go-order-invoice-id>` — renders the order's invoice ID as inline text. Must be
  placed inside `<go-order>`.

---

# v1.19.0

_Released 2025-11-18_

Maintenance release — no integration-facing changes.

---

# v1.18.0

_Released 2025-11-18_

Timeslot buttons now show an outline ring on hover and when selected.

## Changed (behavior)

- `<go-timeslots>` timeslot labels now display `--outline-hover` on hover and when a
  timeslot is selected (checked), matching the outline style already applied to other
  interactive elements. If you have overridden `--outline-hover` in your theme, that
  value will now be visible on these states.

---

# v1.17.0

_Released 2025-11-18_

Visual style overhaul: square corners throughout, theming variables consolidated, and calendar/timeslot interactive states updated to use the primary color.

## New

- `--primary-hover`, `--bg`, `--border`, `--outline-hover` — four new CSS custom properties you can override to control hover/focus outlines, background colors, and border defaults across all components.

## Changed (behavior)

- Form inputs and textareas now also respond to `:hover` and `:active` with a `--primary`-colored border and `--outline-hover` ring, not only `:focus`.
- Calendar selected-date and today cells now use `--primary` for highlights instead of a hardcoded blue (`#274779`). If you rely on the old blue, override `--primary`.
- The timeslot list (`<go-timeslots>`) switches from a flex-wrap row to a CSS grid (`repeat(auto-fill, minmax(90px, 1fr))`); timeslot labels now fill their cell width.
- Timeslot label hover no longer changes the background color — it now highlights the `border-color` with `--primary` only.
- Border-radius removed (set to `0`) on buttons, form inputs, timeslot labels, and calendar cells; if you rely on rounded corners, add your own `border-radius` override.

## Fixed

- Calendar day-number font size increased from `0.875rem` to `1rem`, matching the body text baseline.

## Breaking → migration

### `--color-contrast` CSS variable renamed to `--fg`

The `--color-contrast` custom property (used for text and border color on form fields) is renamed to `--fg`. If you override `--color-contrast` in your site CSS to customize component text color, rename it.

Before:

```css
:root {
  --color-contrast: #333333;
}
```

After:

```css
:root {
  --fg: #333333;
}
```

---

# v1.16.2

_Released 2025-11-13_

Improves debuggability when a `when` expression on `<go-if>` is invalid.

## Fixed

- Invalid `when` expressions on `<go-if>` are now logged to the browser console
  instead of failing silently. If your `when` expression contains a syntax error or
  references an unknown value, you will see an error message in the console rather
  than the element rendering nothing with no indication of why.

---

# v1.16.1

_Released 2025-11-12_

Patch release fixing a JavaScript error thrown by `<go-if>` when its `when=` expression could not be evaluated.

## Fixed

- `<go-if>` no longer throws a JavaScript error when the `when=` expression fails to evaluate — the element now hides its content silently instead of crashing.

---

# v1.16.0

_Released 2025-11-12_

Adds a password-reset form component, renames the single event-id attribute to accept multiple IDs, and fixes several rendering issues in form feedback and ticket-selection context resolution.

## New

- `<go-password-reset>` — renders a form that sends a password-reset email. Accepts a `custom` attribute (same semantics as `<go-form>`). Dispatches a `go-success` event on the host element when the request succeeds, and shows the API-returned confirmation message in the form's success feedback area.

## Changed (behavior)

- `<go-success-feedback>` now shows the message text returned by the API instead of the hard-coded string "Form submitted successfully!". The element is no longer rendered at all when there is no success message.
- `<go-error-feedback>` no longer renders when `apiErrors` is an empty array; previously the block could render with empty content.

## Fixed

- Child components of `<go-ticket-selection>` (`<go-timeslots>`, `<go-calendar>`, `<go-ticket-segment>`, `<go-add-to-cart-button>`, and others) now reliably resolve their parent context even when they initialize before the parent element is fully mounted — previously this could fail silently and leave the components in a broken state.

## Breaking → migration

### `event-id` attribute replaced by `event-ids`

`<go-ticket-selection>` no longer accepts the `event-id` attribute (a single numeric event ID). Use `event-ids` instead, which accepts a comma-separated string of one or more event IDs.

Before:

```html
<go-ticket-selection mode="event" event-id="42" filters="event:admission"> ... </go-ticket-selection>
```

After:

```html
<go-ticket-selection mode="event" event-ids="42" filters="event:admission"> ... </go-ticket-selection>
```

---

# v1.15.0

_Released 2025-11-11_

The cart now dispatches events on `document` when items are added or removed, so external scripts can react to cart changes without polling.

## New

- `go-cart-item-added` — fired on `document` when a cart item is added. `event.detail` is the updated item count.
- `go-cart-item-removed` — fired on `document` when a cart item is removed. `event.detail` is the updated item count.

```js
document.addEventListener('go-cart-item-added', event => {
  console.log('Cart now has', event.detail, 'item(s)')
})

document.addEventListener('go-cart-item-removed', event => {
  console.log('Cart now has', event.detail, 'item(s)')
})
```

---

# v1.14.0

_Released 2025-11-11_

Maintenance release — no integration-facing changes.

---

# v1.13.0

_Released 2025-11-10_

Forms gain cross-field confirmation validation and a fix for error feedback not appearing when form subcomponents mount before the form is ready.

## Changed (behavior)

- `confirmEmail` and `confirmPassword` fields now cross-validate against their base fields on submit and on blur: if the values differ, the confirmation field shows an inline "Emails do not match" or "Passwords do not match" error. No markup change is needed — any form that includes `<go-field key="confirmEmail">` or `<go-field key="confirmPassword">` picks this up automatically.

## Fixed

- `<go-errors-feedback>` and other form subcomponents no longer fail to display errors when they are mounted before the parent `<go-form>` element is fully initialized — error messages now appear correctly on first render.

---

# v1.12.0

_Released 2025-11-10_

New styling-hook attributes on `<go-field>` and `<go-submit>` let you pass CSS classes directly to the rendered label, input, and button elements.

## New

- `<go-field>` gains a `label-class` attribute — the value is added as a CSS class on the `<label>` rendered inside the field, for all input types (text, checkbox, select, date, radio).
- `<go-field>` gains an `input-class` attribute — the value is added as a CSS class on the `<input>` (or `<select>`) rendered inside the field.
- `<go-submit>` gains a `button-class` attribute — the value is added as a CSS class on the `<button>` rendered inside the element.

---

# v1.11.0

_Released 2025-11-04_

Adds a dedicated empty-cart tag, exposes cart state to `<go-if>`, and adds CSS class hooks to cart item fields.

## New

- `<go-cart-empty>` — wraps its slotted content in a conditional that shows only when the cart
  has no items. Place it alongside `<go-cart>` to render an empty-state message without writing
  a custom `<go-if>` expression.

  ```html
  <go-cart></go-cart>
  <go-cart-empty>
    <p>Your cart is empty.</p>
  </go-cart-empty>
  ```

- `<go-if>` now exposes `data.cart` in `when` expressions — use it to branch on cart state,
  for example `when="data.cart.items.length === 0"` or `when="data.cart.items.length > 0"`.

- Cart item fields gain explicit CSS class hooks you can target in your stylesheet:
  - `.go-cart-item-title` — the ticket name span inside `[data-go-cart-item-title]`
  - `.go-cart-item-date` — the date span (timeslot items only)
  - `.go-cart-item-time` — the time span (timeslot items only)

## Changed (behavior)

- The checkout button (`.go-cart-checkout-button`) is no longer rendered when `<go-cart preview>`
  is set. Previously it was visible even in preview mode.

---

# v1.10.0

_Released 2025-11-04_

Adds two new components for annual ticket personalization: a list view that shows purchased annual tickets and their status, and a composable form that collects personalization details for one or more holders.

## New

- `<go-annual-ticket-personalization token="...">` — lists the annual tickets in an order. For
  each ticket sale it renders the title, personalization count, and — when the ticket is not yet
  personalized — a link to the form page.

  ```html
  <go-annual-ticket-personalization token="YOUR_ORDER_TOKEN"></go-annual-ticket-personalization>
  ```

- `<go-annual-ticket-personalization-form token="..." ticket-sale-id="...">` — collects start
  date and holder details for a single annual ticket sale. Place a `<go-personalization-form>`
  template inside it; the component clones it automatically to match the number of personalizations
  on the ticket sale.

  ```html
  <go-annual-ticket-personalization-form token="YOUR_ORDER_TOKEN" ticket-sale-id="19515">
    <go-form form-id="ticketPersonalization" custom>
      <go-field key="startAt" required></go-field>

      <go-personalization-form>
        <go-form form-id="personalization" custom>
          <go-field key="firstName" required></go-field>
          <go-field key="lastName" required></go-field>
          <go-field key="email" required></go-field>
          <go-field key="confirmEmail" required></go-field>
        </go-form>
      </go-personalization-form>

      <go-submit>Submit Personalizations</go-submit>
    </go-form>
  </go-annual-ticket-personalization-form>
  ```

  Submission navigates to the URL returned by `go.config.urls.annualTicketPersonalizationFormSubmit`
  after a successful API call. A `go-submit` event on the host triggers the submit flow.

- Three new URL config hooks for `go.defineConfig({ urls: { … } })`:
  - `annualTicketPersonalizationForm(token, ticketSaleId)` — URL for the form page for one ticket
    sale. Used by `<go-annual-ticket-personalization>` to build the "Personalize" link.
  - `annualTicketPersonalizationList(token)` — URL for the list page for an order. Used by the
    order component when redirecting after a post-checkout flow.
  - `annualTicketPersonalizationFormSubmit(token?)` — URL to navigate to after a successful
    personalization form submission.

- `<go-if>` gains `data.personalizationDetails` when nested inside
  `<go-annual-ticket-personalization-form>` — use it in `when` expressions to branch on
  personalization state, for example `when="data.personalizationDetails.ticketSale"`.

---

# v1.9.0

_Released 2025-11-03_

The ticket-group family of tags is renamed to ticket-segment; update your markup before upgrading.

## Breaking → migration

### `<go-ticket-group>`, `<go-ticket-group-body>`, `<go-ticket-group-sum>` renamed

The three ticket-group tags are renamed to `<go-ticket-segment>`, `<go-ticket-segment-body>`, and `<go-ticket-segment-sum>`. The old names are no longer registered in the bundle and will silently do nothing if left in place.

Before:

```html
<go-tickets>
  <go-ticket-group filters="ticket:timeslot">
    <go-ticket-group-body></go-ticket-group-body>
    <go-ticket-group-sum></go-ticket-group-sum>
  </go-ticket-group>
</go-tickets>
```

After:

```html
<go-tickets>
  <go-ticket-segment filters="ticket:timeslot">
    <go-ticket-segment-body></go-ticket-segment-body>
    <go-ticket-segment-sum></go-ticket-segment-sum>
  </go-ticket-segment>
</go-tickets>
```

---

# v1.8.6

_Released 2025-10-28_

Patch that fixes `window.customOptions` being silently ignored when set before the bundle loads.

## Fixed

- `window.customOptions` set before the bundle script tag was discarded; it is now
  merged into the initial configuration so all pre-load options take effect.

---

# v1.8.5

_Released 2025-10-28_

Patch that registers `<go-cart-counter>` in the bundle so the tag now renders for all integrators.

## Fixed

- `<go-cart-counter>` was missing from the bundle and silently produced no output; it is now registered and renders correctly.

---

# v1.8.4

_Released 2025-10-23_

Fixes the language selector to show all locales configured in your gomus instance instead of a hardcoded two-item list.

## Fixed

- `<go-field key="language">` now populates its options from the gomus locales endpoint, so it reflects the full set of languages configured for your instance rather than always showing only German and English.

---

# v1.8.3

_Released 2025-10-21_

Fixes `<go-if>` failing to read form field values when placed inside `<go-checkout-form>`.

## Fixed

- `<go-if when="data.formData...">` now works correctly inside `<go-checkout-form>`. Previously, `data.formData` was always `undefined` when `<go-if>` was a child of a checkout form, so any conditional expression that accessed `data.formData` never evaluated correctly. The component now waits for the parent form context to become available before evaluating the `when` expression.

---

# v1.8.2

_Released 2025-10-17_

Patch fixing crashes and incorrect behavior in forms and the `<go-if>` conditional element.

## Fixed

- `<go-if>` attributes `when` and `then` are now correctly reflected as DOM properties,
  so reading `element.when` / `element.then` returns the current attribute value.
- Nested `<go-form>` elements now resolve their parent correctly; without this fix,
  a child form inside another form could pick up the wrong parent's context.
- Form validity (`isValid`) was computed from a stale field list, causing the form to
  report valid when it was not (or vice versa). It is now derived from the live field
  list.
- Components that call into the shop API before the shop is fully configured no longer
  throw an uncaught error; they return an empty result and log a warning instead.

---

# v1.8.1

_Released 2025-10-14_

Patch fix for password field payload keys being swapped in registration forms.

## Fixed

- `newPassword` and `confirmPassword` fields now submit under the correct payload keys. Previously, `newPassword` sent its value as `password_confirmation` and `confirmPassword` sent nothing, causing registration via `<go-sign-up>` (or any custom `<go-form>` using those fields) to fail.

---

# v1.8.0

_Released 2025-10-14_

Maintenance release — no integration-facing changes.

---

# v1.7.0

_Released 2025-10-14_

Introduces `<go-field>` as the new way to place individual form fields in custom layouts, and removes the older `<go-input>` and `<go-signup-form>` elements.

## New

- `<go-field>` — places a single field inside a `<go-form custom>` layout. Accepts `key` (the field's registered key, e.g. `"email"`) and `required` (boolean). Renders the input, label, description, and inline error list.

## Changed (behavior)

- `<go-all-fields>` now renders `<go-field>` elements instead of `<go-input>` elements — existing auto-rendered forms are unaffected in appearance, but any CSS targeting the rendered internals should be re-verified.
- `<go-if when="...">` inside a form now throws a JavaScript error when the `when` expression cannot be evaluated, instead of silently logging and continuing. Invalid expressions will surface as uncaught errors in the browser console.

## Breaking → migration

### `<go-input>` removed — replace with `<go-field>`

`<go-input field="...">` no longer exists. Use `<go-field key="..." required>` inside a `<go-form custom>` block.

Before:

```html
<go-checkout-form custom="">
  <go-input field="email" />
  <go-input field="newsletter" />
  <go-submit-button>Submit</go-submit-button>
</go-checkout-form>
```

After:

```html
<go-checkout-form custom="">
  <go-field key="email" required></go-field>
  <go-field key="newsletter" required></go-field>
  <go-submit-button>Submit</go-submit-button>
</go-checkout-form>
```

### `<go-signup-form>` removed — replace with `<go-sign-up>`

The `<go-signup-form>` element is no longer registered. Use `<go-sign-up>` instead.

Before:

```html
<go-signup-form></go-signup-form>
```

After:

```html
<go-sign-up></go-sign-up>
```

---

# v1.6.0

_Released 2025-10-13_

Adds a sign-up element, wires `<go-checkout-form>` into the full guest-checkout flow, introduces a cart checkout button, and changes how `<go-if>` hides its content.

## New

- `<go-sign-up>` — new element that renders the registration form and dispatches `go-success` on successful account creation. Accepts a `custom` attribute to opt into a custom form layout (same as `<go-checkout-form custom>`).
- `<go-checkout-form>` now drives the complete guest-checkout flow on `go-submit`: creates a guest account, submits the cart as an order, then navigates to the payment URL returned by the backend.
- `go.defineConfig({ forms: { checkoutGuest: { beforeSubmit } } })` — optional callback invoked with the submitted form data just before the payment redirect. Useful for analytics or pre-payment side effects.
- `<go-cart>` now renders a checkout button (class `go-cart-checkout-button`) that calls `go.config.urls.checkoutForm()` and navigates to the returned URL.
- `go.defineConfig({ urls: { checkoutForm: () => '...' } })` — new URL slot that controls where the cart's checkout button sends the user.
- `<go-if>` inside a `<go-form>` now receives `data.formData` — the current form's field values, keyed by API field name. Use it in `when` expressions to show or hide fields conditionally based on what the user has entered (e.g. `when="data.formData.addr_country_id === 1"`).

## Changed (behavior)

- `<go-if>` now **removes its content from the DOM** when the `when` expression is falsy, instead of setting `display: none` on the host element. Content is restored to the DOM when the expression becomes truthy again. CSS rules that targeted children of a hidden `<go-if>` (relying on the element being present but invisible) will no longer apply while it is hidden.
- `<go-if>`'s `then` attribute is no longer documented or required. Previously you had to write `then="show"` for the element to display its content; now showing content when `when` is truthy is the default behavior. Existing `then="show"` markup continues to work.
- `<go-checkout-form>` guest form fields changed: `currentPassword` is removed; the default field set is now `firstName`, `lastName`, `email`, `confirmEmail`, `acceptTerms`.
- `formData` exposed to `beforeSubmit` (and to `<go-if>` expressions via `data.formData`) uses **API-side keys** and coerces select values to numbers. For example, `firstName` is exposed as `name`, `salutation` as `customer_salutation_id` (numeric), and `country` as `addr_country_id` (numeric). If you read `formData` by field label, update your keys.

---

# v1.5.0

_Released 2025-10-07_

Adds scripting access to form field values and hardens auth token expiry handling.

## New

- `<go-form>` scripting handle gains `formData` — `element.details.formData` returns
  a `{ [fieldId]: value }` snapshot of all current field values, keyed by field ID.
  Also accessible inside `<go-if>` as `data.formData` for conditional rendering.

## Changed (behavior)

- All `<go-field>` controls now render with a `name` attribute set to the field's ID.
  This enables native browser form serialization and autofill matching by field name.

## Fixed

- Auth sessions whose token has passed its expiry time are now automatically signed
  out on next access, instead of remaining active with stale credentials.
- Corrupt or invalid auth JSON in storage now correctly triggers a sign-out, instead
  of leaving the auth state in an inconsistent condition.

---

# v1.4.0

_Released 2025-10-07_

Adds day-ticket support to `<go-ticket-selection>` and a new `ticket-group-ids` attribute for filtering tickets by group.

## New

- `<go-ticket-selection>` and `<go-ticket-group>` now support `filters="day"` — loads
  day-admission tickets for a selected date without requiring a timeslot.
- `<go-ticket-selection ticket-group-ids="1,2,3">` — optional comma-separated list of
  ticket group IDs; when set, only tickets belonging to those groups are shown.

## Changed (behavior)

- `<go-if when="data.ticketSelection.isCalendarVisible">` now evaluates to `true` when
  `filters` includes `day`, not only when it includes `timeslot`.

---

# v1.3.0

_Released 2025-10-06_

`<go-cart>` gains a read-only preview mode, and its header/footer CSS hooks were renamed for clarity.

## New

- `<go-cart>` gains a `preview` attribute — when set, the cart renders without remove buttons, making it a non-editable summary view.

## Breaking → migration

### Cart header and footer `data-*` hooks renamed

The `data-go-cart-item-*` hooks on the header and footer rows were renamed to distinguish them from per-item row hooks. Update any CSS that targets these attributes.

Before:

```css
[data-go-cart-item-title] {
}
[data-go-cart-item-price] {
}
[data-go-cart-item-count] {
}
[data-go-cart-item-remove] {
}
[data-go-cart-item-sum] {
}
```

After:

```css
/* header row */
[data-go-cart-header-title] {
}
[data-go-cart-header-price] {
}
[data-go-cart-header-count] {
}
[data-go-cart-header-remove] {
}
[data-go-cart-header-sum] {
}

/* footer row */
[data-go-cart-footer-title] {
}
[data-go-cart-footer-price] {
}
[data-go-cart-footer-count] {
}
[data-go-cart-footer-remove] {
}
[data-go-cart-footer-sum] {
}
```

Note: `[data-go-cart-item-*]` attributes on individual cart item rows are unchanged.

---

# v1.2.0

_Released 2025-09-30_

Maintenance release — no integration-facing changes.

---

# v1.1.0

_Released 2025-09-30_

Adds `<go-sign-in>` and `<go-checkout-form>` tags, introduces a `forms` config section for adding extra fields, and fixes form submission to fire `go-submit` on success; the `form-id` values for sign-up and login forms changed.

## New

- `<go-sign-in>` — renders the sign-in form; fires `go-success` on the host element when authentication succeeds.
- `<go-checkout-form>` — renders the guest checkout form. Accepts a `custom` boolean attribute; when set, you supply your own `<go-input>` children instead of the default field set.
- `go.defineConfig({ forms: { checkoutGuest: { additionalFields: [...] } } })` — extend the checkout form with additional fields (e.g. a newsletter checkbox) defined in your page script.

## Changed (behavior)

- `<go-form>` now fires `go-submit` on the form element when validation passes, instead of `success`. Update any listeners attached to the form element accordingly.
- API-level error messages returned from the server are now rendered inside the form's error block, below field-level errors.

## Fixed

- Clicking the "Add to cart" button no longer throws when `go.config.urls.cart` is set — the navigation function was misnamed in the previous release and never ran.

## Breaking → migration

### `form-id="signup"` renamed to `form-id="signUp"`

The `<go-form>` sign-up form identifier changed to camelCase. Update any `<go-signup>` or directly-authored `<go-form>` markup.

Before:

```html
<go-signup></go-signup>
<!-- or -->
<go-form form-id="signup"></go-form>
```

After:

```html
<go-signup></go-signup>
<!-- or -->
<go-form form-id="signUp"></go-form>
```

### `form-id="login"` renamed to `form-id="signIn"`

The login form identifier was renamed to `signIn` for consistency with the new `<go-sign-in>` tag.

Before:

```html
<go-form form-id="login"></go-form>
```

After:

```html
<go-form form-id="signIn"></go-form>
```

### `go.config.navigatoTo` renamed to `go.config.navigateTo`

The navigation callback was misspelled in v1.0.0. Any page script that read or overrode the function by name must be updated.

Before:

```js
go.defineConfig({ navigatoTo: url => myRouter.push(url) })
```

After:

```js
go.defineConfig({ navigateTo: url => myRouter.push(url) })
```

---

# v1.0.0

_Released 2025-09-25_

Initial release of the gomus-webcomponents library — a set of `<go-*>` custom elements covering the full museum ticketing flow from ticket selection through cart and checkout.

## New

**Ticket selection**

- `<go-ticket-selection filters="…">` — outer wrapper; set one or more filter tokens to control which ticket types and UI panels are active.
- `<go-ticket-segment filters="…">` — a bookable segment (one product group + date) inside a selection. Nest one or more inside `<go-ticket-selection>`.
- `<go-calendar>` — date picker driven by availability; appears when the active filter exposes a calendar.
- `<go-timeslots>` — time-slot picker for timeslot-based tickets; appears when the active filter exposes timeslots.
- `<go-tickets>` — quantity selectors for available tickets in the current segment.
- `<go-tickets-empty>` — rendered when no tickets are available for the selected date/time.
- `<go-tickets-sum>` — displays the running total across all ticket segments.
- `<go-ticket-segment-body>`, `<go-ticket-segment-sum>`, `<go-ticket-segment-empty>` — composable sub-parts of a segment.
- `<go-add-to-cart-button>` — add-to-cart trigger; disabled automatically when capacity is zero or no time is selected.

**Filter tokens** (pass to the `filters` attribute):

| Token                       | Use case                                       |
| --------------------------- | ---------------------------------------------- |
| `ticket:timeslot`           | Admission tickets with time-slot selection     |
| `ticket:day`                | Admission tickets valid for a full day         |
| `ticket:annual`             | Annual / membership tickets                    |
| `event:admission`           | Event admission (no separate date picker)      |
| `event:admission:day`       | Event admission with day-level date selection  |
| `event:admission:timeslot`  | Event admission with timeslot selection        |
| `event:price`               | Date-level prices for a single event           |
| `events:admission`          | Multi-event admission listing                  |
| `events:admission:day`      | Multi-event admission with day selection       |
| `events:admission:timeslot` | Multi-event admission with timeslot selection  |
| `events:price`              | Date-level prices across a multi-event listing |

**Cart**

- `<go-cart>` — cart shell; renders a self-contained cart layout by default.
- `<go-cart-items>` — list of cart line items.
- `<go-cart-coupons>` — coupon input and applied-coupon list.
- `<go-cart-subtotal-amount>` — subtotal before discount.
- `<go-cart-discounted-amount>` — discount amount applied.
- `<go-cart-total-amount>` — final total.
- `<go-cart-empty>` — shown when the cart has no items.
- `<go-cart-counter>` — item count badge (for embedding in nav/header areas).

**Checkout & order**

- `<go-checkout-form>` — collects visitor data and submits the order; wraps standard booking fields.
- `<go-order>` — order confirmation view.
- `<go-order-breakdown>` — itemized price breakdown inside the order confirmation.
- `<go-order-invoice-id>` — displays the invoice reference number.

**Authentication**

- `<go-sign-up>` — visitor registration form.
- `<go-sign-in>` — login form.
- `<go-password-reset>` — password-reset request form.

**Profile**

- `<go-profile-overview>`, `<go-profile-details>`, `<go-profile-password>` — account management views for signed-in visitors.

**Forms**

- `<go-form>`, `<go-field>`, `<go-all-fields>`, `<go-submit>`, `<go-form-feedback>`, `<go-errors-feedback>`, `<go-success-feedback>` — composable form primitives for custom booking forms.

**Utility**

- `<go-init>` / `<gomus-init>` — initializes the shop connection (set `shop-url` and `locale` here).
- `<go-if>` — conditional rendering driven by cart / session state.
- `<go-link>` — navigation link that respects the shop's locale and base URL.
- `<go-donations>` — optional donation selector for checkout flows.
- `<go-coupon-redemption>` — standalone coupon code entry (outside the cart).
- `<go-annual-ticket-personalization>`, `<go-annual-ticket-personalization-form>` — personalization fields for annual/membership tickets.
