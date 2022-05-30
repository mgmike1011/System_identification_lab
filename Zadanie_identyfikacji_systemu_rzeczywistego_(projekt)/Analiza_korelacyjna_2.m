clear variables; clc;
% Za³adowanie danych
load('dane_.mat');
% Podstawowe dane
Tp = 0.01; % [s] Okres próbkowania
N = length(u_); % Iloœæ próbek w eksperymencie
% Autokorelacja w³asna i wzajemna
ryu = zeros(1,N);
ruu = zeros(1,N);
for i=1:1:N
   ryu(i) = Covar([y_ u_], i-1); % korelacja wzajemna yu
   ruu(i) = Covar([u_ u_], i-1); % autokorelacja u
end
M = 100; % Horyzont oszacowania

ryu=ryu(1:M); % zapisanie w postaci 1 wiersza o d³ugoœci M

% ograniczenie liczby próbek autokorelacji do M
ruu=ruu(1:M); % zapisanie w postaci 1 wiersza o d³ugoœci M

ruuo=ruu(M:-1:1); % odwrócenie osi
ruuo=ruuo(1:M-1); % zmniejszenie liczby próbek odwróconego
ru=[ruuo  ruu]; % po³¹czenie sygna³u z jego odbiciem

Ruu = zeros(M,M);
for i=1:1:M
    for j=1:1:M
        Ruu(j,i)=ru(i-j+M); % Macierz Ruu
    end
end

pseudoodwrotna_Ruu = pinv(Ruu);
odp_impuls= pseudoodwrotna_Ruu*ryu'/Tp;
% Wyœwietlenie danych
t_odp = 0:Tp:M*Tp-Tp;
plot(t_odp,odp_impuls);
title('OdpowiedŸ impulsowa z analizy korelacyjnej');
xlabel('Czas [s]')
grid on