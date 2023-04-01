defmodule PasswordCrackerChallenge do
  @doc """
  Funkcja przyjmuje hash oryginalnego hasła
  Zwraca znalezione hasło na podstawie oryginalnego hasha
  jako listę znaków - np. 'abc'

  TIP: należy zwrócić uwagę, czy apostrofy są '' (lista znaków) czy "" (String, binary)
  """
  @chunk_size 320_000
  @workload 5_000

  def guess_password(hash), do: guess_password(hash, 0)
  def guess_password(hash, n) do
    :erlang.garbage_collect()

    result = n * @chunk_size..(n + 1) * @chunk_size
    |> Enum.chunk_every(@workload)
    |> Enum.map(&(Task.async(fn -> check_list_of_numbers(&1, hash) end)))
    |> Enum.map(&Task.await/1)
    |> List.flatten()
    |> Enum.filter(&match?({true, _}, &1))

    if result == [] do
      guess_password(hash, n + 1)
    else
      Enum.at(result, 0)
      |> elem(1)
    end
  end

  defp check_list_of_numbers(numbers, hash) do
    numbers
    |> Enum.map(&check_number(&1, hash))
  end

  defp check_number(number, hash) do
    number
    |> number_to_password('')
    |> check_password(hash)
  end

  defp number_to_password(0, ''), do: 'a'
  defp number_to_password(0, password), do: password
  defp number_to_password(number, password) do
    char = number
    |> rem(26)
    |> (fn(x) -> [x + 97] end).()

    number_to_password(div(number, 26), char ++ password)
  end

  defp check_password(password, actual_password_hash) do
    guessed_password_hash = :crypto.hash(:sha512, password)
    {actual_password_hash == guessed_password_hash, password}
  end
end
