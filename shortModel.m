%short model



detector = importdetector();

filters = importfilters(); %import filter spectra into matrix

wavelengths = [488 561 633]; %What lasers do we want to use?

lasers = makeLaser(wavelengths); %creates the lasers

%fluors = importfluors(); %imports the fluorophores
fluors = importfluors2();


[indx, indx2, fitRange] = chooseOptions(fluors,filters);
fluors = fluors(indx);
filters = filters(indx2);



%fitRange = (414:0.2:725.2)'; %this is our wavelength range for everything to fit to

%the following function fits all the assets to our domain
[fitLasers, filters, fluors, detector] = fitassets(fitRange, lasers, fluors, filters, detector);

%%%% Change laser intensity to see how FOM changes
laserIntensity = [.2 0.4 1]; % this is the controllable laser intensity (0-100%)
%%%%

%Which filter?

whichfilter = ['MBS'];

[scaledBright] = excitationcalc2(fitLasers, laserIntensity, fluors);

%the following function will use the fluorophore spectra and laser
%information to capture images of our fluorophore standards.
[fluors, fluorStandard, channelVal, fluorsCombined] = capturestandards(fluors, filters.fitSpectra, fitRange, scaledBright, detector);

%this just plots what our emission spectra will look like before filtering
% plot(fitRange,fluorsCombined)

%This function uses our fluor standards (pure fluors), our combined fluors
%(which is what the microscope sees on a slide), and the filter spectra.
%it then "captures" an image and unmixes it against our standards
FOMS = captureUnmix(fluorStandard, fluorsCombined, filters.fitSpectra, fitRange, detector);


%the following lines just plot the FOM in a bar graph
X = categorical({fluors.name});
bar(X,FOMS)
ylabel('FOM')

