function FOMS = captureUnmix2(fluorStandard, fluorsCombined, fitdichroicSpectra, fitRange, detector)
%captureUnmix9 Adds poisson noise to 1000 trials, unmixes all of them and
%stores FOMS for each fluorophore

a = fluorsCombined.*fitdichroicSpectra.*detector; %our combined fluorophors pass through the dichroic and hit the detector
%then they are sampled
i = 1;

for j = 1:49:(length(fitRange)-49)
    capturedspectra(i) = uint8(trapz(a(j:j+49)));
    i = i + 1;
end

B = repmat(capturedspectra',1,1000);
C = imnoise(B,'poisson'); %this function then applies poisson noise to the entire image

for k = 1:length(C)
     unmixedB(:,k) = lsqnonneg(double(fluorStandard'), double(C(:,k)));
end


FOMS = 1 - abs(1-mean(unmixedB,2));


end

