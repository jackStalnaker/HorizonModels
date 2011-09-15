function LL = horizonModelNormalLL(hmean,hstd,hdata)
%HORIZONMODELNORMALLL returns the negative log likelihood of a mean 
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

% The log likelihood is the same as the log pdf 

% This one is quite simple, and honestly has an analytic solution. We're
% doing it this way for completeness.
LL = sum((hdata-hmean).^2)./(2*hstd^2);