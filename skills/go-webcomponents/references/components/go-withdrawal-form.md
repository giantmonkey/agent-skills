# Withdrawal Component

The `go-withdrawal-form` component lets a customer request the cancellation (withdrawal) of an existing order. The form collects the customer's name, email, and order number, with an optional note, and posts to the gomus withdrawal endpoint.

## Example

```html
<go-withdrawal-form></go-withdrawal-form>
```

## Custom Layout

Pass the `custom` attribute to opt out of the default field layout and provide your own children. The component still owns submission, validation, and success/error dispatching — you only control the markup.

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

## Events

| Event        | When                                                                 |
|--------------|----------------------------------------------------------------------|
| `go-success` | Backend returned a 2xx response. Bubbles + composed.                 |

Non-2xx responses do **not** fire `go-success` — field errors (or a generic fallback message) are surfaced through `<go-errors-feedback>` instead.

## Fields

| Key                  | Required | API key      | Type     |
|----------------------|----------|--------------|----------|
| `withdrawalFirstName`| yes      | `first_name` | text     |
| `withdrawalLastName` | yes      | `last_name`  | text     |
| `email`              | yes      | `email`      | email    |
| `orderNumber`        | yes      | `order_id`   | text     |
| `withdrawalNote`     | no       | `note`       | textarea |

## Localization

| Key                                       | Description                         |
|-------------------------------------------|-------------------------------------|
| `withdrawal.actions.submit`               | Submit button label                 |
| `withdrawal.form.orderNumber`             | Order number field label            |
| `withdrawal.form.note`                    | Note field label                    |
| `withdrawal.form.errors.requestFailed`    | Error message when no order with provided id is found |
| `user.registration.form.name`             | First name field label              |
| `user.registration.form.surname`          | Last name field label               |
