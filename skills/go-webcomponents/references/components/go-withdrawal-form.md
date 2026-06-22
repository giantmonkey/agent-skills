# `<go-withdrawal-form>`

Since `v3.3.0`

A standalone form that lets a customer request the cancellation (withdrawal) of an existing order. It collects the customer's name, email, and order number, with an optional note, validates the input, posts to the gomus withdrawal endpoint, and dispatches `go-success` once the request succeeds.

## Examples

Basic — the default field layout (first name, last name, email, order number, optional note, submit button):

```html
<go-withdrawal-form></go-withdrawal-form>
```

Custom layout — pass `custom` and provide your own markup. The component still owns submission, validation, and success/error dispatching; you only control the layout:

```html
<go-withdrawal-form custom>
  <go-field key="withdrawalFirstName" required></go-field>
  <go-field key="withdrawalLastName" required></go-field>
  <go-field key="email" required></go-field>
  <go-field key="orderNumber" required></go-field>
  <go-field key="withdrawalNote"></go-field>

  <go-success-feedback></go-success-feedback>
  <go-errors-feedback></go-errors-feedback>
  <go-submit>Submit</go-submit>
</go-withdrawal-form>
```

## Attributes

| Attribute | Type    | Default | Description                                                                                                                                 |
| --------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `custom`  | boolean | `false` | Opt out of the default field layout and provide your own children (see the custom-layout example). Submission and validation stay built-in. |

## Events

| Event        | Description                                                                  | `detail` | bubbles |
| ------------ | ---------------------------------------------------------------------------- | -------- | ------- |
| `go-success` | The withdrawal request returned a 2xx response (a `201` with an empty body). | none     | yes     |

Non-2xx responses do **not** fire `go-success` — field errors (or a generic fallback message) are surfaced through `<go-errors-feedback>` instead.

## Fields

Each field's `apiKey` is the property name used in the posted body and in `<go-if>` `formData` expressions (`data.formData?.<apiKey>`).

| Field key             | Required | API key      | Type     |
| --------------------- | -------- | ------------ | -------- |
| `withdrawalFirstName` | yes      | `first_name` | text     |
| `withdrawalLastName`  | yes      | `last_name`  | text     |
| `email`               | yes      | `email`      | email    |
| `orderNumber`         | yes      | `order_id`   | text     |
| `withdrawalNote`      | no       | `note`       | textarea |

## Styling

The form renders through the shared form subcomponents; style their hooks:

- `go-withdrawal-form` — root element
- `.go-field` / `.go-field.is-invalid` — each field, and its invalid state
- `.go-field-errors` — per-field validation messages
- `.go-form-feedback`, `.go-success-feedback`, `.go-error-feedback-api-errors` — feedback blocks

```css
.go-field.is-invalid {
  border-color: #c00;
}
```

## Nesting

Standalone — no required parent.

## Subcomponents

In custom mode you compose the form building blocks:

- `<go-field>`
- `<go-submit>`
- `<go-success-feedback>`
- `<go-errors-feedback>`

## Conditional rendering with `<go-if>`

Inside the form, `<go-if>` evaluates its `when` expression against a `data` object whose `formData` holds the filled field values, keyed by each field's `apiKey`. Gate fields on what the customer has entered — e.g. only ask for a note once an order number is given:

```html
<go-withdrawal-form custom>
  <go-field key="orderNumber" required></go-field>
  <go-if when="data.formData?.order_id">
    <go-field key="withdrawalNote"></go-field>
  </go-if>
  <go-submit>Submit</go-submit>
</go-withdrawal-form>
```

## Localization

| Key                                    | Description                                            |
| -------------------------------------- | ------------------------------------------------------ |
| `withdrawal.actions.submit`            | Submit button label                                    |
| `withdrawal.form.orderNumber`          | Order number field label                               |
| `withdrawal.form.note`                 | Note field label                                       |
| `withdrawal.form.errors.requestFailed` | Error message when no order with the given id is found |
| `user.registration.form.name`          | First name field label                                 |
| `user.registration.form.surname`       | Last name field label                                  |
| `user.registration.form.email`         | Email field label                                      |
