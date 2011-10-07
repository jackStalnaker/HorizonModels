function LL = horizonModelNormalLL(rwMean,rwStd,hdata)
%HORIZONMODELNORMALLL returns the negative log likelihood of an observed
% list of travel time differences between traces. Each element of the
% list of observations is described by the random variable equation 
%
%       Z = W
%
% where z is the observed time difference, W is the random walk step size.
%
% INPUTS
% =================
% rwMean:       Mean of random walk step size
% rwStd:        Std deviation of random walk step size
% hdata:        Given data set
% 
% OUTPUTS
% =================
% LL:           Negative log likelihood

% The log likelihood is the same as the log pdf 

% To be clear, the output should be a single, scalar value. It's the
% likelihood of the entire horizon occuring, which is created out of the
% likelihoods of individual observations travel time differences.

% This one is quite simple, and honestly has an analytic solution. We're
% doing it this way for completeness.
LL = (length(hdata)*log(rwStd^2)/2)+sum((hdata-rwMean).^2)./(2*rwStd^2);