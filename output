Prezentacja działania kodu zawartego w pliku PageRank.m

Program generuje macierz rzadką stochastyczną lewą - tj. w każdej kolumnnie wartości sumują się do jednego. 
Dzięki temu z twierdzenia Frobeniusa, największą wartością własną takiej macierzy jest 1.

Każdą kolumnę należy interpretować jako rozkład linków prowadzących do danego indeksu strony internetowej.
na przykład : M(1,2) = 0,2 -> prawdopodobieństwo przejścia ze strony 1 do 2 wynosi 20%.

Dzięki manipulowaniu parametrami rozkładu normalnego, dla każdej kolumny uzyskuję rozkład równomierny,
natomiast dla każdego wiersza rozkład jest asymetryczny.
Widać to w obcenych charakterystycznych poziomych prążkach na histogramie macierzy (rys. 1).
![alt text](https://github.com/AndrzejKrzywda00/Projekt_TONT/blob/master/output images/matrix_M.jpg?raw=true)

Kilka stron zawiera wiele linków do nich, natomiast wiele stron zawiera niewiele linków do nich (rys. 2).

Można też obejrzeć posortowany rozkład prawdopodobieństwa trafienia w daną stronę. (rys. 3).

Gdy istnieje wygenerowana losowa macierz M implementuję właściwy algorytm PageRank.
Zapisuję macierz L = (dM+(1-d)/N*E) (wszystkie parametry i ich objaśnienie znajduje się w kodzie).
I rozwiązuję równanie r = L*r metodą potęgową.

Ostatecznie dostaję wynik w wektorze własym r - na wykresie przedstawiono rozkład ważności stron (rys. 4).
