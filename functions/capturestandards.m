function [fluors, fluorStandard, fluorsCombined] =  capturestandards(fluors, dichroics, fitRange,exFactor, detector, photonCF, SCALINGFACTOR)

%capturestandards Uses laser and fluorophore information to capture our pure,
%fluorophore standards

if size(dichroics,2) > 1
fitdichroicSpectra = dichroics(1).fitSpectra .* dichroics(2).fitSpectra;
else
    fitdichroicSpectra = dichroics.fitSpectra;
end

fluorsCombined = sum(exFactor.*[fluors.em],2); %this is just combining all fluors into the same pixel


%just initiating
i = 1;

%this loop calculates what the emission spectra will look like after
%passing through the dichroics
%we also account for detector quantum efficiency

for k = 1:length(fluors)
    fluors(k).('postdichroic') = exFactor(k)*(fluors(k).em.*fitdichroicSpectra.*detector);
end

%this loop is spectrally imaging our pure fluorophores.
for j = 1:length(fluors) %for each fluorophore
    for k = 1:49:(length(fitRange)-49) %iterate through the domain
        fluorStandard(j,i) = trapz(fluors(j).postdichroic(k:k+49)); %this takes the integral of this bandwidth as a psuedo photon number
        i = i + 1;
    end
    i = 1;
end
%here, fluorstandard is CAPTURED as photons. What we need to do is apply
%our GAIN first to convert to grey values.
%to apply our gain, 

fluorStandard = fluorStandard*photonCF; %this converts from photons to grey values

 % SCALINGFACTOR = 20; %this is for alexa 488 only?!?!
  %anyways, it scales up

 fluorStandard = fluorStandard*SCALINGFACTOR;
 %this scales fluorStandard up

 fluorStandard = uint8(fluorStandard);
 %this is basically just rounding, because grey values cannot be decimals

end

