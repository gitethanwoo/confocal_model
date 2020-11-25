function [scaledBright] = excitationcalc2(fitLasers, laserIntensity, fluors)
%excitationcalc2 uses lasers and laser power to calculate the relative
%brightness of the fluorophores


defaultPower = [25 20 5]; % these are the laser powers in mW %Zeiss

exFactor = zeros(1,3); %array creation

laserPowers = laserIntensity.*defaultPower; %this is the power of the incident lasers

C = bsxfun(@times, fitLasers, laserPowers); %this scales each laser spectra by the laser power 
lasersCombined = sum(C,2); %this adds all the lasers together


%for each fluorophore on its own - HOW does it interact with ALL of the
%lasers?
%adding 
for k = 1:length(fluors) %this loop tells us, "How much is this fluorophore excited by the lasers?"
    exFactor(k) = sum(fluors(k).ex.*lasersCombined); % This multiplies the lasers by each spectra
end

%This previous loop accomplishes two things: 1. it calculates overlap of
%the laser and the fluorophore excitation spectra and 2. it scales the
%excitation factor according to fluorophore properties of EC and QY

%Each fluorophore is stored relative to one another, not absolute values
scaledBright = exFactor/(max(exFactor)); % the excitation factor is stored as single, relative values

%the overall brightness of each emitting fluor is a result of three things:
%the power of the incident laser, the overlap of the laser, and the quantum
%efficiency of the actual fluorophore. scaledexFactors stores the factors
%by which the fluorophores are excited by all the lasers

%So total emission relative brightness is the laser power (0-100%)*power of
%the laser (5-25mW) * the EC of the fluorophore * QY of the fluor * overlap

end

