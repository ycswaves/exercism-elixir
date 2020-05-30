defmodule Bowling2 do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    %{current_frame: 1, frame_data: [{}]}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  # @spec roll(any, integer) :: any | String.t()

  # strike
  def roll(%{current_frame: frame, frame_data: [{} | rest_frames]}, 10) do
    %{current_frame: frame + 1, frame_data: [{}, {10} | rest_frames]}
  end

  # 1st throw
  def roll(%{current_frame: frame, frame_data: [{} | rest_frames]}, score) do
    %{current_frame: frame, frame_data: [{score} | rest_frames]}
  end

  # 2nd throw
  def roll(%{current_frame: 10, frame_data: [{t1, t2} | rest_frames]}, score)
      when t1 + t2 == 10 do
    %{current_frame: 10, frame_data: [{t1, t2, score} | rest_frames]}
  end

  def roll(%{current_frame: 10, frame_data: [{prev} | rest_frames]}, score) do
    %{current_frame: 10, frame_data: [{prev, score} | rest_frames]}
  end

  def roll(%{current_frame: frame, frame_data: [{prev} | rest_frames]}, score) do
    %{current_frame: frame + 1, frame_data: [{}, {prev, score} | rest_frames]}
  end

  @doc """
    Returns the score of a given game of bowling if the game is complte.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score(game) do
    game.frame_data
    |> Enum.reverse()
    |> do_score(0)
  end

  defp do_score([], sum), do: sum

  # previous frame is spare
  defp do_score([{t1, t2} | rest], sum) when t1 + t2 == 10 do
    [{next_t1, _} | _] = rest
    do_score(rest, 10 + next_t1 + sum)
  end

  defp do_score([{t} | rest], sum), do: do_score(rest, t + sum)
  defp do_score([{t1, t2} | rest], sum), do: do_score(rest, t1 + t2 + sum)
  defp do_score([{t1, t2, t3} | rest], sum), do: do_score(rest, t1 + t2 + t3 + sum)
end
