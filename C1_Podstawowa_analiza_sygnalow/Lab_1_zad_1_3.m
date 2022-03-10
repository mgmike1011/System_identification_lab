% 1.3
N = 2000;
sigma_kwa = 0.64;
Tp = 0.001;
sigma = sqrt(sigma_kwa);
e = sigma*randn(1,N);
x = zeros(1,N);
y = zeros(1,N);
v = zeros(1,N);
H = tf([0.1],[1 -0.9],Tp);
for n = 1:N-1
    x(n) = sin(2*pi*5*n*Tp);
    y(n) = sin(2*pi*5*n*Tp)+e(n);
    v(n) = lsim(H,e,n);
end