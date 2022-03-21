N = 1001;
Tp = 1;
sigma2v = 0.001;
M = 30;
tend = 1000;

y = Zdata(:,1);
u = Zdata(:,2);

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

for i=1:1:M
    for j=1:1:M
        Ruu(j,i)=ru(i-j+M); % Macierz Ruu
    end
end

pseudoodwrotna_Ruu = pinv(Ruu);
g_12_1 = pseudoodwrotna_Ruu*ryu'/Tp; %lewy wz�r (12) cos srednio to wygl�da 
sigma_o = 0.5; % czy tu tez ruu(0) = sigma2_o????
%g_12_2 = % prawy wz�r (12)???
G = tf([0.5], [5 11 7 1], 'OutputDelay', 3); % ci�g�y model

t = 0:Tp:(M-1)*Tp;

figure
impulse(G)
hold on
plot(t, g_12_1, 'r')
%title('Porownanie wynikow')
