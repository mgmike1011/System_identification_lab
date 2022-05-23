clear all; clc;
%% Czesc 1. do odpalenia simulinka - RLS lambda i RIV resetowanie (tu c1o = 0.7)
global Tp Tend Td lambda epsilon_max P_min k
Tp = 0.1; %okres probkowania
Tend = 1500; % horyzont czasowy symulacji
Td = 500; % czas, po ktorym jest zmiana b2o
k = 1;

global c1o
c1o = 0; % wymuszenie zaklocenia kolorowego w rownaniu regresji
lambda = 0.98;
epsilon_max = 4;
P_min = 0.05;

fu = 0.025; % czestotliwosc sygnalu prostokatnego 

global P_RLS phat_RLS d roRLS % P - macierz kowariancyjna, p - estymata wektora
roRLS = 2; % wartosc do inicjalizowania macierzy kowariancyjnej - mnoznik
d = 3; % liczba estymowanych parametrow (a1o, b2o, a2o)
P_RLS = roRLS * eye(d); % warunek poczatkowy P^RLS(0) z wyboru arbitralnego ro*I
phat_RLS = [0; 0; 0]; % estymata wektora parametrow: a1 a2 b2 - warunek poczatkowy

global trace_P_RLS % Slad macierzy
trace_P_RLS = trace(P_RLS); % Slad macierzy warunek poczatkowy

% Wybor metody 
global metoda 
% 1 -> 3 kropka, RLS ze wspolczynnikiem zapominania lambda 
metoda = 1; 

%% Wykreslanie wykresow - po symulacji w Simulinku
sim('ARMAX_ZADANIE_2_1_RLS');

figure;

plot(time, ym_RLS, time, y);
grid on;
title('Porownanie ym[n] oraz y[n] metoda RLS');
legend('odpowiedz modelu symulowanego - ym[n]', 'odpowiedz zaklocona obiektu - y[n]');

figure;

plot(time, ym_RLS, time, yo);
grid on;
title('Porownanie ym[n] symulowana oraz yo[n] niezaklocona metody RLS');
legend('odpowiedz modelu symulowanego - ym[n]', 'odpowiedz idealna obiektu - yo[n]');


figure;

plot(time, y, time, y_pred_RLS);
grid on;
title('Porownanie y[n] oraz y^[n|n-1] metody RLS');
legend('Zaklocona odpowiedz obiektu - y[n]', 'odpowiedz predyktora jednokrokowego - y^[n|n-1]');

figure;

plot(time, trace_P_RLS(3:15003));
grid on;
title('Slad P_RLS');
legend('przebieg sladu macierzy P_RLS');