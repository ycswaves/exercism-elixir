defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  def rotate(text, shift) do
    text
    |> String.to_charlist()
    |> Enum.map(&_shift(&1, shift))
    |> to_string
  end

  defp _shift(char, shift) when ?a <= char and char <= ?z do
    ?a + rem(char - ?a + shift, 26)
  end

  defp _shift(char, shift) when ?A <= char and char <= ?Z do
    ?A + rem(char - ?A + shift, 26)
  end

  defp _shift(any, _), do: any
end
