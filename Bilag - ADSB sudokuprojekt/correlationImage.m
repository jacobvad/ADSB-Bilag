function [grid] = correlationImage(boundImage)
%CORRELATIONIMAGE
% I Denne kode bliver der lavet en grid matrix, som svarer til sudoku
% pladen i billedet. Der vil her blive anvendt krydskorrelation og eulors
% metode for at finde tallene i billederne. 

%Initialisering af buffere
corrMatrix = {};
statistic = {};
maxValues = {};
value = [];
tempL = [];

%Indlæsning af billede til krydskorrelation
for i = 0:9
    corrMatrix{end+1,1} = imread(i+".jpg");
end

%Krydskorrelation laves og alle værdierne lægges i statistics cellen
for j = 1:81
    for i = 1:10
        temp = imcomplement(boundImage{j,1});
        temp_corr = imcomplement(corrMatrix{i,1});
        statistic{end+1,1} = xcorr2(temp(5:35,5:35),temp_corr(5:35,5:35));
    end
end

%Her findes alle max værdierne i hver korrelation
for i = 1:810
    temp = max(statistic{i,1});
    maxValues{end+1,1} = max(temp);
end

%Her findes tallet som findes:
for j = 1:10:810
    for i = j:j+9
        tempL(end+1) = maxValues{i,1};
    end
    [~, index] = max(tempL);
    value(end+1) = index-1;
    if tempL(tempL == 0)
        value(end) = 0;
    end
    tempL = [];
end

%Her tjekkes for 1 & 3 blev forvekslet med 4 eller 8 (eulers metode)
for i = 1:81
    if (value(i) == 4)
       temp = bweuler(imcomplement(boundImage{i,1}(5:35,5:35)),8);
       if (temp == 1)
               value(i) = 1;
       end
       if (temp == 0)
               value(i) = 4;
       end
    end
    if (value(i) == 8 )
       temp = bweuler(imcomplement(boundImage{i,1}(5:35,5:35)),8);
       if (temp == 1)
               value(i) = 3;
       elseif (temp == -1)
               value(i) = 8;
       end
    end    
end

%Her laves grid med tallene i sudoku pladen
grid = zeros(9,9);
%Sudoku pladen indlæses i grid matrixen og denne matrix returneres til main
%funktionen
grid(1:9,1) = value(1:9);
grid(1:9,2) = value(10:18);
grid(1:9,3) = value(19:27);
grid(1:9,4) = value(28:36);
grid(1:9,5) = value(37:45);
grid(1:9,6) = value(46:54);
grid(1:9,7) = value(55:63);
grid(1:9,8) = value(64:72);
grid(1:9,9) = value(73:81);

end
