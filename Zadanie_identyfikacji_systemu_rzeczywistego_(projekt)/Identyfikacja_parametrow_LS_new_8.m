% Identyfikacja parametrow modelu czasu dyskretnego metoda LS
clear variables; clc;

% Zaladowanie danych
load('dane_.mat')

% Podstawowe dane
Tp = 0.01; % [s] Okres pr�bkowania
N = length(u_); % Ilo�� pr�bek w eksperymencie
d = 4; % Liczba parametrow
% t_, y_, u_ - czas, odpowiedz, pobudzenie z danych

% Podzia� danych pomiarowych na 2 podzbiory
Z_est_u = u_(1:(length(u_)/2)); % Dane estymuj�ce u 
Z_est_y = y_(1:(length(u_)/2)); % Dane estymuj�ce y 

Z_wer_u = u_((1+(length(u_)/2)):end); % Dane weryfikuj�ce u 
Z_wer_y = y_((1+(length(u_)/2)):end); % Dane weryfikuj�ce y 

N_est = length(Z_est_u);
N_wer = length(Z_wer_u);
