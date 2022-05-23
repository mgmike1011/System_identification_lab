clear all; clc;
%% Czesc 1. do odpalenia simulinka - RLS resetowanie i RIV resetowanie (tu c1o = 0.7)
global Tp Tend Td k epsilon_max
Tp = 0.1;
Td = 500;
Tend = 1500;
k = 1;

global c1o
c1o = 0; % wymuszenie zaklocenia kolorowego w rownaniu regresji

fu = 0.025; % czestotliwosc sygnalu prostokatnego 

global P_RLS_1 phat_RLS_1 d roRLS % P - macierz kowariancyjna, p - estymata wektora
roRLS = 2; % wartosc do inicjalizowania macierzy kowariancyjnej - mnoznik
d = 3; % liczba estymowanych parametrow (a1o, b2o, a2o)
P_RLS_1 = roRLS * eye(d); % warunek poczatkowy P^RLS(0) z wyboru arbitralnego ro*I
phat_RLS_1 = [0; 0; 0]; % estymata wektora parametrow: a1 a2 b2 - warunek poczatkowy

global trace_P_RLS % Slad macierzy
trace_P_RLS = trace(P_RLS_1); % Slad macierzy warunek poczatkowy

epsilon_max = 4; % Skad bierzemy wartosc?

%% Wykreslanie wykresow - po symulacji w Simulinku
sim('RESET_ARMAX_ZADANIE_2_1_RLS_RESET');

figure;

plot(time, ym_RLS, time, y);
grid on;
title('Porownanie ym[n] oraz y[n] metoda RLS - resetowanie');
legend('odpowiedz modelu symulowanego - ym[n]', 'odpowiedz zaklocona obiektu - y[n]');

figure;

plot(time, ym_RLS, time, yo);
grid on;
title('Porownanie ym[n] symulowana oraz yo[n] niezaklocona metody RLS - resetowanie');
legend('odpowiedz modelu symulowanego - ym[n]', 'odpowiedz idealna obiektu - yo[n]');


figure;

plot(time, y, time, y_pred_RLS);
grid on;
title('Porownanie y[n] oraz y^[n|n-1] metody RLS - resetowanie');
legend('Zaklocona odpowiedz obiektu - y[n]', 'odpowiedz predyktora jednokrokowego - y^[n|n-1]');

figure;

plot(time, trace_P_RLS(3:15003));
grid on;
title('Slad P_RLS');
legend('przebieg sladu macierzy P_RLS');