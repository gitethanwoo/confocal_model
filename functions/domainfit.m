function fittedSpectra = domainfit(spectra,domain)
%domainfit Uses interpolation to fit any component to a specified domain
%   Spectra is the component spectra in (x,y) format. Domain is the goal
%   domain that we need to fit to. 


fittedSpectra = interp1(spectra(:,1),spectra(:,2),domain,"linear","extrap");
%the previous line does the fitting
fittedSpectra(fittedSpectra<0) = 0; %this line does the cleaning
%here we assume that no spectra goes negative.
%we also assume that linear extrapolation is always going to work well. 
end

