import gleam/order
import gleam/int
import money/money_error
import money/currency
import money/currency_db

// Type to represent money (including currency and value).
pub type Money {
  Money(currency: currency.Currency, value: Int)
}

// Compare the value of two Money types.
pub fn compare(
  a: Money,
  b: Money,
) -> Result(order.Order, money_error.MoneyError) {
  case a.currency == b.currency {
    True -> Ok(int.compare(a.value, b.value))
    False -> Error(money_error.CurrencyMismatch)
  }
}

// Convenience function to create new Money with same currency.
pub fn similar(old: Money, new_value: Int) -> Money {
  Money(old.currency, new_value)
}

// Add two Money of the same currency together.
pub fn add(a: Money, b: Money) -> Result(Money, money_error.MoneyError) {
  case a.currency == b.currency {
    True -> Ok(similar(a, a.value + b.value))
    False -> Error(money_error.CurrencyMismatch)
  }
}
