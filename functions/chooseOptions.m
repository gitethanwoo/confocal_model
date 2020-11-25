function [indx, indx2, fitRange] = chooseOptions(fluors,filters)
%chooseOptions This allows user to select filter, fluors, lasers and laser
%power
%   

list = cell(length(fluors),1); %preallocation

for k = 1:length(fluors)
    list{k, 1} = fluors(k).name;
end

list2 = cell(length(filters),1);

for k = 1:length(filters)
    list2{k,1} = filters(k).name;
end


[indx,tf] = listdlg('ListString',list, 'Name', 'Fluorophore Selection');
[indx2,tf2] = listdlg('ListString',list2, 'Name', 'Filter Selection');


dlgtitle = "Select the range (9.8nm steps only)"
prompt = ["Lambda min [nm]: " ; "Lambda max [nm]:"]
answer = inputdlg(prompt);

a = str2double(answer(:));

fitRange = (a(1):0.2:a(2))';

end

