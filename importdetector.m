function [detector] = importdetector()
%importdetector Imports the detector PMT response curve (Hamamatsu)
%   

detector = readmatrix('assets/detectorQE.csv');

detector(:,2) = detector(:,2)/100; %this converts percentage to decimal

[B,I] = sort(detector(:,1)); %some of them were out of order, so we
%have to sort by wavelength

detector = [B detector(I,2)]; %then we use the index of that sort to make
%sure the right values come with the wavelengths


[~, ia, ~] = unique(detector(:,1)); %this just removes duplicate values in the detector spectrum

detector = detector(ia,:); %detector is only the non-duplicate values


end

