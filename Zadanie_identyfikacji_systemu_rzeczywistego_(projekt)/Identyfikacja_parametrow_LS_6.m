% Identyfikacja parametrow modelu czasu dyskretnego metoda LS
clear variables; clc;

% Zaladowanie danych
load('dane_.mat')

% Podstawowe dane
Tp = 0.01; % [s] Okres próbkowania
N = length(u_); % Iloœæ próbek w eksperymencie
d = 4; % Liczba parametrow
% t_, y_, u_ - czas, odpowiedz, pobudzenie z danych

% Podzia³ danych pomiarowych na 2 podzbiory
Z_est_u = u_(1:(length(u_)/2)); % Dane estymuj¹ce u 
Z_est_y = y_(1:(length(u_)/2)); % Dane estymuj¹ce y 

Z_wer_u = u_((1+(length(u_)/2)):end); % Dane weryfikuj¹ce u 
Z_wer_y = y_((1+(length(u_)/2)):end); % Dane weryfikuj¹ce y 

N_est = length(Z_est_u);
N_wer = length(Z_wer_u);
%% Delta + 
% Identyfikacja parametrów metod¹ LS:
    % Regresor
y_n_1 = [0;Z_est_y(1:end-1)];
y_n_2 = [0;0;Z_est_y(1:end-2)];
u_n_1 = [0;Z_est_u(1:end-1)];
u_n_2 = [0;0;Z_est_u(1:end-2)];
fi_C = [-y_n_1,-y_n_2,u_n_1,u_n_2];
    % Estymator LS parametrow modelu
p_N_LS = pinv(fi_C)*Z_est_y;
% Obliczenie parametrów
a1 = (p_N_LS(1)+2)/Tp;
a2 = (p_N_LS(2)-1+a1*Tp)/Tp^2;
b1 = p_N_LS(3);
b2 = (p_N_LS(4)+b1)/Tp;
params=[a1;a2;b1;b2];
%% Tustin - z³a struktura
y_n_1 = [0;Z_est_y(1:end-1)];
y_n_2 = [0;0;Z_est_y(1:end-2)];
u_n_2 = [0;0;Z_est_u(1:end-2)];
u_n_1 = [0;Z_est_u(1:end-1)];
u_n = Z_est_u;
u_n_cal = u_n_2+2.*u_n_1+u_n;
fi_C = [y_n_1,-y_n_2,u_n_cal];
    % Estymator LS parametrow modelu
p_N_LS = pinv(fi_C)*Z_est_y;
% Obliczenie parametrów
params=[2*p_N_LS(1)*Tp,(p_N_LS(1)*Tp^2+2*Tp^2),0 
        (2*Tp*p_N_LS(2)+2*Tp) ,(Tp^2*p_N_LS(2)-Tp^2) ,0 
        2*Tp*p_N_LS(3) ,Tp^2*p_N_LS(3) ,-Tp^2 ]\[(8-4*p_N_LS(1));(4-4*p_N_LS(2));-4*p_N_LS(3)];
%% Delta -
y_n_1 = [0;Z_est_y(1:end-1)];
y_n_2 = [0;0;Z_est_y(1:end-2)];
u_n_2 = [0;0;Z_est_u(1:end-2)];
u_n_1 = [0;Z_est_u(1:end-1)];
u_n = Z_est_u;
fi_C = [-y_n_2,-y_n_2,u_n_1,u_n];
    % Estymator LS parametrow modelu
p_N_LS = pinv(fi_C)*Z_est_y;
% Obliczenie parametrów
params=[p_N_LS(1)*Tp,(p_N_LS(1)*Tp^2),0 ,0
        (Tp*p_N_LS(2)+Tp) ,(Tp^2*p_N_LS(2)),0 ,0 
        Tp*p_N_LS(3) ,Tp^2*p_N_LS(3) ,Tp,0
        Tp*p_N_LS(4),Tp^2*p_N_LS(4),-Tp,-Tp]\[(1-p_N_LS(1));(-2*-p_N_LS(2));-1*p_N_LS(3);-1*p_N_LS(4)];
%% Test odpowiedzi skokowej
sys=tf([params(3) params(4)],[1 params(1) params(2)]);
step(sys)