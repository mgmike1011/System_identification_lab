clear all;
%% Czesc 1. do odpalenia simulinka
global Tp Tend Td
Tp = 0.1; %okres probkowania
Tend = 1000; % horyzont czasowy symulacji
Td = 1500; % czas, po ktorym jest zmiana b2o

global c1o
c1o = 0.99; % wymuszenie zaklocenia kolorowego w rownaniu regresji

fu = 0.025; % czestotliwosc sygnalu prostokatnego 

global PIV_1 phatIV_1 % P - macierz kowariancyjna, p - estymata wektora
roIV = 100; % wartosc do inicjalizowania macierzy kowariancyjnej P^IVch - mnoznik
d = 3; % liczba estymowanych parametrow (a1o, b2o, a2o)
PIV_1 = roIV * eye(d); % warunek poczatkowy P^IV(0) z wyboru arbitralnego ro*I
phatIV_1 = [0; 0; 0]; % estymata wektora parametrow: a1 a2 b2 - warunek poczatkowy

global trace_P_IV % Slad macierzy
trace_P_IV = trace(PIV_1); % Slad macierzy warunek poczatkowy


%% Wykreslanie wykresow - po symulacji w Simulinku
sim('ARMAX_ZADANIE_1_2');

figure;

plot(time, ym_RIV, time, y);
grid on;
title('Porownanie ym[n] oraz y[n] metoda RIV');
legend('odpowiedz modelu symulowanego - ym[n]', 'odpowiedz zaklocona obiektu - y[n]');

figure;

plot(time, ym_RIV, time, yo);
grid on;
title('Porownanie ym[n] symulowana oraz yo[n] niezaklocona metody RIV');
legend('odpowiedz modelu symulowanego - ym[n]', 'odpowiedz idealna obiektu - yo[n]');


figure;

plot(time, y, time, y_pred_RIV);
grid on;
title('Porownanie y[n] oraz y^[n|n-1] metody RIV');
legend('Zaklocona odpowiedz obiektu - y[n]', 'odpowiedz predyktora jednokrokowego - y^[n|n-1]');

figure;

plot(time, trace_P_IV(3:10003));
grid on;
title('Slad P_R_I_V');
legend('przebieg sladu macierzy P_RIV');