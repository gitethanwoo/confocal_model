function FOMS = captureUnmix2(fluorStandard, fluorsCombined, dichroics, fitRange, detector,photonCF, SCALINGFACTOR)
%captureUnmix9 Adds poisson noise to 1000 trials, unmixes all of them and
%stores FOMS for each fluorophore

if size(dichroics,2) > 1
fitdichroicSpectra = dichroics(1).fitSpectra .* dichroics(2).fitSpectra;
else
    fitdichroicSpectra = dichroics.fitSpectra;
end


a = fluorsCombined.*fitdichroicSpectra.*detector; %our combined fluorophors pass through the dichroic and hit the detector
%then they are sampled
i = 1;

for j = 1:49:(length(fitRange)-49)
    capturedspectra(i) = trapz(a(j:j+49));
    i = i + 1;
end

capturedspectra = capturedspectra*photonCF; %this converts from photons to grey values

% 
  %SCALINGFACTOR = 20; %this is for alexa 488 only?!?!
% % 
  capturedspectra = capturedspectra*SCALINGFACTOR;
% % 
  %capturedspectra(capturedspectra>255) = 255;

%here is where we convert to photons, apply poisson noise, then convert
%back

B = uint16(repmat(capturedspectra'./photonCF,1,1000)); %B is in PHOTONS
C = imnoise(B,'poisson'); %this function then applies poisson noise to the entire image
%this poisson noise has ACCURATELY applied noise

%now we convert back to grey values and make sure to ROUND

C = round(C*photonCF);
C = uint8(C); %converting to uint8 automatically does the thresholding 


for k = 1:length(C)
     unmixedB(:,k) = lsqnonneg(double(fluorStandard'), double(C(:,k)));
end


FOMS = 1 - abs(1-mean(unmixedB,2));
%this calculates FOM based on the assumption that, for pure fluorophores, 
%the lsqnonneg calculation should result in "1".


end

