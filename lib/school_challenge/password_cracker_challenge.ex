defmodule PasswordCrackerChallenge do
  @doc """
  Funkcja przyjmuje hash oryginalnego hasła
  Zwraca znalezione hasło na podstawie oryginalnego hasha
  jako listę znaków - np. 'abc'
  TIP: należy zwrócić uwagę, czy apostrofy są '' (lista znaków) czy "" (String, binary)
  """

  @max_number 141_167_095_653_376
  @chunk_size 250_000

  def guess_password(hash), do: guess_password(hash, 0, 10_000_000)

  def guess_password(hash, min, max) when min > @max_number do
    []
  end

  def guess_password(hash, min, max) do
    :erlang.garbage_collect()
    result = check_chunk(min, max, hash)

    case result do
      [] -> guess_password(hash, max, max + 10_000_000)
      a -> a
    end
  end

  defp check_chunk(min, max, hash) do
    stream =
      min..max
      |> Enum.to_list()
      |> Enum.chunk_every(@chunk_size)
      |> Task.async_stream(max_concurrency: 16, fn subchunk ->
        subchunk
        |> Enum.map(fn x -> generate_candidate(x, ~c"") end)
        |> Enum.map(fn y -> check_candidate(y, hash) end)
        |> Enum.filter(fn z -> match?({true, _}, z) end)
        |> Enum.take(1) # stop processing as soon as a match is found
      end)

    Enum.reduce(stream, [], fn {:ok, a}, acc -> a ++ acc end)
  end

  defp map_char(num) do
    [num + 97]
  end

  defp generate_candidate(0, ~c""), do: ~c"a"
  defp generate_candidate(0, password), do: password

  defp generate_candidate(number, password) do
    char = map_char(rem(number - 1, 26))

    generate_candidate(div(number, 27), char ++ password)
  end

  defmodule Cache do
    defstruct entries: %{}

    def get_or_compute(cache, key, func) do
      case Map.get(cache.entries, key) do
        nil ->
          result = func.()
          cache = %{cache | entries: Map.put(cache.entries, key, result)}
          {result, cache}
        value ->
          {value, cache}
      end
    end
  end

  defp check_candidate(password, hash) do
    {result, _} = Cache.get_or_compute(%Cache{}, password, fn ->
      candidate_hash = :crypto.hash(:sha512, password)
      {hash == candidate_hash, password}
      end)
    result
  end
end