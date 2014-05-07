%% UFinch: Unit Flows in Networks of Channels
% UFinch is a product of the USGS National Water Availability 
% and Use Program: Great Lakes Pilot.
%
% The following pragma references scripts used in UFinch for the compiler
%
%% Startup UFinch Application
clear; clear global; clc
%
% Determine if UFinch is initiated in the appropriate directory.
dir = eval('pwd');
StrtCol = strfind(upper(dir),upper('UFinch\UWork'));
if isempty(StrtCol)
   % If the directory is not appropriate, notify user and end UFinch.   
   errordlg('UFinch was not initiated in the ...\UFinch\UWork subdirectory.',...
       'UFinch Code Not Found.');
   fprintf('Change current directory to ...\\UFinch\\UWork and restart UFinch. \n');
   return
end
%
clearvars dir StrtCol
%% Run the UFinch GUI
UFinchGUIv1c;
fprintf(1,'UFinch v1c\n');

