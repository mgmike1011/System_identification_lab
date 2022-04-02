load IdentWsadowaStat.mat
N = length(DaneStatW); % ilo�� pr�bek (2501)

% Wy�wietlenie danych pomiarowych z rozdzieleniem na wej�cie i wyj�cie:
u = DaneStatW(1:1:N,1); % pomiary zaklocone szumem bia�ym
y = DaneStatW(1:1:N,2); % pomiary zaklocone szumem kolorowym 

figure
plot(u,y)
title('Wykres wyj�cia od wej�cia')
xlabel('Wej�cie u')
ylabel('Wyj�cie y')

Phi = zeros(N, 4); % utworzenie deterministycznej macierzy regresji, gdzie d = 4