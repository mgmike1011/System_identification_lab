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

% Estymacja parametrów dla filru z yF:
fi_W = zeros(length(Z_est_u)-1,4);
for i = 2:length(Z_est_u)-1
    fi_W(i,1) = -ypF(i);
    fi_W(i,2) = -yF(i);
    fi_W(i,3) = upF(i);
    fi_W(i,4) = uF(i);
end
yw = yppF(2:end);
p_N_LS = ((fi_W'*fi_W)^(-1))*fi_W'*yw;
% OdpowiedŸ skokowa:
sys=tf([p_N_LS(3) p_N_LS(4)],[1 p_N_LS(1) p_N_LS(2)]);
step(sys)