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
modelInfo.modelFcn = modelFcn;
modelInfo.horizonData = horizonData;
modelInfo.fnames = fn;

if strcmpi(modelInfo.modelFcn,'horizonModelNormalLL')
    LL = horizonModelNormalLL(diff(model.horizonData),parameters(1),parameters(2));
elseif strcmpi(modelInfo.modelFcn,'horizonModelFaultsLL')
    LL = horizonModelFaultsLL(diff(model.horizonData),parameters(1),parameters(2),...
                              parameters(3),parameters(4));
elseif strcmpi(modelInfo.modelFcn,'altHorizonModelFaultsLL')
    LL = altHorizonModelFaultsLL(model.horizonData,parameters(1),parameters(2),...
                              parameters(3),parameters(4),parameters(5));
else
    error('Model name %s not recognized in loglikelihood.m', modelInfo.modelFcn);
end
