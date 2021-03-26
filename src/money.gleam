import gleam/order
import gleam/int
import gleam/float
import gleam/list
import money/money_error.{
  CurrencyMismatch, EmptyAllocationRatios, EmptyList, InvalidAllocationRatios, InvalidNumAllocationRatios,
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
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
///    > assert Ok(gbp) = db |> currency_db.get("GBP")
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
  try _ = check_same_currency([a, b])
  Ok(int.compare(a.value, b.value))
}

/// Returns a new `Money` with the same currency.
///
/// ## Examples
///
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
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
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
///    > assert Ok(gbp) = db |> currency_db.get("GBP")
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
  sum([a, b])
}

/// Returns a new `Money` with value set to absolute value of input value.
///
/// ## Examples
///
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
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
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
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
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
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
  try _ = check_num_allocation_groups(num_groups)

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
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
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
  try _ = check_allocation_ratios(ratios)

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

/// Multiply a `Money` by an Int.
///
/// ## Examples
///
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
///    
///    > Money(usd, 10)
///    > |> money.multiply(2)
///    Ok([Money(usd, 20)])
///
pub fn multiply(money: Money, multiplier: Int) -> Money {
  money
  |> similar(money.value * multiplier)
}

/// Multiply a `Money` by a Float.
///
/// ## Examples
///
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
///    
///    > Money(usd, 10)
///    > |> money.multiply_float(1.550)
///    Ok([Money(usd, 16)])
///
pub fn multiply_float(money: Money, multiplier: Float) -> Money {
  let new_value =
    int.to_float(money.value) *. multiplier
    |> float.round()

  money
  |> similar(new_value)
}

/// Test if the `Money` value is negative.
///
/// ## Examples
///
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
///    
///    > Money(usd, 1)
///    > |> money.is_negative()
///    False
///
///    > Money(usd, 0)
///    > |> money.is_negative()
///    False
///
///    > Money(usd, -1)
///    > |> money.is_negative()
///    True
///
pub fn is_negative(money: Money) -> Bool {
  money.value < 0
}

/// Sums a list of Money elements.
///
/// ## Example
///
///    > let db = currency_db.default()
///    > assert Ok(usd) = db |> currency_db.get("USD")
///    
///    > sum([Money(usd, 1), Money(usd, 2), Money(usd, 3)])
///    Ok(Money(usd, 6))
///
///    > assert Ok(gbp) = db |> currency_db.get("GBP")
///
///    > sum([Money(usd, 1), Money(usd, 2), Money(gbp, 3)])
///    Error(CurrencyMismatch)
///
pub fn sum(monies: List(Money)) -> Result(Money, MoneyError) {
  try first = case monies {
    [money, .._] -> Ok(money)
    _ -> Error(EmptyList)
  }

  try _ = check_same_currency(monies)

  let total_value =
    list.fold(over: monies, from: 0, with: fn(a: Money, b: Int) { b + a.value })

  Ok(similar(first, total_value))
}

fn check_same_currency(monies: List(Money)) -> Result(Bool, MoneyError) {
  let num_currencies =
    list.map(monies, with: fn(m: Money) { m.currency })
    |> list.unique()
    |> list.length()
  case num_currencies == 1 {
    True -> Ok(True)
    False -> Error(CurrencyMismatch)
  }
}

fn check_num_allocation_groups(num_groups: Int) -> Result(Bool, MoneyError) {
  case num_groups > 0 {
    True -> Ok(True)
    False -> Error(InvalidNumAllocationRatios)
  }
}

fn check_allocation_ratios(ratios: List(Int)) -> Result(Bool, MoneyError) {
  try _ = case list.is_empty(ratios) {
    True -> Error(EmptyAllocationRatios)
    False -> Ok(True)
  }

  case list.any(ratios, fn(a) { a <= 0 }) {
    True -> Error(InvalidAllocationRatios)
    False -> Ok(True)
  }
}
