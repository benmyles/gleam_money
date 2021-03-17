import gleam/order
import gleam/int

// Most users will not directly create a Money, instead use the
// currency specific helpers in money/currency.
pub type Money(currency) {
  Money(value: Int, symbol: String)
}

// Compare the value of two Money.
pub fn compare(a: Money(currency), b: Money(currency)) -> order.Order {
  int.compare(a.value, b.value)
}

// Create a new Money of the same currency.
pub fn similar(old: Money(currency), new_value: Int) -> Money(currency) {
  Money(new_value, old.symbol)
}

// Add two Money of the same currency together.
pub fn add(a: Money(currency), b: Money(currency)) -> Money(currency) {
  a
  |> similar(a.value + b.value)
}

// Get the value of a Money.
pub fn value(m: Money(currency)) -> Int {
  m.value
}

// Get the currency symbol of a Money.
pub fn symbol(m: Money(currency)) -> String {
  m.symbol
}
