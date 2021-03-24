pub type CurrencyCode =
  String

/// `Currency` represents a currency and contains ISO 4217 information.
pub type Currency {
  Currency(
    code: CurrencyCode,
    symbol: String,
    numeric_code: Int,
    minor_units: Int,
    name: String,
  )
}
