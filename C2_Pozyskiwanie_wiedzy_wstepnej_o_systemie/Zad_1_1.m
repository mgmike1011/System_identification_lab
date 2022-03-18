clear all; clc;
% 1 - za�adowa� dane
S = load('ProcessStepResponse.mat');
t = S.S(:,1); %Wektro czasu
Tp = t(2); %Okres pr�bkowania
h = S.S(:,2); %wektor odpowiedzi skokowej
% 2 - Wykre�li� sekwencj� pr�bek odpowiedzi skokowej i oszacowa� wzmocnienie statyczne systemu.
figure
plot(t,h)
title('Odpowied� skokowa systemu')
grid on
% Wzmocnienie statyczne systemu = 0.5 (odczytane z wykresu)
% 0.5*0.5 = 0.25<-T50 , 0.5*0.9 = 0.45<-T90
T50 = 11.5; T90 = 22.7;
T_ = T90/T50; %1.9739
T_z90 = T90/5.32;
T_z50 = T50/2.67;
T = (T_z90+T_z50)/2;
% Rz�d dynamiki = 3
% Parametry zast�pcze modelu: K = 0.5, T = 4.2870, p = 3
% Oszacowana odpowied� impulsowa z pomiar�w:
g = zeros(length(h),1);
for i = 2:length(h)
    g(i) = (h(i)-h(i-1))/(t(i)-t(i-1));
end
% Model systemu:
s = tf('s');
Gm1 = 0.5/((T*s+1)^3);
% Por�wnanie odpowiedzi skokowych i impulsowych:
figure
subplot(2,1,1)
step(Gm1)
hold on
plot(t,h,'r')
grid on
hold off
title('Odpowiedzi skokowe system�w')
legend('Model matlab','pomiary')
subplot(2,1,2)
plot(t,g,'r')
hold on
impulse(Gm1)
grid on
hold off
title('Odpowiedzi impulsowe system�w')
legend('pomiary','Model matlab')
% 3 - Powt�rzy� powy�sz� procedur� identyfikacji dla przypadku danych zak��conych
load('NoisyProcessStepResponse.mat') %ns
t_2 = nS(89:end,1)-8.7; %Wektro czasu
h_2 = nS(89:end,2); %Wektor odpowiedzi skokowej
figure
plot(t_2,h_2)
title('Odpowied� skokowa systemu - zak��cenia')
grid on
% Wzmocnienie statyczne systemu = 0.24 (odczytane z wykresu)
% 0.24*0.5 = 0.12 <- T50 , 0.24*0.9 = 0.2160 <- T90
T50_2 = 24.7; T90_2 = 48.7;
T_2 = T90_2/T50_2; %1.9717
T_z90 = T90_2/5.32;
T_z50 = T50_2/2.67;
T2 = (T_z90+T_z50)/2;
% Rz�d dynamiki = 1
% Parametry zast�pcze modelu: K = 0.24, T = 9.2025 , p = 3
% Oszacowana odpowied� impulsowa z pomiar�w:
g2 = zeros(length(h_2),1);
for i = 2:length(h_2)
    g2(i) = (h_2(i)-h_2(i-1))/(t_2(i)-t_2(i-1));
end
% Model systemu:
Gm1_2 = 0.24/((s*T2+1)^3);
% Por�wnanie odpowiedzi skokowych i impulsowych:
figure
subplot(2,1,1)
step(Gm1_2)
hold on
plot(t_2,h_2,'r')
grid on
hold off
title('Odpowiedzi skokowe system�w - zak��cone')
legend('Model matlab','pomiary')
subplot(2,1,2)
plot(t_2,g2,'r')
hold on
impulse(Gm1_2)
grid on
hold off
title('Odpowiedzi impulsowe system�w')
legend('pomiary','Model matlab')