defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @invalid_pin_count {:error, "Pin count exceeds pins on the lane"}
  @game_not_ended {:error, "Score cannot be taken until the end of the game"}
  @game_over {:error, "Cannot roll after game is over"}
  @last_frame 10
  @strike 10

  @spec start() :: any
  def start do
    {1, [{}]}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  defguard invalid_pin_count(t1, roll) when t1 < @strike and roll + t1 > @strike
  defguard invalid_pin_count(roll) when roll > @strike

  defguard invalid_pin_count(t1, t2, roll)
           when t1 == @strike and t2 < @strike and roll + t2 > @strike

  defguard is_spare(t1, t2) when t1 + t2 == @strike

  def roll(_, roll) when invalid_pin_count(roll), do: @invalid_pin_count

  def roll(_, roll) when roll < 0 do
    {:error, "Negative roll is invalid"}
  end

  # frame #10 with fill
  def roll({@last_frame, [{t1, t2} | _]}, roll) when invalid_pin_count(t1, t2, roll) do
    @invalid_pin_count
  end

  def roll({@last_frame, [{t1, t2} | rest_frames]}, roll) when is_spare(t1, t2) do
    {@last_frame, [{t1, t2, roll} | rest_frames]}
  end

  def roll({@last_frame, [{t1, @strike} | rest_frames]}, roll) do
    {@last_frame, [{t1, @strike, roll} | rest_frames]}
  end

  def roll({@last_frame, [{@strike, t2} | rest_frames]}, roll) do
    {@last_frame, [{@strike, t2, roll} | rest_frames]}
  end

  def roll({@last_frame, [{t1} | rest_frames]}, roll) do
    {@last_frame, [{t1, roll} | rest_frames]}
  end

  def roll({frame, [{} | rest_frames]}, @strike) when frame != @last_frame do
    {frame + 1, [{}, {@strike} | rest_frames]}
  end

  # 1st throw
  def roll({frame, [{} | rest_frames]}, roll) do
    {frame, [{roll} | rest_frames]}
  end

  # 2nd throw
  def roll({_, [{t1} | _]}, roll) when invalid_pin_count(t1, roll) do
    @invalid_pin_count
  end

  def roll({frame, [{prev} | rest_frames]}, roll) do
    {frame + 1, [{}, {prev, roll} | rest_frames]}
  end

  def roll(_, _), do: @game_over

  @doc """
    Returns the score of a given game of bowling if the game is complte.
    If the game isn't complete, it returns a helpful message.
  """

  defguard game_not_ended(frame) when frame < @last_frame
  defguard game_not_ended(t1, t2) when is_spare(t1, t2) or t1 + t2 == 2 * @strike
  @spec score(any) :: integer | String.t()
  def score({frame, _}) when game_not_ended(frame) do
    @game_not_ended
  end

  def score({@last_frame, [{@strike} | _]}) do
    @game_not_ended
  end

  def score({@last_frame, [{t1, t2} | _]}) when game_not_ended(t1, t2) do
    @game_not_ended
  end

  def score({_, frame_data}) do
    frame_data
    |> do_score(0, {})
  end

  defp do_score([], sum, _), do: sum

  # strike
  defp do_score([{@strike} | rest], sum, {after1, after2}) do
    do_score(rest, @strike + after1 + after2 + sum, {@strike, after1})
  end

  # spare
  defp do_score([{t1, t2} | rest], sum, {after1, _}) when is_spare(t1, t2) do
    do_score(rest, t1 + t2 + after1 + sum, {t1, t2})
  end

  defp do_score([{t1, t2} | rest], sum, _) do
    do_score(rest, t1 + t2 + sum, {t1, t2})
  end

  # has fill
  defp do_score([{t1, t2, t3} | rest], sum, _) do
    frame_roll = t1 + t2 + t3
    do_score(rest, frame_roll + sum, {t1, t2})
  end
end
