defmodule PasswordCrackerChallenge do
  @doc """
  Funkcja przyjmuje hash oryginalnego hasła
  Zwraca znalezione hasło na podstawie oryginalnego hasha
  jako listę znaków - np. 'abc'

  TIP: należy zwrócić uwagę, czy apostrofy są '' (lista znaków) czy "" (String, binary)
  """
  def guess_password(hash), do: guess_password(hash, 1, get_basic_charlist())
  def guess_password(_hash, 11, _), do: raise "Password not found"
  def guess_password(hash, number, passwords) do
    result = passwords
    |> Enum.map(&check_password(&1, hash))
    |> Enum.filter(&match?({true, _}, &1))

    if result == [] do
      new_passwords = cross_product(passwords, get_basic_charlist())
      guess_password(hash, number + 1, new_passwords)
    else
      Enum.at(result, 0)
      |> elem(1)
    end
  end

  defp get_basic_charlist() do
    ?a..?z
    |> Enum.to_list()
    |> Enum.chunk_every(1)
  end

  defp check_password(password, actual_password_hash) do
    guessed_password_hash = :crypto.hash(:sha512, password)
    {actual_password_hash == guessed_password_hash, password}
  end

  defp cross_product(a, b) do
    for x <- a, y <- b, do: x ++ y
  end
end
