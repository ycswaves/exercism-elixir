defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  def to_rna(''), do: ''

  def to_rna(dna) do
    [head | tail] = dna
    [_complement(head) | to_rna(tail)]
  end

  defp _complement(char) do
    case char do
      ?G -> ?C
      ?C -> ?G
      ?T -> ?A
      ?A -> ?U
    end
  end
end
