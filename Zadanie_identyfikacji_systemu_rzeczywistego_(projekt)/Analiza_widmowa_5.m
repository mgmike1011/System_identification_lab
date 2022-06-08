clear all;

% Zaladowanie danych
load('dane_.mat')

% Podstawowe dane
Tp = 0.01; % [s] Okres próbkowania
t_analiza_widmowa = t_;
y_analiza_widmowa = y_;
u_analiza_widmowa = u_;

N = length(u_analiza_widmowa); % Iloœæ próbek w eksperymencie
Mw = 300; % Mw < N/5
i = -Mw:Mw;

% Autokorelacja w³asna i wzajemna
ru = zeros(size(i)); 
ryu = zeros(size(i)); 
for j = 1:length(i);
    ru(j) = Covar([u_analiza_widmowa u_analiza_widmowa],i(j));
    ryu(j) = Covar([y_analiza_widmowa u_analiza_widmowa],i(j)); 
end

% Wzor - okno przesunieciowe Hanninga wH
okno_hanninga = 0.5*(cos(i*pi/Mw)+1);

% Estymaty gestosci widmowych mocy
Phi_uu = zeros(1,N);
Phi_yu = zeros(1,N);
for k = 0:length(-Mw:1:Mw);
  exp_razy_okno = exp(-1i*2*pi*i*k/N) .* okno_hanninga;
  Phi_uu(k+1) = sum(okno_hanninga .* ru .* exp(-1j .* i .* (2*pi*k/N) )); 
  Phi_yu(k+1) = sum(okno_hanninga .* ryu .* exp(-1j .* i .* (2*pi*k/N) )); 
  
end

% Estymator transmitancji - iloraz estymatorow gestosci widmowych mocy
Gdaszek_N = Phi_yu./Phi_uu;

% Obliczenia konieczne do wykreslenia charakterystyk Bodego
k2 = 0:1:(N-1)/2;
omega_k = 2*pi*k2/(N*Tp);
    % Modul logarytmiczny
Lm_G_N =  20*log10(abs(Gdaszek_N(1:length(omega_k)))); 
    % Przesuniecie fazowe fi
fi_G_N = rad2deg(atan2(imag(Gdaszek_N(1:length(omega_k))), real(Gdaszek_N(1:length(omega_k)))));

% Charakterystyka Bodego
figure;
    % Czestotliwosciowa charakterystyka Bodego
subplot(2,1,1)
semilogx(omega_k, Lm_G_N);
grid on
xlabel('Frequency [rad/s]')
ylabel('Magnitude [dB]')
title('Czestotliwosciowa charakterystyka Bodego')
    % Fazowa charakterystyka Bodego
subplot(2,1,2)
semilogx(omega_k,fi_G_N)
grid on
xlabel('Frequency [rad/s]')
ylabel('Phase [deg]')
title('Fazowa charakterystyka Bodego')