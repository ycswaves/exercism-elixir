defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @valid_dir [:north, :east, :south, :west]
  @valid_instr ["L", "R", "A"]

  defguardp is_direction(dir) when dir in @valid_dir
  defguardp is_position(pos) when is_tuple(pos) and tuple_size(pos) == 2
  defguardp is_position(x, y) when is_integer(x) and is_integer(y)

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create() do
    {:north, {0, 0}}
  end

  def create(dir, _) when not is_direction(dir) do
    {:error, "invalid direction"}
  end

  def create(_, pos) when not is_position(pos) do
    {:error, "invalid position"}
  end

  def create(_, {x, y}) when not is_position(x, y) do
    {:error, "invalid position"}
  end

  def create(dir, pos) when is_direction(dir) do
    {dir, pos}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    simulate_helper(robot, instructions)
  end

  defp simulate_helper(robot, "") do
    robot
  end

  defp simulate_helper({:north = dir, {x, y}}, <<"A", rest::binary>>) do
    simulate_helper({dir, {x, y + 1}}, rest)
  end

  defp simulate_helper({:south = dir, {x, y}}, <<"A", rest::binary>>) do
    simulate_helper({dir, {x, y - 1}}, rest)
  end

  defp simulate_helper({:west = dir, {x, y}}, <<"A", rest::binary>>) do
    simulate_helper({dir, {x - 1, y}}, rest)
  end

  defp simulate_helper({:east = dir, {x, y}}, <<"A", rest::binary>>) do
    simulate_helper({dir, {x + 1, y}}, rest)
  end

  defp simulate_helper({dir, pos}, <<instr::binary-size(1), rest::binary>>)
       when instr in @valid_instr do
    simulate_helper({new_dir(dir, instr), pos}, rest)
  end

  defp simulate_helper(_, _) do
    {:error, "invalid instruction"}
  end

  defp new_dir(:north, "L"), do: :west
  defp new_dir(:north, "R"), do: :east
  defp new_dir(:east, "L"), do: :north
  defp new_dir(:east, "R"), do: :south
  defp new_dir(:south, "L"), do: :east
  defp new_dir(:south, "R"), do: :west
  defp new_dir(:west, "L"), do: :south
  defp new_dir(:west, "R"), do: :north

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction({dir, _}) do
    dir
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position({_, pos}) do
    pos
  end
end
