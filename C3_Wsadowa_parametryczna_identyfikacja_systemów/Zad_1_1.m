load IdentWsadowaStat.mat
N = length(DaneStatW); % iloœæ próbek (2501)

% Wyœwietlenie danych pomiarowych z rozdzieleniem na wejœcie i wyjœcie:
u = DaneStatW(1:1:N,1); % pomiary zaklocone szumem bia³ym
y = DaneStatW(1:1:N,2); % pomiary zaklocone szumem kolorowym 

figure
plot(u,y)
title('Wykres wyjœcia od wejœcia')
xlabel('Wejœcie u')
ylabel('Wyjœcie y')

Phi = zeros(N, 4); % utworzenie deterministycznej macierzy regresji, gdzie d = 4