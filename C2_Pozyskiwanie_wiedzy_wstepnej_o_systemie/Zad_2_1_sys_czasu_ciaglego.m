sim('AKident')
N = 1001;
Tp = 1;
sigma2v = 0.1;
M = 30;
tend = 1000;


u = Zdata(:,1);
y = Zdata(:,2);
ryu = zeros(1,N);
ruu = zeros(1,N);
for i=1:1:N
   ryu(i) = Covar([y u], i-1); % korelacja wzajemna yu
   ruu(i) = Covar([u u], i-1); % autokorelacja u
end
% ograniczenie liczby pr�bek korelacji wzajemnej do M
ryu=ryu(1:M); % zapisanie w postaci 1 wiersza o d�ugo�ci M

% ograniczenie liczby pr�bek autokorelacji do M
ruu=ruu(1:M); % zapisanie w postaci 1 wiersza o d�ugo�ci M

ruuo=ruu(M:-1:1); % odwr�cenie osi
ruuo=ruuo(1:M-1); % zmniejszenie liczby pr�bek odwr�conego
ru=[ruuo  ruu]; % po��czenie sygna�u z jego odbiciem

Ruu = zeros(M,M);
for i=1:1:M
    for j=1:1:M
        Ruu(j,i)=ru(i-j+M); % Macierz Ruu
    end
end

pseudoodwrotna_Ruu = pinv(Ruu);
g_12_1 = pseudoodwrotna_Ruu*ryu'/Tp; 

g12_2_ = zeros(1,length(1:1:M));
for i = 1:1:M
    g12_2_(i) = ryu(i) / ruu(1);
end
g_12_2 = 1/Tp * g12_2_;
G = tf([0.5], [5 11 7 1], 'OutputDelay', 3); % ci�g�y model

t = 0:Tp:(M-1)*Tp;

figure
impulse(G)
hold on
plot(t, g_12_1, 'r')
hold on
plot(t, g_12_2, 'g')
title('Porownanie wynikow')
legend('odp. systemu Go', 'wz�r 12(1)', 'wz�r 12(2)')
% wz�r 12(1) dobre odwzorowanie, lekko kanciaste i przesuni�te w praw�
% stron� wzgl�dem orygina�u
% 12(2) ni�ej warto�� maksymalna 

% Sprawdzi� Tp na jako�� identyfikacji 
% Tp = 2 zle odwzorowanie, za niskie przebiegi ze wzor�w (12)
% Tp = 1 ca�kiem dobre odwzorowanie, lepsze dla wzoru 12(1) niz 12(2)
% Tp = 0.5 �rednie odwzorowanie - wartosc max dla wzor�w (12) duzo wi�ksza
% niz dla modelu
% Tp = 0.25 z�e odwzorowanie, za duza warto�� max + odpowiedzi impuslowe
% dla (12) przesuni�te w lewo 

% Wartosc sigmav2 nie wp�ywa na jako�� identyfikacji (???)

% 2_1_odpowiedz skokowa ostatnia kropka:
suma_gM(1) = g_12_1(1); %pierwsza probka

suma_gM = zeros(length(1:1:M-1), 1);
for j = 1:1:M-1 %petla pr�bki - pierwsza pr�bka
    suma_gM(j+1,1) = g_12_1(j+1,1) + suma_gM(j,1);
end

hM = zeros(length(1:1:M),1);
for n = 1:1:M
    hM(n,1) = Tp * suma_gM(n,1);
end
figure ('Name','Odpowiedz skokowa')
plot(0:1:M-1, hM,'r')
hold on
step(G,M)
grid on
legend('model', 'Odpowiedz prawidlowa obiektu')

% ten poprawny, bo model dyskretny 
% pr�bki (stem):
figure('Name','Odpowiedz skokowa - pr�bki')
step(G, M)
hold on
stem(0:1:M-1, hM, 'r')
legend( 'Odpowiedz prawidlowa obiektu', 'model - pr�bki')

% na podstawie odp. skokowej mozna okre�li�, ze jest to 
% OBIEKT INERCYJNY I RZ�DU Z OPӏNIENIEM
% wzmocnienie k = 0.5,
% styczna -> mozna wyznaczy� sta�� czasow�
% tau (op�nienie) mozna wyznaczy� na podstawie wykresu