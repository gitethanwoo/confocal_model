function [filters] = importfilters()
%importfilters You can guess what it does. Pulls filters from /assets
%   stores filter information in structure called "filters"

d = dir("assets/zeiss*"); %this pulls all the filenames with "alexa" into a struct

filters = struct;% I'm going to put my filters in a structure

for k = 1:length(d)                            %iterate through all the alexa fluors I have
    filters(k).('name') = d(k).name;             %store their name in a structure
    filters(k).('Spectra') = readmatrix(['assets/' d(k).name],'NumHeaderLines', 1); %then store their spectra in the stucture
    filters(k).Spectra(isnan(filters(k).Spectra)) = 0; %This removes Nan values and replaces them with 0
    filters(k).('Spectra') = [filters(k).Spectra(:,1) sum(filters(k).Spectra(:,2:end),2)];
    
end



end
