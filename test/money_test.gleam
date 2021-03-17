import money
import money/currency
import money/currency/symbols
import gleam/should
import gleam/order

pub fn hello_world_test() {
  currency.usd(1000)
  // Money(USD).currency().symbol()
  // |> should.equal("USD")
}

pub fn add_test() {
  money.add(currency.usd(1000), currency.usd(1000))
  |> money.value
  |> should.equal(2000)
}

pub fn compare_test() {
  money.compare(currency.usd(1000), currency.usd(1000))
  |> should.equal(order.Eq)

  money.compare(currency.usd(1000), currency.usd(999))
  |> should.equal(order.Gt)

  money.compare(currency.usd(1000), currency.usd(1001))
  |> should.equal(order.Lt)
}

pub fn symbol_test() {
  currency.usd(1000)
  |> money.symbol
  |> should.equal(symbols.usd)

  currency.gbp(1000)
  |> money.symbol
  |> should.equal(symbols.gbp)

  currency.gbp(1000)
  |> money.symbol
  |> should.not_equal(symbols.usd)
}
// test "new/2 requires existing currency" do
//   assert_raise ArgumentError, fn ->
//     Money.new(123, :ABC)
//   end
// end
