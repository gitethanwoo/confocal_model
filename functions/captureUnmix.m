function FOMS = captureUnmix(fluorStandard, fluorsCombined, fitdichroicSpectra, fitRange, detector)
%captureUnmix9 Adds poisson noise to 1000 trials, unmixes all of them and
%stores FOMS for each fluorophore


B = repmat(fluorsCombined,1, 1000); %this is a step to basically make our combinedFluorophore spectrum into a really big image
%we also scale it by 100 so our pixel values fall between 0-100, which
%relates to photons directly
C = imnoise(B*1e-12, 'poisson')*1e12; %this function then applies poisson noise to the entire image
Bdichroiced = C.*fitdichroicSpectra.*detector;
sampledB = zeros(32, 1000);
unmixedB = zeros(size(fluorStandard,1), 1000);

i = 1;
for k = 1:size(B,2) %this iterates through our Large matrix of the noisy, combined fluors.
    for j = 1:49:length(fitRange)-49 %this iterates through the domain of each, singular "image"
        sampledB(i,k) = trapz(Bdichroiced(j:j+49,k)); %This tells us, "how many photons did we capture from channel 10," etc.
        i = i + 1;
    end
    i = 1;
    unmixedB(:,k) = lsqnonneg(fluorStandard', sampledB(:,k)); %this unmixes every thing
end

FOMS = 1 - abs(1-mean(unmixedB,2));

end

