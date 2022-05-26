clear variables; clc; close all;
load('dane.mat')
% Wy�wietlenie danych
subplot(3,1,1)
plot(t,u);
hold on
plot(t,y);
hold off
xlabel('t [s]')
legend('u','y')
title('Sygna� steruj�cy i wy�ciowy')
subplot(3,1,2)
plot(t,u)
xlabel('t [s]')
title('Sygna� wej�ciowy do obiektu')
subplot(3,1,3)
plot(t,y)
xlabel('t [s]')
title('Sygna� wyj�ciowy z obiektu')
% Dane wst�pne
Tp = 0.01; % [s] Okres pr�bkowania
N = length(u); % Ilo�� pr�bek w eksperymencie
n_y = y(150:end); % Pr�bki y bez odj�tej sk�adowej sta�ej