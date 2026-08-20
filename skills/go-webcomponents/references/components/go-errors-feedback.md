# `<go-form>`

`<go-form>` creates a form container that manages validation, submission, and state for all `<go-field>` children. It provides built-in validation handling and customizable submission behavior.

## Form Submission

The `<go-form>` element exposes an `onsubmit` property — assign a callback to it and it runs when the form is submitted and all validations pass.

```html
<go-form form-id="myForm">
  <go-field key="firstName" required></go-field>
  <go-submit>Submit</go-submit>
</go-form>

<script>
  document.querySelector('go-form').onsubmit = event => {
    console.log('Form submitted successfully!', event)
    // Handle your form submission logic here
  }
</script>
```

The `onsubmit` callback receives the form submission event as a parameter.

**Note:** The `onsubmit` callback is only called when the form is valid. If validation fails, the callback will not be invoked.

## Self-submitting forms (`apiAction`)

A form definition can carry a whitelisted write action. `go-form` then calls the endpoint
itself after client-side validation and renders the result — no JavaScript needed:

- success → `successMessage` appears in `<go-success-feedback>` and the host fires `go-success`
- error → `details.apiErrors` renders form-level errors (`<go-errors-feedback>`) or inline
  per-field errors, depending on the shape the endpoint returns
- while in flight the host has the `is-submitting` class and `<go-submit>` is disabled

These form ids ship pre-registered (overridable via `go.config({ forms })`):

| form-id                | endpoint                | notes                                               |
| ---------------------- | ----------------------- | --------------------------------------------------- |
| `addressCreate`        | `createCustomerAddress` | street/zip/city required                            |
| `addressUpdate`        | `updateCustomerAddress` | needs `record-id`; partial update, nothing required |
| `profileUpdate`        | `updateCustomer`        | all fields optional                                 |
| `passwordUpdate`       | `updatePassword`        | signed-in only                                      |
| `passwordResetRequest` | `requestPasswordReset`  | works signed-out                                    |

```html
<!-- zero config: default fields + feedback + submit -->
<go-form form-id="addressCreate"></go-form>

<!-- custom layout: you place the fields; the endpoint wiring is unchanged.
     Required fields you omit are caught by the API and shown as form-level errors. -->
<go-form form-id="addressCreate" custom>
  <go-field key="customerStreet" required></go-field>
  <go-field key="customerZip" required></go-field>
  <go-field key="customerCity" required></go-field>
  <go-errors-feedback></go-errors-feedback>
  <go-success-feedback></go-success-feedback>
  <go-submit>Save</go-submit>
</go-form>

<!-- id-based writes take the record id from the record-id attribute -->
<go-form form-id="addressUpdate" record-id="42"></go-form>
```

The `api-action` attribute overrides the definition's action for one element. To take over
submission yourself, listen for the (cancelable) `submit` event and call `preventDefault()`:

```js
document.querySelector('go-form').addEventListener('submit', async e => {
  e.preventDefault() // suppresses the built-in call
  const details = e.target.details
  const res = await go.api.createCustomerAddress(details.formData)
  if (res?.response?.ok) details.successMessage = 'Saved!'
  else details.apiErrors = res.error.errors
})
```

Known limitation: empty inputs are omitted from the payload, so an update form cannot
_clear_ a previously saved optional field — use the JS escape hatch for that.

# `<go-field>`

`<go-field>` renders a single form control that is registered with the closest `<go-form>` ancestor. The element bootstraps itself from the field definitions provided through `Forms.defineFields`, so all configuration lives in one place while markup stays declarative.

## Properties

This properties applies to `<go-field>`

| Property      | Description                                    | Type     |
| ------------- | ---------------------------------------------- | :------- |
| `label-class` | Pass classes to the label inside of `go-field` | `string` |
| `input-class` | Pass classes to the input inside of `go-field` | `string` |

## Available field keys

The keys listed below ship with the default configuration. The `apiKey` column shows the payload property written to `formData`.

| key               | apiKey                   | type          | notes                                                                                                                                                                                                                                    |
| ----------------- | ------------------------ | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `salutation`      | `customer_salutation_id` | `select`      | Options come from `/api/v3/customer_salutations` defined in gomus backend.                                                                                                                                                               |
| `firstName`       | `name`                   | `text`        | Uses `autocomplete="given-name"`.                                                                                                                                                                                                        |
| `lastName`        | `surname`                | `text`        | Uses `autocomplete="family-name"`.                                                                                                                                                                                                       |
| `email`           | `email`                  | `email`       | Includes a zod e-mail validator.                                                                                                                                                                                                         |
| `confirmEmail`    | `email_confirmation`     | `email`       | Validates e-mail format and non-empty.                                                                                                                                                                                                   |
| `password`        | `password`               | `password`    | Basic password field.                                                                                                                                                                                                                    |
| `newPassword`     | `password`               | `password`    | Variant with `min(6)` validator for new passwords.                                                                                                                                                                                       |
| `confirmPassword` | `password_confirmation`  | `password`    | Requires at least 6 characters.                                                                                                                                                                                                          |
| `addressee`       | `addr_addressat`         | `text`        | General addressee line.                                                                                                                                                                                                                  |
| `street`          | `addr_street`            | `text`        | —                                                                                                                                                                                                                                        |
| `postcode`        | `addr_zip`               | `text`        | —                                                                                                                                                                                                                                        |
| `city`            | `addr_city`              | `text`        | —                                                                                                                                                                                                                                        |
| `country`         | `addr_country_id`        | `select`      | Options come from `/api/v3/countries` defined in gomus backend.                                                                                                                                                                          |
| `addressType`     | `adress_type_id`         | `select`      | Static options for customer addresses: `0` customer address (the backend default when omitted), `1` invoice address, `2` delivery address.                                                                                              |
| `language`        | `language_id`            | `select`      | Options come from `/api/v4/locales` defined in gomus backend.                                                                                                                                                                            |
| `acceptTerms`     | `terms`                  | `checkbox`    | Typically required for agreements.                                                                                                                                                                                                       |
| `paymentMode`     | `payment_mode_id`        | `paymentMode` | Renders a radio group of payment modes from `shop.payment_modes`. Auto-selects (and hides the input) when only one mode is available. Icons are rendered from the CDN when provided; modes without an icon show their name as the label. |
| `startAt`         | —                        | `date`        | Client-only field; add an `apiKey` if you need to submit it.                                                                                                                                                                             |
| `dateOfBirth`     | `date_of_birth`          | `date`        | Birth date for annual-ticket personalization. Uses `autocomplete="bday"` and an ISO-date (`YYYY-MM-DD`) validator.                                                                                                                       |

## Field definition attributes

Use `window.go.defineFields` to register new fields. Each entry follows the `FieldInit` interface:

- `key` (string, required): Identifier referenced by `<go-field key="...">`.
- `type` (`FieldType`, required): One of `input`, `text`, `email`, `password`, `search`, `tel`, `url`, `number`, `checkbox`, `select`, `radio`, `textarea`, `date`, `paymentMode`.
- `label` (string, required): Human-readable label; sanitized before render.
- `apiKey` (string): Payload key exposed via `FormDetails.formData`.
- `placeholder` (string): Placeholder text.
- `description` (string): Helper text shown beneath the input.
- `autocomplete` (`FullAutoFill`): Native autocomplete hint.
- `options` (`() => { value: string | number; label: string }[]`): Required for `select` and `radio` types.
- `value` (`string | number | boolean`): Initial value; defaults to `''` or `false` for checkboxes.
- `required` (boolean): Default requirement; per-instance `<go-field required>` overrides it.

Any additional attributes placed on `<go-field>` are forwarded to the rendered control, so you can add things like `data-test-id`, `min`, or `max`.

## Built-in form definitions

`Forms.defineForm` provisions the field set rendered by `<go-form form-id="...">`. The components in this package register a few presets on mount:

| form id         | fields (required marked with `*`)                                                                        | usage                                          |
| --------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| `checkoutGuest` | `firstName*`, `lastName*`, `email*`, `confirmEmail*`, `acceptTerms*`, `paymentMode*`                     | Default guest checkout (`<go-checkout-form>`). |
| `signIn`        | `email*`, `password*`                                                                                    | `<go-sign-in>` web component.                  |
| `signUp`        | `firstName*`, `lastName*`, `email*`, `confirmEmail*`, `newPassword*`, `confirmPassword*`, `acceptTerms*` | `<go-sign-up>` web component.                  |

## Conditional fields with `<go-if>`

Inside a `<go-form>`, the `<go-if>` component evaluates its `when` expression against a `data` object that includes `formData`. The `formData` object uses each field's `apiKey` as the property name and contains only filled values.

- Access the current form values with `data.formData?.<apiKey>`.

```html
<go-form form-id="testIf" custom>
  <go-if when="data.formData?.language_id == 1"> German language selected </go-if>
</go-form>
```

Notes:

- The `when` expression is a string and can reference `data.formData` directly.
- `formData` properties are keyed by `apiKey` (e.g., `name`, `email`). Can also access `apiKey` from custom fields
- Value types follow the field type: `select`, `radio`, `number`, and `paymentMode` values are numbers (option ids), checkboxes are booleans, and text-like fields (`text`, `email`, `tel`, `textarea`, …) always stay strings — a postcode keeps its leading zero. Comparisons match types strictly, so write `data.formData?.language_id == 1` (select → number) but `data.formData?.addr_zip == '01067'` (text → string).
- The evaluator is CSP-safe (no `eval` / `new Function`), so `go-if` does not require `script-src 'unsafe-eval'`.
- `when` supports a safe expression subset. For more complex rules, define a function in your app (for example `window.isFormReady = data => ...`) and call it with `when="isFormReady(data)"`.

## Localization

The following table lists all available fields with their localization keys for labels and validation errors.

For required fields, `common.fieldErrors.required` will be used to display a required error message.

### Field Labels and Errors

| Field Key         | Label Key                                           | Error Keys                                                   |
| ----------------- | --------------------------------------------------- | ------------------------------------------------------------ |
| `salutation`      | `user.registration.form.customer_salutation_id`     | —                                                            |
| `firstName`       | `user.registration.form.name`                       | —                                                            |
| `lastName`        | `user.registration.form.surname`                    | —                                                            |
| `email`           | `user.registration.form.email`                      | `user.fieldErrors.emailValid`                                |
| `confirmEmail`    | `user.registration.form.confirmEmail`               | `user.fieldErrors.emailValid`, `user.fieldErrors.emailMatch` |
| `password`        | `user.registration.form.password`                   | —                                                            |
| `newPassword`     | `user.registration.form.password`                   | `user.fieldErrors.passwordTooShort`                          |
| `confirmPassword` | `user.registration.form.confirmPassword`            | `user.fieldErrors.passwordMatch`                             |
| `addressee`       | `user.registration.form.adressat`                   | —                                                            |
| `street`          | `user.registration.form.street`                     | —                                                            |
| `postcode`        | `user.registration.form.plz`                        | —                                                            |
| `city`            | `user.registration.form.city`                       | —                                                            |
| `country`         | `user.registration.form.country`                    | —                                                            |
| `language`        | `user.registration.form.language`                   | —                                                            |
| `acceptTerms`     | `user.registration.form.accept`                     | —                                                            |
| `paymentMode`     | `cart.paymentMode.label`                            | -                                                            |
| `startAt`         | `ticket.annual.personalization.list.startAt.update` | —                                                            |

### General Messages

| Key                  | Description                                                                                                                                                                      |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `forms.errorSummary` | Error summary message shown when form has validation errors. Accepts `{{count}}` parameter for number of errors. Default: `Failed to save because {{count}} fields are invalid.` |
| `common.choose`      | Default option text for select fields. Default: `Please choose`                                                                                                                  |
