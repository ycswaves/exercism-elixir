defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(?A) do
    "A\n"
  end

  def build_shape(letter) do
    upper = build_upper(letter)
    lower = build_lower(upper)

    [upper, [build_layer(letter, letter)], lower]
    |> Enum.concat()
    |> Enum.join()
  end

  defp build_layer(?A, target_letter), do: polish_layer("A", target_letter - ?A)

  defp build_layer(current_letter, target_letter) do
    spaces = String.duplicate(" ", 2 * (current_letter - ?A) - 1)
    str_letter = List.to_string([current_letter])

    "#{str_letter}#{spaces}#{str_letter}" |> polish_layer(target_letter - current_letter)
  end

  defp polish_layer(layer, gap_count) do
    padding = String.duplicate(" ", gap_count)

    "#{padding}#{layer}#{padding}\n"
  end

  defp build_upper(letter) do
    ?A..(letter - 1) |> Enum.map(&build_layer(&1, letter))
  end

  defp build_lower(upper), do: Enum.reverse(upper)
end
