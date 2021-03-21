// Error type with informative variants.
// This module exists primarily to avoid cyclic imports.
pub type MoneyError {
  CurrencyMismatch
  UnknownCurrency
}
