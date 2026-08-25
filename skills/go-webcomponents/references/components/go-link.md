# `<go-link>`

Since `v1.21.0`

Renders an anchor (`<a>`) around your content that points to a named route from your URL configuration. You register routes with `go.config({ urls: { … } })`; clicks navigate through your configured `navigateTo` handler (a full page navigation by default).

## Examples

Basic:

```html
<go-link to="checkoutForm">Checkout</go-link>
```

Registering a route with `go.config` and linking to it:

```html
<script>
  go.config({
    urls: {
      checkoutForm: () => '/checkout',
    },
  })
</script>

<go-link to="checkoutForm">Checkout</go-link>
```

## Attributes

| Attribute | Type   | Default | Description                                                      |
| --------- | ------ | ------- | ---------------------------------------------------------------- |
| `to`      | string | —       | Name of a route registered via `go.config({ urls })` — see below |

### to

The name of the route this link leads to. Route names are case-sensitive and come from the `urls` map you pass to `go.config`. If no URL is registered under the given name, the anchor renders without an `href`, clicking does nothing, and a warning is logged to the browser console. The `href` updates automatically when the configuration changes.

## Events

This component emits no custom events. Clicks are intercepted and routed through the `navigateTo` handler from `go.config` instead of default anchor navigation.

## Styling

- `go-link` — the host element
- `go-link a` — the rendered anchor; your link content is moved inside it (no `href` when the route is not registered)

```css
go-link a {
  text-decoration: underline;
}
```

## Nesting

Standalone — no required parent.

## Subcomponents

None.
