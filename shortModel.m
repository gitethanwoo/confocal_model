%short model

detector = importdetector(); %imports detector

filters = importfilters(); %import filter spectra into matrix

lasers = importlasers(); %creates the lasers

fluors = importfluors2(); %imports fluorophores

[fluors, filters,lasers, fitRange] = chooseOptions(fluors,filters, lasers);

%the following function fits all the assets to our domain
[lasers, filters, fluors, detector] = fitassets(fitRange, lasers, fluors, filters, detector);

%The following calculates how bright the fluorophores will be based on
%lasers and their inherent quantum yield and efficiency
[scaledBright] = excitationcalc2(lasers, fluors);

%the following function will use the fluorophore spectra and laser
%information to capture images of our fluorophore standards.
[fluors, fluorStandard, channelVal, fluorsCombined] = capturestandards(fluors, filters.fitSpectra, fitRange, scaledBright, detector);

%This function uses our fluor standards (pure fluors), our combined fluors
%(which is what the microscope sees on a slide), and the filter spectra.
%it then "captures" an image and unmixes it against our standards
FOMS = captureUnmix(fluorStandard, fluorsCombined, filters.fitSpectra, fitRange, detector);

%the following lines just plot the FOM in a bar graph
X = categorical({fluors.name});
bar(X,FOMS)
ylabel('FOM')
title('FOMs of fluorophores in this experiment')
