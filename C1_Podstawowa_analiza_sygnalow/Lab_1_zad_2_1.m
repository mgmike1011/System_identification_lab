%clear all; clc;
%Gêstoœci widmowe mocy N - elementowych sekwencji sygna³ów

%Dane:
Tp = 0.001; %okres próbkowania
H = tf([0.1],[1 -0.9],Tp); 
N = 2000; % Defaultowa wartoœæ

sigma_kwadrat = 0.64; %z zadania 1.3
sigma = sqrt(sigma_kwadrat); 

x = zeros(1,N);
v = zeros(1,N);

tn = (0:N-1)*Tp;

%Sygna³y (skoñczone sekwencje ich próbek):
e = sigma * randn(1,N); %szum bia³y 
for n = 1:N
    x(n) = (sin(2*pi*5*n*Tp) + 0.5*sin(2*pi*10*n*Tp) + 0.25*sin(2*pi*30*n*Tp));
    v = (lsim(H,e,tn))'; %transpozycja aby by³ wymiar 1x2000
end 
    
% 2.1.1 Wyœwietlanie wykresów:
subplot(3,1,1)
plot(e)
title('Szum bia³y e(n)')
subplot(3,1,2);
plot(x)
title('Spróbkowany w czasie sygna³ - x(nTp)')
subplot(3,1,3)
plot(v)
title('Szum kolorowy')

% 2.1.2 Obliczenie i wyœwietlenie dyskretnego widma amplitudowego:
DFT = fft(x); % Dla Tp = 1
DFT_Tp = Tp*DFT; % Wynik wymno¿ony *Tp
m = abs(DFT_Tp); % |X_N|
f = (0:length(DFT_Tp)-1)*N/length(DFT_Tp); %wektor czêstotliwoœci

% Przeskalowane modu³y, aby uzyskaæ zgodnoœæ wysokoœci pr¹¿ków z A
% sk³adowych sinusoidalnych:
przeskalowane_XN = (2*m/(N*Tp)); 

figure
subplot(2,1,1)
plot(f,m)
title('DFT (XN) nieprzeskalowane')
subplot(2,1,2)
plot(f, przeskalowane_XN)
title('Przeskalowane modu³y X_N')

%Interpretacja wyników zadania 2.1.2:
%Dlaczego nieprzeskalowane i przeskalowane s¹ takie same??

% 2.1.3 Wp³yw N na jakoœæ widma amplitudowego:
% Wnioski dla N = 1000
% Wnioski dla N = 200
% Wnioski dla N = 100

% 2.1.4. Spe³nienie twierdzenia Parsevala (jeœli s¹ sobie równe - spe³nione twierdzenie):
sum_x2=sum(x.^2);
E_1 = Tp*sum_x2; %ca³kowita energia, wzór pierwszy po znaku równa siê

periodogram=m.^2/(N*Tp); % estymator - periodogram
sum_per=sum(periodogram); % suma, wzór na ca³kowit¹ energiê

%Wniosek: wartoœci s¹ sobie równe, spe³nione jest twierdzenie Parsevala

% 2.1.5 Estymatory (14) i (15) - gêstoœæ widmowa:
