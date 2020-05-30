defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  # @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Enum.map(&count/1)
    |> Enum.reduce(%{}, &merge_count/2)
  end

  defp count(text) do
    text
    |> String.graphemes()
    |> Enum.filter(&String.match?(&1, ~r/[[:alpha:]]/u))
    |> Enum.frequencies_by(&String.downcase/1)
  end

  defp merge_count(freq, acc) do
    Map.merge(freq, acc, fn _k, c1, c2 -> c1 + c2 end)
  end
end
