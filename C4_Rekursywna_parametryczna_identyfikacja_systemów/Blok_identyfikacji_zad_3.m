function p_out = Blok_identyfikacji_zad_3(u_in)
global p1 p P P1
% Dane:
u = u_in(1); % u przefiltrowane przez SVF
y = u_in(2); % y z obiektu rzeczywistego przefiltrowane przez SVF
y1 = u_in(3); % y' -> SVF
x = u_in(5); % x z symulatora przefiltorwane przez SVF
x1 = u_in(6); % x' -> SVF
y_z_obiektu = u_in(8); % y z obiektu rzeczyiwstego
fi = [-y1;-y;u]; % regresor
z = [-x1;-x;u]; % zmienne instrumentalne
% Obliczenia estymatora
P = P1 - (P1*z*fi'*P1)/(1+fi'*P1*z); 
k = P * z;
E = u_in(4) - fi'*p1;
p = p1 + k*E;
p1 = p;
P1 = P;
p_out = p;
end