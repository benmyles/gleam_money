# money

Library for handling money in Gleam, loosely modelled after [Elixir Money](https://github.com/elixirmoney/money).

## Usage

**Not yet ready for use!**

```gleam
import money/currency_db
import money/money.{Money}
import money/money_error

pub fn example() {
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
```

## Quick start

```sh
# Run the eunit tests
rebar3 eunit

# Run the Erlang REPL
rebar3 shell
```

## Installation

If [available in Hex](https://rebar3.org/docs/configuration/dependencies/#declaring-dependencies)
this package can be installed by adding `money` to your `rebar.config` dependencies:

```erlang
{deps, [
    money
]}.
```
