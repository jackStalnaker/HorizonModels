function Y = estimateParameters(horizonData, Y0, YLB, YUB, modelFcn)
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
% Y is a structure containing the variables expected as inputs to the model
% named in modelFcn. The fields of the structure HAVE TO BE IN THE EXACT
% ORDER THAT THE INPUT PARAMETERS ARE LISTED IN THE MODEL INPUTS. If they
% aren't, the estimation will be INCORRECT. 
%
% If modelFcn = 'horizonModelNormalLL', the input parameters have to be in
% the order "mean", "standard deviation", etc.


% Set optimizer options (only one should be uncommented)
%Options = optimset('maxfunevals',800,'maxiter',500,'LevenbergMarquardt','on','display','iter','TolFun',0.001); %
%Options = optimset('maxfunevals',1000,'maxiter',700,'LevenbergMarquardt','on','display','iter','TolFun',0.001,'Jacobian','on','Diagnostics','on'); %
Options = optimset('maxfunevals',10000,'maxiter',700,'LevenbergMarquardt','on','display','iter','TolFun',1e-15,'Jacobian','off'); %
%Options = optimset('maxfunevals',2000,'maxiter',500,'LevenbergMarquardt','on','display','iter','TolX',1e-10,'TolFun',1e-10); %

% Convert the input structures to arrays. LSQNONLIN only understands
% arrays
fn = fieldnames(Y0);
initialGuess = zeros(1, length(fn));
for i = 1:length(fn)
    initialGuess(i) = Y0.(fn{i});
end

% if lower bounds have been provided, do the same
if ~isempty(YLB)
    fn = fieldnames(YLB);
    lowerBounds = zeros(1, length(fn));
    for i = 1:length(fn)
        lowerBounds(i) = YLB.(fn{i});
    end
else
    lowerBounds = [];
end

% if upper bounds have been provided, do the same
if ~isempty(YUB)
    fn = fieldnames(YUB);
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

%--------------------------
% LEVENBURG-MARQUARDT
%--------------------------
[estimate,LLNorm,~,~] = lsqnonlin('log_likelihood',initialGuess,lowerBounds,upperBounds,Options,modelInfo);

% Convert the arrays back to structures for output.

Y = Y0;
fn = fieldnames(Y0);
for i = 1:length(fn)
    Y.(fn{i}) = estimate(i);
    
    % Display on screen
    fprintf('Estimated %s:\t\t%5.3f\n', fn{i}, LMResult(i));
end
fprintf('Best fit residual norm:\t\t%5.3f\n', ResNorm);
