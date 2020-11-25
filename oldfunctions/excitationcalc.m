function [optimalInt, scaledBright] = excitationcalc(fitLasers, laserIntensity, fluors)

%optmizdIntensities uses information about the laser excitation of the
%fluorophores to figure out the optimal power for each laser such that the
%brightness is normalized across the emission spectra
%
lasersCombined = sum(fitLasers,2); %this adds all the lasers together

defaultPower = [25 20 5]; % these are the laser powers in mW %Zeiss
EC = [73 88 270];         % Extinction Coefficients - ThermoFisher
qy = [0.92 0.69 0.33]; 

exFactor = zeros(1,3); %array creation

for k = 1:length(fluors)
    exFactor(k) = sum(fluors(k).ex.*lasersCombined); % This multiplies the lasers by each spectra
end

scaledexFactor = exFactor/(max(exFactor)); % the excitation factor is stored as single, relative values
relativeBright = laserIntensity.*defaultPower.*EC.*qy.*scaledexFactor/100;
%we just multiply all the scalars
scaledBright = relativeBright./max(relativeBright);
optimalInt = laserIntensity./(relativeBright/min(relativeBright)); %this just uses the dimmest to scale the laser powers

end

