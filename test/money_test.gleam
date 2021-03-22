import gleam/should
import gleam/order
import gleam/list
import money.{Money}
import money/currency
import money/currency_db
import money/money_error

pub fn example_test() {
  // Expensive operation -- keep the db around to reuse.
  let db = currency_db.default()

  // Currency must be in the db.
  assert Error(money_error.UnknownCurrency) = currency_db.get(db, "@!@")
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
  assert Error(money_error.CurrencyMismatch) = money.add(ten_usd, twenty_gbp)

  // Similarly, money of the same currency can be compared.
  assert Ok(order.Gt) = money.compare(ten_usd, five_usd)

  // ... but it is an error to try to compare different currencies.
  assert Error(money_error.CurrencyMismatch) =
    money.compare(ten_usd, twenty_gbp)

  True
}

pub fn new_test() {
  let db = currency_db.default()

  assert Ok(usd) = currency_db.get(db, "USD")
  assert Error(money_error.UnknownCurrency) = currency_db.get(db, "@!@")

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
  assert Error(money_error.CurrencyMismatch) = money.add(m1, m2)

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

  assert Error(money_error.CurrencyMismatch) =
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

  money.allocate(Money(usd, 5), [1])
  |> should.equal([Money(usd, 5)])
  money.allocate_to(Money(usd, 5), 1)
  |> should.equal([Money(usd, 5)])
  money.allocate_to(Money(usd, 5), 0)
  |> should.equal([])

  money.allocate(Money(usd, 5), [0])
  |> should.equal([Money(usd, 0)])
  money.allocate_to(Money(usd, 0), 0)
  |> should.equal([])

  money.allocate(Money(usd, 5), [3, 7])
  |> should.equal([Money(usd, 2), Money(usd, 3)])
  money.allocate_to(Money(usd, 5), 2)
  |> should.equal([Money(usd, 3), Money(usd, 2)])

  money.allocate(Money(usd, -5), [3, 7])
  |> should.equal([Money(usd, -2), Money(usd, -3)])
  money.allocate_to(Money(usd, -5), 2)
  |> should.equal([Money(usd, -3), Money(usd, -2)])

  money.allocate(Money(usd, 5), [-3, -7])
  |> should.equal([Money(usd, 2), Money(usd, 3)])
  money.allocate_to(Money(usd, 5), -2)
  |> should.equal([Money(usd, 3), Money(usd, 2)])

  money.allocate(Money(usd, 5), [-3, 7])
  |> should.equal([Money(usd, 2), Money(usd, 3)])

  money.allocate(Money(usd, -5), [3, 7, 0])
  |> should.equal([Money(usd, -2), Money(usd, -3), Money(usd, 0)])
  money.allocate_to(Money(usd, -5), 3)
  |> should.equal([Money(usd, -2), Money(usd, -2), Money(usd, -1)])

  money.allocate(Money(usd, 1), [1, 1])
  |> should.equal([Money(usd, 1), Money(usd, 0)])
  money.allocate_to(Money(usd, 1), 2)
  |> should.equal([Money(usd, 1), Money(usd, 0)])

  money.allocate(Money(usd, 0), [1, 1])
  |> should.equal([Money(usd, 0), Money(usd, 0)])
  money.allocate_to(Money(usd, 0), 2)
  |> should.equal([Money(usd, 0), Money(usd, 0)])

  money.allocate(Money(usd, 0), [0, 0])
  |> should.equal([Money(usd, 0), Money(usd, 0)])

  money.allocate(Money(usd, 10), [0, 1])
  |> should.equal([Money(usd, 0), Money(usd, 10)])
  money.allocate_to(Money(usd, 10), 2)
  |> should.equal([Money(usd, 5), Money(usd, 5)])

  money.allocate(Money(usd, 10), [1, 0])
  |> should.equal([Money(usd, 10), Money(usd, 0)])

  money.allocate(Money(usd, 10), [0, 0])
  |> should.equal([Money(usd, 0), Money(usd, 0)])

  money.allocate(Money(usd, 10), [0, 0, 0])
  |> should.equal([Money(usd, 0), Money(usd, 0), Money(usd, 0)])

  money.allocate(Money(usd, 100), [25, 25, 25, 25])
  |> should.equal([
    Money(usd, 25),
    Money(usd, 25),
    Money(usd, 25),
    Money(usd, 25),
  ])
  money.allocate_to(Money(usd, 100), 4)
  |> should.equal([
    Money(usd, 25),
    Money(usd, 25),
    Money(usd, 25),
    Money(usd, 25),
  ])

  money.allocate(Money(usd, 200), [1, 1])
  |> should.equal([Money(usd, 100), Money(usd, 100)])
  money.allocate_to(Money(usd, 200), 2)
  |> should.equal([Money(usd, 100), Money(usd, 100)])

  money.allocate(Money(usd, 201), [1, 1])
  |> should.equal([Money(usd, 101), Money(usd, 100)])
  money.allocate_to(Money(usd, 201), 2)
  |> should.equal([Money(usd, 101), Money(usd, 100)])

  money.allocate(Money(usd, 302), [1, 1, 1])
  |> should.equal([Money(usd, 101), Money(usd, 101), Money(usd, 100)])
  money.allocate_to(Money(usd, 302), 3)
  |> should.equal([Money(usd, 101), Money(usd, 101), Money(usd, 100)])

  money.allocate(Money(usd, 100), [1, 1, 1])
  |> should.equal([Money(usd, 34), Money(usd, 33), Money(usd, 33)])
  money.allocate_to(Money(usd, 100), 3)
  |> should.equal([Money(usd, 34), Money(usd, 33), Money(usd, 33)])
}
