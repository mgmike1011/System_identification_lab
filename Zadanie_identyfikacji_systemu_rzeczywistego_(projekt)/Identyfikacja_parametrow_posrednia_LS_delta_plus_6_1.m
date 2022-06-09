% Identyfikacja parametrow modelu czasu dyskretnego - posrednia metoda LS
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
b1 = p_N_LS(3)/Tp;
b2 = (p_N_LS(4)+b1*Tp)/Tp^2;
params=[a1;a2;b1;b2];

%% Wskaznik dopasowania modelu - JFIT
% Weryfikacja wyników:
sim('Centrum_doswiadczalne_LS_posrednia')
plot(u_);
hold on
plot(y_);
plot(Model_LS_posrednia(1:2000,2));
grid on
legend('u rzeczywistego','y rzeczywistego','y modelu')
title('Porównanie przebiegów modelu i systemu rzeczywistego')

y_wsk = y_(500:end);
model_wsk = Model_LS_posrednia(500:2000,2);
my = (sum(y_wsk)/length(y_wsk)).*ones(1,length(y_wsk));

J_Fit = (1-norm(y_wsk-model_wsk)/norm(y_wsk-my'))*100;
J = sum((y_wsk-model_wsk).^2)/length(y_wsk);
