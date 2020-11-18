function [fluors] = importfluors2()
%importfluors this will simply import all of the fluors we have available
%the specific ones can be chosen later. It doesn't take much time

f = readmatrix('assets/alexaFluors.csv', 'NumHeaderLines', 1); %import alexa fluors)
f(isnan(f)) = 0; %convert NAN to 0

a = readmatrix('assets/attoFluors.csv', 'NumHeaderLines', 1); %import ATTO fluors
a(isnan(a)) = 0; %convert NAN to 0

fb = readmatrix('assets/alexaBrightness.csv');
ab = readmatrix('assets/attoBrightness.csv');

fluors = struct;% I'm going to put my fluorophores in a structure

for i = 1:size(fb,1) %loop through the list of alexa fluors and store them
    k = i*2;
    fluors(i).('name') = ['Alexa '  num2str(fb(i,1))];
    fluors(i).('Spectra') = [f(:,1) f(:,k:k+1)];
    fluors(i).('QY') = fb(i,2);
    fluors(i).('EC') = fb(i,3);
end


for i = 1:size(ab,1)
    k = i*2;
    j = i + length(fb);
    fluors(j).('name') = ['ATTO '  num2str(ab(i,1))];
    fluors(j).('Spectra') = [a(:,1) a(:,k:k+1)];
    fluors(j).('QY') = ab(i,2);
    fluors(j).('EC') = ab(i,3);
end
    




end

