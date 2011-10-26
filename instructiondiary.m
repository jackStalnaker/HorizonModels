% generate synthetic data from normal model
hsyn = horizonModelNormal(3,2,1,50);
% this is the actual trace data. However, remember the log 
% likelihood model operates on the difference between the TWT of
% adjacent traces. Matlab has a command for computing the difference
% between elements of a vector: diff. The result will be one element
% shorted than the original vector, but that's fine for us.

Y0.rwMean = 0

Y0 = 

    rwMean: 0

Y0.rwStd = 0

Y0 = 

    rwMean: 0
     rwStd: 0

YUB = []

YUB =

     []

YLB = []

YLB =

     []

% upper bounds and lower bounds don't work for fminsearch. You
% can just leave them empty like this for now. 
Y = estimateParameters(hsyn,Y0,YLB,YUB,'horizonModelNormalLL')
Estimated rwMean:		2.651
Estimated rwStd:		2.160
Minumum of objective func:		62.246

Y = 

    rwMean: 2.6515
     rwStd: 2.1605

% note that the answer was printed to the screen (for your convenience)
% and also saved to the output variable Y, which has the same form as
% as the initial guess Y0.
% The answer won't be perfect. It will get better if you use more
% traces, but it will never be perfect.
hsyn = horizonModelNormal(3,2,1,500);
Y = estimateParameters(hsyn,Y0,YLB,YUB,'horizonModelNormalLL')
Estimated rwMean:		2.951
Estimated rwStd:		1.889
Minumum of objective func:		566.846

Y = 

    rwMean: 2.9506
     rwStd: 1.8888

% Note how much better the estimate was with 500 traces.
% check the answer against the mean and std of diff(hsyn)
mean(diff(hsyn))

ans =

    2.9506

std(diff(hsyn))

ans =

    1.8907

% results should be almost identical, but they were calculated in 
% different ways.


% Let's try the faults model with the same data set. Zero faults and no
% fault throw in our data, right?
% first add the fields we need to Y0
Y0.nFault = 0;
Y0.rftStd = 0;
Y0

Y0 = 

    rwMean: 0
     rwStd: 0
    nFault: 0
    rftStd: 0

Y = estimateParameters(hsyn,Y0,YLB,YUB,'horizonModelFaultsLL')
{Warning: Infinite or Not-a-Number value encountered.} 
> In <a href="matlab: opentoline('C:\Program Files\MATLAB\R2010b\toolbox\matlab\funfun\quadgk.m',336,1)">quadgk>midpArea at 336</a>
  In <a href="matlab: opentoline('C:\Program Files\MATLAB\R2010b\toolbox\matlab\funfun\quadgk.m',190,1)">quadgk at 190</a>
  In <a href="matlab: opentoline('U:\HorizonModels\horizonModelFaultsLL.m',81,1)">horizonModelFaultsLL at 81</a>
  In <a href="matlab: opentoline('U:\HorizonModels\log_likelihood.m',21,1)">log_likelihood at 21</a>
  In <a href="matlab: opentoline('U:\HorizonModels\estimateParameters.m',96,1)">estimateParameters>@(parameters)log_likelihood(parameters,modelInfo) at 96</a>
  In <a href="matlab: opentoline('C:\Program Files\MATLAB\R2010b\toolbox\matlab\funfun\fminsearch.m',195,1)">fminsearch at 195</a>
  In <a href="matlab: opentoline('U:\HorizonModels\estimateParameters.m',96,1)">estimateParameters at 96</a>
  In <a href="matlab: opentoline('U:\HorizonModels\horizonModelFaultsLL.m',81,1)">horizonModelFaultsLL at 81</a>
  In <a href="matlab: opentoline('U:\HorizonModels\log_likelihood.m',21,1)">log_likelihood at 21</a>
  In <a href="matlab: opentoline('U:\HorizonModels\estimateParameters.m',96,1)">estimateParameters>@(parameters)log_likelihood(parameters,modelInfo) at 96</a>
  In <a href="matlab: opentoline('C:\Program Files\MATLAB\R2010b\toolbox\matlab\funfun\fminsearch.m',195,1)">fminsearch at 195</a>
  In <a href="matlab: opentoline('U:\HorizonModels\estimateParameters.m',96,1)">estimateParameters at 96</a>

% whoa, what? Okay. That's not right. Apparently it doesn't like zero start
% values.
Y0.rwMean = 1;
Y0.nFault = 1;
Y0.rftStd = 1;

Y0 = 

    rwMean: 1
     rwStd: 0
    nFault: 1
    rftStd: 1

Y0.rwStd = 1;
Y = estimateParameters(hsyn,Y0,YLB,YUB,'horizonModelFaultsLL')
 
Exiting: Maximum number of function evaluations has been exceeded
         - increase MaxFunEvals option.
         Current function value: 1025.563746 

Estimated nFault:		462.207
Estimated rftStd:		1.872
Estimated rwMean:		2.967
Estimated rwStd:		0.638
Minumum of objective func:		1025.564

Y = 

    nFault: 462.2067
    rftStd: 1.8720
    rwMean: 2.9672
     rwStd: 0.6375

% I got nFault = 462, rftStd = 2, rwMean = 3, rwStd = 0.6. 
% What? That's not right. Or is it? Well, it is actually correct.
% remember that our synthetic data has no faults, so the 
% estimation routine assumed ALL the traces were faults, and 
% correctly got the fault throw stddev as 2, which was indeed the
% stddev of the random walk. The rest of the low level stuff was 
% taken care of by a much smaller random walk. Long story short,
% This IS the right answer, it's just that the model was poorly suited
% for the data. There are ways to get around this, but let's not
% worry at this point.
%
% Note too that the estimation routine is a LOT slower. This is also
% to be expected because we are integrating numerically inside the 
% log likelihood function.
%
% So let's make a synthetic data set specifically for the fault case
hsynf = horizonModelFaults(3,2,1,500,6,0,20);
Y = estimateParameters(hsynf,Y0,YLB,YUB,'horizonModelFaultsLL')
 
Exiting: Maximum number of function evaluations has been exceeded
         - increase MaxFunEvals option.
         Current function value: Inf 

Estimated nFault:		1.000
Estimated rftStd:		1.000
Estimated rwMean:		1.000
Estimated rwStd:		1.000
Minumum of objective func:		  Inf

Y = 

    nFault: 1
    rftStd: 1
    rwMean: 1
     rwStd: 1

plot(diff(hsyn))
plot(diff(hsynf))
plot(hsynf)
Y = estimateParameters(hsynf,Y0,YLB,YUB,'horizonModelFaultsLL')
 
Exiting: Maximum number of function evaluations has been exceeded
         - increase MaxFunEvals option.
         Current function value: Inf 

Estimated nFault:		1.000
Estimated rftStd:		1.000
Estimated rwMean:		1.000
Estimated rwStd:		1.000
Minumum of objective func:		  Inf

Y = 

    nFault: 1
    rftStd: 1
    rwMean: 1
     rwStd: 1

Y0.rftStd = 15

Y0 = 

    rwMean: 1
     rwStd: 1
    nFault: 1
    rftStd: 15

Y = estimateParameters(hsynf,Y0,YLB,YUB,'horizonModelFaultsLL')
Estimated nFault:		4.996
Estimated rftStd:		30.566
Estimated rwMean:		3.151
Estimated rwStd:		2.069
Minumum of objective func:		1107.539

Y = 

    nFault: 4.9962
    rftStd: 30.5662
    rwMean: 3.1514
     rwStd: 2.0689

% Notice that in this diary I ran the code several times. The first 
% time it failed, complaining that it was taking to long to find an
% answer. The actual complaint was that it had called 
% horizonModelFaults more times than I told it it should (see line
% 31 in estimateParameters.m, where I've set 'maxfunevals'). There
% are several ways around this: 1) set that number higher, and go get
% a coffee while the code runs. or 2) Set the initial value closer to
% the answer. "Wait, that's cheating! I can't do that with real data"
% Sure you can. Load up a horizon, plot the diff plot(diff(horizon)), 
% and pick something close to where most of the fault spikes peak. 
plot(diff(hsynf))
% and pick something close to roughly a third of the abs(biggest peak).
% Mine was at about 45, so I set my start value to 15.
% Another thing you can do is generate a smaller synthetic data set.
% Using 50 traces converges quite quickly. I can also replace 
% fminsearch in the algorithm with something faster/better if the
% need be. 
% fminunc will probably work fine, but I can't test it at work, since
% we don't have the optimization toolbox here. I will try it at home.
%
%
% What about the alt model? This one is a bit different. It doesn't
% use the difference between TWTs like the other two, although you 
% can estimate the rftStd the same way we did above.
%
%
% BREAK FOR SOME DEBUGGING ....
%
%
% ----------------------------------
% After some debugging, it is clear that you need to set the starting
% values of the STANDARD DEVIATION terms quite high. This will make a 
% lot of sense if you think about it. If you set it too small, the 
% likelihood of other parameters drops to zero, and the minimization 
% will have trouble knowing where to go.
%
% If this makes no sense, just remember that the starting (Y0) values
% any standard deviations should be quite high. Remember, they're in
% ms, just like your TWT, so if you see for instance faults normally
% offsetting 100 ms, then set your rftStd starting value to something
% like 200 ms.
% At least. Better to start high than low with the stddevs.
% 
% As a test, I generate some synthetic data with the NO FAULT model:
hsyn = horizonModelNormal(2,2,1,50);
% I'm not sure what the results will be, but let's try it. Here's my YO
% which I've set up using the alt model parameters:
Y0

Y0 = 

         nFault: 1
         rftStd: 100
    wnIntercept: 1
        wnSlope: 1
          wnStd: 100

% let's run it
Y = estimateParameters(hsyn,Y0,YLB,YUB,'altHorizonModelFaultsLL');
Estimated nFault:		0.000
Estimated rftStd:		421.106
Estimated wnIntercept:		-1.281
Estimated wnSlope:		2.125
Estimated wnStd:		2.482
Minumum of objective func:		116.520
Y

Y = 

         nFault: 1.8220e-010
         rftStd: 421.1063
    wnIntercept: -1.2806
        wnSlope: 2.1253
          wnStd: 2.4817

% So, basically we got our answer. There are no faults, it correctly
% guessed. (You can round nFault). The fault stddev looks weird, but
% it doesn't matter, since there are no faults. The white noise stddev
% is off a little, but probably close enough to the r.w. stddev. 
% What about the the slope and y-intercept? Should wnIntercept equal
% 1, the t0 we used as an input parameter? Not necessarily. Basically
% wnSlope and wnIntercept define a best fit line. Let's plot it.

% WAIT
% I SHOULD SAY THIS: YOUR ANSWERS WILL NOT BE THE SAME AS MINE. The
% synthetic data is random. So don't get discouraged if you're not 
% getting exactly the same answer.
%
% let's set up a trace number vector:
n = 1:length(hsyn);
plot(n,hsyn,n,Y.wnSlope*n + Y.wnIntercept)
% and it looks like our line (y = mx + b) fits really well. 
%
% The important thing to remember here is that the code works, but
% it is subject to conditions that may make it give the wrong answer.
%
% You could try a 500 trace data set here like we did before, and you should
% get a more correct answer for the same reasons.
%
% You can also try a set of data generated by the horizonModelFaults code and
% a set generated by the altHorizonModelFaults code. For the last case, you 
% will know the definitive answer before hand.
%
% As a final note, I have conducted a lot of tests not included here, and you
% will have difficulty estimating the number and throw of faults in the alt 
% model. But that's okay. It just goes to show that the random walk based 
% model is better.

%
% For the AIC: There's no code needed. You get the lowest log likelihood 
% from the code when you run it ( I just changed the wording to explicitly
% say minimum log likelihood. 
%
% If you really recall Matlab well, you'll remember that a function can have 
% multiple ouputs. The default output is the estimate Y. The second output is
% the minimum log likelihood, just in case you want to save it to a variable
% for AIC calculation like this:
[Y, minLL] = estimateParameters(hsyn,Y0,YLB,YUB,'altHorizonModelFaultsLL');
% minLL will hold the same value as the final line of the program's output
