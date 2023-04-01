defmodule PasswordCrackerChallenge do
  @doc """
  Funkcja przyjmuje hash oryginalnego hasła
  Zwraca znalezione hasło na podstawie oryginalnego hasha
  jako listę znaków - np. 'abc'

  TIP: należy zwrócić uwagę, czy apostrofy są '' (lista znaków) czy "" (String, binary)
  """

  @max_number 141_167_095_653_376

  def guess_password(hash), do: guess_password(hash, 0, 10_000_000)

  def guess_password(hash, min, max) when min > @max_number do
    []
  end

  def guess_password(hash, min, max) do
    :erlang.garbage_collect()
    result = check_chunk(min, max, hash)

    case result do
      [] -> guess_password(hash, max, max + 10_000_000)
      a -> Enum.at(a, 0) |> elem(1)
    end
  end

  defp check_chunk(min, max, hash) do
    stream =
      min..max
      |> Enum.to_list()
      |> Enum.chunk_every(250_000)
      |> Task.async_stream(fn subchunk ->
        subchunk
        |> Enum.map(fn x -> generate_candidate(x, ~c"") end)
        |> Enum.map(fn y -> check_candidate(y, hash) end)
        |> Enum.filter(fn z -> match?({true, _}, z) end)
      end)

    Enum.reduce(stream, [], fn {:ok, a}, acc -> [a | acc] end)
    |> Enum.reject(&(&1 == []))
    |> Enum.concat()
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

  defp check_candidate(password, hash) do
    candidate_hash = :crypto.hash(:sha512, password)
    {hash == candidate_hash, password}
  end
end
