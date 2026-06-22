# Annual Ticket Personalization

Use the personalization components to list purchased annual tickets, guide users to the form, and collect the required data.

## Annual Tickets list

Lists the Annual tickets inside of an order.

```html
<go-annual-ticket-personalization token="YOUR_ORDER_TOKEN"></go-annual-ticket-personalization>
```

## Annual Ticket Personalization Form

Form for a Annual Ticket Personalization. An annual ticket can have multiple personalizations

```html
<div class="component-container">
  <h2>Annual Ticket Personalization Form</h2>
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
</div>
```

## Localization

| Key                                                | Description                                      |
|----------------------------------------------------|--------------------------------------------------|
| `ticket.annual.personalization.detail.title`       | Label showing personalization count (with count) |
| `ticket.annual.personalization.list.personalize.add` | Link text to add personalizations              |
