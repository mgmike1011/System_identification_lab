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
% Tustin
y_n_1 = [0;Z_est_y(1:end-1)];
y_n_2 = [0;0;Z_est_y(1:end-2)];
u_n_2 = [0;0;Z_est_u(1:end-2)];
u_n_1 = [0;Z_est_u(1:end-1)];
u_n = Z_est_u;
fi = [-y_n_2,-y_n_1,u_n_2,u_n_1,u_n];
p_N_LS = pinv(fi)*Z_est_y;

