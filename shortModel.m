%short model

filters = readmatrix('assets/MBSZeiss.csv'); %import filter spectra into matrix

wavelengths = [488 561 633]; %What lasers do we want to use?

lasers = makeLaser(wavelengths); %creates the lasers

fluors = importfluors(); %imports the fluorophores

fitRange = (414:0.2:725.2)'; %this is our wavelength range for everything to fit to

%the following function fits all the assets to our domain
[fitLasers, fitfilterSpectra, fluors] = fitassets(fitRange, lasers, fluors, filters);

%%%% Change laser intensity to see how FOM changes
laserIntensity = [0.247 0.3675 1]; % this is the controllable laser intensity (0-100%)
%%%%

[optimalInt, scaledBright] = excitationcalc(fitLasers, laserIntensity, fluors);

[fluors, fluorStandard, channelVal, fluorsCombined] = captureimage(fluors, fitfilterSpectra, fitRange, scaledBright);

% plot(fitRange,fluorsCombined)

test = lsqnonneg(fluorStandard', channelVal);

FOMS = captureUnmix(fluorStandard, fluorsCombined, fitfilterSpectra, fitRange);


X = categorical({'488 FOM','568 FOM','647 FOM'});

bar(X,FOMS)

