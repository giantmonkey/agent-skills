# `<go-profile-details>`

Since `v1.34.0`

An account-details form for the signed-in customer. It renders salutation, name, email, and language fields and pre-fills them with the customer's current data once they are signed in. Submitting only validates the input — the component does not save changes itself. To persist profile changes, use the self-submitting `<go-form form-id="profileUpdate">` (see the `<go-form>` documentation).

## Examples

Basic:

```html
<go-profile-details></go-profile-details>
```

On a profile page, together with the other profile components:

```html
<go-profile-overview></go-profile-overview>
<go-profile-details></go-profile-details>
<go-profile-password></go-profile-password>
```

## Attributes

This component takes no attributes.

## Events

This component emits no custom events. After client-side validation passes, the inner form's `submit` event bubbles through the element.

## Styling

No style hooks of its own beyond the root element. The rendered form is light DOM and uses the shared form hooks (`.go-field`, `.go-field.is-invalid`, `.go-field-errors`, `<go-submit>`) — see the `<go-form>` documentation.

```css
go-profile-details .go-field.is-invalid label {
  color: darkred;
}
```

## Nesting

Standalone — no required parent.

## Subcomponents

None — you don't place children inside it. It renders a pre-configured `<go-form>` internally.

## Conditional rendering with `<go-if>`

Show the form only for signed-in customers:

```html
<go-if when="data.auth.isLoggedIn">
  <go-profile-details></go-profile-details>
</go-if>
```

## Form Fields

- `salutation` (optional) — salutation/title
- `firstName` (required) — first name
- `lastName` (required) — last name
- `email` (required) — email address
- `confirmEmail` (required) — email confirmation
- `language` (required) — preferred language
