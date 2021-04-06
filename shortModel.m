%short model

oldpath = path;
path(genpath('hello-world'),oldpath)

detector = importdetector(); %imports detector

dichroics = importdichroics(); %import dichroic spectra into matrix

lasers = importlasers(); %creates the lasers

fluors = importfluors2(); %imports fluorophores
%%
[fluors, dichroics,lasers, fitRange, photonCF] = chooseOptions(fluors,dichroics, lasers);
imageSize = 0.16; %(square micrometers)
b = imageSize^2 / 0.16^2;
SCALINGFACTOR = 12.4*b; %this scaling factor, 12.4, was found by copying the settings of a real experiment, 
%then just dividing the peak grey values of the real fluorophores by the
%simulated peak values and averaging the result

%the following function fits all the assets to our domain
[lasers, dichroics, fluors, detector] = fitassets(fitRange, lasers, fluors, dichroics, detector);

%The following calculates how bright the fluorophores will be based on
%lasers and their inherent quantum yield and efficiency
[exFactor, fluors] = excitationcalc2(lasers, fluors);

%the following function will use the fluorophore spectra and laser
%information to capture images of our fluorophore standards.
[fluors, fluorStandard, fluorsCombined] = capturestandards(fluors, dichroics, fitRange, exFactor, detector, photonCF,SCALINGFACTOR);

%This function uses our fluor standards (pure fluors), our combined fluors
%(which is what the microscope sees on a slide), and the dichroic spectra.
%it then "captures" an image and unmixes it against our standards
FOMS = captureUnmix2(fluorStandard, fluorsCombined, dichroics, fitRange, detector, photonCF,SCALINGFACTOR);
%%
%the following lines just plot the FOM in a bar graph
X = categorical({fluors.name});
figure
bar(X,FOMS)
ylabel('FOM')
title('FOMs of fluorophores in this experiment')

rngmsg = ['Range selected: ' num2str(round(fitRange(1))) ':' num2str(round(fitRange(end))) ];
dichroicmsg = ['Dichroic Selected: ' dichroics.name];
lasermsg = ['Lasers selected: ' {lasers.name}];
fluormsg = ['Fluors Selected: ' {fluors.name}];


f = msgbox([rngmsg dichroicmsg lasermsg fluormsg] , 'Summary:');
figure
c = colororder
simplot = plot(1:length(fluorStandard),fluorStandard,'--', 'LineWidth',2);

title("Simulated spectral data")
axis([0 length(fluorStandard) 0 255])
legend({fluors.name})
%% This section is to be used in conjunction with matchingExperiment.m. Matching experiment 
%Pulls in real experimental data and uses it as a comparison. There are 4
%experiments available, though this should be expanded to thousands.
% rs = double(max(realStandard,[],2))
% fs = double(max(fluorStandard,[],2))
% 
% weights = rs./fs;

