// Type alias to represent currency code as a String.
pub type CurrencyCode =
  String

// Type to represent the details of a currency.
pub type Currency {
  Currency(
    code: CurrencyCode,
    symbol: String,
    numeric_code: Int,
    minor_units: Int,
    name: String,
  )
}
