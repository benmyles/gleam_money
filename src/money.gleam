import gleam/order
import gleam/int
import gleam/list
import money/money_error.{
  CurrencyMismatch, EmptyAllocationRatios, InvalidAllocationRatios, InvalidNumAllocationRatios,
  MoneyError,
}
import money/currency
import money/currency_db

/// `Money` represents a monetary value in a specified currency.
/// The value is in the base unit (for example, cents when USD).
pub type Money {
  Money(currency: currency.Currency, value: Int)
}

/// Compares two `Money`, returning an order if possible.
///
/// ## Examples
///
///    > assert Ok(usd) = currency_db.default().get(db, "USD")
///    > assert Ok(gbp) = currency_db.default().get(db, "GBP")
///
///    > compare(Money(usd, 2), Money(usd, 3))
///    Ok(order.Lt)
///
///    > compare(Money(usd, 4), Money(usd, 3))
///    Ok(order.Gt)
///
///    > compare(Money(usd, 3), Money(usd, 3))
///    Ok(order.Eq)
///
///    > compare(Money(usd, 3), Money(gbp, 3))
///    Error(CurrencyMismatch)
///
pub fn compare(a: Money, b: Money) -> Result(order.Order, MoneyError) {
  try tuple(a, b) = check_same_currency(a, b)
  Ok(int.compare(a.value, b.value))
}

/// Returns a new `Money` with the same currency.
///
/// ## Examples
///
///    > assert Ok(usd) = currency_db.default().get(db, "USD")
///
///    > let m1 = Money(usd, 1000)
///    Money(currency: usd, value: 1000)
///
///    > similar(m1, 500)
///    Money(currency: usd, value: 500)
///
pub fn similar(old: Money, new_value: Int) -> Money {
  Money(old.currency, new_value)
}

/// Adds two `Money` together (if they are the same currency).
///
/// ## Examples
///
///    > assert Ok(usd) = currency_db.default().get(db, "USD")
///    > assert Ok(gbp) = currency_db.default().get(db, "GBP")
///
///    > let five_usd = Money(usd, 500)
///    Money(currency: usd, value: 500)
///
///    > let ten_usd = Money(usd, 500)
///    Money(currency: usd, value: 1000)
///
///    > add(five_usd, ten_usd)
///    Ok(Money(currency: usd, value: 1500))
///
///    > let five_gbp = Money(gbp, 500)
///    Money(currency: gbp, value: 500)
///
///    > add(five_gbp, five_usd)
///    Error(CurrencyMismatch)
///
pub fn add(a: Money, b: Money) -> Result(Money, MoneyError) {
  try tuple(a, b) = check_same_currency(a, b)
  Ok(similar(a, a.value + b.value))
}

/// Returns a new `Money` with value set to absolute value of input value.
///
/// ## Examples
///
///    > assert Ok(usd) = currency_db.default().get(db, "USD")
///    
///    > Money(usd, -1000)
///    > |> absolute_value()
///    Money(currency: usd, value: 1000)
///
pub fn absolute_value(m: Money) -> Money {
  Money(m.currency, int.absolute_value(m.value))
}

/// Returns a new `Money` with the value negated.
///
/// ## Examples
///
///    > assert Ok(usd) = currency_db.default().get(db, "USD")
///    
///    > Money(usd, 1000)
///    > |> negate()
///    Money(currency: usd, value: -1000)
///
///    > Money(usd, -1000)
///    > |> negate()
///    Money(currency: usd, value: 1000)
///
pub fn negate(m: Money) -> Money {
  Money(m.currency, int.negate(m.value))
}

/// Allocate money equally among the given number of groups.
///
/// ## Examples
///
///    > assert Ok(usd) = currency_db.default().get(db, "USD")
///    
///    > allocate_to(Money(usd, 5), 1)
///    Ok([Money(usd, 5)])
///
///    > allocate_to(Money(usd, 5), 2)
///    Ok([Money(usd, 3), Money(usd, 2)])
///
///    > allocate_to(Money(usd, -5), 2)
///    > Ok([Money(usd, -3), Money(usd, -2)])
///
///    > allocate_to(Money(usd, 5), 0)
///    Error(InvalidNumAllocationRatios)
///
///    > allocate_to(Money(usd, 5), -1)
///    Error(InvalidNumAllocationRatios)
///
pub fn allocate_to(
  money: Money,
  num_groups: Int,
) -> Result(List(Money), MoneyError) {
  try num_groups = check_num_allocation_groups(num_groups)

  money
  |> allocate(
    list.range(0, num_groups)
    |> list.map(fn(_) { 1 }),
  )
}

/// Allocate money among the given number of groups using ratios.
/// Algorithm from P of EAA: https://martinfowler.com/eaaCatalog/money.html.
///
/// ## Examples
///
///    > assert Ok(usd) = currency_db.default().get(db, "USD")
///    
///    > allocate(Money(usd, 5), [1])
///    Ok([Money(usd, 5)])
///
///    > allocate(Money(usd, 5), [3, 7])
///    Ok([Money(usd, 2), Money(usd, 3)])
///
///    > allocate(Money(usd, -5), [3, 7])
///    Ok([Money(usd, -2), Money(usd, -3)])
///
///    > allocate(Money(usd, 100), [25, 25, 25, 25])
///    Ok([Money(usd, 25), Money(usd, 25), Money(usd, 25), Money(usd, 25)])
///
///    > allocate(Money(usd, 5), [])
///    Error(EmptyAllocationRatios)
///
///    > allocate(Money(usd, 5), [0])
///    Error(InvalidAllocationRatios)
///
///    > allocate(Money(usd, 5), [-1])
///    Error(InvalidAllocationRatios)
///
pub fn allocate(
  money: Money,
  ratios: List(Int),
) -> Result(List(Money), MoneyError) {
  try ratios = check_allocation_ratios(ratios)

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

fn check_same_currency(
  a: Money,
  b: Money,
) -> Result(tuple(Money, Money), MoneyError) {
  case a.currency == b.currency {
    True -> Ok(tuple(a, b))
    False -> Error(CurrencyMismatch)
  }
}

fn check_num_allocation_groups(num_groups: Int) -> Result(Int, MoneyError) {
  case num_groups > 0 {
    True -> Ok(num_groups)
    False -> Error(InvalidNumAllocationRatios)
  }
}

fn check_allocation_ratios(ratios: List(Int)) -> Result(List(Int), MoneyError) {
  try ratios = case list.is_empty(ratios) {
    True -> Error(EmptyAllocationRatios)
    False -> Ok(ratios)
  }

  case list.any(ratios, fn(a) { a <= 0 }) {
    True -> Error(InvalidAllocationRatios)
    False -> Ok(ratios)
  }
}
