clear variables; clc;
% 
% Zad 3.1
% 
    % Transmitancja ko/(To*s + 1)
    % ko = 2.0; To = 0.5
% 
% Zad 3.2
% 
N = 4001;
Tp = 0.01;
fp = 1/Tp;
s = tf('s'); % zmienna operatorowa Laplace’a
TF = 50*Tp; % wybór wartoœci sta³ej czasowej dla filtrów SVF
n = 1; % wybór rzêdu dynamiki sla filtrów SVF
F0 = 1/(1+s*TF)^n; % definicja filtru SFV typu F^0
F1 = s/(1+s*TF)^n; % definicja filtru SFV typu F^1
% 
% Zad 3.3
% 
% Wczytanie danych:
load('IdentWsadowaDyn.mat')
DaneDynW_u = DaneDynW(:,1); % Zak³ócenie bia³e
DaneDynW_yw = DaneDynW(:,2); % Zak³ócenie bia³e
Z_est_W_u = DaneDynW_u(1:2000); % Dane estymuj¹ce - zak³ócenie bia³e
Z_est_W_yw = DaneDynW_yw(1:2000); % Dane estymuj¹ce - zak³ócenie bia³e
Z_wer_W_u = DaneDynW_u(2001:end); % Dane weryfikuj¹ce - zak³ócenie bia³e
Z_wer_W_yw = DaneDynW_yw(2001:end); % Dane weryfikuj¹ce - zak³ócenie bia³e
% Aproksymowane filtracje SVF:
t = Tp*(0:2000-1);
yF = lsim(F0,Z_est_W_yw,t,'foh'); % filtracja SVF filtrem F^0 sekwencji yw z ekstrapolacj¹ ’foh’
ypF = lsim(F1,Z_est_W_yw,t,'foh'); % filtracja SVF filtrem F^1 sekwencji yw z ekstrapolacj¹ ’foh’
uF = lsim(F0,Z_est_W_u,t,'foh'); % filtracja SVF filtrem F^0 sekwencji u z ekstrapolacj¹ ’foh’
% 
% Zad 3.4
% 
    % Estymacja parametrów dla filru z yF:
fi_W = zeros(2000-1,2);
for i = 2:2000-1
    fi_W(i,1) = -yF(i);
    fi_W(i,2) = uF(i);
end
yw = ypF(2:end);
p_N_LS_W = ((fi_W'*fi_W)^(-1))*fi_W'*yw;
% Na podstawie estymacji:
To_est = 1/p_N_LS_W(1);
ko_est = To_est*p_N_LS_W(2);
% 
% Zad 3.5
% 
    % Uzyskane parametry s¹ podobne do proawdziwych.