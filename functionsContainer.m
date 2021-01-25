%% Klasa przechowująca zestaw niezbędnych funkcji do symulacji działania algorytmu PageRank

classdef functionsContainer
    
    properties
        desription = "Object holds useful functions for web analysis";
    end
    
    methods
        
        %% funkcja generująca rzadką macierz relacji między stronami internetowymi
        % spełnia warunki zawarte w głównym skrypcie "PageRank.m"

        function [genMatrix] = generateWebMatrix(N)

            % pierwszym krokiem jest zerowanie lewej górnej przekątnej
            % żaden węzeł nie ma referencji do samego siebie
            
            M = zeros(N);

            % dla każdej kolumny losuję ile będzie połączeń -- liczba z zakresu od
            % 1 do N
            for i = 1:N
                howManyConnections = randi(N);              % losuję ile będzie połączeń
                indexes = randperm(N,howManyConnections);   % ustalam listę bez powtórzeń, na jakich indeksach wystąpią połączenia
                for j = 1:howManyConnections
                    M(i,indexes(i)) = 1/N;                  % przypisuję odpowiednim kolumnom ustaloną stałą wartość
                end      
            end
    
            % graphical check
            HeatMap(M);
            
            genMatrix = 3;
            
        end
    end
end