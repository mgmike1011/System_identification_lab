function Wyj_RLS = estymator_RLS(Wej_RLS)

global P_RLS phatRLS
global trace_P_RLS
global metoda lambda ro_RLS_lambda k_R1_RLS T epsilon_max P_min
x_2 = Wej_RLS(1);
x_1 = Wej_RLS(2);  % odpowiedz modelu symulowanego z poprzedniej próbki dla RIV (ym_RIV_1)
u_2 = Wej_RLS(3);
u_1 = Wej_RLS(4);
y_2 = Wej_RLS(5);
y_1 = Wej_RLS(6);
y = Wej_RLS(7);
ym_RLS_1 = Wej_RLS(8); % odpowiedz modelu symulowanego z poprzedniej próbki dla RLS

% Regresor
fi = [-y_1; -y_2; u_2];
epsilon = y-(fi'*phatRLS);
% Macierz kowariancyjna - w zaleznosc id metody
if metoda == 1 % WSPÓ£CZYNNIK ZAPOMINANIA
    P_RLS = (1/lambda)*(P_RLS-((P_RLS*fi*fi'*P_RLS)/(lambda+fi'*P_RLS*fi)));
else
    P_RLS = P_RLS-((P_RLS*fi*fi'*P_RLS)/(1+fi'*P_RLS*fi));
    if metoda == 2 % RESETOWANIE MACIERZY
        epsilon_OE_1 = y_1 - ym_RLS_1;  % b³¹d wyjœæia dla poprzedniej próbki
        if abs(epsilon) > epsilon_max || abs(epsilon_OE_1) > epsilon_max && trace(P_RLS) < P_min
            P_RLS = ro_RLS_lambda*eye(d);
        end
    end
end

% Slad macierzy 
trace_P_RLS = [trace_P_RLS trace(P_RLS)];

% Wektorowe wzmocnienie i biezaca wartosc bledu predykcji
k = P_RLS*fi;


% Poprawka
poprawka = k*epsilon; 

% Estymator parametrow - wektor
phatRLS = phatRLS + poprawka;

Wyj_RLS = phatRLS;
end