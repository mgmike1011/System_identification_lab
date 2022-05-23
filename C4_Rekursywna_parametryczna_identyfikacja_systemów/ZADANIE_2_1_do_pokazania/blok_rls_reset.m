function Wyj = blok_rls_reset(Wej)
global P_RLS_1 phat_RLS_1 trace_P_RLS k roRLS epsilon_max

% Dane z wejscia muxa
x_2 = Wej(1);
x_1 = Wej(2);
u_2 = Wej(3);
u_1 = Wej(4);
y_2 = Wej(5);
y_1 = Wej(6);
y = Wej(7);
ym_RLS_1 = Wej(8); % odpowiedz modelu opozniona o 1 probke

% Regresor
fi = [-y_1; -y_2; u_2];

% Zmienne instrumentalne z -> dla RIV
z = [-x_1; -x_2; u_2];

epsilon = y-(fi'*phat_RLS_1); % Epsilon wzor (24)
epsilon_oe = y_1 - ym_RLS_1; % Epsilon - blad wyjsciowy, y_1 to wyjscie cofniete o 1 probke, ym_RLS_1 to wyjscie modelu cofniete o 1 probke

% Macierz kowariancyjna
PLS = P_RLS_1 - ((P_RLS_1 * fi * fi' * P_RLS_1) / (1 + fi' * P_RLS_1 * fi));
if trace(PLS) < 0.05 && (abs(epsilon_oe)>epsilon_max) % Pmin = 0.05 sk¹d ta wartosc?
    PLS = roRLS*eye(3); %diag([0; 0; roRLS]);
else
    PLS = P_RLS_1 - ((P_RLS_1 * fi * fi' * P_RLS_1) / (1 + fi' * P_RLS_1 * fi));
end

% Uaktualniam zmienn¹ globaln¹ PLS_1
P_RLS_1 = PLS;

% Slad macierzy 
trace_P_RLS = [trace_P_RLS trace(PLS)];

% Wektorowe wzmocnienie i biezaca wartosc bledu predykcji
k = PLS*fi;

% Poprawka
poprawka = k*epsilon; 

% Estymator parametrow - wektor
phat_RLS = phat_RLS_1 + poprawka;
% Uaktualnienie phat_RLS_1
phat_RLS_1 = phat_RLS;

Wyj = phat_RLS;

end