clear variables; clc;
load IdentWsadowaStat.mat % ladowanie danych
% Sprawdziæ wp³yw liczby N np. co dziesi¹ta para:
% np. u = DaneStatW(1:10:N,1); % pomiary zaklocone szumen bia³ym
N = length(DaneStatW); % iloœæ próbek (2501)
d = 4; % z instrukcji ze wzoru 6

% SZUM BIA£Y
% rozdzielenie danych na wejœcie i wyœcie
u = DaneStatW(1:1:N,1); % pomiary zaklocone szumen bia³ym
y = DaneStatW(1:1:N,2); % pomiary zaklocone szumem bia³ym 

% Wyswietlenie danych pomiarowych
figure
plot(u,y, 'o')
title('Wykres wyjœcia od wejœcia')
xlabel('Wejœcie u')
ylabel('Wyjœcie y')

fi = zeros(N, d); % utworzenie regresora jako macierzy 0, duze Phi
fi(:,1) = 1; % 1 w pierwszej kolumnie
for i = 2:d
    fi(:,i) = fi(:,i-1)./u; % deterministyczna macierz regresji zale¿na 
    %od deterministycznego wejœcia u
end
p_estymator_LS = pinv(fi)*y; % wyk³ad strona 19, estymator metody LS
y_estyma = fi*p_estymator_LS; % model w postaci regresji liniowej 

% SZUM KOLOROWY
u_kolor = DaneStatC(1:1:N,1); % pomiary zaklocone szumem kolorowym
y_kolor = DaneStatC(1:1:N,2); % pomiary zaklocone szumem kolorowym

fi1 = zeros(N, d); % utworzenie regresora jako macierzy 0 
fi1(:,1) = 1; % 1 w pierwszej kolumnie
for i = 2:d
    fi1(:,i) = fi1(:,i-1)./u_kolor; % uzupe³nienie kolumn fi(u)
end
p1_estymator_LS_kolor = pinv(fi1)*y_kolor; % wzór (4)
y1_estyma_kolor = fi1*p1_estymator_LS_kolor; % pod wzorem (2)

% Wykres danych pomiarowych i zidentyfikowanych odwzorowañ: 
% Szum bia³y, DaneStatW
figure
subplot(2,1,1);
plot(u, y, 'o') 
hold on
plot(u, y_estyma, 'r')
grid on
title('Dane pomiarowe oraz zidentyfikowane odwzorowanie z szumem bia³ym')
hold off

% Szum kolorowy, DaneStatC
subplot(2,1,2);
plot(u_kolor, y_kolor, 'o')
hold on
plot(u_kolor, y1_estyma_kolor, 'r')
grid on
title('Dane pomiarowe oraz zidentyfikowane odwzorowanie z szumem kolorowym')
hold off

% Macierz kowariancji dla danych zaklóconych szumem bialym
ei = y - y_estyma; % ei - b³¹d resztowy wzór (5)
sigma2 = 1 / (N - d) * sum(ei.^2); % estymata wariancji zak³ócenia (5)
cov = sigma2 * inv(fi'*fi); % obliczenie kowariancji wzór 5

% Okreœlanie przedzia³ow ufnoœci dla 95% instrukcja wzór 22 i 23
for i = 1:d
   odchylenie = 1.96*sqrt(cov(i,i)); % odchylenie przedzia³u ufnoœci 
   lewo(i)  = p_estymator_LS(i) - odchylenie; 
   prawo(i) = p_estymator_LS(i) + odchylenie; 
end
ufnosc = [lewo; prawo]';
