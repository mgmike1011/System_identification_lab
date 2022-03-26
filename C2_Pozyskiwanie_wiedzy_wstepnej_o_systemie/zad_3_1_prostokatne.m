sim('AWident_2015')
u = Zdata(:,1);
y = Zdata(:,2);
M = 200;

for i = 1:2*N-1;
    ru(i) = Covar([u u],i-N-1);
    ryu(i) = Covar([y u],i-N-1); 
end

% z = zeros(N-M);
% o = ones(M);
% okno_prostokatne = [o(1,:) z(1,:)];
okno_prostokatne = rectwin(2*M+1);
okno_prostokatne = okno_prostokatne';

ru1 = ru(N-M:N+M); %Zmniejszenie liczby próbek
ryu1 = ryu(N-M:N+M); %Zmniejszenie liczby próbek

for k = 1:2*N-1;
  exp_razy_okno = exp(-j*2*pi*i*k/N) .* okno_prostokatne;
  Phi_uu(k) = ru1 * exp_razy_okno';
  Phi_yu(k) = ryu1 * exp_razy_okno'; 
  
end

exp_razy_okno = exp_razy_okno';

k2 = 0:1:(N-1)/2;
omega_k = 2*pi*k2/(N*Tp);

for i=1:1:N
Gdaszek_N_16_prostok(i) = Phi_yu(i)./Phi_uu(i);
end

figure;
Lm_G_N_16_prostok =  20*log10(abs(Gdaszek_N_16_prostok(1:501))); %bo omega_k 1:501
fi_G_N_16_prostok = angle(Gdaszek_N_16_prostok(1:501));

% Charakterystyka Bodego:
subplot(2,1,1)
semilogx(omega_k,Lm_G_N_16_prostok);
grid on
title('Lm(w)')
xlabel('w')
subplot(2,1,2)
semilogx(omega_k,fi_G_N_16_prostok)
grid on
title('fi(w)')
xlabel('w')
