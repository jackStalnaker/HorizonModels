x = fminsearch(@(x) horizonModelNormalLL(hsyn,x(1),x(2)),[0 0])
horizonModelNormal(hsyn,x(1),x(2))
horizonModelNormalLL(hsyn,x(1),x(2))
horizonModelNormalLL(hsyn,2,2)
horizonModelNormalLL(hsyn,1,1)
horizonModelNormalLL(hsyn,3,2)
x = fminsearch(@(x) horizonModelNormalLL(hsyn,x(1),x(2)),[0 0])
mle(hsyn,'logpdf',horizonModelNormalLL)
horizonModelNormalLL(hsyn,3,2)
horizonModelNormalLL(hsyn,1,1)
mean(hsyn)
stddev(hsyn)
std(hsyn)
mle(hsyn,'logpdf',horizonModelNormalLL)
x = fminsearch(@(x) horizonModelNormalLL(hsyn,x(1),x(2)),[0 0])
x = fminsearch(@(x) horizonModelNormalLL(diff(hsyn),x(1),x(2)),[0 0])
mean(diff(hsyn))
std(diff(hsyn))
x = fminsearch(@(x) horizonModelFaultsLL(diff(hsyn),x(1),x(2)),[0 0])
x = fminsearch(@(x) horizonModelFaultsLL(diff(hsyn),x(1),x(2),x(3),x(4)),[0 0 0 0])
horizonModelFaultsLL(hsyn,1,1,1,1)
horizonModelFaultsLL(hsyn,0,0,0,0)
rwMean =1
rwStd = 1
nFault = 1
rftStd = 1
pFault = nFault/size(diff(hsyn),1)
diff(hsyn)
pFault = nFault/size(diff(hsyn),1)
intlim = 3*rftStd
hdata = diff(hsyn)
z = hdata(1)
rwL = @(w,rwMean,rwStd) (1/sqrt(2*pi*rwStd^2)) * exp((-(w-rwMean).^2)/(2*rwStd.^2));
rwL(hdata,1,1)
prod(rwL(hdata,1,1))
fpL = @(x,pFault) pFault.^x * (1-pFault).^(1-x);
fpL(hdata,pFault)
fpL = @(x,pFault) pFault.^x .* (1-pFault).^(1-x);
fpL(hdata,pFault)
prod(fpL(hdata,pFault))
jntL = @(y,z,rwMean,rwStd,pFault,rftStd) ...
ftL(y,rftStd) .* (fpL(0,pFault) .* ...
rwL(z,rwMean,rwStd) + fpL(1,pFault).*rwL(z-y,rwMean,rwStd));
z
quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim)
ftL = @(y,rftStd) (1/sqrt(2*pi*rftStd^2)) * exp((-(y).^2)/(2*rftStd.^2));
ftL(hdata,1)
prod(ftL(hdata,1))
quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim)
ftL = @(y,rftStd) (1/sqrt(2*pi*rftStd^2)) * exp((-(y).^2)/(2*rftStd.^2));
jntL = @(y,z,rwMean,rwStd,pFault,rftStd) ...
ftL(y,rftStd) .* (fpL(0,pFault) .* ...
rwL(z,rwMean,rwStd) + fpL(1,pFault).*rwL(z-y,rwMean,rwStd));
quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim)
z = hdata(2)
quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim)
z = hdata(3)
quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim)
for k = 1:length(hdata)
z = hdata(k)
for k = 1:length(hdata)
z = hdata(k);
quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim)
end
LL = 0
for k = 1:length(hdata)
z = hdata(k);
log(quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim))
end
for k = 1:length(hdata)
z = hdata(k);
LL = LL - log(quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim))
end
rwMean = 3
rwStd = 2
LL=0
for k = 1:length(hdata)
z = hdata(k);
LL = LL - log(quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim))
end
horizonModelFaultsLL(hsyn,0,0,0,0)
horizonModelFaultsLL(hsyn,1,1,1,1)
horizonModelFaultsLL(hsyn,3,2,1,1)
rwMean = 1
rwStd = 1
horizonModelFaultsLL(hdata,1,1,1,1)
horizonModelFaultsLL(hsyn,1,1,1,1)
plot(hsyn)
plot(hdiff)
plot(hdata)
LL=0
for k = 1:length(hdata)
z = hdata(k);
LL = LL - log(quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim))
end
LL=0
for k = 1:length(hdata)
z = hsyn(k);
LL = LL - log(quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim))
end
LL=0
for k = 1:10
z = hsyn(k);
LL = LL - log(quadgk(@(y) jntL(y,z,rwMean,rwStd,pFault,rftStd),-intlim,intlim))
end
plot(hsyn)
x = fminsearch(@(x) horizonModelFaultsLL(diff(hsyn),x(1),x(2),x(3),x(4)),[0 0 0 0])
x = fminsearch(@(x) horizonModelFaultsLL(hdata,x(1),x(2),x(3),x(4)),[1 1 1 1])
horizonModelFaultsLL(hdata,x(1),x(2),x(3),x(4))
x(1)
x(2)
x(3)
x(4)
doc fminsearch
x = fmincon(@(x) horizonModelNormalLL(diff(hsyn),x(1),x(2)),[0 0],[],[],[],[],0,1000)
x = fmincon(@(x) horizonModelNormalLL(diff(hsyn),x(1),x(2)),[0 0])
x = fmincon(@(x) horizonModelNormalLL(diff(hsyn),x(1),x(2)),[0 0],[],[])
x = fminuncon(@(x) horizonModelNormalLL(diff(hsyn),x(1),x(2)),[0 0])
x = fminunc(@(x) horizonModelNormalLL(diff(hsyn),x(1),x(2)),[0 0])
x = fminsearch(@(x) horizonModelNormalLL(diff(hsyn),x(1),x(2)),[0 0])
x = fminsearch(@(x) horizonModelNormalLL(diff(hsyn),abs(x(1)),abs(x(2))),[0 0])
x = fminsearch(@(x) horizonModelFaultsLL(hdata,abs(x(1)),abs(x(2)),abs(x(3)),abs(x(4))),[1 1 1 1])
hsyn = horizonModelNormal(3,2,0,50);
hsynf = horizonModelFaults(3,2,1,50,3,0,10)l
hsynf = horizonModelFaults(3,2,1,50,3,0,10);
hdataf = diff(hsynf)
plot(hdata)
plot(hdataf)
x = fminsearch(@(x) horizonModelFaultsLL(hdataf,abs(x(1)),abs(x(2)),abs(x(3)),abs(x(4))),[1 1 1 1])
hsynf = horizonModelFaults(3,2,1,50,3,0,20)l
hsynf = horizonModelFaults(3,2,1,50,3,0,20)
hsynf = horizonModelFaults(3,2,1,50,3,0,20);
hdataf = diff(hsynf);
x = fminsearch(@(x) horizonModelFaultsLL(hdataf,abs(x(1)),abs(x(2)),abs(x(3)),abs(x(4))),[1 1 1 1])