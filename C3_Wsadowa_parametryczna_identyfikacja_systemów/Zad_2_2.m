clear variables; clc;
% Za³adowanie danych
load('IdentWsadowaDyn.mat');

DaneDynC_u = DaneDynC(:,1); % Zak³ócenie kolorowe
DaneDynC_yc = DaneDynC(:,2); % Zak³ócenie kolorowe
Tp = 0.01;
N = 4001;
t=0:Tp:(N-1)*Tp;
d = 2;

% Podzia³ danych pomiarowych na 2 podzbiory
Z_est_C_u = DaneDynC_u(1:2000); % Dane estymuj¹ce u - zak³ócenie kolorowe
Z_est_C_yc = DaneDynC_yc(1:2000); % Dane estymuj¹ce y - zak³ócenie kolorowe

Z_wer_C_u = DaneDynC_u(2001:end); % Dane weryfikuj¹ce u - zak³ócenie kolorowe
Z_wer_C_yc = DaneDynC_yc(2001:end); % Dane weryfikuj¹ce y - zak³ócenie kolorowe

N_est = length(Z_est_C_u);
N_wer = length(Z_wer_C_u);

% Identyfikacja parametrów metod¹ LS:
fi_C = zeros(N_est,2);
for i = 2:N_est
    fi_C(i, :) = [Z_est_C_yc(i-1), Z_est_C_u(i-1)];
    %fi_C(i,1) = Z_est_C_yc(i);
    %fi_C(i,2) = Z_est_C_u(i);
end
p_N_LS_C = pinv(fi_C)*Z_est_C_yc;

% Identyfikacja parametryczna IV - poszczególne kroki:
    % Wyznaczanie próbek x - liczone podobnie jak próbki wyjœcia y:
x(1) = 0;
for i = 2 : N_est
    x(i) = p_N_LS_C(1)*x(i-1) + p_N_LS_C(2)*Z_est_C_u(i-1);
end
    % Wyznaczanie macierzy zmiennych instrumentalnych
    Z = zeros(N_est, 2);
for i = 2 : N_est
    Z(i, :) = [x(i-1) Z_est_C_u(i-1)];
end
    % Wektor parametrów - metoda IV
p_N_IV_C = inv(Z'*fi_C)*Z'*Z_est_C_yc;

% Rekonstrukcja estymat k^ i T^:
T_hat = -Tp/(log(p_N_IV_C(1)));
k_hat = p_N_IV_C(2)/(1-p_N_IV_C(1));

    % Porównanie k^ i T^ z ko i To
disp('T^, To ') ; [T_hat, 0.5] 
disp('k^, ko ') ; [k_hat, 2.0] 

% Zilustrowaæ na wspólnym wykresie przebiegi sygna³ów:
    % Zmierzona odpowiedz y(n) ze zbioru Zwer:
t_wer=0:Tp:(N_wer-1)*Tp;
    % Niezak³ócona odpowiedŸ yo - w praktyce niedostêpna:
k_o = 2.0;
T_o = 0.5;
G_o = tf(k_o, [T_o 1]);
yo = lsim(G_o, Z_wer_C_u, t_wer);

    % OdpowiedŸ predyktora jednokrokowego:
y_hat = zeros(N_wer, 1);
for i=2:N_wer
    y_hat(i) = p_N_IV_C(1) * Z_wer_C_yc(i-1) + p_N_IV_C(2) * Z_wer_C_u(i-1);
end

     % OdpowiedŸ modelu symulowanego ym
Gm = tf(k_hat, [T_hat, 1]);
y_m = lsim(Gm, Z_wer_C_u, t_wer);

figure
plot(t_wer, Z_wer_C_yc);
hold on
plot(t_wer, yo) 
plot(t_wer, y_hat) 
plot(t_wer, y_m)
grid on 
legend('Zmierzona odpowiedz y(n) ze zbioru Zwer', 'Niezak³ócona odpowiedŸ yo', 'OdpowiedŸ predyktora jednokrokowego', 'OdpowiedŸ modelu symulowanego ym')
ylabel('')
xlabel('Dziedzina czasu')

% Oceniæ jakoœciowo oraz iloœciowo wynik identyfikacji:
    % WskaŸniki (21)
V_p = 1/N_wer * sum((Z_wer_C_yc - y_hat).^2);
V_m = 1/N_wer * sum((yo - y_m).^2);

    % Wartoœci, jakie by³y uzyskane dla metody LS (dla danych z macierzy DaneDynC)
V_p_LS = 0.234939997981680;
V_m_LS = 0.031558596170236;

V_p_text_IV = 'V_p_IV:';
V_p_text_LS = 'V_p_LS:';

porownanie_V_p = [V_p_text_IV, ' ', num2str(V_p), ' ', V_p_text_LS, ' ', num2str(V_p_LS)]
porownanie_V_m = [V_p_text_IV, ' ', num2str(V_m), ' ', V_p_text_LS, ' ', num2str(V_m_LS)]