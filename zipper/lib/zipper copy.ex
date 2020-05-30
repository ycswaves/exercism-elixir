# defmodule Zipper do
#   @doc """
#   Get a zipper focused on the root node.
#   """
#   # @spec from_tree(BinTree.t()) :: Zipper.t()
#   defstruct [:parents, :data]

#   def from_tree(bin_tree) do
#     # %BinTree{left: l, right: r, value: v} = bin_tree
#     %Zipper{parents: [], data: bin_tree}
#   end

#   @doc """
#   Get the complete tree from a zipper.
#   """

#   # @spec to_tree(Zipper.t()) :: BinTree.t()
#   def to_tree(%Zipper{parents: [], data: d}), do: d
#   def to_tree(zipper), do: zipper |> up |> to_tree

#   @doc """
#   Get the value of the focus node.
#   """
#   # @spec value(Zipper.t()) :: any
#   def value(zipper) do
#     zipper.data.value
#   end

#   @doc """
#   Get the left child of the focus node, if any.
#   """
#   # @spec left(Zipper.t()) :: Zipper.t() | nil
#   def left(%Zipper{data: %{left: nil}}), do: nil

#   def left(zipper) do
#     %Zipper{parents: [{:from_left, zipper.data} | zipper.parents], data: zipper.data.left}
#   end

#   @doc """
#   Get the right child of the focus node, if any.
#   """
#   # @spec right(Zipper.t()) :: Zipper.t() | nil
#   def right(%Zipper{data: %{right: nil}}), do: nil

#   def right(zipper) do
#     %Zipper{parents: [{:from_right, zipper.data} | zipper.parents], data: zipper.data.right}
#   end

#   @doc """
#   Get the parent of the focus node, if any.
#   """
#   # @spec up(Zipper.t()) :: Zipper.t() | nil
#   def up(%Zipper{parents: []}), do: nil

#   def up(%{parents: [{:from_left, parent} | t], data: d}) do
#     %Zipper{parents: t, data: %{parent | left: d}}
#   end

#   def up(%{parents: [{:from_right, parent} | t], data: d}) do
#     %Zipper{parents: t, data: %{parent | right: d}}
#   end

#   @doc """
#   Set the value of the focus node.
#   """
#   # @spec set_value(Zipper.t(), any) :: Zipper.t()
#   def set_value(zipper, value) do
#     %Zipper{zipper | data: %{zipper.data | value: value}}
#   end

#   @doc """
#   Replace the left child tree of the focus node.
#   """
#   # @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
#   def set_left(zipper, left) do
#     %Zipper{zipper | data: %{zipper.data | left: left}}
#   end

#   @doc """
#   Replace the right child tree of the focus node.
#   """
#   # @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
#   def set_right(zipper, right) do
#     %Zipper{zipper | data: %{zipper.data | right: right}}
#   end
# end
