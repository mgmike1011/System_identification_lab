load('StochasticProcess.mat')
% Realizacja w czasie
m_czas = zeros(1,501);
sig_kwa_czas = zeros(1,501);
for i = 1:501
    x = StochasticProcess(i,:);
    m_czas(i) = mean(x);
    sig_kwa_czas(i) = var(x);
end
% Realizacja po realizacji
m_realizacja = zeros(1,1001);
sig_kwa_reali = zeros(1,1001);
for j = 1:1001
    x = StochasticProcess(:,j);
    m_czas(j) = mean(x);
    sig_kwa_czas(j) = var(x);
end
% Przedstawienie na wykresie:
% plot()