function [scaledBright] = excitationcalc2(fitLasers, laserIntensity, fluors)
%excitationcalc2 uses lasers and laser power to calculate the relative
%brightness of the fluorophores



lasersCombined = sum(fitLasers,2); %this adds all the lasers together
defaultPower = [25 20 5]; % these are the laser powers in mW %Zeiss

exFactor = zeros(1,3); %array creation

laserPowers = laserIntensity.*defaultPower; %this is the power of the incident lasers


for k = 1:length(fluors) %this loop tells us, "How much is this fluorophore excited by the lasers?"
    exFactor(k) = sum(fluors(k).ex.*lasersCombined); % This multiplies the lasers by each spectra
end


scaledexFactors = exFactor/(max(exFactor)); % the excitation factor is stored as single, relative values

%the overall brightness of each emitting fluor is a result of three things:
%the power of the incident laser, the overlap of the laser, and the quantum
%efficiency of the actual fluorophore. scaledexFactors stores the factors
%by which the fluorophores are excited by all the lasers

laserPowers = laserIntensity.*defaultPower; %this is the power of the incident lasers



end

