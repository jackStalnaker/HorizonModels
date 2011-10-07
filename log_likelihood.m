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
