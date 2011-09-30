function LL = horizonModelFaultsLL(hmean,hstd,hdata)
%HORIZONMODELFAULTSLL returns the negative log likelihood of a mean 
% and standard deviation given a data set
%
% INPUTS
% =================
% hmean:        Mean of random walk step size
% hstd:         Std deviation of random walk step size
% hdata:        Given data set
% 
% OUTPUTS
% =================
% LL:           Negative log likelihood

% NOTE: the following likelihoods are declared as anonymous functions in
% matlab. Meaning they're all just one line functions that take an argument
% x as defined in the @(x) part of the code. That's because these values
% will be integrated over, since we don't have direct observations of the
% data they represent the likelihood of.

% Likelihood of random walk step size is gaussian. 
rwL = @(x) (1/sqrt(2*pi*rwStd^2)) * exp((-(x-rwMean).^2)/(2*rwStd.^2));

% Likelihood of a fault being present is a bernoulli distribution.
% where the probability of a fault being present at all is a poisson
% estimated number of faults over the number of traces. 
pFault = nFault/size(hdata,1);

% bernoulli pmf/likelihood
fpL = @(x) pFault.^x * (1-pFault).^(1-x);

% Likelihood of fault throw is zero-mean gaussian
ftL = @(x) (1/sqrt(2*pi*ftStd^2)) * exp((-(x).^2)/(2*ftStd.^2));

% independent joint likelihood
jntL = @(x,y,z) rwL(x) * fpL(y) * ftL(z);

% numerically integrate for each observation in the data vector hdata

