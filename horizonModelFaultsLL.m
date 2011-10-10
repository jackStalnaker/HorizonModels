function LL = horizonModelFaultsLL(hdata,nFault,rftStd,rwMean,rwStd)
%HORIZONMODELFAULTSLL returns the negative log likelihood of an observed
% list of travel time differences between traces. Each element of the
% list of observations is described by the random variable equation 
%
%       Z = W + XY
%
% where z is the observed time difference, W is the random walk step size,
% X is 0 if a fault is absent at this location, and 1 if it is not absent.
% Y is the throw of the fault.
%
% INPUTS
% =================
% hdata:        Given data set (list of z values)
% nFault:       Number of faults in horizon
% rftStd:        Standard deviation of fault throw
% rwMean:       Mean of random walk step size
% rwStd:        Std deviation of random walk step size

% 
% OUTPUTS
% =================
% LL:           Negative log likelihood

% To be clear, the output should be a single, scalar value. It's the
% likelihood of the entire horizon occuring, which is created out of the
% likelihoods of individual observations travel time differences.

% NOTE: the following likelihoods are declared as anonymous functions in
% matlab. Meaning they're all just one line functions that take an argument
% x as defined in the @(x) part of the code. That's because these values
% will be integrated over, since we don't have direct observations of the
% data they represent the likelihood of.

% Likelihood of random walk step size is gaussian. 
rwL = @(w,rwMean,rwStd) (1/sqrt(2*pi*rwStd^2)) * exp((-(w-rwMean).^2)/(2*rwStd.^2));

% Likelihood of a fault being present is a bernoulli distribution.
% where the probability of a fault being present at all is a poisson
% estimated number of faults over the number of traces. 
pFault = nFault/size(hdata,1);

% bernoulli pmf/likelihood
fpL = @(x,pFault) pFault.^x * (1-pFault).^(1-x);

% Likelihood of fault throw is zero-mean gaussian
ftL = @(y,rftStd) (1/sqrt(2*pi*rftStd^2)) * exp((-(y).^2)/(2*rftStd.^2));

% independent joint likelihood
jntL = @(y,z,rwMean,rwStd,pFault,rftStd) ...
    ftL(y,rftStd) .* (fpL(0,pFault) .* ...
    rwL(z,rwMean,rwStd) + fpL(1,pFault).*rwL(z-y,rwMean,rwStd));

% numerically integrate for each observation in the data vector hdata
% technically, this is an integral from -infinity to infinity, but it's the
% integral of a gaussian (bell curve). 99.7% of the area under a bell curve
% occurs falls under +/- 3 standard deviations, so we can set our limits 
% to much more sensible values.

% Also, remember that maximizing the likelihood is the same as maximizing
% the log likelihood (because log(x) increases as x increases. Also,
% maximizing the likelihood is the same as minimizing the negative
% likelihood, which works better for most optimization software. Finally,
% note that 'log' in matlab means natural log, which is typically written
% 'ln' on paper. 'log10' is your typical base 10 logarithm.

% The likelihood contains an integral of the pdf of y, which is zero mean
% gaussian. This integral is technically from -infinity < y < infinity, but
% because the pdf is a bell curve, we only need to go from -3*stddev  < y <
% 3*stddev. Why? Because 99.7% of the area under a bell curve falls within
% 3 stddevs.

intlim = 3*rftStd;
LL = 0;
for k = 1: length(hdata)
    z = hdata(k);
    % we're summing up the log likelihood of all the observed data points
    % here. Since the observations are all independent, the pdf of the
    % whole observation vector is just the product of its terms. logging a
    % product turns it into a sum
    LL = LL - log(quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim));
end