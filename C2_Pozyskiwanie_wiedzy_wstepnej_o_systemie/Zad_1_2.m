clear all; clc;
% 1 - Stosuj¹c wzory (2)-(5) dokonaæ identyfikacji systemu z u¿yciem modelu Gm2(s)
load('ProcessStepResponse.mat');
load('NoisyProcessStepResponse.mat');
t = S(:,1); %Wektor czasu - bez zak³óceñ
