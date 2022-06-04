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
% ograniczenie liczby próbek korelacji wzajemnej do M
ryu=ryu(1:M); % zapisanie w postaci 1 wiersza o d³ugoœci M

% ograniczenie liczby próbek autokorelacji do M
ruu=ruu(1:M); % zapisanie w postaci 1 wiersza o d³ugoœci M

ruuo=ruu(M:-1:1); % odwrócenie osi
ruuo=ruuo(1:M-1); % zmniejszenie liczby próbek odwróconego
ru=[ruuo  ruu]; % po³¹czenie sygna³u z jego odbiciem

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
G = tf([0.5], [5 11 7 1], 'OutputDelay', 3); % ci¹g³y model

t = 0:Tp:(M-1)*Tp;

figure
impulse(G)
hold on
plot(t, g_12_1, 'r')
hold on
plot(t, g_12_2, 'g')
title('Porownanie wynikow')
legend('odp. systemu Go', 'wzór 12(1)', 'wzór 12(2)')
% wzór 12(1) dobre odwzorowanie, lekko kanciaste i przesuniête w praw¹
% stronê wzglêdem orygina³u
% 12(2) ni¿ej wartoœæ maksymalna 

% Sprawdziæ Tp na jakoœæ identyfikacji 
% Tp = 2 zle odwzorowanie, za niskie przebiegi ze wzorów (12)
% Tp = 1 ca³kiem dobre odwzorowanie, lepsze dla wzoru 12(1) niz 12(2)
% Tp = 0.5 œrednie odwzorowanie - wartosc max dla wzorów (12) duzo wiêksza
% niz dla modelu
% Tp = 0.25 z³e odwzorowanie, za duza wartoœæ max + odpowiedzi impuslowe
% dla (12) przesuniête w lewo 

% Wartosc sigmav2 nie wp³ywa na jakoœæ identyfikacji (???)

% 2_1_odpowiedz skokowa ostatnia kropka:
suma_gM(1) = g_12_1(1); %pierwsza probka

suma_gM = zeros(length(1:1:M-1), 1);
for j = 1:1:M-1 %petla próbki - pierwsza próbka
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
% próbki (stem):
figure('Name','Odpowiedz skokowa - próbki')
step(G, M)
hold on
stem(0:1:M-1, hM, 'r')
legend( 'Odpowiedz prawidlowa obiektu', 'model - próbki')

% na podstawie odp. skokowej mozna okreœliæ, ze jest to 
% OBIEKT INERCYJNY I RZÊDU Z OPÓNIENIEM
% wzmocnienie k = 0.5,
% styczna -> mozna wyznaczyæ sta³¹ czasow¹
% tau (opóŸnienie) mozna wyznaczyæ na podstawie wykresu