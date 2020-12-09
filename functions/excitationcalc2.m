function [scaledBright] = excitationcalc2(lasers, fluors)
%excitationcalc2 uses lasers and laser power to calculate the relative
%brightness of the fluorophores


%defaultPower = [25 20 5]; % these are the laser powers in mW %Zeiss

exFactor = zeros(1,size(fluors,2)); %array creatione

for k = 1:length(lasers) %this loop scales the fit lasers according to their selected power
    scaledlasers(:,k) = lasers(k).fitSpectra.*lasers(k).intensity.*lasers(k).power;
end

%C = bsxfun(@times, lasers.fitSpectra, laserPowers); %this scales each laser spectra by the laser power 
lasersCombined = sum(scaledlasers,2); %this adds all the lasers together


%for each fluorophore on its own - HOW does it interact with ALL of the
%lasers?
%adding 
for k = 1:length(fluors) %this loop tells us, "How much is this fluorophore excited by the lasers?"
    fluors(k).('overlap') = sum(fluors(k).ex.*lasersCombined);
    exFactor(k) = fluors(k).overlap.*fluors(k).EC.*fluors(k).QY.*1e-4;% This multiplies the lasers by each spectra
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

