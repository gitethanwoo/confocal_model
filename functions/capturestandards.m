function [fluors, fluorStandard, channelVal, fluorsCombined] =  capturestandards(fluors, fitdichroicSpectra, fitRange,scaledBright, detector)

%capturestandards Uses laser and fluorophore information to capture our pure,
%fluorophore standards

fluorsCombined = sum(scaledBright.*[fluors.em],2); %this is just combining all fluors into the same pixel

postdichroicSpectra = fitdichroicSpectra.*fluorsCombined; %this is what the spectra look like when passed through the dichroic

%just initiating
fluorStandard = zeros(size(fluors,1),32);
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
        fluorStandard(j,i) = trapz(fluors(j).postdichroic(k:k+49)); %this takes the integral of this bandwidth as a psuedo photon number
        i = i + 1;
    end
    i = 1;
end

%just initiating
channelVal = zeros(32,1);
i = 1;

%this loop is spectrally imaging the combined fluorophores with no noise

for k = 1:49:(length(fitRange)-49) %I'm iterating through the wavelength domain. 0.2nm resolution, 9.8nm distance = 49
    channelVal(i) = trapz(postdichroicSpectra(k:k+49)); %this takes the integral of this bandwidth as a psuedo photon number
    i = i + 1;
end


end

