# `<go-form>`

Since `v1.0.0`

`<go-form>` creates a form container that manages validation, submission, and state for all `<go-field>` children. It provides built-in validation handling and customizable submission behavior.

## Examples

A custom form — you register the definition and lay out the fields yourself:

```html
<script>
  go.config({
    forms: {
      contact: {
        fields: [
          { key: 'firstName', required: true },
          { key: 'lastName', required: true },
        ],
      },
    },
  })
</script>

<go-form form-id="contact" custom>
  <go-field key="firstName" required></go-field>
  <go-field key="lastName" required></go-field>
  <go-submit>Submit</go-submit>
</go-form>
```

A pre-registered self-submitting form, zero config:

```html
<go-form form-id="addressCreate"></go-form>
```

A custom layout with feedback elements:

```html
<go-form form-id="profileUpdate" custom>
  <go-field key="firstName"></go-field>
  <go-field key="lastName"></go-field>
  <go-errors-feedback></go-errors-feedback>
  <go-success-feedback></go-success-feedback>
  <go-submit>Save</go-submit>
</go-form>
```

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

## Attributes

| Attribute    | Type    | Default | Description                                                                                   | Since     |
| ------------ | ------- | ------- | --------------------------------------------------------------------------------------------- | --------- |
| `form-id`    | string  | —       | The registered form definition to render and wire                                             |           |
| `custom`     | boolean | `false` | Suppresses the auto-rendered fields, feedback, and submit — you lay out the children yourself |           |
| `api-action` | string  | —       | Overrides the definition's write action for this element (see self-submitting forms below)    | `v4.19.0` |
| `record-id`  | number  | —       | Record id for id-based write actions such as `addressUpdate`                                  | `v4.19.0` |

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

## Events

| Event                 | Description                                                                                                                                              | `detail` | bubbles | Since     |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- | --------- |
| `go-after-validation` | Fires on every submit attempt, right after validation runs — valid or not                                                                                | —        | yes     | `v1.21.0` |
| `go-submit`           | Fires when a submit passes validation, before any built-in API call                                                                                      | —        | yes     |           |
| `submit`              | Fires on the `<go-form>` element when a submit passes validation. Cancelable — `preventDefault()` suppresses the built-in call of a self-submitting form | —        | yes     |           |
| `go-success`          | Fires on the `<go-form>` element after a self-submitting form's call succeeds                                                                            | —        | yes     |           |

# `<go-field>`

`<go-field>` renders a single form control that is registered with the closest `<go-form>` ancestor. The element bootstraps itself from the registered field definitions (extend them via `go.config({ fields })`), so all configuration lives in one place while markup stays declarative.

## Field attributes

These attributes apply to `<go-field>`:

| Attribute     | Description                                                            | Type      |
| ------------- | ---------------------------------------------------------------------- | :-------- |
| `key`         | The field key to render — see the available field keys below           | `string`  |
| `required`    | Marks the field as required, overriding the field definition's default | `boolean` |
| `label-class` | Pass classes to the label inside of `go-field` _(Since `v1.12.0`)_     | `string`  |
| `input-class` | Pass classes to the input inside of `go-field` _(Since `v1.12.0`)_     | `string`  |

`<go-submit>` takes a `button-class` attribute _(Since `v1.12.0`)_ — its value is set as the `class` of the `<button type="submit">` it renders.

## Available field keys

The keys listed below ship with the default configuration. The `apiKey` column shows the payload property written to `formData`.

| key                   | apiKey                   | type          | notes                                                                                                                                                                                                                                    |
| --------------------- | ------------------------ | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `salutation`          | `customer_salutation_id` | `select`      | Options come from the shop's configured customer salutations.                                                                                                                                                                            |
| `firstName`           | `name`                   | `text`        | Uses `autocomplete="given-name"`.                                                                                                                                                                                                        |
| `lastName`            | `surname`                | `text`        | Uses `autocomplete="family-name"`.                                                                                                                                                                                                       |
| `email`               | `email`                  | `email`       | Includes a zod e-mail validator.                                                                                                                                                                                                         |
| `confirmEmail`        | `email_confirmation`     | `email`       | Validates e-mail format and non-empty.                                                                                                                                                                                                   |
| `password`            | `password`               | `password`    | Basic password field.                                                                                                                                                                                                                    |
| `newPassword`         | `password`               | `password`    | Variant with `min(6)` validator for new passwords.                                                                                                                                                                                       |
| `confirmPassword`     | `password_confirmation`  | `password`    | Requires at least 6 characters.                                                                                                                                                                                                          |
| `addressee`           | `addr_addressat`         | `text`        | General addressee line.                                                                                                                                                                                                                  |
| `street`              | `addr_street`            | `text`        | —                                                                                                                                                                                                                                        |
| `postcode`            | `addr_zip`               | `text`        | —                                                                                                                                                                                                                                        |
| `city`                | `addr_city`              | `text`        | —                                                                                                                                                                                                                                        |
| `country`             | `addr_country_id`        | `select`      | Options come from the shop's configured countries.                                                                                                                                                                                       |
| `addressType`         | `adress_type_id`         | `select`      | Static options for customer addresses: `0` customer address (the backend default when omitted), `1` invoice address, `2` delivery address.                                                                                               |
| `language`            | `language_id`            | `select`      | Options come from the shop's available locales.                                                                                                                                                                                          |
| `acceptTerms`         | `terms`                  | `checkbox`    | Typically required for agreements.                                                                                                                                                                                                       |
| `paymentMode`         | `payment_mode_id`        | `paymentMode` | Renders a radio group of payment modes from `shop.payment_modes`. Auto-selects (and hides the input) when only one mode is available. Icons are rendered from the CDN when provided; modes without an icon show their name as the label. |
| `startAt`             | `start_at`               | `date`        | Start date for annual-ticket personalization. Validates an ISO date (`YYYY-MM-DD`).                                                                                                                                                      |
| `dateOfBirth`         | `date_of_birth`          | `date`        | Birth date for annual-ticket personalization. Uses `autocomplete="bday"` and an ISO-date (`YYYY-MM-DD`) validator. _(Since `v4.8.0`)_                                                                                                    |
| `currentPassword`     | `current_password`       | `password`    | Current password for password changes. _(Since `v1.1.0`)_                                                                                                                                                                                |
| `tel`                 | `tel`                    | `tel`         | Phone number.                                                                                                                                                                                                                            |
| `customerAddressee`   | `adressat`               | `text`        | Addressee line for the customer-address forms (`addressCreate` / `addressUpdate`). _(Since `v4.19.0`)_                                                                                                                                   |
| `customerStreet`      | `street`                 | `text`        | Street for the customer-address forms. _(Since `v4.19.0`)_                                                                                                                                                                               |
| `customerZip`         | `zip`                    | `text`        | Postcode for the customer-address forms. _(Since `v4.19.0`)_                                                                                                                                                                             |
| `customerCity`        | `city`                   | `text`        | City for the customer-address forms. _(Since `v4.19.0`)_                                                                                                                                                                                 |
| `customerCountry`     | `country_id`             | `select`      | Country select for the customer-address forms. _(Since `v4.19.0`)_                                                                                                                                                                       |
| `token`               | `id`                     | `text`        | Coupon code input, used by `<go-coupon-redemption>`. _(Since `v1.35.0`)_                                                                                                                                                                 |
| `photo`               | `file`                   | `file`        | Photo upload for annual-ticket personalization. Uploaded separately — excluded from the submitted form data. _(Since `v1.57.0`)_                                                                                                         |
| `withdrawalFirstName` | `first_name`             | `text`        | First name for `<go-withdrawal-form>`. _(Since `v3.3.0`)_                                                                                                                                                                                |
| `withdrawalLastName`  | `last_name`              | `text`        | Last name for `<go-withdrawal-form>`. _(Since `v3.3.0`)_                                                                                                                                                                                 |
| `orderNumber`         | `order_id`               | `text`        | Order number for `<go-withdrawal-form>`. _(Since `v3.3.0`)_                                                                                                                                                                              |
| `withdrawalNote`      | `note`                   | `textarea`    | Free-text note for `<go-withdrawal-form>`. _(Since `v3.3.0`)_                                                                                                                                                                            |

## Field definition attributes

Register new fields via `go.config({ fields: { … } })` — an object keyed by the field key you reference from `<go-field key="…">`. Each entry supports:

- `key` (string, required): Identifier referenced by `<go-field key="...">`.
- `type` (`FieldType`, required): One of `input`, `text`, `email`, `password`, `search`, `tel`, `url`, `number`, `checkbox`, `select`, `radio`, `textarea`, `date`, `file`, `paymentMode`. `file` values are uploaded separately and excluded from the submitted form data. _(`file` since `v1.57.0`)_
- `label` (string, required): Human-readable label; sanitized before render.
- `apiKey` (string): Payload key exposed via `FormDetails.formData`.
- `placeholder` (string): Placeholder text.
- `description` (string): Helper text shown beneath the input.
- `autocomplete` (`FullAutoFill`): Native autocomplete hint.
- `options` (`() => { value: string | number; label: string }[]`): Required for `select` and `radio` types.
- `value` (`string | number | boolean`): Initial value; defaults to `''` or `false` for checkboxes.
- `required` (boolean): Default requirement; per-instance `<go-field required>` overrides it.
- `passwordToggle` (boolean): For `password`-type fields — renders a show/hide toggle button after the input. Off by default; see below. _(Since `v4.23.0`)_

Any additional attributes placed on `<go-field>` are forwarded to the rendered control, so you can add things like `data-test-id`, `min`, or `max`.

### Password visibility toggle

Since `v4.23.0`

Any `password`-type field (`password`, `newPassword`, `confirmPassword`, `currentPassword`) can opt into a show/hide toggle. Enable it per field — `go.config` merges into the built-in definition, so this is all you need:

```js
go.config({
  fields: {
    password: { passwordToggle: true },
  },
})
```

The toggle renders as an unstyled `<button type="button" class="go-password-toggle">` directly after the input. Clicking it switches the input between hidden and plain text; the entered value is kept. It follows the toggle-button pattern: the label stays `Show password` (the `forms.password.show` key) while `aria-pressed` reports whether the password is currently revealed, and `aria-controls` links the button to its input. Style it via `.go-password-toggle` — for example into an eye icon.

## Built-in form definitions

A form definition provisions the field set rendered by `<go-form form-id="...">` (register your own via `go.config({ forms })`). Some components register presets when they mount:

| form id         | fields (required marked with `*`)                                                                        | usage                                                         |
| --------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `checkoutGuest` | `firstName*`, `lastName*`, `email*`, `confirmEmail*`, `acceptTerms*`, `paymentMode*`                     | Default guest checkout (`<go-checkout-form>`).                |
| `signIn`        | `email*`, `password*`                                                                                    | `<go-sign-in>` web component.                                 |
| `signUp`        | `firstName*`, `lastName*`, `email*`, `confirmEmail*`, `newPassword*`, `confirmPassword*`, `acceptTerms*` | `<go-sign-up>` web component.                                 |
| `checkoutUser`  | `acceptTerms*`, `paymentMode*`                                                                           | Signed-in checkout (`<go-checkout-form>`). _(Since `v4.5.0`)_ |

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
| `dateOfBirth`     | `user.registration.form.dateOfBirth`                | —                                                            |

### General Messages

| Key                   | Purpose                                                                                                                                                                          |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `forms.errorSummary`  | Error summary message shown when form has validation errors. Accepts `{{count}}` parameter for number of errors. Default: `Failed to save because {{count}} fields are invalid.` |
| `common.choose`       | Default option text for select fields. Default: `Please choose`                                                                                                                  |
| `form.success`        | Fallback success message for self-submitting forms when neither the definition nor the API provides one. _(Since `v4.19.0`)_                                                     |
| `form.error`          | Generic error shown when a self-submitting call fails without a usable error body. _(Since `v4.19.0`)_                                                                           |
| `forms.password.show` | Label of the password show/hide toggle. Default: `Show password`. _(Since `v4.23.0`)_                                                                                         |

## Styling

- `go-form.is-submitting` — present while a self-submitting call is in flight
- `.go-field` — every `<go-field>`; `.go-field.is-invalid` when it has errors
- `.go-field-errors` — the error list rendered under an invalid field
- `.go-password-toggle` — the show/hide button on password fields that opt in via `passwordToggle`; `aria-pressed="true"` while the password is revealed _(Since `v4.23.0`)_
- `<go-errors-feedback>` gets `.go-feedback`, `.is-invalid` while errors exist, and a `data-num-errors` attribute with the current error count; API errors render in a `.go-error-feedback-api-errors` list
- `.go-form-feedback` — wrapper rendered by `<go-form-feedback>`
- `.go-success-feedback` — the success live region; `.is-successful` while a message is shown
- `<go-submit>` renders a native `<button type="submit">` (disabled while submitting); pass classes via `button-class`

```css
.go-field.is-invalid label {
  color: darkred;
}
```

## Nesting

`<go-form>` is standalone — no required parent. All other elements on this page must be placed inside a `<go-form>`.

## Subcomponents

- `<go-field>` — a single form control
- `<go-all-fields>` — renders every field of the form definition (what a non-`custom` form uses internally)
- `<go-form-feedback>` — wrapper for the feedback elements
- `<go-errors-feedback>` — live error summary and API errors
- `<go-success-feedback>` — live success message
- `<go-submit>` — the submit button
