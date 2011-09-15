function [t,faultTrace] = horizonModelFaults(mean,stdDev,t0,numTraces,faultLambda,faultMean,faultStdDev)

% generate random steps
t = randn(numTraces,1) * stdDev + mean; 

% replace first step with the known t0 value
t(1) = t0;

% Now determine how many jumps (faults) there will be based on a Poisson
% distribution with parameter lambda
numFaults = poissrnd(faultLambda);

% find the trace where the fault is located. All traces are equally likely,
% (except the first) so we'll use a uniform distribution
faultTrace = randi(numTraces-1,numFaults,1) + 1;

% find the fault offset, based on a second normal distribution 
faultOffsets = randn(numFaults,1) * faultStdDev + faultMean;

% May need to fix this, but let's assume fault throw is equally likely to
% be positive or negative
faultThrow = randi(2,numFaults,1);
faultThrow(faultThrow == 2) = -1;  % convert 2s to -1s

% add in the fault steps
t(faultTrace) = t(faultTrace) + faultOffsets.*faultThrow;

% get the actual horizon time by adding each step to the previous travel
% time

t = cumsum(t);
