defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l) do
    count_helper(l, 0)
  end

  defp count_helper([], count), do: count
  defp count_helper([_ | tail], count), do: count_helper(tail, count + 1)

  @spec reverse(list) :: list
  def reverse(l) do
    reverse_helper(l, [])
  end

  defp reverse_helper([], new_list), do: new_list

  defp reverse_helper(rest, new_list) do
    [head | tail] = rest
    reverse_helper(tail, [head | new_list])
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    map_helper(l, f, [])
  end

  defp map_helper([], _, new_list), do: new_list |> reverse

  defp map_helper(l, f, new_list) do
    [head | tail] = l
    map_helper(tail, f, [f.(head) | new_list])
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    filter_helper(l, f, [])
  end

  defp filter_helper([], _, new_list), do: new_list |> reverse

  defp filter_helper(l, f, new_list) do
    [head | tail] = l

    cond do
      f.(head) -> filter_helper(tail, f, [head | new_list])
      true -> filter_helper(tail, f, new_list)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _), do: acc

  def reduce(l, acc, f) do
    [head | tail] = l
    new_acc = f.(head, acc)
    reduce(tail, new_acc, f)
  end

  @spec append(list, list) :: list
  def append(a, []), do: a
  def append([], b), do: b
  def append(a, b), do: append_helper(a |> reverse, b, :reverse)

  defp append_helper(a, [], :reverse), do: a |> reverse
  defp append_helper(a, [], _), do: a

  defp append_helper(a, b, rev) do
    [head | tail] = b
    append_helper([head | a], tail, rev)
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    ll
    |> reduce([], &append_helper(&2, &1, :no_reverse))
    |> reverse
  end
end
