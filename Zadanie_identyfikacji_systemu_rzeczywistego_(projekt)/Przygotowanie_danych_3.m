clear all;
load('dane.mat')
u_ = u(1001:end);
y_ = y(1001:end);
t_ = t(1:(end-1000));
plot(t_,u_);
hold on
plot(t_,y_);
legend('u','y')
xlabel('Czas [s]')
grid on
title('Dane wybrane do eksperymentu identyfikacji')