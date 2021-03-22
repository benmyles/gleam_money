import gleam/order
import gleam/int
import gleam/list
import money/money_error.{
  CurrencyMismatch, EmptyAllocationRatios, InvalidAllocationRatios, MoneyError,
}
import money/currency
import money/currency_db

// Type to represent money (including currency and value).
pub type Money {
  Money(currency: currency.Currency, value: Int)
}

// Compare the value of two Money types.
pub fn compare(a: Money, b: Money) -> Result(order.Order, MoneyError) {
  case a.currency == b.currency {
    True -> Ok(int.compare(a.value, b.value))
    False -> Error(CurrencyMismatch)
  }
}

// Convenience function to create new Money with same currency.
pub fn similar(old: Money, new_value: Int) -> Money {
  Money(old.currency, new_value)
}

// Add two Money of the same currency together.
pub fn add(a: Money, b: Money) -> Result(Money, MoneyError) {
  case a.currency == b.currency {
    True -> Ok(similar(a, a.value + b.value))
    False -> Error(CurrencyMismatch)
  }
}

// Returns a new Money that is the absolute value of the one supplied.
pub fn absolute_value(m: Money) -> Money {
  Money(m.currency, int.absolute_value(m.value))
}

// Return a new Money with the value negated.
pub fn negate(m: Money) -> Money {
  Money(m.currency, int.negate(m.value))
}

// Simplified version of the allocate function that allocates the Money among
// the given number of groups.
pub fn allocate_to(
  money: Money,
  num_groups: Int,
) -> Result(List(Money), MoneyError) {
  try _ = case num_groups <= 0 {
    True -> Error(InvalidAllocationRatios)
    False -> Ok(False)
  }

  money
  |> allocate(
    list.range(0, num_groups)
    |> list.map(fn(_) { 1 }),
  )
}

// Allocate the given Money in the supplied ratios.
// This algorithm is from P of EAA:
// https://martinfowler.com/eaaCatalog/money.html
pub fn allocate(
  money: Money,
  ratios: List(Int),
) -> Result(List(Money), MoneyError) {
  try _ = case list.is_empty(ratios) {
    True -> Error(EmptyAllocationRatios)
    False -> Ok(False)
  }

  try _ = case list.any(ratios, fn(a) { a <= 0 }) {
    True -> Error(InvalidAllocationRatios)
    False -> Ok(False)
  }

  let total =
    list.fold(
      over: ratios,
      from: 0,
      with: fn(a, b) { int.absolute_value(a) + b },
    )

  let groups: List(Money) =
    list.map(
      ratios,
      with: fn(r) {
        similar(money, money.value * int.absolute_value(r) / total)
      },
    )

  let remainder =
    list.fold(
      over: groups,
      from: money.value,
      with: fn(a: Money, b: Int) { b - a.value },
    )

  let tuple(lhs, rhs) = list.split(groups, int.absolute_value(remainder))

  Ok(list.append(
    list.map(
      lhs,
      fn(a) {
        case remainder >= 0 {
          True -> similar(a, a.value + 1)
          False -> similar(a, a.value - 1)
        }
      },
    ),
    rhs,
  ))
}
