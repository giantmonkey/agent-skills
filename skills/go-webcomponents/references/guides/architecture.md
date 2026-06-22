# Web components

Custom elements for ticket shops — what the library does, what stays on your side, when it fits. Architecture overview with a pointer to the official component docs.

`go~mus` web components are reusable HTML elements with their own logic and no styling — a built-in browser standard with no framework lock-in. You keep running your website, your shop, your CMS; the components handle the standardised booking and checkout flows.

This page is the architecture overview. The current component API, properties and examples live in the official docs — linked below.

## Custom elements as building blocks

```html
<go-tickets></go-tickets>
<go-cart></go-cart>
<go-checkout-form></go-checkout-form>
```

These tags behave like `<input>` or `<video>`, just custom-built — they run in React, Vue, Svelte, WordPress, TYPO3 or plain HTML. One bundle, all platforms, no vendor lock-in. W3C standard, all modern browsers without polyfills.

- The library: `@gomusdev/web-components` on npm.
- Live storybook with components and examples: [webcomponents.platform.gomus.de](https://webcomponents.platform.gomus.de).

## Initialisation

The library must be initialised once per page. Drop the snippet below into your `<head>`. The small inline stub creates a `go` object with queued `init` and `config` calls, then `go.load()` injects the library bundle and replays the queue.

```html
<script>
  // use _go_src to override the default location of the webcomponents library
  // _go_src = '../dist-js/gomus-webcomponents.js'
  ;(function (w) {
    let _queue = []
    let stub = method => options => _queue.push({ method, options })
    let go = {
      _queue,
      init: stub('init'),
      config: stub('config'),
    }
    go.load = function (options) {
      var s = document.createElement('script')
      s.src =
        window._go_src ??
        'https://unpkg.com/@gomusdev/web-components@' + options.version + '/dist-js/gomus-webcomponents.iife.js'
      document.head.appendChild(s)
    }
    window.go = go
  })(window)

  // Load the web components library
  go.load({ version: 'latest' })

  // Initialize the shop
  go.init({
    shop: 'your-shop-id',
    api: 'api.gomus.de',
    locale: 'en',
  })
</script>
```

Pin a specific version in production (e.g. `version: '2.1.x'`) instead of `'latest'`. Override `window._go_src` if you self-host the bundle. After `go.init()` resolves, every `<go-*>` element on the page becomes live.

## What you can sell with them

| Product       | What it is                                               | Status    |
| ------------- | -------------------------------------------------------- | --------- |
| Day tickets   | Single admission, optionally with time slot              | Available |
| Events (EPA)  | Single-seat offer — event with dates, seats per attendee | Available |
| Annual passes | Period-based, with personalisation                       | Available |
| Combo tickets | Multiple tickets bundled (exhibition + tour etc.)        | Available |
| Group tours   | Booked as a whole group (package price)                  | Roadmap   |
| Vouchers      | Gift voucher as a sellable product                       | Roadmap   |
| Merchandise   | Physical goods (catalogues, shop items)                  | Roadmap   |

**Important:** Events ≠ Tours. Events (EPA) sell individual seats to individual attendees. Tours sell a whole group as a unit, e.g. a private guided tour for a school class. Two categories, two workflows. More in _Events and Tours_.

## Coexistence: what the component handles, what stays yours

Web components are building blocks, not a platform. They coexist with everything already in place on your site.

**Component handles:**

- Paid tickets and events
- Cart and checkout
- Login, registration, profile
- Annual pass sales incl. personalisation

**Stays as it was:**

- Free event registration as a custom form
- Newsletter signup (Mailchimp, Brevo, ...)
- Donation form (e.g. betterplace)
- Event and exhibition calendar from the CMS

You keep control over all other touchpoints. Web components are used only where they add real value.

## Clean separation between your logic and the component

The web components are the standardised purchase flow. Everything around them can be freely extended in the shop shell, without waiting for a library release.

Example from a production shop. Some events also require a separate admission ticket. The cart shows a notice block that links directly to the matching day ticket. This logic lives in the surrounding shop code, not the web component. One day of work, without touching component code.

What becomes possible in the shell around the components:

- Museum-specific notices and upsells
- Custom landing pages for campaigns
- CRM and newsletter integrations
- Analytics, A/B testing, cookie banners

**Who does what:**

- **Component** = standardised purchase flow, updates ship cleanly
- **Shop code** = museum-specific needs, under your control, independent release cycle

## Example snippet

A minimal ticket selection with date picker and cart button looks like this:

```html
<go-ticket-selection filters="ticket:day">
  <go-calendar></go-calendar>
  <go-timeslots></go-timeslots>
  <go-tickets>
    <go-ticket-segment>
      <go-ticket-segment-body></go-ticket-segment-body>
    </go-ticket-segment>
  </go-tickets>
</go-ticket-selection>
```

That is enough to show a day-ticket selection on any HTML page. Full component list, properties, events and page examples for cart, checkout and account flows: in the storybook.

## Quality in depth

The components are not a demo library, they are production software for museum revenue:

- **Performance** — lazy-loaded bundles, code splitting, optimised assets. Lighthouse-capable on mobile and desktop.
- **Accessibility** — WCAG 2.2 AA as the standard. Keyboard navigation, screen-reader testing. BITV 2.0 reachable for public-sector houses.
- **Security** — Content-Security-Policy friendly, no inline scripts, dependency audits in every release.
- **Quality** — automated tests, storybook-driven component workflow, continuous release tracking.
- **Internationalisation** — DE and EN out-of-the-box, more languages via configuration and translation sync.
- **Extensibility** — museum-specific features plug cleanly into the shop shell without touching component code. Update-safe.

A note on accessibility. The components are purely functional and ship without styling — on the functional level we offer full accessibility (semantics, keyboard navigation, focus order, ARIA roles). Visual accessibility — colour contrast, font sizes, spacing — lives in your shop CSS and is your responsibility.

## Active development as an asset

The library is under continuous development. Two tracks run in parallel on npm.

| Track  | npm tag   | When to use                                                                                               |
| ------ | --------- | --------------------------------------------------------------------------------------------------------- |
| Master | `@latest` | Production. Stable release, fully tested. The safe default.                                               |
| Next   | `@next`   | You need a feature that just landed and is not yet in master. Evaluation, early adopters, migration prep. |

**How to choose.** Start with master. Pin the major (e.g. `@gomusdev/web-components@2.x`) and patch/minor updates land safely. Switch a deployment to `next` only when you need a feature that is not yet in master. Once that feature reaches master, switch back.

Patch and minor releases run continuously on both tracks. Breaking changes are called out in the npm changelog before they ship.

## Versioning and source of truth

The library is under active development. Major bumps can ship breaking changes — this is software, not marketing copy.

Recommendations:

- Pin the version in production. Use `@gomusdev/web-components@2.1.x` instead of `@latest`, otherwise a bump can land unannounced.
- The storybook is the authoritative documentation. Properties, events and slots are maintained there — not here. This page would otherwise age between major bumps.
- Read the changelog in the npm package before upgrading. Breaking-change notes live there.

When you wire up a specific component, look up the current API in the storybook. When you orient yourself overall, this page is the right entry point.

## Who builds it

Two routes, both valid. The choice depends on your internal setup, pace, and design expectations.

|                | Variant A: Agency integrates                          | Variant B: Specialised shop builder                 |
| -------------- | ----------------------------------------------------- | --------------------------------------------------- |
| Who            | Your existing web agency                              | Specialists for museum shops                        |
| Pace           | Pace of the web-components roadmap                    | Your pace, custom features in shop code in parallel |
| Visual         | Your website + component embed                        | Standalone shop, own domain                         |
| When this fits | Agency owns the website anyway, shop area stays small | High visual demands, many custom features           |

## When this fits vs. linking and iframe widget

| Variant                    | Visual          | Effort        | When this fits                                                          |
| -------------------------- | --------------- | ------------- | ----------------------------------------------------------------------- |
| Link to the `go~mus` shop  | Breaks on click | Hours         | Live fast, simple ticket structure, brand consistency not critical      |
| iframe widget              | Iframe boundary | Hours         | Single booking per date (e.g. registration), no order flow on your side |
| Web components (this page) | Seamless        | Days to weeks | Full booking flow, high brand expectations                              |

Linking and web components are not exclusive. Main pages as web components, newsletters and third-party pages link to the standard shop — a common combination.

## The direct API as a complement

The direct API is not a fourth path next to linking, widget and web components — it is the complement that makes each of these variants polished.

**Combined with web components:**

- A custom event calendar built from API data, with the booking handled by the embedded component next to it
- Custom filters and search via API, results handed to the component
- Dynamic notices and upsells in the shop shell, fed by your own API calls

**Combined with linking:**

- Show availability and prices via API on overview or detail pages, click leads into the shop with the date pre-selected
- Combine CMS content (editorials, images, texts) and API data (dates, remaining seats) on one page
- Build clean deep links into the shop because the API provides the needed ids and slugs

A standalone booking flow purely on the direct API is possible, but rarely the right choice — web components and widget handle checkout production-ready. The API shines next to them, in transition and display logic.
