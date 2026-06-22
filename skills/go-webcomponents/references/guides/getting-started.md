# Installation

## Load the script
in `<Head>`
```html
<script type="module" src="url_to_js_file"></script>
```

The code is a [NPM package](https://www.npmjs.com/package/@gomusdev/web-components), you
can get the `url_to_js_file` for example using unpckg:
`https://unpkg.com/@gomusdev/web-components@x.x.x/dist-js/gomus-webcomponents.iife.js`
where x.x.x is the version number.

For development purposes you can load the latest version:
`https://unpkg.com/@gomusdev/web-components@latest/dist-js/gomus-webcomponents.iife.js`

Alternatively you can import the code via `npm`

## Initialize

Initialize the component echo system
```html
<go-init shop-domain="..." api-domain="..." locale="de-DE" />
```

## Usage
Now you can start using the components, for example a Ticket Selection:

```html
<go-ticket-selection mode="ticket" filter="time_slot" ticketids="" museumids="" exhibitionids="">
  <go-calendar></go-calendar>
  <go-timeslots></go-timeslots>
  <go-tickets></go-tickets>
</go-ticket-selection>
```
