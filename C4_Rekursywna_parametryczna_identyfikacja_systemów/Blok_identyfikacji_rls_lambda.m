function p_  = Blok_identyfikacji(u)
global P1_ p1_ lambda

% Dane:
y_ = u(4);
y_1 = u(5);
y_2 = u(6);
u_ = u(1);
u_1 = u(2);
u_2 = u(3);
% Regresor:
fi_ = [-y_1; -y_2; u_2];
P_ = 1/lambda(P1_ - (((P1_*fi_)*fi_'*P1_)/(lambda+fi_'*P1_*fi_))); % Macierz kowariancyjna
k_ = P_*fi_; % Wzmocnienie
E_ = y_-fi_'*p1_; % B³¹d predykcji jednokrokowej
p_f = p1_ + k_*E_; % Wektor parametrów
P1_ = P_;
p1_ = p_f;
p_ = p_f;
end
