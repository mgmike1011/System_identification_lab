clear variables;
% Zad 3.1.1
Tp = 0.05; % [s]
sigma2e = 0.1;
% Zad 3.1.2
global p; % wektor parametr�w [a1;a2;b]
p = [0;0;0]; % warto�ci pocz�tkowe estymat
global p1 P P1 
p1 = p; % poprzednia estymata
P = eye(3); % macierz kowariancyjna
P1 = eye(3); % Poprzednia macierz kowariancyjna
% Zad 3.1.3
Tf = 8*Tp; % Sta�a czasowa filtru SVF
N = 20000; % Ilo�� pr�bek eksperymentu
tend = Tp*N/10; %D�ugo�� symulacji

sim('SystemSISOC')