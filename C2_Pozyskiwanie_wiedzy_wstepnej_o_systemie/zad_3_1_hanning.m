% close all
clear;
clc;

sim('AWident_2015')
u = Zdata(:,1);
y = Zdata(:,2);
M = 200;

ru = zeros(1,length(1:2*N-1)); 
ryu = zeros(1,length(1:2*N-1)); 
for i = 1:2*N-1;
    ru(i) = Covar([u u],i-N-1);
    ryu(i) = Covar([y u],i-N-1); 
end

i = -M:1:M;
okno_hanninga = 0.5*(cos(i*pi/M)+1);

ru1 = ru(N-M:N+M); %Zmniejszenie liczby próbek
ryu1 = ryu(N-M:N+M); %Zmniejszenie liczby próbek

for k = 1:2*N-1;
  exp_razy_okno = exp(-j*2*pi*i*k/N) .* okno_hanninga;
  Phi_uu(k) = ru1 * exp_razy_okno';
  Phi_yu(k) = ryu1 * exp_razy_okno'; 
  
end

k2 = 0:1:(N-1)/2;
omega_k = 2*pi*k2/(N*Tp);

for i=1:1:N
Gdaszek_N_16(i) = Phi_yu(i)./Phi_uu(i);
end

figure;
Lm_G_N_16 =  20*log10(abs(Gdaszek_N_16(1:501))); %bo omega_k 1:501
fi_G_N_16 = rad2deg(-1*atan2(imag(Gdaszek_N_16(1:501)), real(Gdaszek_N_16(1:501))));

% Charakterystyka Bodego:
subplot(2,1,1)
semilogx(omega_k,Lm_G_N_16);
grid on
title('Lm(w)')
xlabel('w')
subplot(2,1,2)
semilogx(omega_k,fi_G_N_16)
grid on
title('fi(w)')
xlabel('w')