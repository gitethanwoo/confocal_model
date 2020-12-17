function [lasers, dichroics, fluors, detector] = fitassets(fitRange, lasers, fluors, dichroics, detector)
%fitassets this does all of the fitting in a single function.

%   we fit the dichroics, lasers, and fluorophores using interpolation. Some
%   cleaning is necessary on the dichroic spectra, for whatever reason

%fitLasers = zeros(length(fitRange), size(lasers,3)); %Array creation


for k = 1:size(lasers,2) %lasers
    lasers(k).('fitSpectra') = domainfit(lasers(k).spectra,fitRange); %this uses the function domainfit
end %basically all the lasers are fit to our target domain using interpolation

for k = 1:length(fluors) %fluorophores
    fluors(k).('ex') = domainfit(fluors(k).Spectra(:,[1 3]),fitRange); %excitation side
    fluors(k).('em') = domainfit(fluors(k).Spectra(:,[1 2]),fitRange); %emission side
end

%dichroics
for k = 1:length(dichroics) %fluorophores
    [~, ia, ~] = unique(dichroics(k).Spectra(:,1)); %this just removes duplicate values in the dichroic spectrum
    clean = dichroics(k).Spectra(ia,:);
    dichroics(k).('fitSpectra') = domainfit(clean,fitRange); %excitation dichroic
end


detector = domainfit(detector, fitRange);


end

