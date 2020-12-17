%short model

detector = importdetector(); %imports detector

dichroics = importdichroics(); %import dichroic spectra into matrix

lasers = importlasers(); %creates the lasers

fluors = importfluors2(); %imports fluorophores

[fluors, dichroics,lasers, fitRange] = chooseOptions(fluors,dichroics, lasers);

%the following function fits all the assets to our domain
[lasers, dichroics, fluors, detector] = fitassets(fitRange, lasers, fluors, dichroics, detector);

%The following calculates how bright the fluorophores will be based on
%lasers and their inherent quantum yield and efficiency
[scaledBright] = excitationcalc2(lasers, fluors);

%the following function will use the fluorophore spectra and laser
%information to capture images of our fluorophore standards.
[fluors, fluorStandard, channelVal, fluorsCombined] = capturestandards(fluors, dichroics.fitSpectra, fitRange, scaledBright, detector);

%This function uses our fluor standards (pure fluors), our combined fluors
%(which is what the microscope sees on a slide), and the dichroic spectra.
%it then "captures" an image and unmixes it against our standards
FOMS = captureUnmix(fluorStandard, fluorsCombined, dichroics.fitSpectra, fitRange, detector);

%the following lines just plot the FOM in a bar graph
X = categorical({fluors.name});
bar(X,FOMS)
ylabel('FOM')
title('FOMs of fluorophores in this experiment')

rngmsg = ['Range selected: ' num2str(round(fitRange(1))) ':' num2str(round(fitRange(end))) ];
dichroicmsg = ['Dichroic Selected: ' dichroics.name];
lasermsg = ['Lasers selected: ' {lasers.name}];
fluormsg = ['Fluors Selected: ' {fluors.name}];


f = msgbox([rngmsg dichroicmsg lasermsg fluormsg] , 'Summary:');
