clear variables; clc;

% Zaladowanie danych
load('dane_.mat')

% Podstawowe dane
Tp = 0.01; % [s] Okres próbkowania
N = length(u_); % Iloœæ próbek w eksperymencie
d = 4; % Liczba parametrow
% t_, y_, u_ - czas, odpowiedz, pobudzenie z danych
p_N_LS = [1.9459, 6.9874, 2.4031, 6.9655]; % Estymaty obci¹¿one LS 
p_N_IV = [2.1800, 7.1345, 2.6512, 7.1236]; % Estymaty IV
sim('Centrum_doswiadczalne')
%% DO LS
subplot(2,2,1)
plot(t_,u_)
hold on
plot(t_,y_)
grid on
title('System rzeczywisty - pomiary')
xlabel('Czas [s]')
legend('u','y')
subplot(2,2,2)
plot(Model_LS_bezposrednia(:,1))
hold on
plot(Model_LS_bezposrednia(:,2))
grid on
title('System z identyfikacji LS')
xlabel('Próbki')
legend('u','y')
subplot(2,2,[3,4])
plot(t_,y_)
hold on
plot(t_,Model_LS_bezposrednia(1:2000,2))
grid on
legend('y','y_m')
title('Porównanie przebiegów modelu i systemu rzeczywistego')
xlabel('Czas [s]')
sgtitle('Porównanie przebiegów systemu i modelu')
% WskaŸniki jakoœci
% WskaŸnik dopasowania:
y_wsk = y_(500:end);
model_wsk = Model_LS_bezposrednia(500:2000,2);
my = (sum(y_wsk)/length(y_wsk)).*ones(1,length(y_wsk));
J_Fit = (1-norm(y_wsk-model_wsk)/norm(y_wsk-my))*100;
J = sum((y_wsk-model_wsk).^2)/length(y_wsk);
%% DO IV
subplot(2,2,1)
plot(t_,u_)
hold on
plot(t_,y_)
grid on
title('System rzeczywisty - pomiary')
xlabel('Czas [s]')
legend('u','y')
subplot(2,2,2)
plot(Model_IV_bezposrednia(:,1))
hold on
plot(Model_IV_bezposrednia(:,2))
grid on
title('System z identyfikacji IV')
xlabel('Próbki')
legend('u','y')
subplot(2,2,[3,4])
plot(t_,y_)
hold on
plot(t_,Model_IV_bezposrednia(1:2000,2))
grid on
legend('y','y_m')
title('Porównanie przebiegów modelu i systemu rzeczywistego')
xlabel('Czas [s]')
sgtitle('Porównanie przebiegów systemu i modelu')
% WskaŸniki jakoœci
% WskaŸnik dopasowania:
y_wsk = y_(500:end);
model_wsk = Model_IV_bezposrednia(500:2000,2);
my = (sum(y_wsk)/length(y_wsk)).*ones(1,length(y_wsk));
J_Fit = (1-norm(y_wsk-model_wsk)/norm(y_wsk-my))*100;
J = sum((y_wsk-model_wsk).^2)/length(y_wsk);
%% Porównanie obu 
plot(Model_IV_bezposrednia(:,1))
hold on
plot(Model_IV_bezposrednia(:,2))
plot(Model_LS_bezposrednia(:,2),'color',[0,0.3,0])
grid on
xlabel('Próbki')
legend('u','y_mIV','y_mLS')
title('Porównanie przebiegów symulatorów z estymatami LS oraz IV')