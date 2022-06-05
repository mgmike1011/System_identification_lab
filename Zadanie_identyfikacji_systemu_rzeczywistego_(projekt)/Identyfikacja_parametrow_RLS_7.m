% Identyfikacja parametrow modelu czasu dyskretnego metoda RLS
clear variables; clc;

% Zaladowanie danych
load('dane_.mat')

% Podstawowe dane
Tp = 0.01; % [s] Okres próbkowania
N = length(u_); % Iloœæ próbek w eksperymencie
d = 3; % Liczba parametrow
% t_, y_, u_ - czas, odpowiedz, pobudzenie z danych

%% Detla +
% Przygotowanie danych pocz¹tkowych
P1=eye(3);
p1=[0;0;0];
% Przygotowanie danych 
y1 = 0;
y2 = 0;
u1 = 0;
u2 = 0;
% Wektor estymat
p = zeros(3,length(u_)); 
for i = 1:N
    fi = [y1;-y2;u2];
    P = P1 - (((P1*fi)*fi'*P1)/(1+fi'*P1*fi)); % Macierz kowariancyjna
    k = P*fi; % Wzmocnienie
    E = y_(i)-fi'*p1; % B³¹d predykcji jednokrokowej
    p_ = p1 + k*E; % Wektor parametrów 
    p(1,i) = p_(1);
    p(2,i) = p_(2);
    p(3,i) = p_(3);
    % Aktualizacja danych
    p1 = p_;
    P1 = P;
    y2 = y1;
    y1 = y_(i);
    u2 = u1;
    u1 = u_(i);
end
% Obliczenie parametrów
b1 = p_(3)/Tp^2;
a1 = (-p_(1)+2)/Tp;
a2 = (p_(2)+a1*Tp-1)/Tp^2;
%% Tustin
% Przygotowanie danych pocz¹tkowych
P1=eye(3);
p1=[0;0;0];
% Przygotowanie danych 
y1 = 0;
y2 = 0;
u1 = 0;
u2 = 0;
% Wektor estymat
p = zeros(3,length(u_)); 
for i = 1:N
    fi = [y1;-y2;(u2+2*u1+u_(i))];
    P = P1 - (((P1*fi)*fi'*P1)/(1+fi'*P1*fi)); % Macierz kowariancyjna
    k = P*fi; % Wzmocnienie
    E = y_(i)-fi'*p1; % B³¹d predykcji jednokrokowej
    p_ = p1 + k*E; % Wektor parametrów 
    p(1,i) = p_(1);
    p(2,i) = p_(2);
    p(3,i) = p_(3);
    % Aktualizacja danych
    p1 = p_;
    P1 = P;
    y2 = y1;
    y1 = y_(i);
    u2 = u1;
    u1 = u_(i);
end
% Obliczenie parametrów
params=[2*p_(1)*Tp,(p_(1)*Tp^2+2*Tp^2),0 
        (2*Tp*p_(2)+2*Tp) ,(Tp^2*p_(2)-Tp^2) ,0 
        2*Tp*p_(3) ,Tp^2*p_(3) ,-Tp^2 ]\[(8-4*p_(1));(4-4*p_(2));-4*p_(3)];
%% Delta -
% Przygotowanie danych pocz¹tkowych
P1=eye(3);
p1=[0;0;0];
% Przygotowanie danych 
y1 = 0;
y2 = 0;
u1 = 0;
u2 = 0;
% Wektor estymat
p = zeros(3,length(u_)); 
for i = 1:N
    fi = [-y1;-y2;u_(i)];
    P = P1 - (((P1*fi)*fi'*P1)/(1+fi'*P1*fi)); % Macierz kowariancyjna
    k = P*fi; % Wzmocnienie
    E = y_(i)-fi'*p1; % B³¹d predykcji jednokrokowej
    p_ = p1 + k*E; % Wektor parametrów 
    p(1,i) = p_(1);
    p(2,i) = p_(2);
    p(3,i) = p_(3);
    % Aktualizacja danych
    p1 = p_;
    P1 = P;
    y2 = y1;
    y1 = y_(i);
    u2 = u1;
    u1 = u_(i);
end
% Obliczenie parametrów
params=[p_(1)*Tp,(p_(1)*Tp^2),0 
        (Tp*p_(2)+Tp) ,(Tp^2*p_(2)) ,0 
        Tp*p_(3) ,Tp^2*p_(3) ,-Tp^2 ]\[(1-p_(1));(-2*-p_(2));-1*p_(3)];