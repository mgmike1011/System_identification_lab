clear all; clc;
% 1 - Stosuj¹c wzory (2)-(5) dokonaæ identyfikacji systemu z u¿yciem modelu Gm2(s)
load('ProcessStepResponse.mat');
load('NoisyProcessStepResponse.mat');
t = S(:,1); %Wektor czasu - bez zak³óceñ
h = S(:,2); %Wektor odpowiedzi skokowej - bez zak³óceñ
t_2 = nS(:,1); %Wektor czasu - zak³ócenia
h_2 = nS(:,2); %Wektor odpowiedzi skokowej - zak³ócenia
% Identyfikacja bez zak³oceñ:
figure
plot(t,h) %Wyœwietlenie odp skokowej z pomiarów
title('OdpowiedŸ skokowa i impulsowa bez zak³óceñ - 1.2.1')
grid on
hold on
% OdpowiedŸ impulsowa
% Oszacowana odpowiedŸ impulsowa z pomiarów:
g = zeros(length(h),1);
for i = 2:length(h)
    g(i) = (h(i)-h(i-1))/(t(i)-t(i-1));
end
plot(t,g)
ag = max(g);
t_ = find(g == ag);
tg = t(t_);
sg = h(t_);
b = sg - ag*tg;
s = ag*t+b;%0.0343*t-0.1398
plot(t(1:300),s(1:300),'--')
legend('skokowa','impulsowa','s(tn)')
% Parametry:
K = 0.5; %Wzmocnienie
T0 = (ag*tg-sg)/ag; %OpóŸnienie
T = K/ag; %Sta³a czasowa
% Transmitancja:
Gm2 = tf(K,[T,1]);
Gm2.InputDelay = T0;
% Porównanie odpowiedzi:
figure
subplot(2,1,1)
plot(t,h,'r')
hold on
step(Gm2)
grid on
hold off
title('Odpowiedzi skokowe bez zak³óceñ - 1.2.1')
legend('pomiar','model')
subplot(2,1,2)
plot(t,g,'r')
hold on
impulse(Gm2)
hold off
grid on
title('Odpowiedzi impulsowe')
legend('pomiar','model')
% Co mo¿na powiedzieæ na temat efektywnoœci tej metody identyfikacji? -
% Ma³o efektywna, niski rz¹d modelu

% Identyfikacja pomiary z zak³óceniami:
figure
plot(t_2,h_2) %Wyœwietlenie odp skokowej z pomiarów
title('OdpowiedŸ skokowa i impulsowa - zak³ócenia - 1.2.2')
grid on
hold on
% OdpowiedŸ impulsowa
% Oszacowana odpowiedŸ impulsowa z pomiarów:
g_2 = zeros(length(h_2),1);
for i = 2:length(h_2)
    g_2(i) = (h_2(i)-h_2(i-1))/(t_2(i)-t_2(i-1));
end
plot(t_2,g_2)
ag_2 = max(g_2);
t__2 = find(g_2 == ag_2);
tg_2 = t(t__2);
sg_2 = h(t__2);
b_2 = sg_2 - ag_2*tg_2;
s_2 = ag_2*t_2+b_2;%0.0527*t-1.2366
plot(t_2(200:300),s_2(200:300),'--')
legend('skokowa','impulsowa','s(tn)')
hold off
% Parametry:
K_2 = 0.24; %Wzmocnienie
T0_2 = (ag_2*tg_2-sg_2)/ag_2; %OpóŸnienie
T_2 = K_2/ag_2; %Sta³a czasowa
% Transmitancja:
Gm2_2 = tf(K_2,[T_2,1]);
Gm2_2.InputDelay = T0_2;
% Porównanie odpowiedzi:
figure
subplot(2,1,1)
plot(t_2,h_2,'r')
hold on
step(Gm2_2)
grid on
hold off
title('Odpowiedzi skokowe zak³ócenia')
legend('pomiar','model')
subplot(2,1,2)
plot(t_2,g_2,'r')
hold on
impulse(Gm2_2)
hold off
grid on
title('Odpowiedzi impulsowe')
legend('pomiar','model')
% Co mo¿na powiedzieæ na temat efektywnoœci metody w przypadku danych
% zak³óconych? - ca³kowicie nieefektywna