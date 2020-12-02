function [fluors, filters,lasers, fitRange] = chooseOptions(fluors,filters, lasers)
%chooseOptions This allows user to select filter, fluors, lasers and laser
%power
%   

range = readmatrix('assets/range.csv');
%this imports our microscope wavelength range with real values

list = cell(length(fluors),1); %preallocation
list2 = cell(length(filters),1); %preallocation
list3 = cell(length(lasers),1); %preallocation
list4 = cell(length(range),1); %preallocation


%the following loops just pull out the names of everything we can choose
for k = 1:length(fluors)
    list{k, 1} = fluors(k).name;
end

for k = 1:length(filters)
    list2{k,1} = filters(k).name;
end

for k = 1:length(lasers)
    list3{k,1} = lasers(k).name;
end

for k = 1:length(range)
    list4{k,1} = num2str(range(k)); %this one converts raw numbers to strings
end

%these are the dialog boxes where you actually pick what you want
[indx,~] = listdlg('ListString',list, 'Name', 'Fluorophore Selection');
[indx2,~] = listdlg('ListString',list2, 'Name', 'Filter Selection');
[indx3,~] = listdlg('ListString',list3, 'Name', 'Laser Selection');
[indx4,~] = listdlg('ListString',list4, 'Name', 'Range Selection: Choose a top and bottom value');

fluors = fluors(indx);
filters = filters(indx2);
lasers = lasers(indx3);

a = range(indx4); %this deals with the range selection

fitRange = (a(1):0.2:a(end))'; %this creates the actual range


dlgtitle = "Input the intensity for the lasers you selected";%just a menu title

text = string([]); %pre-allocation

for k = 1:length(lasers) %this loop creates the text for the question boxes
    text(k) = [lasers(k).name  ' Laser Intensity (0.01-1)']; 
end %basically, it uses the lasers you selected to generate questions about those lasers

answer = inputdlg(text, dlgtitle); %this function opens the actual question box
%it asks, what laser intensity do you want?
b = str2double(answer(:)); %this converts the answers into numbers

for k = 1:length(lasers)
    lasers(k).('intensity') = b(k);
end


end

