function [dichroics] = makeDichroic(centers)
%makeDichroic This function will create dichroics with a sharp 10nm band
%around the center wavelength, where all other values are .97, and the
%center is at 0


range = [380:750]';

transmission = zeros(length(range),1);

transmission(:) = 0.97;


dichroics = struct;

%this is custom
y = [0.7 0.5 0.3 0.1 0.1 0 0 0 0 0 0 0 0 0 0.1 0.1 0.3 0.5 0.7]';

newdichroic = [range transmission];


for i = 1:size(centers,2)
   a = newdichroic;
   start = centers(i) - (floor(length(y)/2)) - 379; %this is just indexing
   fin = start + length(y) - 1;
   
   a(start:fin,2) = y;
   
   dichroics(i).('name') = centers(i);
   dichroics(i).('spectra') = a;
    
end



end

