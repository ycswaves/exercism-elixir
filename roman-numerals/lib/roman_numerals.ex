defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @roman_num_map %{
    1 => "I",
    5 => "V",
    10 => "X",
    50 => "L",
    100 => "C",
    500 => "D",
    1000 => "M"
  }

  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    divide(number, 1, "")
  end

  defp divide(0, _, converted), do: converted

  defp divide(number, multiple, converted) do
    rest = div(number, 10)
    digit = rem(number, 10)
    converted_continue = convert_digit(digit, multiple) <> converted
    divide(rest, multiple * 10, converted_continue)
  end

  defp convert_digit(num, multiple) do
    symbol = @roman_num_map[multiple]
    half_symbol = @roman_num_map[multiple * 5]

    cond do
      num < 4 -> String.duplicate(symbol, num)
      num == 4 -> symbol <> half_symbol
      num == 9 -> symbol <> @roman_num_map[multiple * 10]
      num > 4 -> half_symbol <> String.duplicate(symbol, num - 5)
    end
  end
end
