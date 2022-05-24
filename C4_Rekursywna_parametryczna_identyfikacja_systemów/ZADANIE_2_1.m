clear all;
%% Czesc 1. do odpalenia simulinka
global Tp Tend Td
Tend = 1500; % horyzont czasowy symulacji
Td = 500; % czas, po ktorym jest zmiana b2o
Tp = 0.1; % okres probkowania

global epsilon_max
 
global c1o
c1o = 0; % zak³ócanie szumem bia³ym w równaniu regresyjnym

fu = 0.025; % czestotliwosc sygnalu prostokatnego 

global P_RLS phatRLS ro_RLS_lambda % P - macierz kowariancyjna, p - estymata wektora
ro_RLS_lambda = 2; % mnoznik macierzy P
d = 3; % liczba estymowanych parametrow (a1o, b2o, a2o)
P_RLS = ro_RLS_lambda * eye(d); % warunek poczatkowy P^IV(0) z wyboru arbitralnego ro*I
phatRLS = [0; 0; 0]; % estymata wektora parametrow: a1 a2 b2 - warunek poczatkowy

metoda = 1; % aktualna metoda adaptacyjnej identyfikacji systemu
% 1 -> RLS lambda ze wspolczynnikiem zapominania lambda
global lambda
lambda = 0.98; % Wspolczynnik zapominania z zakresu  [0.98; 0.999].
% 2 -> resetowanie macierzy
k_R1_RLS = 1; % wartosc poczatkowa k dla metody R1. resetowanie okresowe
T = 101; % okres resetowania
% 3 -> 
% 4 ->

global trace_P_RLS % Slad macierzy
trace_P_RLS = trace(P_RLS); % Slad macierzy warunek poczatkowy

epsilon_max = 0;
global P_min
P_min = 0; % min œlad macierzy P
%% Po symulacji w simulinku
% 2_1 3 kropka - wyswietlenie sladu macierzy P metoda RLS Lambda
% wspolczynnik zapominania
sim('proba_2_1_dziala');

figure;

plot(time', trace_P_RLS(3:15003));
grid on;
title('Slad macierzy P');
legend('przebieg sladu macierzy P_RLS');

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
title('Porownanie y[n] oraz y^[n|n-1] metody RIV');
legend('Zaklocona odpowiedz obiektu - y[n]', 'odpowiedz predyktora jednokrokowego - y^[n|n-1]');
