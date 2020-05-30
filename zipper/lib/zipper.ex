defmodule Zipper do
  @doc """
  Get a zipper focused on the root node.
  """
  defstruct [:parent, :data]

  def from_tree(bin_tree) do
    %Zipper{parent: nil, data: bin_tree}
  end

  @doc """
  Get the complete tree from a zipper.
  """

  # @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{parent: nil, data: d}), do: d
  def to_tree(zipper), do: zipper |> up |> to_tree

  @doc """
  Get the value of the focus node.
  """
  # @spec value(Zipper.t()) :: any
  def value(zipper) do
    zipper.data.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  # @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{data: %{left: nil}}), do: nil

  def left(zipper) do
    %Zipper{parent: {:from_left, zipper}, data: zipper.data.left}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  # @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{data: %{right: nil}}), do: nil

  def right(zipper) do
    %Zipper{parent: {:from_right, zipper}, data: zipper.data.right}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  # @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{parent: nil}), do: nil

  def up(%Zipper{parent: {:from_left, parent_zipper}, data: d}) do
    %Zipper{parent: parent_zipper.parent, data: %{parent_zipper.data | left: d}}
  end

  def up(%Zipper{parent: {:from_right, parent_zipper}, data: d}) do
    %Zipper{parent: parent_zipper.parent, data: %{parent_zipper.data | right: d}}
  end

  @doc """
  Set the value of the focus node.
  """
  # @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    %Zipper{zipper | data: %{zipper.data | value: value}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  # @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    %Zipper{zipper | data: %{zipper.data | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    %Zipper{zipper | data: %{zipper.data | right: right}}
  end
end
