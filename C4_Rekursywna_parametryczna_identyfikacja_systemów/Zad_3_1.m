clear variables;
% Zad 3.1.1
Tp = 0.05; % [s]
sigma2e = 0.1;
% Zad 3.1.2
global p;
p = [0;0;0];
global p1 P P1
p1 = p;
P = eye(3);
P1 = eye(3);
% Zad 3.1.3
Tf = 8*Tp; % Sta³a czasowa filtru SVF
N = 20000; % Iloœæ próbek eksperymentu
tend = Tp*N; %D³ugoœæ symulacji