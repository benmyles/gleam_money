import gleam/should
import gleam/order
import gleam/list
import gleam/map
import money.{Money}
import money/currency
import money/currency_db
import money/money_error.{
  CurrencyMismatch, EmptyAllocationRatios, InvalidAllocationRatios, InvalidNumAllocationRatios,
  UnknownCurrency,
}

pub fn example_test() {
  // Expensive operation -- keep the db around to reuse.
  let db = currency_db.default()

  // Currency must be in the db.
  assert Error(UnknownCurrency) = currency_db.get(db, "@!@")
  // Luckily, the default db comes with a full set of currencies.
  assert Ok(usd) = currency_db.get(db, "USD")
  assert Ok(gbp) = currency_db.get(db, "GBP")

  // Minting money is easy once you have a currency:
  let ten_usd = Money(usd, 10 * 100)
  // and there's a convenience function for minting more:
  let five_usd = money.similar(ten_usd, 5 * 100)

  // We can add currencies of the same type together.
  assert Ok(_fifteen_usd) = money.add(ten_usd, five_usd)

  // ... but we cannot add money of different currencies together.
  let twenty_gbp = Money(gbp, 20 * 100)
  assert Error(CurrencyMismatch) = money.add(ten_usd, twenty_gbp)

  // Similarly, money of the same currency can be compared.
  assert Ok(order.Gt) = money.compare(ten_usd, five_usd)

  // ... but it is an error to try to compare different currencies.
  assert Error(CurrencyMismatch) = money.compare(ten_usd, twenty_gbp)

  // Money can be allocated to groups using the algorithm in the P of EAA book
  // (see https://martinfowler.com/eaaCatalog/money.html).
  //
  // Allocate the money among two groups as close to equal as possible:
  assert Ok(groups) = money.allocate_to(Money(usd, 5), 2)
  groups
  |> should.equal([Money(usd, 3), Money(usd, 2)])

  // Allocate the money to two groups using the supplied ratios
  // (3/10 in group 1 and 7/10 in group 2):
  assert Ok(groups) = money.allocate(Money(usd, 5), [3, 7])
  groups
  |> should.equal([Money(usd, 2), Money(usd, 3)])

  True
}

pub fn new_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")
  assert Error(UnknownCurrency) = currency_db.get(db, "@!@")

  let m = Money(usd, 1000)
  m.value
  |> should.equal(1000)
}

pub fn add_matched_currency_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")

  let m1 = Money(usd, 1000)
  let m2 = Money(usd, 500)

  assert Ok(m3) = money.add(m1, m2)
  m3.value
  |> should.equal(1500)
}

pub fn add_mismatched_currency_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")
  assert Ok(gbp) = currency_db.get(db, "GBP")

  let m1 = Money(usd, 1000)
  let m2 = Money(gbp, 500)
  assert Error(CurrencyMismatch) = money.add(m1, m2)

  True
}

pub fn add_negative_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")

  let m1 = Money(usd, 1000)
  let m2 = Money(usd, -500)
  assert Ok(m3) = money.add(m1, m2)
  m3.value
  |> should.equal(500)

  let m1 = Money(usd, -1000)
  let m2 = Money(usd, -500)
  assert Ok(m3) = money.add(m1, m2)
  m3.value
  |> should.equal(-1500)
}

pub fn compare_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")
  assert Ok(gbp) = currency_db.get(db, "GBP")

  assert Error(CurrencyMismatch) =
    money.compare(Money(usd, 1000), Money(gbp, 1000))

  assert Ok(result) = money.compare(Money(usd, 1000), Money(usd, 1000))
  result
  |> should.equal(order.Eq)

  assert Ok(result) = money.compare(Money(usd, 1000), Money(usd, 999))
  result
  |> should.equal(order.Gt)

  assert Ok(result) = money.compare(Money(usd, 1000), Money(usd, 1001))
  result
  |> should.equal(order.Lt)
}

pub fn similar_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")

  let m1 = Money(usd, 1000)
  let m2 = money.similar(m1, 1500)
  tuple(m2.currency, m2.value)
  |> should.equal(tuple(usd, 1500))
}

pub fn absolute_value_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")

  Money(usd, 1000)
  |> money.absolute_value()
  |> should.equal(Money(usd, 1000))

  Money(usd, -1000)
  |> money.absolute_value()
  |> should.equal(Money(usd, 1000))

  Money(usd, 0)
  |> money.absolute_value()
  |> should.equal(Money(usd, 0))
}

pub fn negate_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")

  Money(usd, 1000)
  |> money.negate()
  |> should.equal(Money(usd, -1000))

  Money(usd, -1000)
  |> money.negate()
  |> should.equal(Money(usd, 1000))
}

pub fn allocate_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")

  assert Error(EmptyAllocationRatios) = money.allocate(Money(usd, 5), [])

  assert Error(InvalidAllocationRatios) = money.allocate(Money(usd, 5), [0])
  assert Error(InvalidAllocationRatios) = money.allocate(Money(usd, 5), [-1])
  assert Error(InvalidAllocationRatios) = money.allocate(Money(usd, 5), [1, -1])

  assert Error(InvalidNumAllocationRatios) = money.allocate_to(Money(usd, 5), 0)
  assert Error(InvalidNumAllocationRatios) =
    money.allocate_to(Money(usd, 5), -1)

  // Simple allocation to one group
  assert Ok(groups) = money.allocate(Money(usd, 5), [1])
  groups
  |> should.equal([Money(usd, 5)])
  assert Ok(groups) = money.allocate_to(Money(usd, 5), 1)
  groups
  |> should.equal([Money(usd, 5)])

  // Allocating 0 results in groups of 0
  assert Ok(groups) = money.allocate(Money(usd, 0), [1])
  groups
  |> should.equal([Money(usd, 0)])

  assert Ok(groups) = money.allocate(Money(usd, 0), [1, 1])
  groups
  |> should.equal([Money(usd, 0), Money(usd, 0)])

  assert Ok(groups) = money.allocate_to(Money(usd, 0), 1)
  groups
  |> should.equal([Money(usd, 0)])

  assert Ok(groups) = money.allocate_to(Money(usd, 0), 2)
  groups
  |> should.equal([Money(usd, 0), Money(usd, 0)])

  // Allocation with a remainder
  assert Ok(groups) = money.allocate(Money(usd, 5), [3, 7])
  groups
  |> should.equal([Money(usd, 2), Money(usd, 3)])

  assert Ok(groups) = money.allocate_to(Money(usd, 5), 2)
  groups
  |> should.equal([Money(usd, 3), Money(usd, 2)])

  // Allocation with negative money
  assert Ok(groups) = money.allocate(Money(usd, -5), [3, 7])
  groups
  |> should.equal([Money(usd, -2), Money(usd, -3)])

  assert Ok(groups) = money.allocate_to(Money(usd, -5), 2)
  groups
  |> should.equal([Money(usd, -3), Money(usd, -2)])

  // Allocation to more groups than is possible
  assert Ok(groups) = money.allocate(Money(usd, 1), [1, 1])
  groups
  |> should.equal([Money(usd, 1), Money(usd, 0)])

  assert Ok(groups) = money.allocate_to(Money(usd, 1), 2)
  groups
  |> should.equal([Money(usd, 1), Money(usd, 0)])

  // Allocation to a larger set of groups
  assert Ok(groups) = money.allocate(Money(usd, 100), [25, 25, 25, 25])
  groups
  |> should.equal([
    Money(usd, 25),
    Money(usd, 25),
    Money(usd, 25),
    Money(usd, 25),
  ])

  assert Ok(groups) = money.allocate_to(Money(usd, 100), 4)
  groups
  |> should.equal([
    Money(usd, 25),
    Money(usd, 25),
    Money(usd, 25),
    Money(usd, 25),
  ])
}

pub fn multiply_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")

  Money(usd, 10)
  |> money.multiply(2)
  |> should.equal(Money(usd, 20))

  Money(usd, 10)
  |> money.multiply(-2)
  |> should.equal(Money(usd, -20))

  Money(usd, -10)
  |> money.multiply(2)
  |> should.equal(Money(usd, -20))

  Money(usd, -10)
  |> money.multiply(-2)
  |> should.equal(Money(usd, 20))

  Money(usd, 0)
  |> money.multiply(2)
  |> should.equal(Money(usd, 0))

  Money(usd, 0)
  |> money.multiply(0)
  |> should.equal(Money(usd, 0))

  Money(usd, 10)
  |> money.multiply(0)
  |> should.equal(Money(usd, 0))
}

pub fn multiply_float_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")

  Money(usd, 10)
  |> money.multiply_float(2.0)
  |> should.equal(Money(usd, 20))

  Money(usd, 10)
  |> money.multiply_float(-2.0)
  |> should.equal(Money(usd, -20))

  Money(usd, -10)
  |> money.multiply_float(2.0)
  |> should.equal(Money(usd, -20))

  Money(usd, -10)
  |> money.multiply_float(-2.0)
  |> should.equal(Money(usd, 20))

  Money(usd, 0)
  |> money.multiply_float(2.0)
  |> should.equal(Money(usd, 0))

  Money(usd, 0)
  |> money.multiply_float(0.0)
  |> should.equal(Money(usd, 0))

  Money(usd, 10)
  |> money.multiply_float(0.0)
  |> should.equal(Money(usd, 0))

  Money(usd, 10)
  |> money.multiply_float(1.555436)
  |> should.equal(Money(usd, 16))

  Money(usd, 10)
  |> money.multiply_float(1.550)
  |> should.equal(Money(usd, 16))

  Money(usd, 10)
  |> money.multiply_float(1.549)
  |> should.equal(Money(usd, 15))
}
