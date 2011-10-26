function LL = log_likelihood(parameters,modelInfo)
% LOG_LIKELIHOOD returns the log likelihood of a model specified in modelInfo
% from a given data set also packed in modelInfo.
%
% Input parameters
%           parameters      Model parameters  
%           modelInfo       Structure holding all other required
%                           including the model function name of interest
%                           and the data set
%
% Output parameters
%           LL              Log Likelihood


% determine which log likelihood function we should call
if strcmpi(modelInfo.modelFcn,'horizonModelNormalLL')
    % Fminsearch doesn't do bounds, so let's prevent negative parameter values
    parameters = abs(parameters);

    LL = horizonModelNormalLL(diff(modelInfo.horizonData),parameters(1),parameters(2));
elseif strcmpi(modelInfo.modelFcn,'horizonModelFaultsLL')
    % Fminsearch doesn't do bounds, so let's prevent negative parameter values
    parameters = abs(parameters);

    LL = horizonModelFaultsLL(diff(modelInfo.horizonData),parameters(1),parameters(2),...
                              parameters(3),parameters(4));
elseif strcmpi(modelInfo.modelFcn,'altHorizonModelFaultsLL')
    % Fminsearch doesn't do bounds, so let's prevent negative parameter values
    % except for the slope and intercept, of course, which can be negative.
    parameters([1,2,5]) = abs(parameters([1,2,5]));

    LL = altHorizonModelFaultsLL(modelInfo.horizonData,parameters(1),parameters(2),...
                              parameters(3),parameters(4),parameters(5));
else
    error('Model name %s not recognized in loglikelihood.m', modelInfo.modelFcn);
end
