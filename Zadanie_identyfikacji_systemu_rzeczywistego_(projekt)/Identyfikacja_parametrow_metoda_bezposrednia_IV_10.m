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
% Filtry
fp = 1/Tp;
s = tf('s'); % zmienna operatorowa Laplace’a
TF = 50*Tp; % wybór wartoœci sta³ej czasowej dla filtrów SVF
n = 2; % wybór rzêdu dynamiki sla filtrów SVF
F0 = 1/(1+s*TF)^n; % definicja filtru SFV typu F^0
F1 = s/(1+s*TF)^n; % definicja filtru SFV typu F^1
F2 = s^2/(1+s*TF)^n; % definicja filtru SFV typu F^2

% Aproksymowane filtracje SVF:
t = Tp*(0:length(Z_est_u)-1);
yF = lsim(F0,Z_est_y,t,'foh'); % filtracja SVF filtrem F^0 sekwencji y z ekstrapolacj¹ ’foh’
ypF = lsim(F1,Z_est_y,t,'foh'); % filtracja SVF filtrem F^1 sekwencji y z ekstrapolacj¹ ’foh’
yppF = lsim(F2,Z_est_y,t,'foh'); % filtracja SVF filtrem F^2 sekwencji y z ekstrapolacj¹ ’foh’
uF = lsim(F0,Z_est_u,t,'foh'); % filtracja SVF filtrem F^0 sekwencji u z ekstrapolacj¹ ’foh’
upF = lsim(F1,Z_est_u,t,'foh'); % filtracja SVF filtrem F^0 sekwencji u z ekstrapolacj¹ ’foh’

% Zmienne instrumentalne
p_N_LS = [1.9459, 6.9874, 2.4031, 6.9655]; % Estymaty obci¹¿one LS 
model = tf([p_N_LS(3) p_N_LS(4)],[1 p_N_LS(1) p_N_LS(2)]); % Symulator
t_model = Tp*(0:length(Z_est_u)-1);
model_out = lsim(model,Z_est_u,t_model,'foh');
xF = lsim(F0,model_out,t,'foh'); % filtracja SVF filtrem F^0 sekwencji y z ekstrapolacj¹ ’foh’
xpF = lsim(F1,model_out,t,'foh'); % filtracja SVF filtrem F^1 sekwencji y z ekstrapolacj¹ ’foh’
xppF = lsim(F2,model_out,t,'foh'); % filtracja SVF filtrem F^2 sekwencji y z ekstrapolacj¹ ’foh’

% Estymacja parametrów dla filru z yF:
fi_W = zeros(length(Z_est_u)-1,4);
z_W = zeros(length(Z_est_u)-1,4);
for i = 2:length(Z_est_u)-1
    fi_W(i,1) = -ypF(i);
    fi_W(i,2) = -yF(i);
    fi_W(i,3) = upF(i);
    fi_W(i,4) = uF(i);
    z_W(i,1) = -xpF(i);
    z_W(i,2) = -xF(i);
    z_W(i,3) = upF(i);
    z_W(i,4) = uF(i);
end
yw = yppF(2:end);
p_N_IV = ((z_W'*fi_W)^(-1))*z_W'*yw;
% Weryfikacja wyników:
sys = tf([p_N_IV(3) p_N_IV(4)],[1 p_N_IV(1) p_N_IV(2)]);
sim('Centrum_doswiadczalne')
plot(u_);
hold on
plot(y_);
plot(Model_IV_bezposrednia(1:2000,2));
grid on
legend('u','y','y_{model}')
% WskaŸnik dopasowania:
y_wsk = y_(500:end);
model_wsk = Model_IV_bezposrednia(500:2000,2);
my = (sum(y_wsk)/length(y_wsk)).*ones(1,length(y_wsk));
J_Fit = (1-norm(y_wsk-model_wsk)/norm(y_wsk-my))*100;
J = sum((y_wsk-model_wsk).^2)/length(y_wsk);