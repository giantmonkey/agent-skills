---
name: go-webcomponents
description: |
  Gomus museum-ticketing web components — integration reference for embedding go-* custom elements in any HTML page. Public tags: go-add-to-cart-button, go-all-fields, go-annual-ticket-personalization, go-annual-ticket-personalization-form, go-calendar, go-cart, go-cart-counter, go-cart-coupons, go-cart-discounted-amount, go-cart-empty, go-cart-items, go-cart-subtotal-amount, go-cart-total-amount, go-checkout-form, go-coupon-redemption, go-donations, go-errors-feedback, go-field, go-form, go-form-feedback, go-if, go-init, go-link, go-order, go-order-breakdown, go-order-invoice-id, go-password-reset, go-profile-details, go-profile-overview, go-profile-password, go-sign-in, go-sign-up, go-submit, go-success-feedback, go-ticket-segment, go-ticket-segment-body, go-ticket-segment-empty, go-ticket-segment-sum, go-ticket-selection, go-tickets, go-tickets-empty, go-tickets-sum, go-timeslots, go-withdrawal-form, gomus-init. Library version 3.7.0 (npm: @gomusdev/web-components). Trigger on: integrate gomus components; museum ticket booking; how do I show tickets; how do I set up the cart; upgrade gomus components; migrate web-components; update go-* to the latest version; go-ticket-selection; go-cart; go-checkout-form; or any go-* tag mentioned by name. For upgrades/migrations ("upgrade gomus", "migrate web-components", "update to the latest version"), follow ./references/migration.md.
version: 3.7.0
---

# Gomus web components

Custom elements for museum ticket shops. `<go-ticket-selection>` is the root context provider for the booking flow; cart, checkout, order, account and donation components are independent and read shared state.

## Start here

- [Architecture overview](./references/guides/architecture.md) — init snippet, product catalog, versioning, integration variants.
- [Component index](./references/components/index.md) — every public `<go-*>` tag with attributes.
- [Filters](./references/filters.md) — values for the `filters` attribute on `<go-ticket-selection>`.
- [Integration flows](./references/flows/index.md) — full-page examples.
- [Migrating versions](./references/migration.md) — upgrade your `<go-*>` markup to a newer library version; applies the documented breaking-change edits with review.
- [Changelog](./references/changelog.md) — per-version New / Changed / Deprecated / Breaking, newest first.
- [Nesting graph](./references/nesting.md) — which `<go-*>` tags nest inside which.
- [All guides](./references/guides/index.md)

## Digging deeper

The compiled library ships with this skill at `./references/gomus-webcomponents.iife.js`. When these docs do not answer a question — an exact attribute name, an event payload shape, a default value, an edge case — read or grep that bundle for the real behavior; it is the source of truth.

Keep answers to integrators concise and integration-focused. The bundle is your reference, not theirs — don't surface internal implementation details unless they ask.

## Public tags

`<go-add-to-cart-button>`, `<go-all-fields>`, `<go-annual-ticket-personalization>`, `<go-annual-ticket-personalization-form>`, `<go-calendar>`, `<go-cart>`, `<go-cart-counter>`, `<go-cart-coupons>`, `<go-cart-discounted-amount>`, `<go-cart-empty>`, `<go-cart-items>`, `<go-cart-subtotal-amount>`, `<go-cart-total-amount>`, `<go-checkout-form>`, `<go-coupon-redemption>`, `<go-donations>`, `<go-errors-feedback>`, `<go-field>`, `<go-form>`, `<go-form-feedback>`, `<go-if>`, `<go-init>`, `<go-link>`, `<go-order>`, `<go-order-breakdown>`, `<go-order-invoice-id>`, `<go-password-reset>`, `<go-profile-details>`, `<go-profile-overview>`, `<go-profile-password>`, `<go-sign-in>`, `<go-sign-up>`, `<go-submit>`, `<go-success-feedback>`, `<go-ticket-segment>`, `<go-ticket-segment-body>`, `<go-ticket-segment-empty>`, `<go-ticket-segment-sum>`, `<go-ticket-selection>`, `<go-tickets>`, `<go-tickets-empty>`, `<go-tickets-sum>`, `<go-timeslots>`, `<go-withdrawal-form>`, `<gomus-init>`

## Styling

The components ship without styling. Visual styling — colours, fonts, spacing, contrast — is the integrator's responsibility and lives in the shop CSS, not in the library. See the Architecture overview for the rationale.

## How this skill is generated

_Auto-generated from `apps/web-components` at library version 3.7.0 (2026-06-22T13:26:56.824Z). Prose docs live as MDX under `src/docs/` and `src/components/**/docs/` — review and edit them there._
