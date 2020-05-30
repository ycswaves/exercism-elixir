defmodule Bob do
  def hey(input) do
    cond do
      String.match?(input, ~r/^[\s]*$/) ->
        "Fine. Be that way!"

      String.match?(input, ~r/[[:digit:][:punct:]\s]\?\s*$/) ->
        "Sure."

      String.match?(input, ~r/^[[:upper:][:digit:][:punct:]\s]+\?$/u) ->
        "Calm down, I know what I'm doing!"

      String.match?(input, ~r/[[:digit:][:punct:]+]$/) and
          !String.match?(input, ~r/[[:upper:]\?]/u) ->
        "Whatever."

      String.match?(input, ~r/^[[:upper:][:digit:][:punct:]\s]+$/u) ->
        "Whoa, chill out!"

      String.match?(input, ~r/\?\s*$/) ->
        "Sure."

      true ->
        "Whatever."
    end
  end
end
