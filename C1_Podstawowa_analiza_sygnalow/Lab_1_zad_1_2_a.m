close all; clear; clc;
load('StochasticProcess.mat')
% Zadanie 1.1
hold on
plot(StochasticProcess(1,:), StochasticProcess(2,:))
plot(StochasticProcess(1,:), StochasticProcess(3,:))
plot(StochasticProcess(1,:), StochasticProcess(4,:))
hold off
title('Przyk³adowe przebiegi')
% Wartoœæ oczekiwana
Mn = mean(StochasticProcess(2:end, :)); %Po zbiorze
M = mean(StochasticProcess(2:end,:), 2); %Po pojedynczej realizacji
% Plot mn i m - wartoœæ oczekiwana zmiennej losowej, 
figure;
plot(M)
hold on
plot(Mn)
hold off
legend('Po czasie','Po zbiorze')
title('Wartoœci oczekiwane')
% Wartoœci oczekiwane pojedyncze/uœrednione
mi = mean(Mn); %Ze zbioru
m = mean(M); %Po czasie
% Wariancja w postaci wektorów
Sig2_n = var(StochasticProcess(2:end, :), 1); %Po wszytskich
Sig2 = var(StochasticProcess(2:end, :), 1, 2); %Po pojedynczej realizacji
figure;
plot(Sig2)
hold on
plot(Sig2_n)
hold off
title('Estymatory wariancji')
legend('Po czasie','Po zbiorze')
% Wartoœæ pojedyncza wariancji po zbiorze:
sig2_n = mean(Sig2_n);
% Wartoœæ pojedyncza wariancji z pojedynczej realizacji:
sig2 = mean(Sig2);