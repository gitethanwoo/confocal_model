function [lasers] = importlasers()
%importlasers just imports the lasers and their power
%   
lasers = struct;

l = readmatrix('assets/lasers.csv');

l2 = makeLaser(l(:,1));

for i = 1:1:length(l)
    lasers(i).('name') = num2str(l(i,1));
    lasers(i).('spectra') = l2(:,:,i);
    lasers(i).('power') = l(i,2);
end
    
end

