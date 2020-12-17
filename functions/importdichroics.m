function [dichroics] = importdichroics()
%importdichroics You can guess what it does. Pulls dichroics from /assets
%   stores dichroic information in structure called "dichroics"

d = dir("assets/dichroics/zeiss*"); %this pulls all the filenames with "alexa" into a struct

dichroics = struct;% I'm going to put my dichroics in a structure

for k = 1:length(d)                            %iterate through all the alexa fluors I have
    dichroics(k).('name') = d(k).name;             %store their name in a structure
    dichroics(k).('Spectra') = readmatrix(['assets/dichroics/' d(k).name],'NumHeaderLines', 1); %then store their spectra in the stucture
    dichroics(k).Spectra(isnan(dichroics(k).Spectra)) = 0; %This removes Nan values and replaces them with 0
   
    if size(dichroics(k).Spectra, 2) > 2 %this takes care of our dichroic sets
        dichroics(k).('ex') = dichroics(k).Spectra(:,2);
        dichroics(k).('dichroic') = dichroics(k).Spectra(:,3);
        dichroics(k).('em') = dichroics(k).Spectra(:,4);
    end
    
end



end 
