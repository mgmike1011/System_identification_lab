%clear all; clc;
%Gêstoœci widmowe mocy N - elementowych sekwencji sygna³ów

%Dane:
Tp = 0.001; %okres próbkowania
H = tf([0.1],[1 -0.9],Tp); 
N = 2000; %wziête z zadania 1.3
sigma_kwadrat = 0.64; %z zadania 1.3
sigma = sqrt(sigma_kwadrat); 

x = zeros(1,N);
v = zeros(1,N);

tn = (0:N-1)*Tp;

%Sygna³y (skoñczone sekwencje ich próbek):
e = sigma * randn(1,N); %szum bia³y 
for n = 1:N
    x(n) = (sin(2*pi*5*n*Tp) + 0.5*sin(2*pi*10*n*Tp) + 0.25*sin(2*pi*30*n*Tp));
    v = (lsim(H,e,tn))'; %transpozycja aby by³ wymiar 1x2000
end 
    
% 2.1.1 Wyœwietlanie wykresów:
subplot(3,1,1)
plot(e)
title('Szum bia³y e(n)')
subplot(3,1,2);
plot(x)
title('Spróbkowany w czasie sygna³ - x(nTp)')
subplot(3,1,3)
plot(v)
title('Odpowiedz H na wymuszenie e - v')

% 2.1.2 Obliczenie i wyœwietlenie dyskretnego widma amplitudowego:

