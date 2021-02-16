function [fluors, fluorStandard, fluorsCombined] =  capturestandards(fluors, fitdichroicSpectra, fitRange,scaledBright, detector, gain)

%capturestandards Uses laser and fluorophore information to capture our pure,
%fluorophore standards

fluorsCombined = sum(scaledBright.*[fluors.em],2); %this is just combining all fluors into the same pixel


%just initiating
i = 1;

%this loop calculates what the emission spectra will look like after
%passing through the dichroics
%we also account for detector quantum efficiency

for k = 1:length(fluors)
    fluors(k).('postdichroic') = fluors(k).em.*fitdichroicSpectra.*detector;
end

%this loop is spectrally imaging our pure fluorophores.
for j = 1:length(fluors) %for each fluorophore
    for k = 1:49:(length(fitRange)-49) %iterate through the domain
        fluorStandard(j,i) = uint8(trapz(fluors(j).postdichroic(k:k+49))); %this takes the integral of this bandwidth as a psuedo photon number
        i = i + 1;
    end
    i = 1;
end

end

