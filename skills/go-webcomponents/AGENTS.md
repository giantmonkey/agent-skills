# Gomus web components — AI integration reference

These are tool-agnostic Markdown docs for integrating the gomus museum-ticketing web components (`<go-*>` custom elements) into any HTML page. Library version 3.7.0 (npm: `@gomusdev/web-components`).

Point your AI assistant at this folder, or paste these files into a chat. (Claude users: the sibling `SKILL.md` exposes the same content as a Claude skill.)

## Start here

- [Architecture overview](./references/guides/architecture.md) — init snippet, product catalog, versioning, integration variants.
- [Component index](./references/components/index.md) — every public `<go-*>` tag with attributes.
- [Filters](./references/filters.md) — values for the `filters` attribute on `<go-ticket-selection>`.
- [Integration flows](./references/flows/index.md) — full-page examples.
- [Migrating versions](./references/migration.md) — upgrade your `<go-*>` markup to a newer library version.
- [Changelog](./references/changelog.md) — per-version New / Changed / Deprecated / Breaking, newest first.
- [Nesting graph](./references/nesting.md) — which `<go-*>` tags nest inside which.
- [All guides](./references/guides/index.md)

## Digging deeper

The compiled library ships alongside these docs at `./references/gomus-webcomponents.iife.js`. When the docs do not answer a question — an exact attribute name, an event payload shape, a default value — read or grep that bundle for the real behavior; it is the source of truth. Keep answers to integrators concise; the bundle is your reference, not theirs.

## Public tags

`<go-add-to-cart-button>`, `<go-all-fields>`, `<go-annual-ticket-personalization>`, `<go-annual-ticket-personalization-form>`, `<go-calendar>`, `<go-cart>`, `<go-cart-counter>`, `<go-cart-coupons>`, `<go-cart-discounted-amount>`, `<go-cart-empty>`, `<go-cart-items>`, `<go-cart-subtotal-amount>`, `<go-cart-total-amount>`, `<go-checkout-form>`, `<go-coupon-redemption>`, `<go-donations>`, `<go-errors-feedback>`, `<go-field>`, `<go-form>`, `<go-form-feedback>`, `<go-if>`, `<go-init>`, `<go-link>`, `<go-order>`, `<go-order-breakdown>`, `<go-order-invoice-id>`, `<go-password-reset>`, `<go-profile-details>`, `<go-profile-overview>`, `<go-profile-password>`, `<go-sign-in>`, `<go-sign-up>`, `<go-submit>`, `<go-success-feedback>`, `<go-ticket-segment>`, `<go-ticket-segment-body>`, `<go-ticket-segment-empty>`, `<go-ticket-segment-sum>`, `<go-ticket-selection>`, `<go-tickets>`, `<go-tickets-empty>`, `<go-tickets-sum>`, `<go-timeslots>`, `<go-withdrawal-form>`, `<gomus-init>`

## Styling

The components ship without styling. Visual styling — colours, fonts, spacing, contrast — is the integrator's responsibility and lives in the shop CSS, not in the library. See the Architecture overview for the rationale.
