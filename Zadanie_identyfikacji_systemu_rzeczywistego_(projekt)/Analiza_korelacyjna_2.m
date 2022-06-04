clear variables; clc;
% Za�adowanie danych
load('dane_.mat');
% Podstawowe dane
Tp = 0.01; % [s] Okres pr�bkowania
N = length(u_); % Ilo�� pr�bek w eksperymencie
t_odp_skok = t_(1:499);
y_odp_skok = y_(499:997);
u_odp_skok = u_(499:997);
%% Spos�b Andrzeja 
M = 50;
ryu = zeros(M, 1);
for tau=0:M-1
    ryu(tau + 1) = Covar([y_, u_], tau);
end
Ruu = zeros(M, M);
for i=0:M-1
    for j=0:M-1
        Ruu(i+1, j+1) = Covar([u_, u_], j - i);
    end
end
gM1 = 1/Tp*pinv(Ruu) * ryu;
t = ((0:M-1) * Tp)';
plot(t,gM1);

%% Spos�b Aga i Mi�osz
% Autokorelacja w�asna i wzajemna
ryu = zeros(1,N);
ruu = zeros(1,N);
for i=1:N
   ryu(i) = Covar([y_ u_], i-1); % korelacja wzajemna yu
   ruu(i) = Covar([u_ u_], i-1); % autokorelacja u
end
M = 50; % Horyzont oszacowania
ryu=ryu(1:M); % zapisanie w postaci 1 wiersza o d�ugo�ci M
% ograniczenie liczby pr�bek autokorelacji do M
ruu=ruu(1:M); % zapisanie w postaci 1 wiersza o d�ugo�ci M
ruuo=ruu(M:-1:1); % odwr�cenie osi
ruuo=ruuo(1:M-1); % zmniejszenie liczby pr�bek odwr�conego
ru=[ruuo  ruu]; % po��czenie sygna�u z jego odbiciem

Ruu = zeros(M,M);
for i=1:1:M
    for j=1:1:M
        Ruu(j,i)=ru(i-j+M); % Macierz Ruu
    end
end
pseudoodwrotna_Ruu = pinv(Ruu);
odp_impuls= pseudoodwrotna_Ruu*ryu'/Tp;
% Wy�wietlenie danych
t_odp = 0:Tp:M*Tp-Tp;
plot(t_odp,odp_impuls);
title('Odpowied� impulsowa z analizy korelacyjnej');
xlabel('Czas [s]')
grid on