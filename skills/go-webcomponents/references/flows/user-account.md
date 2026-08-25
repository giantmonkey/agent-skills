# User account

How visitors create an account, sign in, recover a lost password, and manage their
profile — and how the rest of the page reacts to the sign-in state. Each step is its
own standalone component; you combine them with `<go-if>`, which exposes the current
sign-in state to your markup.

## Components in this flow

| Component               | Role                                                      |
| ----------------------- | --------------------------------------------------------- |
| `<go-sign-up>`          | Registration form — creates a customer account            |
| `<go-sign-in>`          | E-mail + password sign-in form                            |
| `<go-password-reset>`   | Requests the password-reset e-mail                        |
| `<go-set-password>`     | Sets the new password from the reset-link credentials     |
| `<go-profile-overview>` | Shows the signed-in customer's name and e-mail            |
| `<go-profile-details>`  | Account-details form, pre-filled with the customer's data |
| `<go-profile-password>` | Change-password form (current password required)          |
| `<go-checkout-user>`    | Checkout for signed-in customers                          |
| `<go-if>`               | Gates markup on the sign-in state (`data.auth.*`)         |

All of them are standalone — no required parent. Initialize the shop first with
`go.init({ shop, api, locale })` (see **The Go Interface**).

## Sign-up

`<go-sign-up>` collects name, e-mail (with confirmation), password (with
confirmation), and acceptance of the terms, and fires `go-success` once the account
is created:

```html
<go-sign-up></go-sign-up>

<script>
  document.querySelector('go-sign-up').addEventListener('go-success', () => {
    // account created — show a "check your inbox" message
  })
</script>
```

`go-success` means the account was **created, not signed in**: the shop sends a
confirmation e-mail, and the customer confirms their address before the first
sign-in. A sign-in attempt before confirmation fails with an error shown inline.

For your own field layout, add the `custom` attribute and compose the form
subcomponents yourself — see **Components / Sign Up**.

## Sign-in

`<go-sign-in>` renders e-mail and password fields and fires `go-success` once the
visitor is signed in:

```html
<go-sign-in></go-sign-in>

<script>
  document.querySelector('go-sign-in').addEventListener('go-success', () => {
    window.location.href = '/account'
  })
</script>
```

A failed sign-in emits no event — the errors render inline in the form. After a
successful sign-in the session is active immediately; every `<go-if>` gated on
`data.auth.*` updates reactively, without a page reload.

## Reacting to the sign-in state

`<go-if>` exposes the sign-in state to its `when` expression _(Since `v4.5.0`)_:

- `data.auth.isLoggedIn` — a customer is signed in with an account
- `data.auth.isGuest` — only a guest-checkout session is held
- `data.auth.isAuthenticated` — either of the above

A typical account menu:

```html
<go-if when="!data.auth.isLoggedIn">
  <a href="/sign-in">Sign in</a>
</go-if>

<go-if when="data.auth.isLoggedIn">
  <a href="/account">My account</a>
</go-if>
```

The state is reactive: content appears and disappears as the visitor signs in, and
when the session expires.

## Password reset

The reset is a two-step flow across two components:

1. `<go-password-reset>` — the visitor enters their e-mail; the shop sends a reset
   e-mail. Point `redirect-url` at the page hosting step 2.
2. `<go-set-password>` — the link in the e-mail returns the visitor to that page
   with one-time credentials in the URL query string; you pass them in as
   attributes, and the visitor picks a new password. On success the visitor is
   signed in automatically.

One page can host both steps:

```html
<go-password-reset redirect-url="https://your-shop.example/password-reset"></go-password-reset>
<go-set-password id="set-password" hidden></go-set-password>

<script>
  var params = new URLSearchParams(location.search)
  if (params.get('reset_password') === 'true') {
    var el = document.getElementById('set-password')
    el.setAttribute('access-token', params.get('access-token'))
    el.setAttribute('client', params.get('client'))
    el.setAttribute('uid', params.get('uid'))
    el.removeAttribute('hidden')

    el.addEventListener('go-success', function () {
      window.location.href = '/account'
    })
  }
</script>
```

See **Components / Password Reset** and **Components / Set Password** for the
attribute and query-parameter details.

## Profile management

Gate the account area on the sign-in state and compose the profile components:

```html
<go-if when="!data.auth.isLoggedIn">
  <go-sign-in></go-sign-in>
</go-if>

<go-if when="data.auth.isLoggedIn">
  <go-profile-overview></go-profile-overview>
  <go-profile-details></go-profile-details>
  <go-profile-password></go-profile-password>
</go-if>
```

- `<go-profile-overview>` shows the customer's full name and e-mail. When no one is
  signed in it shows a localized sign-in prompt instead.
- `<go-profile-details>` renders the account-details form (salutation, name,
  e-mail, language) pre-filled with the signed-in customer's data.
- `<go-profile-password>` lets the customer change their password; it asks for the
  current password and shows a success message inline.

To save profile changes, use the pre-registered self-submitting `profileUpdate`
form — it submits directly to the account-update endpoint and renders the result,
no JavaScript needed:

```html
<go-form form-id="profileUpdate"></go-form>
```

Customer addresses work the same way via the `addressCreate` / `addressUpdate`
form ids — see **Components / Forms**.

## Signed-in checkout

Checkout has one component per auth state; pick which to render with `<go-if>`:

```html
<go-if when="!data.auth.isLoggedIn">
  <go-checkout-guest></go-checkout-guest>
</go-if>

<go-if when="data.auth.isLoggedIn">
  <go-checkout-user></go-checkout-user>
</go-if>
```

`<go-checkout-user>` skips the identity fields — a signed-in customer only confirms
the terms and picks a payment mode. `<go-checkout-guest>` creates a guest session
on submit (`data.auth.isGuest` becomes true). See **Components / Checkout Form**.

## Session behavior

- The session is stored in the browser and shared across tabs — signing in on one
  tab signs in all of them.
- Sessions expire automatically; an expired session reads as signed out, and every
  `<go-if>` gated on `data.auth.*` updates accordingly.
- Guest sessions (from guest checkout) count as `isGuest` / `isAuthenticated`, not
  `isLoggedIn`.

## Scripting

For account features beyond the components, `go.api` offers the customer endpoints —
`getCustomer()`, `getOrders()`, `getCustomerAddresses()`, `getCustomerMemberships()`,
`updateCustomer()`, `updatePassword()`, `requestPasswordReset()`, and the address
writes. All requests automatically carry the current session. See **The Go Interface**.
