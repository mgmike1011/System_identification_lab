clear all; close all;
% Zad 1.1.1

% Zad 1.1.2
% Zapis w postaci regresji liniowej: 
    % y(n) = [-y(n-1) -y(n-2) u(n-2) e(n-1)]*[a1; a2; b2; c1] + e(n)
    
% Zad 1.1.3
Tp = 0.1; % [s] - okres próbkowania
Tend = 1500; % [s] - horyzont czasowy symulacji 
Td = 500; % [s] - czas zmiany parametru b2

% Zad 1.1.4
% Deklaracja zmiennych
global c1o;
c1o = 0;
% Symulacja
global P1_ p1_ lambda
P1_ = eye(3);
p1_ = [0;0;0];
lambda = 0.98;
