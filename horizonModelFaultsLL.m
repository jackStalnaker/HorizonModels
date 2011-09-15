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

% Likelihood of normal step size is gaussian.



% Likel





LL = sum((hdata-hmean).^2)./(2*hstd^2);