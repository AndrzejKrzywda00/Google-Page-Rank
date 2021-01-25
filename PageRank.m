%% PROJEKT NA LABORATORIUM Z TONTU.
% Autor -- Andrzej Krzywda
% Data -- 23.01.2021

clear;
clc;

N = 50; % rozmiar badanej sieci połączeń ze stronami
d = 0.85; % współczynnik tłumienia
r = ones(N,1); % pionowy wektor r to wektor rang stron internetowych

%% normalizacja wektora r do wartości 1/N.
% można zacząć od dowolonych wartości ale heurystycznie przyjęta wartość
% 1/N -- założenie początkowe, że każdy link ma takie samo znaczenie
% zapewnia dobre wartości na początek algorytmu

for i = 1:N
    r(i) = r(i)/N;
end

%% tworzenie macierzy M -- macierzy opisu relacji między stronami internetowymi
% zakładam że odpowiednio duży i reprezentatywny zbiór stron internetowych
% będzie cechował się rozkładem Pareta -- czyli asymetrycznym
% rozłożeniem relacji między stronami internetowymi w obszarze

M = generateWebMatrix(N); % generowanie macierzy wag połączeń między stronami

% wytyczne dla funkcji:
% 1) macierz musi być rzadka - większość stron nie ma połączeń
% do wszystkich pozostałych
% 2) macierz musi mieć mało wierszy o dużej sumie wartości oraz wiele
% wierszy o małej sumie wartości
% 3) wartości w każej kolumnie muszą sumować się do 1

[sumInRows,SumOfZeros] = sumRows(N,M);
ZerosPercentage = SumOfZeros/(N*N)*100; % wyliczam procentowy współczunnik zapełnienia zerami
ssr = sort(sumInRows);
[tails,dw] = distributeVector(ssr);

figure('Renderer', 'painters', 'Position', [10 10 900 600]);
stem(1:N,sumInRows,'red','LineWidth',3);
title('Rozkład linków prowadzących do danej strony (GĘSTOŚĆ PRAWDOPODOBIEŃSTWA)');
subtitle('Suma wartości we wszystkich kolumnach z danego wiersza macierzy M');
xlabel('indeks strony internetowej');
ylabel('metryka prawdopodobieństwa trafienia na stronę');

figure('Renderer', 'painters', 'Position', [10 10 900 600]);
plot(1:N+tails,dw,"LineWidth",2);
title('Rosnący rozkład linków prowadzących do danej strony (DYSTRYBUANTA)');
subtitle('Suma wartości we wszystkich kolumnach z danego wiersza macierzy M');
xlabel('indeks strony internetowej');
ylabel('metryka prawdopodobieństwa trafienia na stronę');

%% obszar dokonywania obliczeń właściwych czyli wyznaczania wektora r
% musi zostać spełnione równanie;
% r = Lr gdzie L jest odpowiednią macierzą
% zatem -- szukamy największej wartości własnej macierzy L
% i towarzyszącejmu jej wartości wektora własnego r

I = ones(N,N);             % odpowiednia macierz jednostkowa
L = d.*M + ((1-d)/N).*I;  % ważne przekształcenie macierzy M -> L
%image(L*2550);

[V,D] = eig(M);
sumo = zeros(1,N);

for i = 1:N
    summ = 0;
    for j = 1:N
        summ = summ + M(j,i); 
    end
    sumo(i) = summ;
end

% wybieram iteracyjną metodę potęgową i wyliczam kolejne wartości r
r_prim = L*r;
howManyIterations = 1;

while (~endComputingL(r,r_prim,N))
    r = r_prim;
    r_prim = L * r_prim;
    howManyIterations = howManyIterations + 1;
end

%% obszar definiowania funkcji

%% funkcja generująca rzadką macierz relacji między stronami internetowymi
        % spełnia warunki zawarte w głównym skrypcie "PageRank.m"

function genMatrix = generateWebMatrix(N)

    % pierwszym krokiem jest zerowanie lewej górnej przekątnej
    % żaden węzeł nie ma referencji do samego siebie
            
    M = zeros(N);
    fullIndexes = randperm(N);          % całościowa lista permutacji dostępnych indeksów

    % dla każdej kolumny losuję ile będzie połączeń -- liczba z zakresu od
    % 1 do N
    for i = 1:N
        % losuję ile będzie połączeń
        % podaję parametry
        %% MAGIC NUMBERS !!! - FIX
        mean = 6;
        standardDeviation = 5;
        howManyConnections = GenConnections(mean,standardDeviation);
        
        if ( howManyConnections > 0 )                                 % tylko gdy są połączenia
            indexes = getIndexes(howManyConnections,N,fullIndexes); % ustalam listę bez powtórzeń, na jakich indeksach wystąpią połączenia
            for j = 1:howManyConnections
                M(indexes(j),i) = 1/howManyConnections;               % przypisuję odpowiednim kolumnom ustaloną stałą wartość
            end
        end
    end
    
    % graficzne przedstawienie
    %plot(M);
    %imshow(M);
    image(M*2550);
            
    genMatrix = M;
            
end

%% funkcja pomocnicza sumująca wartości w wierszach żeby zapewnić pożądany
% rozkład wartości

function [sumR,sumAll] = sumRows(N,M)
    sumR = zeros(N,1);
    sumAll = 0;
    for i = 1:N                         % i odpowiada za iterowanie po wierszach
        sumLoc = 0;
        for j = 1:N
            sumLoc = sumLoc + M(i,j);
            if M(i,j) == 0
                sumAll = sumAll + 1;
            end
        end
        sumR(i) = sumLoc;
    end
                                        % zwracam wektor wartości zsumowanych w wierszach
end


%% funkcja generuje losowo o określonych parametrach ilość linków ze strony
% jest to po prostu zmodyfikowany rozkład normalny

function howManyLinks = GenConnections(mean,standardDeviation)
    generatedNum = round(random('Normal',mean,standardDeviation)); % generating Normal distribution with my custom parameters
    if ( generatedNum < 0 )
        generatedNum = 0;
    end
    howManyLinks = generatedNum;
end


%% funkcja generująca losowy zbiór indeksów na których wystąpią połączenia
% jest złożeniem funkcji randperm() z losowymi parametrami innych rozkładów

function indexesList = getIndexes(howManyIndexes,N,fullIndexes)
    generatedList = zeros(1,howManyIndexes);
    mean = N/2;                                        % dokładnie wartość środkowa zbioru
    howDenseParameter = 6;                             % parametr rozrzucenia rozkładu
    standardDeviation = N/howDenseParameter;           % 95,9 % wyników mieści się w przedziale <1;N>
    for i = 1:howManyIndexes
        
        currentIndex = round(random('Normal',mean,standardDeviation));
        
        if ( currentIndex > N )
            currentIndex = N;
        end
        
        if ( currentIndex < 1 )
            currentIndex = 1;
        end
        
        generatedList(i) = fullIndexes(currentIndex);
    end
    indexesList = generatedList;                       % zwraca listę o długości howManyIndexes
end


%% funkcja rozwijająca zbiór rosnący w dystrybuantę
% dodawanie "ogonów" charakerystycznych dla dystrybuanty

function [tails,dist] = distributeVector(v)
    [lengthV,~] = size(v);
    scale = 4;
    tail = round(lengthV/scale);
    lenD = lengthV + 2 * tail;
    distribution = zeros(1,lenD);
    upValue = v(lengthV);
    
    for i = 1:lenD
        if ( i <= tail )
            distribution(i) = 0;
        end
        if ( i >= lenD-tail )
            distribution(i) = upValue;
        end
        if ( i > tail && i < lenD-tail )
            distribution(i) = v(i-tail);
        end
    end
    dist = distribution;
    tails = 2 * tail;
end

%% funkcja sprawdzająca jaka jest zmiana wektora r(i+1) w stosunku do wektora r(i)
% jeśli wszystkie składowe wektora r zmieniły się o mniej niż err
% to zwracam true; w przeciwnym przypadku false

function metric = endComputingL(r,new_r,N)
    error = 1/N;                               % idealnie gdyby to zależało od średniej wartości wpisu
    for i = 1:N                                        
        if ( abs(r(i)-new_r(i)) >= error )      % gdy tylko jedna różnica jest większa niż error to zwracam false
            metric = false;
            return;
        end
    end
    metric = true;
end
