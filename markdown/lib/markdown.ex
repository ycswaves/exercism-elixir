defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    m
    |> String.split("\n")
    |> Enum.map_join(&process/1)
    |> enclose_list_item
  end

  defp process("#" <> _ = t) do
    t
    |> parse_header_md_level
    |> enclose_with_header_tag
  end

  defp process("*" <> _ = t) do
    parse_list_md_level(t)
  end

  defp process(t) do
    t
    |> String.split()
    |> enclose_with_paragraph_tag
  end

  defp parse_header_md_level(hwt) do
    [h | t] = String.split(hwt)
    {String.length(h), Enum.join(t, " ")}
  end

  defp parse_list_md_level(l) do
    t =
      l
      |> String.trim_leading("* ")
      |> String.split()

    "<li>#{join_words_with_tags(t)}</li>"
  end

  defp enclose_with_header_tag({hl, htl}) do
    "<h#{hl}>#{htl}</h#{hl}>"
  end

  defp enclose_with_paragraph_tag(t) do
    "<p>#{join_words_with_tags(t)}</p>"
  end

  defp join_words_with_tags(t) do
    Enum.map_join(t, " ", &replace_md_with_tag/1)
  end

  defp replace_md_with_tag("__" <> rest) do
    String.replace_suffix("<strong>#{rest}", "__", "</strong>")
  end

  defp replace_md_with_tag("_" <> rest) do
    String.replace_suffix("<em>#{rest}", "_", "</em>")
  end

  defp replace_md_with_tag(w) do
    w
    |> String.replace_suffix("__", "</strong>")
    |> String.replace_suffix("_", "</em>")
  end

  defp enclose_list_item(l) do
    l
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
