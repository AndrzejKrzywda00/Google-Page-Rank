%% testowy plik dla funkcji compressMartix()
% testowanie parametrów dla różnych rodzajów macierzy

clear;

M = [0,0,0,1;
    3,0,2,0;
    0,0,0,0;
    0,0,1,0];

obj = functionsContainer;
[obj,vec] = obj.compressMatrix(M);