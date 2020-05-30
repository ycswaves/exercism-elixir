defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  use GenServer

  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank(balance \\ 0) do
    {:ok, pid} = GenServer.start(__MODULE__, balance)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  def close_bank(account) do
    GenServer.stop(account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    if Process.alive?(account) do
      GenServer.call(account, :get_balance)
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    if Process.alive?(account) do
      GenServer.cast(account, {:update, amount})
    else
      {:error, :account_closed}
    end
  end

  # Start of GenServer implementations

  @impl GenServer
  def init(balance \\ 0) do
    {:ok, balance}
  end

  @impl GenServer
  def handle_call(:get_balance, _from, balance) do
    {:reply, balance, balance}
  end

  @impl GenServer
  def handle_cast({:update, amount}, balance) do
    {:noreply, balance + amount}
  end
end
