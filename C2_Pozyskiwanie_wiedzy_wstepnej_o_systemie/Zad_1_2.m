clear all; clc;
% 1 - Stosuj�c wzory (2)-(5) dokona� identyfikacji systemu z u�yciem modelu Gm2(s)
load('ProcessStepResponse.mat');
load('NoisyProcessStepResponse.mat');
t = S(:,1); %Wektor czasu - bez zak��ce�
