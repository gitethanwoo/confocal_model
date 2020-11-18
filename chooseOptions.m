function [indx, tf] = chooseOptions()
%chooseOptions This allows user to select filter, fluors, lasers and laser
%power
%   

list = {'atto 488','atto 514'}

[indx,tf] = listdlg('ListString',list)
 
% 
% dlgtitle = "Optimize Acquisition Scheme"
% prompt = ["Lambda min [nm]: " ; "Lambda max [nm]:" ; "Lambda steps[nm]:"; ...
%             "Number of Excitations:" ; "Number of Channels:" ; ...
%             "Laser intensity steps [%]: "];
end

