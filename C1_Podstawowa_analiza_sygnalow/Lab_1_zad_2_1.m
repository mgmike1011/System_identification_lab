%clear all; clc;
%G�sto�ci widmowe mocy N - elementowych sekwencji sygna��w

%Dane:
Tp = 0.001; %okres pr�bkowania
H = tf([0.1],[1 -0.9],Tp); 
N = 2000; %wzi�te z zadania 1.3
sigma_kwadrat = 0.64; %z zadania 1.3
sigma = sqrt(sigma_kwadrat); 

x = zeros(1,N);
v = zeros(1,N);

tn = (0:N-1)*Tp;

%Sygna�y (sko�czone sekwencje ich pr�bek):
e = sigma * randn(1,N); %szum bia�y 
for n = 1:N
    x(n) = (sin(2*pi*5*n*Tp) + 0.5*sin(2*pi*10*n*Tp) + 0.25*sin(2*pi*30*n*Tp));
    v = (lsim(H,e,tn))'; %transpozycja aby by� wymiar 1x2000
end 
    
% 2.1.1 Wy�wietlanie wykres�w:
subplot(3,1,1)
plot(e)
title('Szum bia�y e(n)')
subplot(3,1,2);
plot(x)
title('Spr�bkowany w czasie sygna� - x(nTp)')
subplot(3,1,3)
plot(v)
title('Odpowiedz H na wymuszenie e - v')

% 2.1.2 Obliczenie i wy�wietlenie dyskretnego widma amplitudowego:

