defmodule Forth do
  @opaque evaluator :: any

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %{evaluated: [], custom_ops: %{}}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(%{custom_ops: custom_ops} = ev, ":" <> _ = ev_str) do
    [_, new_op, def_str, rest_ev_str] = Regex.run(~r/:\s(.+?)\s(.+)\s;(.*)/, ev_str)

    if is_num(new_op) do
      raise(Forth.InvalidWord)
    end

    def_list = def_str |> String.trim() |> String.upcase() |> String.split()

    ev = %{ev | custom_ops: Map.put(custom_ops, String.upcase(new_op), def_list)}

    if String.length(rest_ev_str) > 0 do
      do_eval([String.trim(rest_ev_str)], ev)
    else
      ev
    end
  end

  def eval(ev, s) do
    s
    |> String.upcase()
    |> String.split(~r/[^[:alnum:]*\/+-:;]/u, trim: true)
    |> do_eval(ev)
  end

  defp do_eval([], ev), do: ev

  defp do_eval(["*" | rest_input], %{evaluated: evaluated} = ev) do
    [one, two | rest_evaluated] = evaluated

    do_eval(rest_input, %{ev | evaluated: [two * one | rest_evaluated]})
  end

  defp do_eval(["/" | _], %{evaluated: [one, _ | _]}) when one == 0 do
    raise Forth.DivisionByZero
  end

  defp do_eval(["/" | rest_input], %{evaluated: evaluated} = ev) do
    [one, two | rest] = evaluated

    do_eval(rest_input, %{ev | evaluated: [div(two, one) | rest]})
  end

  defp do_eval(["+" | rest_input], %{evaluated: evaluated} = ev) do
    [one, two | rest] = evaluated

    do_eval(rest_input, %{ev | evaluated: [two + one | rest]})
  end

  defp do_eval(["-" | rest_input], %{evaluated: evaluated} = ev) do
    [one, two | rest] = evaluated

    do_eval(rest_input, %{ev | evaluated: [two - one | rest]})
  end

  defp do_eval(["DUP" | rest_input], %{evaluated: [item | rest]} = ev) do
    do_eval(rest_input, %{ev | evaluated: [item, item | rest]})
  end

  defp do_eval(["DUP" | _], _), do: raise(Forth.StackUnderflow)

  defp do_eval(["DROP" | rest_input], %{evaluated: [_ | rest]} = ev) do
    do_eval(rest_input, %{ev | evaluated: rest})
  end

  defp do_eval(["DROP" | _], _), do: raise(Forth.StackUnderflow)

  defp do_eval(["SWAP" | rest_input], %{evaluated: [a, b | rest]} = ev) do
    do_eval(rest_input, %{ev | evaluated: [b, a | rest]})
  end

  defp do_eval(["SWAP" | rest_input], %{custom_ops: custom} = ev) do
    if Map.has_key?(custom, "SWAP") do
      do_eval(Map.get(custom, "SWAP") ++ rest_input, ev)
    else
      raise(Forth.StackUnderflow)
    end
  end

  defp do_eval(["OVER" | rest_input], %{evaluated: [a, b | rest]} = ev) do
    do_eval(rest_input, %{ev | evaluated: [b, a, b | rest]})
  end

  defp do_eval(["OVER" | _], _), do: raise(Forth.StackUnderflow)

  defp do_eval([op | rest_input], %{custom_ops: ops} = ev) do
    cond do
      Map.has_key?(ops, op) -> do_eval(ops[op] ++ rest_input, ev)
      is_num(op) -> do_eval(rest_input, %{ev | evaluated: [String.to_integer(op) | ev.evaluated]})
      true -> raise Forth.UnknownWord
    end
  end

  defp is_num(str), do: String.match?(str, ~r/[0-9]/)

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    ev.evaluated
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
