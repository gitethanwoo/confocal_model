function [fluors] = importfluors()

%importfluors this will simply import all of the fluors we have available
%the specific ones can be chosen later. It doesn't take much time

d = dir("assets/Alexa*"); %this pulls all the filenames with "alexa" into a struct

fluors = struct;% I'm going to put my fluorophores in a structure

for k = 1:length(d)                            %iterate through all the alexa fluors I have
    fluors(k).('name') = d(k).name;             %store their name in a structure
    fluors(k).('Spectra') = readmatrix(['assets/' d(k).name]); %then store their spectra in the stucture
end

end

