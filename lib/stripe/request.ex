defmodule Stripe.Request do
  alias Stripe.Util

  @spec create(String.t, struct, map, module, Keyword.t) :: {:ok, struct} | {:error, Exception.t}
  def create(endpoint, struct, valid_keys, module, opts) do
    body =
      struct
      |> Map.take(valid_keys)
      |> Util.drop_nil_keys()

    case Stripe.request(:post, endpoint, body, %{}, opts) do
      {:ok, result} -> {:ok, Util.stripe_map_to_struct(module, result)}
      {:error, error} -> {:error, error}
    end
  end

  @spec retrieve(String.t, module, Keyword.t) :: {:ok, struct} | {:error, Exception.t}
  def retrieve(endpoint, module, opts) do
    case Stripe.request(:get, endpoint, %{}, %{}, opts) do
      {:ok, result} -> {:ok, Util.stripe_map_to_struct(module, result)}
      {:error, error} -> {:error, error}
    end
  end

  @spec update(String.t, map, map, struct, Keyword.t) :: {:ok, struct} | {:error, Exception.t}
  def update(endpoint, changes, valid_keys, module, opts) do
    body =
      changes
      |> Util.map_keys_to_atoms()
      |> Map.take(valid_keys)
      |> Util.drop_nil_keys()

    case Stripe.request(:post, endpoint, body, %{}, opts) do
      {:ok, result} -> {:ok, Util.stripe_map_to_struct(module, result)}
      {:error, error} -> {:error, error}
    end
  end

  @spec delete(String.t, Keyword.t) :: :ok | {:error, Exception.t}
  def delete(endpoint, opts) do
    case Stripe.request(:delete, endpoint, %{}, %{}, opts) do
      {:ok, _} -> :ok
      {:error, error} -> {:error, error}
    end
  end
end
