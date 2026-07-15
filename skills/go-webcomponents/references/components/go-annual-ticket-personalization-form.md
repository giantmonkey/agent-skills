# `<go-annual-ticket-personalization>`

Since `v1.10.0`

The annual-ticket personalization journey. `<go-annual-ticket-personalization>` lists the
annual tickets in an order and links each one to its personalization page;
`<go-annual-ticket-personalization-form>` collects the start date and the holder data for every
personalization on a ticket.

## Examples

List the annual tickets in an order (one block per ticket, with a “Personalize” link for tickets
that still need data):

```html
<go-annual-ticket-personalization token="YOUR_ORDER_TOKEN"></go-annual-ticket-personalization>
```

Personalization form. You supply **one** `<go-personalization-form>` template; the component
duplicates it once per personalization on the ticket (so a ticket with three holders renders three
copies of your block). The outer `startAt` field is the ticket’s valid-from date:

```html
<go-annual-ticket-personalization-form {token} {ticketSaleId}>
  <go-form form-id="ticketPersonalization" custom>
    <section class="form-section">
      <h3>Start date of the annual ticket</h3>
      <go-field key="startAt" required></go-field>
    </section>

    <go-personalization-form>
      <go-form form-id="personalization" custom>
        <section class="form-section">
          <h3>Personal Information</h3>
          <go-field key="firstName" required></go-field>
          <go-field key="lastName" required></go-field>
          <go-field key="dateOfBirth" required></go-field>
          <go-field key="email" required></go-field>
          <go-field key="confirmEmail" required></go-field>
        </section>

        <section class="form-section">
          <h3>Address</h3>
          <go-field key="addressee"></go-field>
          <go-field key="street" required></go-field>
          <go-field key="postcode" required></go-field>
          <go-field key="city" required></go-field>
          <go-field key="country" required></go-field>
          <go-field key="language" required></go-field>
        </section>
      </go-form>
    </go-personalization-form>

    <go-submit>Submit Personalizations</go-submit>
  </go-form>
</go-annual-ticket-personalization-form>
```

When the ticket requires a photo, add a file `<go-field key="photo" required>` inside
`<go-personalization-form>`. A photo is uploaded per personalization and the submit is blocked
until every required photo is present.

## Attributes

`<go-annual-ticket-personalization>`:

| Attribute | Type   | Default | Description                                        |
| --------- | ------ | ------- | -------------------------------------------------- |
| `token`   | string | —       | Order token whose annual tickets should be listed. |

`<go-annual-ticket-personalization-form>`:

| Attribute        | Type   | Default | Description                                           |
| ---------------- | ------ | ------- | ----------------------------------------------------- |
| `token`          | string | —       | Order token the personalization belongs to.           |
| `ticket-sale-id` | number | —       | ID of the ticket within the order being personalized. |

## Events

These components emit no custom events. The form submits when the nested `<go-submit>` button fires
its built-in submit (see the `<go-form>` component). On success it runs the
optional `forms.personalization.beforeSubmit(data)` hook, then navigates to the URL returned by
`urls.annualTicketPersonalizationFormSubmit()` (both set in your shop init options).

## Styling

`<go-annual-ticket-personalization>` renders one list per ticket:

- `.go-annual-ticket` — the `<ul>` for one ticket; carries `data-ticket-sale-id`
- `.go-annual-ticket-title` — the ticket title
- `.go-annual-ticket-personalization-count` — the “Personalization #n” count line
- the “Personalize” link only renders while a ticket still needs personalizing

`<go-annual-ticket-personalization-form>` adds no wrapper of its own — it composes `<go-form>`,
`<go-field>` and `<go-submit>` (style those via the forms component) and tags each cloned
`<go-personalization-form>` with `data-personalization-id`.

```css
.go-annual-ticket-title {
  font-weight: 600;
}
```

## Nesting

Both are standalone — no required parent. `<go-annual-ticket-personalization-form>` requires a
specific child structure instead: a `<go-form form-id="ticketPersonalization">` containing the
`startAt` field, exactly one `<go-personalization-form>` template, and a `<go-submit>`.

## Subcomponents

`<go-annual-ticket-personalization>` exposes none.

`<go-annual-ticket-personalization-form>` is composed from:

- `<go-personalization-form>` — your repeated-per-holder template (cloned by the form, not a
  registered element)
- `<go-form>`, `<go-field>`, `<go-submit>` — from the forms component

## Configuration

Set these in your shop init options to wire the journey together:

| Option                                       | Purpose                                                                  |
| -------------------------------------------- | ------------------------------------------------------------------------ |
| `urls.annualTicketPersonalizationForm`       | `(token, ticketSaleId) => url` — target of the list’s “Personalize” link |
| `urls.annualTicketPersonalizationFormSubmit` | `(token) => url` — where the form navigates after a successful submit    |
| `forms.personalization.beforeSubmit`         | `(data) => void` — optional hook run after a successful finalize         |

## Localization

| Key                                                   | Description                                     |
| ----------------------------------------------------- | ----------------------------------------------- |
| `ticket.annual.personalization.detail.title`          | “Personalization #n” count label (with count)   |
| `ticket.annual.personalization.list.personalize.add`  | “Personalize” link text in the list             |
| `ticket.annual.personalization.list.personalize.edit` | Link text once a ticket is already personalized |
| `ticket.annual.personalization.list.startAt`          | “Valid from `{{startAt}}`” line                 |
| `ticket.annual.personalization.error.title`           | Error heading shown when finalizing fails       |
| `ticket.annual.personalization.photo.missing`         | Error when a required photo is not provided     |
| `ticket.annual.personalization.photo.upload_failed`   | Error when a photo upload fails                 |
