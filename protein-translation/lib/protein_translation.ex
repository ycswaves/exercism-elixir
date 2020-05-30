defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    res =
      rna
      |> to_charlist
      |> Enum.chunk_every(3)
      |> Enum.map(&to_string(&1))
      |> Enum.map(&of_codon(&1))
      |> Enum.group_by(&_key_fun(&1), &_val_fun(&1))

    case res do
      %{:error => _} -> {:error, "invalid RNA"}
      %{:ok => ok} -> {:ok, Enum.take_while(ok, &(&1 != "STOP"))}
    end
  end

  defp _key_fun(protein) do
    case protein do
      {:error, _} -> :error
      _ -> :ok
    end
  end

  defp _val_fun(protein) do
    case protein do
      {:ok, protein_name} -> protein_name
      _ -> 1
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  def of_codon(codon) do
    case codon do
      "UGU" ->
        {:ok, "Cysteine"}

      "UGC" ->
        {:ok, "Cysteine"}

      "UUA" ->
        {:ok, "Leucine"}

      "UUG" ->
        {:ok, "Leucine"}

      "AUG" ->
        {:ok, "Methionine"}

      "UUU" ->
        {:ok, "Phenylalanine"}

      "UUC" ->
        {:ok, "Phenylalanine"}

      "UCU" ->
        {:ok, "Serine"}

      "UCC" ->
        {:ok, "Serine"}

      "UCA" ->
        {:ok, "Serine"}

      "UCG" ->
        {:ok, "Serine"}

      "UGG" ->
        {:ok, "Tryptophan"}

      "UAU" ->
        {:ok, "Tyrosine"}

      "UAC" ->
        {:ok, "Tyrosine"}

      "UAA" ->
        {:ok, "STOP"}

      "UAG" ->
        {:ok, "STOP"}

      "UGA" ->
        {:ok, "STOP"}

      _ ->
        {:error, "invalid codon"}
    end
  end
end
