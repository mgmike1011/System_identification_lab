clear variables; clc; close all;
load('dane.mat')
% Wyœwietlenie danych
subplot(3,1,1)
plot(t,u);
hold on
plot(t,y);
hold off
xlabel('t [s]')
legend('u','y')
title('Sygna³ steruj¹cy i wyœciowy')
subplot(3,1,2)
plot(t,u)
xlabel('t [s]')
title('Sygna³ wejœciowy do obiektu')
subplot(3,1,3)
plot(t,y)
xlabel('t [s]')
title('Sygna³ wyjœciowy z obiektu')
% Dane wstêpne
Tp = 0.01; % [s] Okres próbkowania
N = length(u); % Iloœæ próbek w eksperymencie
n_y = y(150:end); % Próbki y bez odjêtej sk³adowej sta³ej