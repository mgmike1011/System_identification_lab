load('StochasticProcess.mat')
data = StochasticProcess(2:end,:);
ilosc_realizacji = length(data(:,1));
czas_realizacji = length(data(1,:));
% Realizacja w czasie
m_czas = zeros(1,czas_realizacji);
sig_kwa_czas = zeros(1,czas_realizacji);
for i = 1:czas_realizacji
    x = data(1:end,i);
    m_czas(i) = mean(x);
    sig_kwa_czas(i) = var(x);
end
% Realizacja po realizacji
m_realizacja = zeros(1,ilosc_realizacji);
sig_kwa_realizacja = zeros(1,ilosc_realizacji);
for i = 1:ilosc_realizacji
    x = data(:,i);
    m_realizacja(i) = mean(x);
    sig_kwa_realizacja(i) = var(x);
end
% Przedstawienie na wykresie:
% Wartoœæ oczekiwana
plot(m_czas)
hold on
plot(m_realizacja)
hold off
title('Wartoœæ oczekiwana')
legend('Po czasie','Po realizacji')
% Wariancja
figure
plot(sig_kwa_czas)
hold on
plot(sig_kwa_realizacja)
hold off
title('Estymatory wariancji')
legend('Po czasie','Po realizacji')
% Wyswietlenie w konsoli:
disp('Wartoœæ oczekiwana po czasie:')
mean(m_czas)
disp('Wartoœæ oczekiwana po realizacji:')
mean(m_realizacja)
disp('Wariancja po czasie:')
mean(sig_kwa_czas)
disp('Wariancja po realizacji:')
mean(sig_kwa_realizacja)