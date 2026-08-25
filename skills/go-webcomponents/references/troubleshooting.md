# Troubleshooting

Symptom-first fixes for the problems integrators hit most. Check the browser console first — the components report misconfiguration there with a `[go]`, `[go-…]`, or `(go)` prefix, and almost every issue below has a matching console message.

## Nothing renders at all

**Symptom:** the `<go-*>` tags stay inert — no controls appear, no network requests fire.

The library bundle never loaded:

- The loader snippet must be on the page **before** any other `go.*` call, and `go.load({ version: '…' })` must actually run — see **The Go Interface**.
- Check the Network tab: `gomus-webcomponents.iife.js` must load with status 200. A `version` that was never published makes the CDN request fail and nothing else happens.
- If you set `window._go_src`, it must be the complete file URL — the `version` option is ignored then.
- Load the bundle **once**. Including it twice makes the second registration of each custom element throw.

## Components render but never load data

**Symptom:** the markup appears but stays empty; the console shows `(fetchAndCache) Couldn't fetch, Shop not loaded!`.

`go.init(…)` never ran, or ran with wrong values:

```js
go.init({ shop: 'myshop', api: 'api.gomus.de', locale: 'de' })
```

- `api` is a **domain without protocol**. Passing `https://api.gomus.de` produces requests against an invalid `https://https://…` URL — every call fails.
- `shop` is the shop identifier gomus gave you. A wrong value makes the very first shop request fail — inspect it in the Network tab.
- The declarative alternative follows the same rules: `<go-init api-domain="api.gomus.de" shop-domain="…" locale="de"></go-init>`.

## `go.api` / `go.cart` scripting errors

**Symptom:** `TypeError` — `go.api` is `undefined`.

`go.api` is **not** queued by the snippet; it exists only after the bundle loads. Call it from event handlers, or gate on `window.go?.loaded`. See **The Go Interface**.

**Symptom:** a call rejects with `[go] Shop not initialized — call go.init({ shop, api, locale }) first.`

Run `go.init(…)` before the call (queueing it before load is fine — calls made while `go.init()` is still in flight wait for it automatically).

**Symptom:** a `go.cart.addItem(…)` queued before load does nothing.

Queued cart calls are fire-and-forget — failures (sold out, missing field) land in the console, not in a rejected promise. Two related console messages:

- `(go) the pasted go snippet predates go.cart — cart calls cannot be queued before load.` — your inline snippet is outdated; paste the current one.
- `(go) unknown command: cart.addTour` — a script still calls the removed `go.cart.addTour`; use `go.cart.addItem({ filter: 'tour', … })`.

## Ticket selection shows no tickets

Work through this checklist:

- **Unknown or misspelled filter** — console: `[go-ticket-selection] Unknown filter "…". Valid filters: …`. Filter names are exact, e.g. `ticket:timeslot`, `event:admission`.
- **Legacy `mode` attribute** — `mode` is deprecated and ignored (console warning). Use `filters`.
- **Missing prerequisite attribute** — every `event:*` / `events:*` filter needs `event-ids`. Without it the filter loads nothing, silently.
- **No date or timeslot picked yet** — most filters show tickets only after a date (and, for timeslot filters, a slot) is chosen. Include `<go-calendar>` (and `<go-timeslots>`) inside the selection.
- **Selection and segment filters disagree** — a `filters` attribute on `<go-ticket-segment>` should be a subset of the parent `<go-ticket-selection>`'s; see **Components / Ticket Selection**.
- **Nothing bookable** — the backend only returns tickets that are active and bookable in the online shop; check the ticket's shop settings in gomus.

## The calendar shows no selectable days

- Days before today are always blocked — a callback can't open them.
- Availability comes from the backend for the active filters: if every day renders unavailable or sold out, the tickets or events have no bookable dates or remaining quota in that range.
- If you use `availability-override`, watch the console: `[go-calendar] availability-override="…" does not resolve to a function on window` means the global's name doesn't match; a callback that throws or returns an unexpected value is reported once and the gomus default is used instead.

## The timeslot list is empty

`<go-timeslots>` renders nothing until a date is chosen **and** an active filter includes a timeslot step — that is by design, so it can sit in the markup unconditionally. If a date is selected and the list stays empty, every slot on that date is sold out or already in the past. Also note: a date with exactly one usable slot auto-selects it, so the visitor may never see a list.

## The add-to-cart button stays disabled

`<go-add-to-cart-button>` enables once at least one ticket in the surrounding `<go-ticket-selection>` has a quantity above zero. It must be nested **inside** the selection whose tickets it adds — placed outside, it never enables.

## After add to cart, the page navigates (or doesn't)

Clicking the button adds the selected tickets to the cart, resets the selection's quantities to zero, and — only when configured — navigates to the cart URL:

```js
go.config({
  urls: {
    cart: () => 'https://your-shop.example/cart',
  },
})
```

If the page jumps and you don't want it to, remove the `urls.cart` entry; if you expect a jump and none happens, add it.

## The cart is empty after a reload

The cart persists in the browser's `localStorage`, so it survives reloads on the **same origin** only — and it is deliberately volatile:

- carts older than **15 minutes** are discarded on load, so stale prices and availability never drive the UI,
- lines whose date or timeslot has meanwhile passed are dropped,
- rendering the confirmation page (`<go-order token="…">`) empties the cart — the purchase is complete,
- private-browsing modes or blocked storage make the cart reset on every navigation.

## Checkout lands on the wrong page

After a successful checkout the components navigate by outcome; the success and failure URLs default to the shop's built-in pages. Override them:

```js
go.config({
  urls: {
    checkoutSuccess: token => `/order-complete?token=${token}`,
    checkoutFailure: error => `/order-failed?error=${error}`,
  },
})
```

If the checkout request itself is rejected, no redirect happens — the errors render on the form. See **Components / Checkout Form**.

## The order confirmation page is empty

`<go-order>` needs its `token` attribute — it does not read the URL itself. Pass the token your `checkoutSuccess` URL carries:

```html
<go-order id="order">
  <go-order-breakdown></go-order-breakdown>
</go-order>

<script>
  const token = new URLSearchParams(location.search).get('token')
  if (token) document.getElementById('order').setAttribute('token', token)
</script>
```

## `<go-link>` renders a dead link

Console: `[go-link] No URL found for route "…".` Every route name a `<go-link to="…">` uses must be configured as a URL-builder function:

```js
go.config({
  urls: {
    cart: () => 'https://your-shop.example/cart',
  },
})
```

## Wrong language, or odd price and date formatting

The `locale` passed to `go.init` drives both the translated texts and price/date formatting. It must be a valid BCP 47 tag (`de`, `en`, `de-CH`). Two warnings on load tell you what went wrong:

- `[go] Invalid locale "…"` — malformed tag, e.g. `de_DE` with an underscore; price and date formatting will throw.
- `[go] Unknown locale "…"` — well-formed but the browser has no data for it; formatting falls back to the browser default.

## Styling problems

- The components render in the **light DOM** with no styling of their own — looking "unstyled" is the headless default. Style them from your page CSS; each component's documentation lists its class and `data-*` hooks.
- The flip side: your page's global CSS applies **inside** the components too. An aggressive global reset (e.g. on `button` or `input`) restyles the components' controls as well.
- **Never self-close custom elements.** `<go-cart />` is not valid HTML — the browser ignores the `/` and everything after it becomes a child of `<go-cart>`. Always write an explicit closing tag: `<go-cart></go-cart>`.
