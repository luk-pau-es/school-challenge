# SchoolChallenge

# Zasady konkursu

Uczestnikami konkursu mogą by tylko uczestniczy wiosennej edycji Szkoły Elixira 2023.
Zadanie polega na zaimplementowaniu funkcji `guess_password` w module `PasswordCrackerChallenge`.
Funkcja przyjmuje hash hasła i jej zadaniem jest znaleźć oryginalne hasło, albo hasło którego hasz jest taki sam jak oryginalnego hasła.
Funkacja haszująca to sha512.
Rozwiązanie zadania prosimy wysłać jako Pull Request do repozytorium.
Rozwiązanie jest sprawdzane automatycznie przez GitHub Actions i testy znajdujące się w module `PasswordCrackerChallengeTest`

Założenia i informacje:

- przyjmowane są rozwiązania wyłącznie w jęzku Elixir/Erlang
- generowane hasła składają się z małych liter a-z (abcdefghijklmnopqrstuvwxyz)
- hasła mają długość 1 do 10 liter
- można tworzyć dowolną liczbę modułów i wykorzysytwać dowolne biblioteki
- można dopisać własne testy do implementacji (tylko w nowych modułach)
- nie można w jakikolwiek sposób modyfikować modułu `PasswordCrackerChallengeTest`
- GitHub Actions wykorzystuje Elixir 1.14.3 oraz Erlang 25.2.2

Wygrywają 2 osoby, które jako pierwsze dostarczą działające rozwiązanie - kolejność zgłoszonych rozwiązań
rozstrzyga timestamp commita, który przechodzi wszystkie testy.
(wyznaczniekiem są przechodzące testy na GHActions oraz weryfikacja przez organizatorów).
Wszelkie niejasności i wątpliwości będą rozstrzygnięte przez organizatora konkursu.

TIPS:

- polecamy zrównoleglić szukanie rozwiązania za pomocą wielu procesów
