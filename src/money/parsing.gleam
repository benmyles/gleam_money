import gleam/float
import gleam/int
import gleam/string
import gleam/list
import money/currency

pub type ParseOpts {
  ParseOpts(separator: String, delimiter: String)
}

pub fn parse(
  input: String,
  currency: currency.Currency,
  parse_opts: ParseOpts,
) -> Result(Int, Nil) {
  let input =
    input
    |> string.trim()
    |> string.replace(each: " ", with: "")
    |> add_minor_units(currency, parse_opts)
    |> remove_separators(parse_opts)
    |> remove_currency_symbol(currency)

  try value = float.parse(input)
  Ok(float.round(value *. float.power(10.0, int.to_float(currency.minor_units))))
}

fn add_minor_units(
  input: String,
  currency: currency.Currency,
  parse_opts: ParseOpts,
) -> String {
  case string.contains(input, parse_opts.delimiter) {
    True -> input
    False ->
      string.join(
        [
          input,
          parse_opts.delimiter,
          string.join(
            list.range(0, currency.minor_units)
            |> list.map(fn(_) { "0" }),
            "",
          ),
        ],
        "",
      )
  }
}

fn remove_separators(input: String, parse_opts: ParseOpts) -> String {
  string.replace(input, each: parse_opts.separator, with: "")
}

fn remove_currency_symbol(input: String, currency: currency.Currency) -> String {
  case string.starts_with(input, currency.symbol) {
    True ->
      case string.split_once(input, on: currency.symbol) {
        Ok(tuple(_, tail)) -> tail
        _ -> input
      }
    False -> input
  }
}
