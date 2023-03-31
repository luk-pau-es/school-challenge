defmodule PasswordCrackerChallengeTest do
  use ExUnit.Case

  @passwords_count 7
  @max_password_length 7

  for password_length <- 1..@max_password_length do
    test "test #{password_length} chars passwords" do
      for _ <- 1..@passwords_count do
        actual_password =
          1..unquote(password_length)
          |> Enum.to_list()
          |> Enum.map(fn _ -> Enum.random(?a..?z) end)

        IO.inspect(actual_password, label: "Actual password is:")
        actual_password_hash = :crypto.hash(:sha512, actual_password)

        guessed_password = PasswordCrackerChallenge.guess_password(actual_password_hash)
        guessed_password_hash = :crypto.hash(:sha512, guessed_password)
        assert actual_password_hash == guessed_password_hash
      end
    end
  end
end
