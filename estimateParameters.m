function [Y, minLL] = estimateParameters(horizonData, Y0, YLB, YUB, modelFcn)
% ESTIMATEPARAMETERS estimates the parameters of a specified horizon model
% from a given data set.

% Input parameters
%           horizonData     Horizon twt for each trace on horizon
%           Y0              Initial guess at model parameters
%           YLB             Lower bounds on parameters
%           YUB             Upper bounds on parameters
%           modelFcn        A string holding the name of the model function
%                           for which the parameters are desired
%
% Output parameters
%           Y               Matlab structure holding model parameters
%
% =========================================================================
% NOTES 
%
% Y, Y0, YLB, and YUB all have the same format.
%
% Y0 is a structure containing the variables expected as inputs to the model
% named in modelFcn. 
%
% The order of the fields in Y doesn't matter, but it does matter that all
% the fields are present in Y0, YLB, and YUB. The program checks for this,
% and warns if it isn't true

% Set optimizer options (only one should be uncommented)
%Options = optimset('maxfunevals',800,'maxiter',500,'LevenbergMarquardt','on','display','iter','TolFun',0.001); %
%Options = optimset('maxfunevals',1000,'maxiter',700,'LevenbergMarquardt','on','display','iter','TolFun',0.001,'Jacobian','on','Diagnostics','on'); %
Options = optimset('maxfunevals',1000000,'maxiter',700,'display','None','TolFun',1e-15); %
%Options = optimset('maxfunevals',2000,'maxiter',500,'LevenbergMarquardt','on','display','iter','TolX',1e-10,'TolFun',1e-10); %

% Sort the input structure fields
Y0 = orderfields(Y0);

% Convert the input structures to arrays. LSQNONLIN only understands
% arrays
fn = fieldnames(Y0);
initialGuess = zeros(1, length(fn));
for i = 1:length(fn)
    initialGuess(i) = Y0.(fn{i});
end

% if lower bounds have been provided, do the same
if ~isempty(YLB)
    YLB = orderfields(YLB);
    fnLB = fieldnames(YLB);
    
    % error checking
    if length(fnLB) ~= length(fn)
        error('YLB does not contain same number of fields as Y0');
    end
    if any(strcmp(fn,fnLB)) == 0
        error('YLB contains fields that are different from Y0');
    end
        
    lowerBounds = zeros(1, length(fn));
    for i = 1:length(fn)
        lowerBounds(i) = YLB.(fn{i});
    end
else
    lowerBounds = [];
end

% if upper bounds have been provided, do the same
if ~isempty(YUB)
    YUB = orderfields(YUB);
    fnUB = fieldnames(YUB);
        
    % error checking
    if length(fnUB) ~= length(fn)
        error('YUB does not contain same number of fields as Y0');
    end
    if any(strcmp(fn,fnUB)) == 0
        error('YUB contains fields that are different from Y0');
    end
    
    upperBounds = zeros(1, length(fn));
    for i = 1:length(fn)
        upperBounds(i) = YUB.(fn{i});
    end
else
    upperBounds = [];
end

% Pack information the model needs together for use in log likelihood function
modelInfo.modelFcn = modelFcn;
modelInfo.horizonData = horizonData;
modelInfo.fnames = fn;

%--------------------------
% Minimization
%--------------------------
%[estimate,LLNorm,~,~] = lsqnonlin('log_likelihood',initialGuess,lowerBounds,upperBounds,Options,modelInfo);
[estimate,minLL] = fminsearch(@(parameters) log_likelihood(parameters, modelInfo), initialGuess,Options);

% get rid of meaningless negative values (quirk of the way fminsearch
% works)
if strcmpi(modelFcn,'altHorizonModelFaultsLL')
    estimate([1,2,5]) = abs(estimate([1,2,5]));
else
    estimate = abs(estimate);
end

% Convert the arrays back to structures for output.
Y = Y0;
fn = fieldnames(Y0);
for i = 1:length(fn)
    Y.(fn{i}) = estimate(i);
    
    % Display on screen
    fprintf('Estimated %s:\t\t%5.3f\n', fn{i}, estimate(i));
end
fprintf('Minimum log likelihood:\t\t%5.3f\n', minLL);