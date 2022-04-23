clear variable; clc;
% Za�adowanie danych
load('IdentWsadowaDyn.mat');
DaneDynW_u = DaneDynW(:,1); % Zak��cenie bia�e
DaneDynW_yw = DaneDynW(:,2); % Zak��cenie bia�e
DaneDynC_u = DaneDynC(:,1); % Zak��cenie kolorowe
DaneDynC_yw = DaneDynC(:,2); % Zak��cenie kolorowe
Tp = 0.01;
N = 4001;
t = 0:Tp:(N-1)*Tp;
% Parametry identyfikowanego systemu czasu ci�g�ego
ko = 2; 
To = 0.5;
Go = tf(ko, [To 1]);
% Sygna� pobudzaj�cy
u = 0.2*sin(5*t)+0.1*sin(2*t)+0.5*cos(2*t);
% Generowanie zak��cenia bia�ego:
H = tf(1,[To 1]);
e = randn(N,1);
v_biale = lsim(H,e,t,'zoh');
% Generowanie zaklocenia kolorowego:
H = tf(0.5,[0.05 1]);
e = randn(N,1);
v_kolorowe = lsim(H,e,t,'zoh');
% 
% Zad 2.1.1
% 
    % W zeszycie
% 
% Zad 2.1.2
% 
    % Wy�wietlenie danych
subplot(2,2,1)
plot(t,DaneDynW_u)
grid on
title('Sygna� u - zak��cenie bia�e')
xlabel('Czas t')
subplot(2,2,2)
plot(t,DaneDynC_u)
grid on
title('Sygna� u - zak��cenie kolorowe')
xlabel('Czas t')
subplot(2,2,3)
plot(t,DaneDynW_yw)
grid on
title('Sygna� yw - zak��cenie bia�e')
xlabel('Czas t')
subplot(2,2,4)
plot(t,DaneDynC_yw)
grid on
title('Sygna� yw - zak��cenie kolorowe')
xlabel('Czas t')
%sgtitle('Zad 2.1.2 - wy�wietlenie danych')
    % Podzia� zbioru danych
Z_est_W_u = DaneDynW_u(1:2000); % Dane estymuj�ce - zak��cenie bia�e
Z_est_W_yw = DaneDynW_yw(1:2000); % Dane estymuj�ce - zak��cenie bia�e
Z_est_C_u = DaneDynC_u(1:2000); % Dane estymuj�ce - zak��cenie kolorowe
Z_est_C_yw = DaneDynC_yw(1:2000); % Dane estymuj�ce - zak��cenie kolorowe
Z_wer_W_u = DaneDynW_u(2001:end); % Dane weryfikuj�ce - zak��cenie bia�e
Z_wer_W_yw = DaneDynW_yw(2001:end); % Dane weryfikuj�ce - zak��cenie bia�e
Z_wer_C_u = DaneDynC_u(2001:end); % Dane weryfikuj�ce - zak��cenie kolorowe
Z_wer_C_yw = DaneDynC_yw(2001:end); % Dane weryfikuj�ce - zak��cenie kolorowe
% 
% Zad 2.1.3
% 
    % Estymacja dla zak��cenia bia�ego
fi_W = zeros(2000-1,2);
for i = 2:2000-1
    fi_W(i,1) = Z_est_W_yw(i);
    fi_W(i,2) = Z_est_W_u(i);
end
yw = Z_est_W_yw(2:end);
p_N_LS_W = ((fi_W'*fi_W)^(-1))*fi_W'*yw;
    % Estymacja dla zak��cenia kolorowego
fi_C = zeros(2000-1,2);
for i = 2:2000-1
    fi_C(i,1) = Z_est_C_yw(i);
    fi_C(i,2) = Z_est_C_u(i);
end
yc = Z_est_C_yw(2:end);
p_N_LS_C = ((fi_C'*fi_C)^(-1))*fi_C'*yc;
% 
% Zad 2.1.4
% 
    % Wyniki estymacji parametr�w dla bia�ego:
T_est_W = 0.505; k_est_W = 2.0605;
    % Wyniki estymacji parametr�w dla kolorowego:
T_est_C = 0.23137; k_est_C = 1.4373;
% Lepsze wyniki dla bia�ego!!!
% 
% Zad 2.1.5
% 
figure
plot(t(1:2001),Z_wer_W_yw)
hold on
grid on
xlabel('Czas')
plot(t(1:2001),Z_wer_C_yw)
plot(t(1:2001),lsim(Go,Z_wer_W_u,t(1:2001)))
plot(t(1:2001),lsim(Go,Z_wer_C_u,t(1:2001)))
Z_wer_W_yw_zero = [0;Z_wer_W_yw(1:end)];
y_n_n_1 = (1-(1+T_est_W*Z_wer_W_yw_zero(1:end-1))).*Z_wer_W_yw +k_est_W.*Z_wer_W_u;
Z_wer_C_yw_zero = [0;Z_wer_C_yw(1:end)];
y_n_n_1_C = (1-(1+T_est_C*Z_wer_C_yw_zero(1:end-1))).*Z_wer_C_yw +k_est_C.*Z_wer_C_u;
plot(t(1:2001),y_n_n_1)
plot(t(1:2001),y_n_n_1_C)
plot(t(1:2001),lsim(tf(k_est_C,[T_est_C 1]),Z_wer_C_u,t(1:2001)))
plot(t(1:2001),lsim(tf(k_est_W,[T_est_W 1]),Z_wer_W_u,t(1:2001)))
legend('y(n) - Zwer White','y(n) - Zwer Color','Odpowied� niezak��cona yo(n) - Zwer White','Odpowied� niezak��cona yo(n) - Zwer Color','Predyktor White','Predyktor Color','ym(n) - Zwer Color','ym(n) - Zwer White')
    % Ocena jako�ciowa oraz ilo�ciowa wyniku identyfikacji:
% Bli�sze prawdziwym warto�ci s� wyniki uzsykane dla szumu bia�ego,
Wm_W = 1/length(Z_wer_W_yw)*sum((lsim(Go,Z_wer_W_u,t(1:2001))-(lsim(tf(k_est_W,[T_est_W 1]),Z_wer_W_u,t(1:2001)))).^2);
Wm_C = 1/length(Z_wer_C_yw)*sum((lsim(Go,Z_wer_C_u,t(1:2001))-(lsim(tf(k_est_C,[T_est_C 1]),Z_wer_C_u,t(1:2001)))).^2);
Vp_W = 1/length(Z_wer_W_yw)*sum((Z_wer_W_yw - y_n_n_1).^2);
Vp_C = 1/length(Z_wer_C_yw)*sum((Z_wer_C_yw - y_n_n_1_C).^2);
disp("Wm_White: "+ Wm_W+" Vp_White: " + Vp_W)
disp("Wm_Color: "+ Wm_C+" Vp_Color: " + Vp_C)
% 
% Zad 2.1.6
% 
% Macierz kowariancji dla danych zakl�conych szumem bialym
ei = Z_wer_W_yw - lsim(tf(k_est_W,[T_est_W 1]),Z_wer_W_u,t(1:2001)); % ei - b��d resztowy wz�r (5)
sigma2 = 1 / (N - 2) * sum(ei.^2); % estymata wariancji zak��cenia (5)
cov = sigma2 * (fi_W'*fi_W)^(-1); % obliczenie kowariancji wz�r 5

% Okre�lanie przedzia�ow ufno�ci dla 95% instrukcja wz�r 22 i 23
lewo = zeros(1,2);
prawo = zeros(1,2);
for i = 1:2
   odchylenie = 1.96*sqrt(cov(i,i)); % odchylenie przedzia�u ufno�ci 
   lewo(i)  = p_N_LS_W(i) - odchylenie; 
   prawo(i) = p_N_LS_W(i) + odchylenie; 
end
ufnosc = [lewo; prawo]';
disp('Przedzia� ufno�ci: '); disp(ufnosc);

