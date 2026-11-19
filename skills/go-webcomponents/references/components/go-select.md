# `<go-select>`

Since `v4.35.0`

A select for one choice of a group tour booking: its language, age group or school class. The
`data` attribute names which. The entries come from the tour named by the `tour-id` of the
surrounding `<go-ticket-selection>`.

## Examples

Basic — the tour's languages:

```html
<go-ticket-selection filters="tour" tour-id="188">
  <go-select data="tour:language"></go-select>
</go-ticket-selection>
```

All three choices of a booking:

```html
<go-ticket-selection filters="tour" tour-id="188">
  <go-participants></go-participants>
  <go-select data="tour:language"></go-select>
  <go-select data="tour:age-group"></go-select>
  <go-select data="tour:grade"></go-select>
  <go-calendar></go-calendar>
  <go-tour-timeslots></go-tour-timeslots>
  <go-tour-prices></go-tour-prices>
  <go-add-to-cart-button></go-add-to-cart-button>
</go-ticket-selection>
```

## Attributes

| Attribute | Type   | Default | Description                                                    |
| --------- | ------ | ------- | -------------------------------------------------------------- |
| `data`    | string | —       | **Required.** What the select offers — one of the values below |

### data

| Value            | Offers                    | Sent with the booking |
| ---------------- | ------------------------- | --------------------- |
| `tour:language`  | the tour's languages      | the language          |
| `tour:age-group` | the tour's age groups     | the age group         |
| `tour:grade`     | the tour's school classes | the school class      |

An unknown value renders nothing and logs a console warning.

## Events

This component emits no custom events. Its `<select>` emits the standard DOM `change` event.

## Styling

A `<div class="go-select">` holding a `<label>`, the `<select>` and, when they apply, the texts
below it:

- `.go-select` — root element
- `.go-select-error` — the error of a blank select after a click on the button
- `.go-select-hint` — the error text when the tour could not be loaded (`role="alert"`)
- `select[aria-invalid='true']` — a select that shows its error

```css
go-select select[aria-invalid='true'] {
  border-color: #b00020;
}
go-select .go-select-error {
  color: #b00020;
}
```

## Nesting

Must be placed inside `<go-ticket-selection>` with `filters="tour"` and a `tour-id`.

## Subcomponents

None.

## What it shows

| The tour offers…           | The select                                                              |
| -------------------------- | ----------------------------------------------------------------------- |
| several entries            | a blank entry first, nothing picked                                     |
| one entry                  | that entry, picked already, without a blank entry                       |
| no entry                   | nothing renders                                                         |
| nothing: it failed to load | a disabled select and an error text (`.go-select-hint`, `role="alert"`) |

Without a `tour-id` on the selection nothing renders, and a console warning names the missing
`tour-id`.

### A pick is required

Every `<go-select>` on the page that offers entries needs a pick before the booking goes into the
cart. A click on `<go-add-to-cart-button>` with a blank select adds nothing: each blank select shows
its error (`.go-select-error`) and gets `aria-invalid="true"`, and the focus moves to the first
one. A select's error goes away as soon as the visitor picks an entry.

A choice you leave off the page is not asked for. The language is the exception: the backend
refuses a booking without one, so a tour with several languages can only be booked with a
`<go-select data="tour:language">` on the page. Without it no prices are asked for,
`<go-tour-prices>` says that the tour cannot be booked online, the button stays disabled and a
console warning names the missing select.

### The language narrows the booking

Once a language is picked, `<go-calendar>` only opens days the tour runs in that language,
`<go-tour-timeslots>` only lists start times in it, and `<go-tour-prices>` quotes the prices for
it (a foreign language can carry a surcharge). A picked start time the language does not offer is
dropped.

## Localization

| Key                            | Purpose                                      |
| ------------------------------ | -------------------------------------------- |
| `tour.select.blank`            | Text of the blank entry                      |
| `tour.select.failed`           | Error text when the tour could not be loaded |
| `tour.select.language.label`   | Label of `tour:language`                     |
| `tour.select.language.missing` | Error of a blank `tour:language`             |
| `tour.select.ageGroup.label`   | Label of `tour:age-group`                    |
| `tour.select.ageGroup.missing` | Error of a blank `tour:age-group`            |
| `tour.select.grade.label`      | Label of `tour:grade`                        |
| `tour.select.grade.missing`    | Error of a blank `tour:grade`                |

All keys ship English and German defaults; your shop's own translations override them. The three
labels also name the choices on the cart line and the order page.
