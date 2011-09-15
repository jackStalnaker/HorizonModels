function [t,faultTrace] = altHorizonModelFaults(m,t0,mean,stdDev,numTraces,faultLambda,faultMean,faultStdDev)

% noise free horizon, modeled as a straight line, with 
% slope m = delta t/trace, and t-intercept t0
t = m * (1:numTraces) + t0;

% generate random deviation from linear model on each trace
terr = randn(numTraces,1) * stdDev + mean; 

% combine together to create noisy linear model
t = t' + terr;

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
for ifault = 1:numFaults
    t(1:numTraces >= faultTrace(ifault)) = ...
        t(1:numTraces >= faultTrace(ifault)) + ...
        faultOffsets(ifault).*faultThrow(ifault);
end
