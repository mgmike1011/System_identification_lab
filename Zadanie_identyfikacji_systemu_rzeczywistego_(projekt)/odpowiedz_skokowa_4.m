clear all;
load('dane_.mat')
t_odp_skok = t_(1:499);
y_odp_skok = y_(499:997);
u_odp_skok = u_(499:997);
% Wyúwietlenie odpowiedzi skokowej
plot(t_odp_skok,y_odp_skok);
title('Odpowiedü skokowa - na podstawie pomiarÛw');
xlabel('Czas [s]')
grid on

% Obliczenie odpowiedzi impulsowej ze skokwej
odp_impulsowe = zeros(1,length(t_odp_skok));
for i=2:length(t_odp_skok)
    odp_impulsowe(i) = (y_odp_skok(i)-y_odp_skok(i-1))/(0.01);
end
% Wyswietlenie odpowiedzi impulsowej
figure
plot(t_odp_skok,odp_impulsowe)
title('Odpowiedü impulsowa - na podstawie pochodnej z odp. skokwej')
xlabel('Czas [s]')
grid on
% Wzmocnienie statyczne
K = y_odp_skok(end)/u_odp_skok(end);