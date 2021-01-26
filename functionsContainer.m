%% Klasa przechowująca zestaw niezbędnych funkcji do symulacji działania algorytmu PageRank

classdef functionsContainer
    
    properties
        desription = "Object holds useful functions for web analysis";
    end
    
    methods
        
        %% Funkcja zapisująca macierz sparse NxN do skompresowanego formatu
        % można ją wykorzystać przy zapisywaniu macierzy stochastycznej
        % macierz jest konwertowana do wektora, o krótszej długości
        % macierz musi spełniać warunek nieujemności wartości zapisanych

        % Uwaga! funkcja kompresuje macierz liniowo od górnego lewego rogu
        % przez kolejne kolumny
        % następnie zmienia wiersz
        % funkcja jest czuła na ciągi dłuższe niż 3 zera

        % symbolem wskazującym na początek skompresowanego fragmentu jest -1
        % następnie następuje informacja jak wiele zer znajduje się w ciągu
        % następnie dopisywany jest numer sekwencyjny, dzięki niemu można sprawdzić
        % czy np. odtworzono poprawnie zaszyfrowany 

        function [compresionLevel,outputVector] = compressMatrix(M)
            zeroCounter = 0;                % parametr zliczający ile zer w danym ciągu wystąpi
            patchIndicator = -1;            % stała wartość -- symbol charakterystyczny dla kompresji
            sequenceNumber = 1;
            outputVector = zeros(1,3);

            for i = 1:N
                for j = 1:N
                    if ( M(i,j) <= tolerance )
                        zeroCounter = zeroCounter + 1;      % to znaczy że trafiłem w zero
                    else
                        if ( zeroCounter > 3 )
                            outputVector = [outputVector,patchIndicator,zeroCounter,sequenceNumber];
                            zeroCounter = 0;
                            sequenceNumber = sequenceNumber + 1;
                        else
                            for k = 1:zeroCounter
                                outputVector = [outputVector,0];
                            end
                            zeroCounter = 0;
                        end
                        
                    end
                    
                    if ( zeroCounter > 3 ) 
                        
                    end
                end     
            end

        end 

    end
end