% Identyfikacja parametrow modelu czasu dyskretnego metoda RLS
clear variables; clc;

% Zaladowanie danych
load('dane_.mat')

% Podstawowe dane
Tp = 0.01; % [s] Okres próbkowania
N = length(u_); % Iloœæ próbek w eksperymencie
d = 4; % Liczba parametrow
% t_, y_, u_ - czas, odpowiedz, pobudzenie z danych

%% Detla +
% Przygotowanie danych pocz¹tkowych
P1=eye(4);
p1=[2;7;2;7];
% Przygotowanie danych 
y1 = 0;
y2 = 0;
u1 = 0;
u2 = 0;
% Wektor estymat
p = zeros(4,length(u_)); 
% Przebieg œladu macierzy P^(LS):
P_trace = trace(P1);
for i = 1:N
    fi = [-y1;-y2;-u1;u2];
    P = P1 - (((P1*fi)*fi'*P1)/(1+fi'*P1*fi)); % Macierz kowariancyjna
    k = P*fi; % Wzmocnienie
    E = y_(i)-fi'*p1; % B³¹d predykcji jednokrokowej
    p_ = p1 + k*E; % Wektor parametrów 
    p(1,i) = p_(1);
    p(2,i) = p_(2);
    p(3,i) = p_(3);
    p(4,i) = p_(4);
    % Aktualizacja danych
    p1 = p_;
    P1 = P;
    y2 = y1;
    y1 = y_(i);
    u2 = u1;
    u1 = u_(i);
    P_trace = [P_trace; trace(P)];
end
% Obliczenie parametrów
a1 = (p_(1)+2)/Tp;
a2 = (p_(2)-1+a1*Tp)/Tp^2;
b1 = p_(3);
b2 = (p_(4)+b1)/Tp;
params=[a1;a2;b1;b2];
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
% Przebieg œladu macierzy P^(LS):
P_trace = trace(P1);
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
    P_trace = [P_trace; trace(P)];
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
% Przebieg œladu macierzy P^(LS):
P_trace = trace(P1);
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
    P_trace = [P_trace; trace(P)];
end
% Obliczenie parametrów
params=[p_(1)*Tp,(p_(1)*Tp^2),0 
        (Tp*p_(2)+Tp) ,(Tp^2*p_(2)) ,0 
        Tp*p_(3) ,Tp^2*p_(3) ,-Tp^2 ]\[(1-p_(1));(-2*-p_(2));-1*p_(3)];
%% Test odpowiedzi skokowej
subplot(3,2,1)
sys=tf([params(3) params(4)],[1 params(1) params(2)]);
step(sys)
title('System z estymacji')
grid on
subplot(3,2,2)
t_odp_skok = t_(1:499);
y_odp_skok = y_(499:997);
u_odp_skok = u_(499:997);
plot(t_odp_skok,y_odp_skok)
hold on
plot(t_odp_skok,u_odp_skok)
title('System prawdziwy')
grid on
subplot(3,2,[3,4])
plot(P_trace)
grid on
title('Œlad macierzy P')
subplot(3,2,[5,6])
plot(p(1,:))
grid on
hold on
plot(p(2,:))
plot(p(3,:))
plot(p(4,:))
title('Przebieg estymat parametrów')
legend('p1','p2','p3','p4')