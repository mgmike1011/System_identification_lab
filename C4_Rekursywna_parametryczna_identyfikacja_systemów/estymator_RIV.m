function Wyj = estymator_RIV(Wej)
global PIV_1 phatIV_1
global trace_P_IV

% Dane z wejscia muxa
x_2 = Wej(1);
x_1 = Wej(2);
u_2 = Wej(3);
u_1 = Wej(4);
y_2 = Wej(5);
y_1 = Wej(6);
y = Wej(7);

% Regresor
fi = [-y_1; -y_2; u_2];

% Zmienne instrumentalne z
z = [-x_1; -x_2; u_2];

% Macierz kowariancyjna
PIV_1 = PIV_1-((PIV_1*z*fi'*PIV_1)/(1+fi'*PIV_1*z));

% Slad macierzy 
trace_P_IV = [trace_P_IV trace(PIV_1)];

% Wektorowe wzmocnienie i biezaca wartosc bledu predykcji
k = PIV_1*z;
epsilon = y-(fi'*phatIV_1);

% Poprawka
poprawka = k*epsilon; 

% Estymator parametrow - wektor
phatIV_1 = phatIV_1 + poprawka;

Wyj = phatIV_1;
end
