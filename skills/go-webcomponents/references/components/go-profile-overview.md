# `<go-profile-overview>`

Since `v1.34.0`

The `go-profile-overview` component displays the signed-in customer's full name and email address. When no customer is signed in, it renders a localized sign-in prompt instead.

## Examples

Basic:

```html
<go-profile-overview></go-profile-overview>
```

On a profile page, together with the editable profile details:

```html
<go-profile-overview></go-profile-overview> <go-profile-details></go-profile-details>
```

## Attributes

This component takes no attributes.

## Events

This component emits no custom events.

## Styling

- `.go-profile-fullname` — the customer's full name
- `.go-profile-email` — the customer's email address

```css
.go-profile-email {
  color: #666;
}
```

## Nesting

Standalone — no required parent.

## Subcomponents

None.

## Conditional rendering with `<go-if>`

Show the profile overview only for signed-in customers:

```html
<go-if when="data.auth.isLoggedIn">
  <go-profile-overview></go-profile-overview>
</go-if>
```

## Localization

| Key                    | Purpose                                            |
| ---------------------- | -------------------------------------------------- |
| `user.login.desc.text` | Sign-in prompt shown when no customer is signed in |
