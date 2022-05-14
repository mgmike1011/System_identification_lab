clear all; close all;
% Zad 1.1.1

% Zad 1.1.2
% Zapis w postaci regresji liniowej: 
    % y(n) = [-y(n-1) -y(n-2) u(n-2) e(n-1)]*[a1; a2; b2; c1] + e(n)
    
% Zad 1.1.3
Tp = 0.1; % [s] - okres próbkowania
Tend = 1000; % [s] - horyzont czasowy symulacji 
Td = 1500; % [s] - czas zmiany parametru b2

% Zad 1.1.4
% Deklaracja zmiennych
c1o = 0;
sim('SystemARMAX.mdl')
y1 = 0;
y2 = 0;
u2 = 0;
u1 = 0;
P1 = eye(3);
p1 = [0;0;0];
% Dane z symulacji
u = simout(:,1);
y = simout(:,2);
% Wektor estymat
p = zeros(3,length(u));
for i = 1:length(u)
    fi = [-y1;-y2;u2]; % Regresor
    P = P1 - ((P1*fi)*fi'*P1)/(1+fi'*P1*fi); % Macierz kowariancyjna
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
end
% Symulator
t = Tp*(0:length(u)-1);
ym = lsim(filt([0 0 p_(3)],[1 p_(1) p_(2)],Tp),u,t);
% Predyktor
yn = (1 - (1 + p(1,:)*[0;y(1:end-1)] + p(2,:)*[0;0;y(1:end-2)]))*y + (p(3,:)*[0;0;u(1:end-2)])*u; %????? Dobre ale zbyt d¿e wartoœci???
% Wyœwietlenie danych:
subplot(3,1,1)
plot(u)
hold on
plot(y)
hold off
legend('u(n)','y(n)')
subplot(3,1,2)
plot(p(1,:))
hold on
plot(p(2,:))
plot(p(3,:))
hold off
legend('a1','a2','b2')
subplot(3,1,3)
plot(y)
hold on
plot(simout(:,4))
plot(ym)
plot(yn)
legend('y(n)','yo(n)','ym','yn')