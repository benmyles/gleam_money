import gleam/map
import money/currency.{Currency, CurrencyCode}
import money/money_error

// Type to hold details about currencies.
pub type CurrencyDb =
  map.Map(CurrencyCode, Currency)

// Create a CurrencyDb from a list of tuples.
pub fn from_list(data: List(tuple(CurrencyCode, Currency))) -> CurrencyDb {
  map.from_list(data)
}

// Find the Currency for a given code.
pub fn get(
  from: CurrencyDb,
  code: CurrencyCode,
) -> Result(Currency, money_error.MoneyError) {
  case map.get(from, code) {
    Ok(c) -> Ok(c)
    Error(Nil) -> Error(money_error.UnknownCurrency)
  }
}

pub fn default() -> CurrencyDb {
  from_list([
    tuple(
      "AED",
      Currency(
        code: "AED",
        symbol: "د.إ",
        numeric_code: 784,
        minor_units: 2,
        name: "UAE Dirham",
      ),
    ),
    tuple(
      "AFN",
      Currency(
        code: "AFN",
        symbol: "؋",
        numeric_code: 971,
        minor_units: 2,
        name: "Afghani",
      ),
    ),
    tuple(
      "ALL",
      Currency(
        code: "ALL",
        symbol: "Lek",
        numeric_code: 8,
        minor_units: 2,
        name: "Lek",
      ),
    ),
    tuple(
      "AMD",
      Currency(
        code: "AMD",
        symbol: "AMD",
        numeric_code: 51,
        minor_units: 2,
        name: "Armenian Dram",
      ),
    ),
    tuple(
      "ANG",
      Currency(
        code: "ANG",
        symbol: "ƒ",
        numeric_code: 532,
        minor_units: 2,
        name: "Netherlands Antillian Guilder",
      ),
    ),
    tuple(
      "AOA",
      Currency(
        code: "AOA",
        symbol: "Kz",
        numeric_code: 973,
        minor_units: 2,
        name: "Kwanza",
      ),
    ),
    tuple(
      "ARS",
      Currency(
        code: "ARS",
        symbol: "$",
        numeric_code: 32,
        minor_units: 2,
        name: "Argentine Peso",
      ),
    ),
    tuple(
      "AUD",
      Currency(
        code: "AUD",
        symbol: "$",
        numeric_code: 36,
        minor_units: 2,
        name: "Australian Dollar",
      ),
    ),
    tuple(
      "AWG",
      Currency(
        code: "AWG",
        symbol: "ƒ",
        numeric_code: 533,
        minor_units: 2,
        name: "Aruban Guilder",
      ),
    ),
    tuple(
      "AZN",
      Currency(
        code: "AZN",
        symbol: "ман",
        numeric_code: 944,
        minor_units: 2,
        name: "Azerbaijanian Manat",
      ),
    ),
    tuple(
      "BAM",
      Currency(
        code: "BAM",
        symbol: "KM",
        numeric_code: 977,
        minor_units: 2,
        name: "Convertible Marks",
      ),
    ),
    tuple(
      "BBD",
      Currency(
        code: "BBD",
        symbol: "$",
        numeric_code: 52,
        minor_units: 2,
        name: "Barbados Dollar",
      ),
    ),
    tuple(
      "BDT",
      Currency(
        code: "BDT",
        symbol: "৳",
        numeric_code: 50,
        minor_units: 2,
        name: "Taka",
      ),
    ),
    tuple(
      "BGN",
      Currency(
        code: "BGN",
        symbol: "лв",
        numeric_code: 975,
        minor_units: 2,
        name: "Bulgarian Lev",
      ),
    ),
    tuple(
      "BHD",
      Currency(
        code: "BHD",
        symbol: ".د.ب",
        numeric_code: 48,
        minor_units: 3,
        name: "Bahraini Dinar",
      ),
    ),
    tuple(
      "BIF",
      Currency(
        code: "BIF",
        symbol: "FBu",
        numeric_code: 108,
        minor_units: 0,
        name: "Burundi Franc",
      ),
    ),
    tuple(
      "BMD",
      Currency(
        code: "BMD",
        symbol: "$",
        numeric_code: 60,
        minor_units: 2,
        name: "Bermudian Dollar (customarily known as Bermuda Dollar)",
      ),
    ),
    tuple(
      "BND",
      Currency(
        code: "BND",
        symbol: "$",
        numeric_code: 96,
        minor_units: 2,
        name: "Brunei Dollar",
      ),
    ),
    tuple(
      "BOB",
      Currency(
        code: "BOB",
        symbol: "$b",
        numeric_code: 68,
        minor_units: 2,
        name: "Boliviano Mvdol",
      ),
    ),
    tuple(
      "BOV",
      Currency(
        code: "BOV",
        symbol: "$b",
        numeric_code: 984,
        minor_units: 2,
        name: "Boliviano Mvdol",
      ),
    ),
    tuple(
      "BRL",
      Currency(
        code: "BRL",
        symbol: "R$",
        numeric_code: 986,
        minor_units: 2,
        name: "Brazilian Real",
      ),
    ),
    tuple(
      "BSD",
      Currency(
        code: "BSD",
        symbol: "$",
        numeric_code: 44,
        minor_units: 2,
        name: "Bahamian Dollar",
      ),
    ),
    tuple(
      "BTN",
      Currency(
        code: "BTN",
        symbol: "Nu.",
        numeric_code: 64,
        minor_units: 2,
        name: "Indian Rupee Ngultrum",
      ),
    ),
    tuple(
      "BWP",
      Currency(
        code: "BWP",
        symbol: "P",
        numeric_code: 72,
        minor_units: 2,
        name: "Pula",
      ),
    ),
    tuple(
      "BYN",
      Currency(
        code: "BYN",
        symbol: "p.",
        numeric_code: 933,
        minor_units: 2,
        name: "Belarusian Ruble",
      ),
    ),
    tuple(
      "BYR",
      Currency(
        code: "BYR",
        symbol: "p.",
        numeric_code: 933,
        minor_units: 0,
        name: "Belarusian Ruble",
      ),
    ),
    tuple(
      "BZD",
      Currency(
        code: "BZD",
        symbol: "BZ$",
        numeric_code: 84,
        minor_units: 2,
        name: "Belize Dollar",
      ),
    ),
    tuple(
      "CAD",
      Currency(
        code: "CAD",
        symbol: "$",
        numeric_code: 124,
        minor_units: 2,
        name: "Canadian Dollar",
      ),
    ),
    tuple(
      "CDF",
      Currency(
        code: "CDF",
        symbol: "CF",
        numeric_code: 976,
        minor_units: 2,
        name: "Congolese Franc",
      ),
    ),
    tuple(
      "CHF",
      Currency(
        code: "CHF",
        symbol: "CHF",
        numeric_code: 756,
        minor_units: 2,
        name: "Swiss Franc",
      ),
    ),
    tuple(
      "CLF",
      Currency(
        code: "CLF",
        symbol: "$",
        numeric_code: 990,
        minor_units: 4,
        name: "Chilean Peso Unidades de fomento",
      ),
    ),
    tuple(
      "CLP",
      Currency(
        code: "CLP",
        symbol: "$",
        numeric_code: 152,
        minor_units: 0,
        name: "Chilean Peso Unidades de fomento",
      ),
    ),
    tuple(
      "CNY",
      Currency(
        code: "CNY",
        symbol: "¥",
        numeric_code: 156,
        minor_units: 2,
        name: "Yuan Renminbi",
      ),
    ),
    tuple(
      "COP",
      Currency(
        code: "COP",
        symbol: "$",
        numeric_code: 170,
        minor_units: 2,
        name: "Colombian Peso",
      ),
    ),
    tuple(
      "COU",
      Currency(
        code: "COU",
        symbol: "$",
        numeric_code: 970,
        minor_units: 2,
        name: "Colombian Peso Unidad de Valor Real",
      ),
    ),
    tuple(
      "CRC",
      Currency(
        code: "CRC",
        symbol: "₡",
        numeric_code: 188,
        minor_units: 2,
        name: "Costa Rican Colon",
      ),
    ),
    tuple(
      "CUC",
      Currency(
        code: "CUC",
        symbol: "₱",
        numeric_code: 931,
        minor_units: 2,
        name: "Cuban Peso Peso Convertible",
      ),
    ),
    tuple(
      "CUP",
      Currency(
        code: "CUP",
        symbol: "₱",
        numeric_code: 192,
        minor_units: 2,
        name: "Cuban Peso Peso Convertible",
      ),
    ),
    tuple(
      "CVE",
      Currency(
        code: "CVE",
        symbol: "$",
        numeric_code: 132,
        minor_units: 0,
        name: "Cape Verde Escudo",
      ),
    ),
    tuple(
      "CZK",
      Currency(
        code: "CZK",
        symbol: "Kč",
        numeric_code: 203,
        minor_units: 2,
        name: "Czech Koruna",
      ),
    ),
    tuple(
      "DJF",
      Currency(
        code: "DJF",
        symbol: "Fdj",
        numeric_code: 262,
        minor_units: 0,
        name: "Djibouti Franc",
      ),
    ),
    tuple(
      "DKK",
      Currency(
        code: "DKK",
        symbol: "kr.",
        numeric_code: 208,
        minor_units: 2,
        name: "Danish Krone",
      ),
    ),
    tuple(
      "DOP",
      Currency(
        code: "DOP",
        symbol: "RD$",
        numeric_code: 214,
        minor_units: 2,
        name: "Dominican Peso",
      ),
    ),
    tuple(
      "DZD",
      Currency(
        code: "DZD",
        symbol: "دج",
        numeric_code: 12,
        minor_units: 2,
        name: "Algerian Dinar",
      ),
    ),
    tuple(
      "EEK",
      Currency(
        code: "EEK",
        symbol: "KR",
        numeric_code: 233,
        minor_units: 2,
        name: "Kroon",
      ),
    ),
    tuple(
      "EGP",
      Currency(
        code: "EGP",
        symbol: "£",
        numeric_code: 818,
        minor_units: 2,
        name: "Egyptian Pound",
      ),
    ),
    tuple(
      "ERN",
      Currency(
        code: "ERN",
        symbol: "Nfk",
        numeric_code: 232,
        minor_units: 2,
        name: "Nakfa",
      ),
    ),
    tuple(
      "ETB",
      Currency(
        code: "ETB",
        symbol: "Br",
        numeric_code: 230,
        minor_units: 2,
        name: "Ethiopian Birr",
      ),
    ),
    tuple(
      "EUR",
      Currency(
        code: "EUR",
        symbol: "€",
        numeric_code: 978,
        minor_units: 2,
        name: "Euro",
      ),
    ),
    tuple(
      "FJD",
      Currency(
        code: "FJD",
        symbol: "$",
        numeric_code: 242,
        minor_units: 2,
        name: "Fiji Dollar",
      ),
    ),
    tuple(
      "FKP",
      Currency(
        code: "FKP",
        symbol: "£",
        numeric_code: 238,
        minor_units: 2,
        name: "Falkland Islands Pound",
      ),
    ),
    tuple(
      "GBP",
      Currency(
        code: "GBP",
        symbol: "£",
        numeric_code: 826,
        minor_units: 2,
        name: "Pound Sterling",
      ),
    ),
    tuple(
      "GEL",
      Currency(
        code: "GEL",
        symbol: "₾",
        numeric_code: 981,
        minor_units: 2,
        name: "Lari",
      ),
    ),
    tuple(
      "GHS",
      Currency(
        code: "GHS",
        symbol: "GH₵",
        numeric_code: 936,
        minor_units: 2,
        name: "Cedi",
      ),
    ),
    tuple(
      "GIP",
      Currency(
        code: "GIP",
        symbol: "£",
        numeric_code: 292,
        minor_units: 2,
        name: "Gibraltar Pound",
      ),
    ),
    tuple(
      "GMD",
      Currency(
        code: "GMD",
        symbol: "D",
        numeric_code: 270,
        minor_units: 2,
        name: "Dalasi",
      ),
    ),
    tuple(
      "GNF",
      Currency(
        code: "GNF",
        symbol: "FG",
        numeric_code: 324,
        minor_units: 0,
        name: "Guinea Franc",
      ),
    ),
    tuple(
      "GTQ",
      Currency(
        code: "GTQ",
        symbol: "Q",
        numeric_code: 320,
        minor_units: 2,
        name: "Quetzal",
      ),
    ),
    tuple(
      "GYD",
      Currency(
        code: "GYD",
        symbol: "$",
        numeric_code: 328,
        minor_units: 2,
        name: "Guyana Dollar",
      ),
    ),
    tuple(
      "HKD",
      Currency(
        code: "HKD",
        symbol: "$",
        numeric_code: 344,
        minor_units: 2,
        name: "Hong Kong Dollar",
      ),
    ),
    tuple(
      "HNL",
      Currency(
        code: "HNL",
        symbol: "L",
        numeric_code: 340,
        minor_units: 2,
        name: "Lempira",
      ),
    ),
    tuple(
      "HRK",
      Currency(
        code: "HRK",
        symbol: "kn",
        numeric_code: 191,
        minor_units: 2,
        name: "Croatian Kuna",
      ),
    ),
    tuple(
      "HTG",
      Currency(
        code: "HTG",
        symbol: " ",
        numeric_code: 332,
        minor_units: 2,
        name: "Gourde US Dollar",
      ),
    ),
    tuple(
      "HUF",
      Currency(
        code: "HUF",
        symbol: "Ft",
        numeric_code: 348,
        minor_units: 2,
        name: "Forint",
      ),
    ),
    tuple(
      "IDR",
      Currency(
        code: "IDR",
        symbol: "Rp",
        numeric_code: 360,
        minor_units: 2,
        name: "Rupiah",
      ),
    ),
    tuple(
      "ILS",
      Currency(
        code: "ILS",
        symbol: "₪",
        numeric_code: 376,
        minor_units: 2,
        name: "New Israeli Sheqel",
      ),
    ),
    tuple(
      "INR",
      Currency(
        code: "INR",
        symbol: "₹",
        numeric_code: 356,
        minor_units: 2,
        name: "Indian Rupee",
      ),
    ),
    tuple(
      "IQD",
      Currency(
        code: "IQD",
        symbol: "‎ع.د",
        numeric_code: 368,
        minor_units: 3,
        name: "Iraqi Dinar",
      ),
    ),
    tuple(
      "IRR",
      Currency(
        code: "IRR",
        symbol: "﷼",
        numeric_code: 364,
        minor_units: 2,
        name: "Iranian Rial",
      ),
    ),
    tuple(
      "ISK",
      Currency(
        code: "ISK",
        symbol: "kr",
        numeric_code: 352,
        minor_units: 0,
        name: "Iceland Krona",
      ),
    ),
    tuple(
      "JMD",
      Currency(
        code: "JMD",
        symbol: "J$",
        numeric_code: 388,
        minor_units: 2,
        name: "Jamaican Dollar",
      ),
    ),
    tuple(
      "JOD",
      Currency(
        code: "JOD",
        symbol: "JOD",
        numeric_code: 400,
        minor_units: 3,
        name: "Jordanian Dinar",
      ),
    ),
    tuple(
      "JPY",
      Currency(
        code: "JPY",
        symbol: "¥",
        numeric_code: 392,
        minor_units: 0,
        name: "Yen",
      ),
    ),
    tuple(
      "KES",
      Currency(
        code: "KES",
        symbol: "KSh",
        numeric_code: 404,
        minor_units: 2,
        name: "Kenyan Shilling",
      ),
    ),
    tuple(
      "KGS",
      Currency(
        code: "KGS",
        symbol: "лв",
        numeric_code: 417,
        minor_units: 2,
        name: "Som",
      ),
    ),
    tuple(
      "KHR",
      Currency(
        code: "KHR",
        symbol: "៛",
        numeric_code: 116,
        minor_units: 2,
        name: "Riel",
      ),
    ),
    tuple(
      "KMF",
      Currency(
        code: "KMF",
        symbol: "CF",
        numeric_code: 174,
        minor_units: 0,
        name: "Comoro Franc",
      ),
    ),
    tuple(
      "KPW",
      Currency(
        code: "KPW",
        symbol: "₩",
        numeric_code: 408,
        minor_units: 2,
        name: "North Korean Won",
      ),
    ),
    tuple(
      "KRW",
      Currency(
        code: "KRW",
        symbol: "₩",
        numeric_code: 410,
        minor_units: 0,
        name: "Won",
      ),
    ),
    tuple(
      "KWD",
      Currency(
        code: "KWD",
        symbol: "د.ك",
        numeric_code: 414,
        minor_units: 3,
        name: "Kuwaiti Dinar",
      ),
    ),
    tuple(
      "KYD",
      Currency(
        code: "KYD",
        symbol: "$",
        numeric_code: 136,
        minor_units: 2,
        name: "Cayman Islands Dollar",
      ),
    ),
    tuple(
      "KZT",
      Currency(
        code: "KZT",
        symbol: "лв",
        numeric_code: 398,
        minor_units: 2,
        name: "Tenge",
      ),
    ),
    tuple(
      "LAK",
      Currency(
        code: "LAK",
        symbol: "₭",
        numeric_code: 418,
        minor_units: 2,
        name: "Kip",
      ),
    ),
    tuple(
      "LBP",
      Currency(
        code: "LBP",
        symbol: "£",
        numeric_code: 422,
        minor_units: 2,
        name: "Lebanese Pound",
      ),
    ),
    tuple(
      "LKR",
      Currency(
        code: "LKR",
        symbol: "₨",
        numeric_code: 144,
        minor_units: 2,
        name: "Sri Lanka Rupee",
      ),
    ),
    tuple(
      "LRD",
      Currency(
        code: "LRD",
        symbol: "$",
        numeric_code: 430,
        minor_units: 2,
        name: "Liberian Dollar",
      ),
    ),
    tuple(
      "LSL",
      Currency(
        code: "LSL",
        symbol: " ",
        numeric_code: 426,
        minor_units: 2,
        name: "Rand Loti",
      ),
    ),
    tuple(
      "LTL",
      Currency(
        code: "LTL",
        symbol: "Lt",
        numeric_code: 440,
        minor_units: 2,
        name: "Lithuanian Litas",
      ),
    ),
    tuple(
      "LVL",
      Currency(
        code: "LVL",
        symbol: "Ls",
        numeric_code: 428,
        minor_units: 2,
        name: "Latvian Lats",
      ),
    ),
    tuple(
      "LYD",
      Currency(
        code: "LYD",
        symbol: "ل.د",
        numeric_code: 434,
        minor_units: 3,
        name: "Libyan Dinar",
      ),
    ),
    tuple(
      "MAD",
      Currency(
        code: "MAD",
        symbol: "د.م.",
        numeric_code: 504,
        minor_units: 2,
        name: "Moroccan Dirham",
      ),
    ),
    tuple(
      "MDL",
      Currency(
        code: "MDL",
        symbol: "MDL",
        numeric_code: 498,
        minor_units: 2,
        name: "Moldovan Leu",
      ),
    ),
    tuple(
      "MGA",
      Currency(
        code: "MGA",
        symbol: "Ar",
        numeric_code: 969,
        minor_units: 2,
        name: "Malagasy Ariary",
      ),
    ),
    tuple(
      "MKD",
      Currency(
        code: "MKD",
        symbol: "ден",
        numeric_code: 807,
        minor_units: 2,
        name: "Denar",
      ),
    ),
    tuple(
      "MMK",
      Currency(
        code: "MMK",
        symbol: "K",
        numeric_code: 104,
        minor_units: 2,
        name: "Kyat",
      ),
    ),
    tuple(
      "MNT",
      Currency(
        code: "MNT",
        symbol: "₮",
        numeric_code: 496,
        minor_units: 2,
        name: "Tugrik",
      ),
    ),
    tuple(
      "MOP",
      Currency(
        code: "MOP",
        symbol: "MOP$",
        numeric_code: 446,
        minor_units: 2,
        name: "Pataca",
      ),
    ),
    tuple(
      "MRO",
      Currency(
        code: "MRO",
        symbol: "UM",
        numeric_code: 478,
        minor_units: 2,
        name: "Ouguiya",
      ),
    ),
    tuple(
      "MRU",
      Currency(
        code: "MRU",
        symbol: "UM",
        numeric_code: 929,
        minor_units: 2,
        name: "Ouguiya",
      ),
    ),
    tuple(
      "MUR",
      Currency(
        code: "MUR",
        symbol: "₨",
        numeric_code: 480,
        minor_units: 2,
        name: "Mauritius Rupee",
      ),
    ),
    tuple(
      "MVR",
      Currency(
        code: "MVR",
        symbol: "Rf",
        numeric_code: 462,
        minor_units: 2,
        name: "Rufiyaa",
      ),
    ),
    tuple(
      "MWK",
      Currency(
        code: "MWK",
        symbol: "MK",
        numeric_code: 454,
        minor_units: 2,
        name: "Kwacha",
      ),
    ),
    tuple(
      "MXN",
      Currency(
        code: "MXN",
        symbol: "$",
        numeric_code: 484,
        minor_units: 2,
        name: "Mexican Peso",
      ),
    ),
    tuple(
      "MXV",
      Currency(
        code: "MXV",
        symbol: "UDI",
        numeric_code: 979,
        minor_units: 2,
        name: "Mexican Peso Mexican Unidad de Inversion (UDI)",
      ),
    ),
    tuple(
      "MYR",
      Currency(
        code: "MYR",
        symbol: "RM",
        numeric_code: 458,
        minor_units: 2,
        name: "Malaysian Ringgit",
      ),
    ),
    tuple(
      "MZN",
      Currency(
        code: "MZN",
        symbol: "MT",
        numeric_code: 943,
        minor_units: 2,
        name: "Metical",
      ),
    ),
    tuple(
      "NAD",
      Currency(
        code: "NAD",
        symbol: "$",
        numeric_code: 516,
        minor_units: 2,
        name: "Rand Namibia Dollar",
      ),
    ),
    tuple(
      "NGN",
      Currency(
        code: "NGN",
        symbol: "₦",
        numeric_code: 566,
        minor_units: 2,
        name: "Naira",
      ),
    ),
    tuple(
      "NIO",
      Currency(
        code: "NIO",
        symbol: "C$",
        numeric_code: 558,
        minor_units: 2,
        name: "Cordoba Oro",
      ),
    ),
    tuple(
      "NOK",
      Currency(
        code: "NOK",
        symbol: "kr",
        numeric_code: 578,
        minor_units: 2,
        name: "Norwegian Krone",
      ),
    ),
    tuple(
      "NPR",
      Currency(
        code: "NPR",
        symbol: "₨",
        numeric_code: 524,
        minor_units: 2,
        name: "Nepalese Rupee",
      ),
    ),
    tuple(
      "NZD",
      Currency(
        code: "NZD",
        symbol: "$",
        numeric_code: 554,
        minor_units: 2,
        name: "New Zealand Dollar",
      ),
    ),
    tuple(
      "OMR",
      Currency(
        code: "OMR",
        symbol: "﷼",
        numeric_code: 512,
        minor_units: 3,
        name: "Rial Omani",
      ),
    ),
    tuple(
      "PAB",
      Currency(
        code: "PAB",
        symbol: "B/.",
        numeric_code: 590,
        minor_units: 2,
        name: "Balboa US Dollar",
      ),
    ),
    tuple(
      "PEN",
      Currency(
        code: "PEN",
        symbol: "S/.",
        numeric_code: 604,
        minor_units: 2,
        name: "Nuevo Sol",
      ),
    ),
    tuple(
      "PGK",
      Currency(
        code: "PGK",
        symbol: "K",
        numeric_code: 598,
        minor_units: 2,
        name: "Kina",
      ),
    ),
    tuple(
      "PHP",
      Currency(
        code: "PHP",
        symbol: "₱",
        numeric_code: 608,
        minor_units: 2,
        name: "Philippine Peso",
      ),
    ),
    tuple(
      "PKR",
      Currency(
        code: "PKR",
        symbol: "₨",
        numeric_code: 586,
        minor_units: 2,
        name: "Pakistan Rupee",
      ),
    ),
    tuple(
      "PLN",
      Currency(
        code: "PLN",
        symbol: "zł",
        numeric_code: 985,
        minor_units: 2,
        name: "Zloty",
      ),
    ),
    tuple(
      "PYG",
      Currency(
        code: "PYG",
        symbol: "₲",
        numeric_code: 600,
        minor_units: 0,
        name: "Guarani",
      ),
    ),
    tuple(
      "QAR",
      Currency(
        code: "QAR",
        symbol: "﷼",
        numeric_code: 634,
        minor_units: 2,
        name: "Qatari Rial",
      ),
    ),
    tuple(
      "RON",
      Currency(
        code: "RON",
        symbol: "lei",
        numeric_code: 946,
        minor_units: 2,
        name: "New Leu",
      ),
    ),
    tuple(
      "RSD",
      Currency(
        code: "RSD",
        symbol: "Дин.",
        numeric_code: 941,
        minor_units: 2,
        name: "Serbian Dinar",
      ),
    ),
    tuple(
      "RUB",
      Currency(
        code: "RUB",
        symbol: "₽",
        numeric_code: 643,
        minor_units: 2,
        name: "Russian Ruble",
      ),
    ),
    tuple(
      "RWF",
      Currency(
        code: "RWF",
        symbol: " ",
        numeric_code: 646,
        minor_units: 0,
        name: "Rwanda Franc",
      ),
    ),
    tuple(
      "SAR",
      Currency(
        code: "SAR",
        symbol: "﷼",
        numeric_code: 682,
        minor_units: 2,
        name: "Saudi Riyal",
      ),
    ),
    tuple(
      "SBD",
      Currency(
        code: "SBD",
        symbol: "$",
        numeric_code: 90,
        minor_units: 2,
        name: "Solomon Islands Dollar",
      ),
    ),
    tuple(
      "SCR",
      Currency(
        code: "SCR",
        symbol: "₨",
        numeric_code: 690,
        minor_units: 2,
        name: "Seychelles Rupee",
      ),
    ),
    tuple(
      "SDG",
      Currency(
        code: "SDG",
        symbol: "SDG",
        numeric_code: 938,
        minor_units: 2,
        name: "Sudanese Pound",
      ),
    ),
    tuple(
      "SEK",
      Currency(
        code: "SEK",
        symbol: "kr",
        numeric_code: 752,
        minor_units: 2,
        name: "Swedish Krona",
      ),
    ),
    tuple(
      "SGD",
      Currency(
        code: "SGD",
        symbol: "$",
        numeric_code: 702,
        minor_units: 2,
        name: "Singapore Dollar",
      ),
    ),
    tuple(
      "SHP",
      Currency(
        code: "SHP",
        symbol: "£",
        numeric_code: 654,
        minor_units: 2,
        name: "Saint Helena Pound",
      ),
    ),
    tuple(
      "SLL",
      Currency(
        code: "SLL",
        symbol: "Le",
        numeric_code: 694,
        minor_units: 2,
        name: "Leone",
      ),
    ),
    tuple(
      "SOS",
      Currency(
        code: "SOS",
        symbol: "S",
        numeric_code: 706,
        minor_units: 2,
        name: "Somali Shilling",
      ),
    ),
    tuple(
      "SRD",
      Currency(
        code: "SRD",
        symbol: "$",
        numeric_code: 968,
        minor_units: 2,
        name: "Surinam Dollar",
      ),
    ),
    tuple(
      "SSP",
      Currency(
        code: "SSP",
        symbol: "SS£",
        numeric_code: 728,
        minor_units: 2,
        name: "South Sudanese Pound",
      ),
    ),
    tuple(
      "STD",
      Currency(
        code: "STD",
        symbol: "Db",
        numeric_code: 678,
        minor_units: 2,
        name: "Dobra",
      ),
    ),
    tuple(
      "STN",
      Currency(
        code: "STN",
        symbol: "Db",
        numeric_code: 930,
        minor_units: 2,
        name: "Dobra",
      ),
    ),
    tuple(
      "SVC",
      Currency(
        code: "SVC",
        symbol: "$",
        numeric_code: 222,
        minor_units: 2,
        name: "El Salvador Colon US Dollar",
      ),
    ),
    tuple(
      "SYP",
      Currency(
        code: "SYP",
        symbol: "£",
        numeric_code: 760,
        minor_units: 2,
        name: "Syrian Pound",
      ),
    ),
    tuple(
      "SZL",
      Currency(
        code: "SZL",
        symbol: "E",
        numeric_code: 748,
        minor_units: 2,
        name: "Lilangeni",
      ),
    ),
    tuple(
      "THB",
      Currency(
        code: "THB",
        symbol: "฿",
        numeric_code: 764,
        minor_units: 2,
        name: "Baht",
      ),
    ),
    tuple(
      "TJS",
      Currency(
        code: "TJS",
        symbol: " ",
        numeric_code: 972,
        minor_units: 2,
        name: "Somoni",
      ),
    ),
    tuple(
      "TMT",
      Currency(
        code: "TMT",
        symbol: "₼",
        numeric_code: 934,
        minor_units: 2,
        name: "Manat",
      ),
    ),
    tuple(
      "TND",
      Currency(
        code: "TND",
        symbol: "د.ت",
        numeric_code: 788,
        minor_units: 2,
        name: "Tunisian Dinar",
      ),
    ),
    tuple(
      "TOP",
      Currency(
        code: "TOP",
        symbol: "T$",
        numeric_code: 776,
        minor_units: 2,
        name: "Pa'anga",
      ),
    ),
    tuple(
      "TRY",
      Currency(
        code: "TRY",
        symbol: "TL",
        numeric_code: 949,
        minor_units: 2,
        name: "Turkish Lira",
      ),
    ),
    tuple(
      "TTD",
      Currency(
        code: "TTD",
        symbol: "TT$",
        numeric_code: 780,
        minor_units: 2,
        name: "Trinidad and Tobago Dollar",
      ),
    ),
    tuple(
      "TWD",
      Currency(
        code: "TWD",
        symbol: "NT$",
        numeric_code: 901,
        minor_units: 2,
        name: "New Taiwan Dollar",
      ),
    ),
    tuple(
      "TZS",
      Currency(
        code: "TZS",
        symbol: "Tsh",
        numeric_code: 834,
        minor_units: 2,
        name: "Tanzanian Shilling",
      ),
    ),
    tuple(
      "UAH",
      Currency(
        code: "UAH",
        symbol: "₴",
        numeric_code: 980,
        minor_units: 2,
        name: "Hryvnia",
      ),
    ),
    tuple(
      "UGX",
      Currency(
        code: "UGX",
        symbol: "Ush",
        numeric_code: 800,
        minor_units: 0,
        name: "Uganda Shilling",
      ),
    ),
    tuple(
      "USD",
      Currency(
        code: "USD",
        symbol: "$",
        numeric_code: 840,
        minor_units: 2,
        name: "US Dollar",
      ),
    ),
    tuple(
      "USN",
      Currency(
        code: "USN",
        symbol: "$",
        numeric_code: 997,
        minor_units: 2,
        name: "US Dollar next-day funds",
      ),
    ),
    tuple(
      "UYI",
      Currency(
        code: "UYI",
        symbol: "$U",
        numeric_code: 940,
        minor_units: 0,
        name: "Peso Uruguayo Uruguay Peso en Unidades Indexadas",
      ),
    ),
    tuple(
      "UYU",
      Currency(
        code: "UYU",
        symbol: "$U",
        numeric_code: 858,
        minor_units: 2,
        name: "Peso Uruguayo Uruguay Peso en Unidades Indexadas",
      ),
    ),
    tuple(
      "UZS",
      Currency(
        code: "UZS",
        symbol: "лв",
        numeric_code: 860,
        minor_units: 2,
        name: "Uzbekistan Sum",
      ),
    ),
    tuple(
      "VEF",
      Currency(
        code: "VEF",
        symbol: "Bs",
        numeric_code: 937,
        minor_units: 2,
        name: "Bolivar Fuerte",
      ),
    ),
    tuple(
      "VND",
      Currency(
        code: "VND",
        symbol: "₫",
        numeric_code: 704,
        minor_units: 0,
        name: "Dong",
      ),
    ),
    tuple(
      "VUV",
      Currency(
        code: "VUV",
        symbol: "VT",
        numeric_code: 548,
        minor_units: 0,
        name: "Vatu",
      ),
    ),
    tuple(
      "WST",
      Currency(
        code: "WST",
        symbol: "WS$",
        numeric_code: 882,
        minor_units: 2,
        name: "Tala",
      ),
    ),
    tuple(
      "XAF",
      Currency(
        code: "XAF",
        symbol: "FCFA",
        numeric_code: 950,
        minor_units: 0,
        name: "CFA Franc BEAC",
      ),
    ),
    tuple(
      "XAG",
      Currency(
        code: "XAG",
        symbol: " ",
        numeric_code: 961,
        minor_units: 2,
        name: "Silver",
      ),
    ),
    tuple(
      "XAU",
      Currency(
        code: "XAU",
        symbol: " ",
        numeric_code: 959,
        minor_units: 2,
        name: "Gold",
      ),
    ),
    tuple(
      "XBA",
      Currency(
        code: "XBA",
        symbol: " ",
        numeric_code: 955,
        minor_units: 2,
        name: "Bond Markets Units European Composite Unit (EURCO)",
      ),
    ),
    tuple(
      "XBB",
      Currency(
        code: "XBB",
        symbol: " ",
        numeric_code: 956,
        minor_units: 2,
        name: "European Monetary Unit (E.M.U.-6)",
      ),
    ),
    tuple(
      "XBC",
      Currency(
        code: "XBC",
        symbol: " ",
        numeric_code: 957,
        minor_units: 2,
        name: "European Unit of Account 9(E.U.A.-9)",
      ),
    ),
    tuple(
      "XBD",
      Currency(
        code: "XBD",
        symbol: " ",
        numeric_code: 958,
        minor_units: 2,
        name: "European Unit of Account 17(E.U.A.-17)",
      ),
    ),
    tuple(
      "XCD",
      Currency(
        code: "XCD",
        symbol: "$",
        numeric_code: 951,
        minor_units: 2,
        name: "East Caribbean Dollar",
      ),
    ),
    tuple(
      "XDR",
      Currency(
        code: "XDR",
        symbol: " ",
        numeric_code: 960,
        minor_units: 2,
        name: "SDR",
      ),
    ),
    tuple(
      "XFU",
      Currency(
        code: "XFU",
        symbol: " ",
        numeric_code: 0,
        minor_units: 2,
        name: "UIC-Franc",
      ),
    ),
    tuple(
      "XOF",
      Currency(
        code: "XOF",
        symbol: " ",
        numeric_code: 952,
        minor_units: 0,
        name: "CFA Franc BCEAO",
      ),
    ),
    tuple(
      "XPD",
      Currency(
        code: "XPD",
        symbol: " ",
        numeric_code: 964,
        minor_units: 2,
        name: "Palladium",
      ),
    ),
    tuple(
      "XPF",
      Currency(
        code: "XPF",
        symbol: " ",
        numeric_code: 953,
        minor_units: 0,
        name: "CFP Franc",
      ),
    ),
    tuple(
      "XPT",
      Currency(
        code: "XPT",
        symbol: " ",
        numeric_code: 962,
        minor_units: 2,
        name: "Platinum",
      ),
    ),
    tuple(
      "XTS",
      Currency(
        code: "XTS",
        symbol: " ",
        numeric_code: 963,
        minor_units: 2,
        name: "Codes specifically reserved for testing purposes",
      ),
    ),
    tuple(
      "XSU",
      Currency(
        code: "XSU",
        symbol: " ",
        numeric_code: 994,
        minor_units: 2,
        name: "Sucre",
      ),
    ),
    tuple(
      "XUA",
      Currency(
        code: "XUA",
        symbol: " ",
        numeric_code: 965,
        minor_units: 2,
        name: "ADB Unit of Account",
      ),
    ),
    tuple(
      "YER",
      Currency(
        code: "YER",
        symbol: "﷼",
        numeric_code: 886,
        minor_units: 2,
        name: "Yemeni Rial",
      ),
    ),
    tuple(
      "ZAR",
      Currency(
        code: "ZAR",
        symbol: "R",
        numeric_code: 710,
        minor_units: 2,
        name: "Rand",
      ),
    ),
    tuple(
      "ZMW",
      Currency(
        code: "ZMW",
        symbol: "ZK",
        numeric_code: 967,
        minor_units: 2,
        name: "Zambian Kwacha",
      ),
    ),
    tuple(
      "ZWL",
      Currency(
        code: "ZWL",
        symbol: "$",
        numeric_code: 932,
        minor_units: 2,
        name: "Zimbabwe Dollar",
      ),
    ),
  ])
}