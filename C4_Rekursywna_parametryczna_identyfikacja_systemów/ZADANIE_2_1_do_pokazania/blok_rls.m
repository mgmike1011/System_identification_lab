function Wyj = blok_rls(Wej)
global P_RLS phat_RLS lambda
global trace_P_RLS
global metoda
global k

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

% Macierz kowariancyjna
if metoda == 1
    P_RLS = (1/lambda)*(P_RLS-((P_RLS*fi*fi'*P_RLS)/(lambda+fi'*P_RLS*fi)));
end

% Slad macierzy 
trace_P_RLS = [trace_P_RLS trace(P_RLS)];

% Wektorowe wzmocnienie i biezaca wartosc bledu predykcji
k = P_RLS*fi;
epsilon = y-(fi'*phat_RLS);

% Poprawka
poprawka = k*epsilon; 

% Estymator parametrow - wektor
phat_RLS = phat_RLS + poprawka;

Wyj = phat_RLS;
end
