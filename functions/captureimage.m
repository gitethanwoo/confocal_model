function [fluors, fluorStandard, channelVal, fluorsCombined] =  captureimage(fluors, fitfilterSpectra, fitRange,scaledBright)

%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
fluorsCombined = sum(scaledBright.*[fluors.em],2); %this is just combining all fluors into the same pixel

postFilterSpectra = fitfilterSpectra.*fluorsCombined; %this is what the spectra look like when passed through the filter


channelVal = zeros(32,1);
i = 1;
for k = 1:49:(length(fitRange)-49) %I'm iterating through the wavelength domain. 0.2nm resolution, 9.8nm distance = 49
    channelVal(i) = trapz(postFilterSpectra(k:k+49)); %this takes the integral of this bandwidth as a psuedo photon number
    i = i + 1;
end


fluorStandard = zeros(3,32);
i = 1;

for k = 1:length(fluors)
    fluors(k).('postfilter') = fluors(k).em.*fitfilterSpectra;
end

for j = 1:length(fluors) %for each fluorophore
    for k = 1:49:(length(fitRange)-49) %iterate through the domain
        fluorStandard(j,i) = trapz(fluors(j).postfilter(k:k+49)); %this takes the integral of this bandwidth as a psuedo photon number
        i = i + 1;
    end
    i = 1;
end
end

