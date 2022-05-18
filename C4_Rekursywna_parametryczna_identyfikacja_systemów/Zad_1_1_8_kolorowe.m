clear all; close all;

Tp = 0.1; % [s] - okres próbkowania
Tend = 1000; % [s] - horyzont czasowy symulacji 
Td = 1500; % [s] - czas zmiany parametru b2

% Deklaracja zmiennych
global c1o;
c1o = 0.99;
% Symulacja
global P1_ p1_
P1_ = eye(3);
p1_ = [0;0;0];
sim('SystemARMAX.mdl')
% Dane z symulacji
u = simout(:,1);
y = simout(:,2);
    % Metoda RLS - bez identyfikacji parametru c1o - zak³ócenie kolorowe
% Parametry 
y1 = 0;
y2 = 0;
u2 = 0;
u1 = 0;
P1 = eye(3);
p1 = [0;0;0];
b2o = simout(:,3);
yo = simout(:,4);
% Wektor estymat
p = zeros(3,length(u)); 
% Przebieg œladu macierzy P^(LS):
P_trace = trace(P1);
for i = 1:length(u)
    fi = [-y1;-y2;u2]; % Regresor
    P = P1 - (((P1*fi)*fi'*P1)/(1+fi'*P1*fi)); % Macierz kowariancyjna
    k = P*fi; % Wzmocnienie
    E = y(i)-fi'*p1; % B³¹d predykcji jednokrokowej
    p_ = p1 + k*E; % Wektor parametrów 
    p(1,i) = p_(1);
    p(2,i) = p_(2);
    p(3,i) = p_(3);
% Aktualizacja danych
    p1 = p_;
    P1 = P;
    y2 = y1;
    y1 = y(i);
    u2 = u1;
    u1 = u(i);
    P_trace = [P_trace; trace(P)];
end 
% a1o = -0.97 -> a powinno -0.8
% a2o = 0.057 -> a powinno -0.1
% b20 = 0.433 -> a powinno 0.5
    % Metoda RELS - identyfikacja ARMAX i c1o
% Parametry 
y1_rels = 0;
y2_rels = 0;
u2_rels = 0;
u1_rels = 0;
P1_rels = eye(4);
p1_rels = [0;0;0;0];
% Wektor estymat
p_rels = zeros(4,length(u)); 
% Przebieg œladu macierzy P^(LS):
P_trace_rels = trace(P1_rels);
% Zapis w postaci regresji liniowej: 
    % y(n) = [-y(n-1) -y(n-2) u(n-2) e(n-1)]*[a1; a2; b2; c1] + e(n)
fi_rels = [-y1_rels;-y2_rels;u2_rels;y(1)];
for i = 1:length(u)
    e1_rels = y(i) - fi_rels'*p1_rels;
    fi_rels = [-y1_rels;-y2_rels;u2_rels;e1_rels]; % Regresor
    P_rels = P1_rels - (((P1_rels*fi_rels)*fi_rels'*P1_rels)/(1+fi_rels'*P1_rels*fi_rels)); % Macierz kowariancyjna
    k_rels = P_rels*fi_rels; % Wzmocnienie
    E_rels = y(i)-fi_rels'*p1_rels; % B³¹d predykcji jednokrokowej
    p__rels = p1_rels + k_rels*E_rels; % Wektor parametrów 
    p_rels(1,i) = p__rels(1);
    p_rels(2,i) = p__rels(2);
    p_rels(3,i) = p__rels(3);
    p_rels(4,i) = p__rels(4);
    % Aktualizacja danych
    p1_rels = p__rels;
    P1_rels = P_rels;
    y2_rels = y1_rels;
    y1_rels = y(i);
    u2_rels = u1_rels;
    u1_rels = u(i);
    P_trace_rels = [P_trace_rels; trace(P_rels)];
end
% a1o = -0.908 - > 
% a2o = -0.0689 - > a powinno byæ -0.1
% b2o = 0.1126 - > a powinno byæ 0.5
% c1o = 0.805 - > a powinno byæ 0.99
% Wyœwietlenie wyników 
subplot(2,1,1)
plot(p(1,:))
hold on
plot(p(2,:))
plot(p(3,:))
hold off
legend('a1o','a2o','b2o')
title('RLS - zak³ócenie kolorowe')
subplot(2,1,2)
plot(p_rels(1,:))
hold on
plot(p_rels(2,:))
plot(p_rels(3,:))
plot(p_rels(4,:))
hold off
legend('a1o','a2o','b2o','c1o')
title('RELS - zak³ócenie kolorowe')