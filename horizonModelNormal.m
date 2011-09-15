function t = horizonModelNormal(mean,stdDev,t0,numTraces)

% generate random steps
t = randn(numTraces,1) * stdDev + mean; 

% replace first step with the known t0 value
t(1) = t0;

% get the actual horizon time by adding each step to the previous travel
% time

t = cumsum(t);