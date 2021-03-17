import money
import money/currency/symbols

pub opaque type USD {
  USD
}

pub fn usd(value: Int) -> money.Money(USD) {
  money.Money(value, symbols.usd)
}

pub opaque type GBP {
  GBP
}

pub fn gbp(value: Int) -> money.Money(GBP) {
  money.Money(value, symbols.gbp)
}
