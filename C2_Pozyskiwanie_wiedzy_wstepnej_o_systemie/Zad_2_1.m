% Zmienne zadeklarowane przed uruchomieniem AKident.mdl

Tp = 1; %okres próbkowania 
sigma2v = 0; %wariancja zak³ócenia v
N = 1001; 
tend = 1000; %czas symulacji, czy tyle powinien wynosiæ? 
sim('AKident_2015')
u = Zdata(:,1);
y = Zdata(:,2);

% Zadanie 2_1_2 wyœwietliæ dane pomiarowe w dziedzinie czasu (Go(z)):
figure
subplot(2,1,1)
plot(Zdata(:,3),y)%Zdata(:,1))
title('y(n)')
subplot(2,1,2)
plot(Zdata(:,3),u)%Zdata(:,2))
title('u(n) wejœciowy sygna³ pobudzaj¹cy')
%currentFigure = gcf;
%title(currentFigure.Children(end), 'Wykresy w dziedzinie czasu');

%Zadanie 2_1_3 
M = 20;
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

%Wzór (10):
pseudoodwrotna_Ruu = pinv(Ruu);
gm_10 = pseudoodwrotna_Ruu*ryu';
t = 0:Tp:(M-1)*Tp;

%Wzór (11):
sigma_o = 0.5; %wariancja szumu bia³ego, czyli sygna³u wejœciowego
gm_11 = ryu'./sigma_o;

%Odpowiedz impulsowa obiektu Go(z):
Go_z = filt(2,[1 -0.7],Tp);
%Porównanie wyników analizy korelacyjnej: wzory (10), (11), obiektu:
figure
impulse(Go_z, M)
hold on 
plot(t, gm_10, t, gm_11, 'r');
legend('Odpowiedz systemu Go_z', 'Wzór 10', 'Wzór 11')
title('Analiza korelacyjna - wzory (10), (11), system')
axis([0 M -1 2]); 

% Wariancja sigmav2 na jakoœæ:
% sigmav2 = 0 dobre odwzorowanie (wzór 10 daje "p³ynny" przebieg, wzór 11
% taki "powyginany")

% sigmav2 = 0.001 dobre odwzorowanie

% sigmav2 = 0.01 %wzór 10 - dobre odwzorowanie, wzór 11 - trochê gorzej

% sigmav2 = 0.1

%zmiana sigmav2 nie wp³ynê³o na jakoœæ identyfikacji 
