# Coupon Redemption Component

The `go-coupon-redemption` component allows users to redeem voucher coupons by entering a barcode/token. Valid vouchers automatically add the associated ticket to the shopping cart at zero cost.

## Example

```html
<go-coupon-redemption></go-coupon-redemption>
```

### Uppercasing
The coupon code is automatically stored as uppercased. This is to prevent case-sensitive issues.

## Localization

The `go-coupon-redemption` component uses the following translation keys for its interface and validation:

| Key                           | Default Description             |
|-------------------------------|---------------------------------|
| `cart.coupon.form.submit`     | Submit button text              |
| `cart.coupon.form.code`       | Label text                      |
| `cart.coupon.form.errors.notValid` | Error message when coupon is not valid |
| `cart.coupon.form.errors.error`    | Error message when something else fails |
