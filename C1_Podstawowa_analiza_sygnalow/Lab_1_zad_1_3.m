% 1.3
N = 2000;
sigma_kwa = 0.64;
Tp = 0.001;
sigma = sqrt(sigma_kwa);
e = sigma*randn(1,N);
x = zeros(1,N);
y = zeros(1,N);
v = zeros(1,N);
H = tf(0.1,[1 -0.9],Tp);
tn = (0:N-1)*Tp;
tn(1) = 0;
for n = 1:N
    x(n) = sin(2*pi*5*n*Tp);
    y(n) = sin(2*pi*5*n*Tp)+e(n);
    v_ = lsim(H,e,tn);
    v(n) = v_(n);
end
% Wyœwietlenie sygna³ów
figure
subplot(2,1,1)
plot(y)
hold on
plot(x)
hold off
legend('y','x')
subplot(2,1,2)
plot(v)
legend('v')
% Wartoœci estymatora funkcji autokorelacji:
rxx = xcorr(x);
ryy = xcorr(y);
rvv = xcorr(v);
ree = xcorr(e);
% Wyœwietlenie wyników:
N = length(rxx);
% N_ = (-N+1):(N);
figure
subplot(4,1,1)
% xxr = flip(rxx);
% rx = [xxr rxx];
plot(rxx)
title('xcorr(x)')
% axis([(-N+1) (N-1) -1000 1000])
subplot(4,1,2)
plot(ryy)
title('xcorr(y)')
subplot(4,1,3)
plot(ree)
title('xcorr(e)')
subplot(4,1,4)
plot(rvv)
title('xcorr(v)')
% Sprawdziæ ró¿nice w przebiegu funkcji autokorelacji przy zastosowaniu estymatora obci¹¿onego i nieobci¹¿onego.
