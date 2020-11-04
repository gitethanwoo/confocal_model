function [fitLasers, fitfilterSpectra, fluors] = fitassets(fitRange, lasers, fluors, filters)
%fitassets this does all of the fitting in a single function.

%   we fit the filters, lasers, and fluorophores using interpolation. Some
%   cleaning is necessary on the filter spectra, for whatever reason

fitLasers = zeros(length(fitRange), size(lasers,3)); %Array creation


for k = 1:size(lasers,3) %lasers
    fitLasers(:,k) = domainfit(lasers(:,:,k),fitRange); %this uses the function domainfit
end %basically all the lasers are fit to our target domain using interpolation

for k = 1:length(fluors) %fluorophores
    fluors(k).('ex') = domainfit(fluors(k).Spectra(:,[1 2]),fitRange); %excitation side
    fluors(k).('em') = domainfit(fluors(k).Spectra(:,[1 3]),fitRange); %emission side
end

[~, ia, ~] = unique(filters(:,1)); %this just removes duplicate values in the filter spectrum
filterSpectraClean = filters(ia,:); %this stores those clean values in a variable

fitfilterSpectra = domainfit(filterSpectraClean,fitRange);


end

