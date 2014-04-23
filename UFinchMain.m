% UFinchMain reads a NHDFlowline (shapefile), a StreamGageEvent
% (shapefile), and an AFINCH formatted water-use data and displays 
% flowlines color-coded by water use for the specified year and month.
% Streamgage locations are displayed and color-coded for activity status on
% the selected year and month.
%
function varargout = UFinchMain(varargin)
% UFINCHMAIN MATLAB code for UFinchMain.fig
%      UFINCHMAIN, by itself, creates a new UFINCHMAIN or raises the existing
%      singleton*.
%
%      H = UFINCHMAIN returns the handle to a new UFINCHMAIN or the handle to
%      the existing singleton*.
%
%      UFINCHMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UFINCHMAIN.M with the given input arguments.
%
%      UFINCHMAIN('Property','Value',...) creates a new UFINCHMAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UFinchMain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UFinchMain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UFinchMain

% Last Modified by GUIDE v2.5 05-Jul-2012 10:58:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @UFinchMain_OpeningFcn, ...
    'gui_OutputFcn',  @UFinchMain_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%
% Show program title on figure label
set(get(0,'CurrentFigure'),'Visible','on','numberTitle','off',...
    'name','USGS WaterSMART Initiative');
% set(handles.OpenFlowlinePanel,'BackgroundColor',[0.99 0.92 0.80]);
%
% --- Executes just before UFinchMain is made visible.
function UFinchMain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UFinchMain (see VARARGIN)

% Choose default command line output for UFinchMain
handles.output = hObject;

% Update handles structure
set(handles.ActiveLayerButtonGroup,'SelectionChangeFcn',@ActiveLayerButtonGroup_SelectionChangeFcn);

% Setup hUFinchGUI link
setappdata(0, 'hUFinchGUI', gcf);
% Link hUFinchGUI workspace
hUFinchGUI = getappdata(0,'hUFinchGUI');
setappdata(hUFinchGUI,'in4digit',1);
setappdata(hUFinchGUI,'originalFmt',1);

set(handles.hydroRegionPanel,'BackgroundColor',[0.93 0.93 0.93]);
guidata(hObject, handles);


% UIWAIT makes UFinchMain wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = UFinchMain_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OpenFlowlineShapefilePB.
function OpenFlowlineShapefilePB_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFlowlineShapefilePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.flinefile,handles.flinepath] = uigetfile({'*.shp'},'Open Flowline Shapefile');
set(handles.DisplayFlowlineShapefileST,'string',[handles.flinepath,handles.flinefile],...
    'BackgroundColor',[0.93 0.93 0.93]);
% hMsg = msgbox('Please wait (commonly 45s).  This message box will automatically close when processing is complete.',...
%     'Reading and displaying flowlines...');
hUFinchGUI = getappdata(0,'hUFinchGUI');
hucList    = getappdata(hUFinchGUI,'hucList');
flowLine   = shaperead(fullfile(handles.flinepath,handles.flinefile),...
    'Selector',{@(hsr) strncmp(hucList,hsr,4),'REACHCODE'},...
        'ATTRIBUTES',{'COMID','REACHCODE','GNIS_NAME','LENGTHKM'},...
        'UseGeoCoords',true);
setappdata(hUFinchGUI,'flowLine',flowLine);

figure(handles.hHsr);
geoshow(flowLine,'Color',[0.7 0.7 0.7]);
xlabel('Longitude, in decimal degrees');
ylabel('Latitude, in decimal degrees');
% close(hMsg);
set(handles.OpenStreamgagePanel,'BackgroundColor',[0.93 0.93 0.93]);
set(handles.flowlineRB','Value',1);
guidata(hObject,handles);
% 
% --- Executes during object creation, after setting all properties.
function flowlinePanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flowlinePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes during object creation, after setting all properties.


% --- Executes on button press in ExitPB.
function ExitPB_Callback(hObject, eventdata, handles)
% hObject    handle to ExitPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
res = questdlg({'Exiting AFINCH Water Use Data Tool.';...
    'Do you want to close all figures?'},'Exiting Data Tool');
switch res
    case 'Yes'
        close all
        return
    case 'No'
        close(gcf)
        return
    case 'Cancel'
        fprintf(1,'Aborting the exit.\n');
end

function TitleST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TitleST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% pause(1);
% set(TitleST,'String','','ForegroundColor',[0.5 0.5 0.5]);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over TitleST.
function TitleST_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TitleST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OpenStreamgageShapefilePB.
function OpenStreamgageShapefilePB_Callback(hObject, eventdata, handles)
% hObject    handle to OpenStreamgageShapefilePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.sgagefile,handles.sgagepath] = uigetfile({'*.shp'},'Open Streamgage Shapefile');
set(handles.StreamgageShapefileST,'string',fullfile(handles.sgagepath,handles.sgagefile),...
    'BackgroundColor',[0.93 0.93 0.93]);
%
hUFinchGUI = getappdata(0,'hUFinchGUI');
hucList    = getappdata(hUFinchGUI,'hucList');
%
StreamGageEvent = shaperead(fullfile(handles.sgagepath,handles.sgagefile),...
    'ATTRIBUTES',{'EVENTDATE','REACHCODE','SOURCE_FEA','MEASURE',...
    'STATION_NM','DA_SQ_MILE','DAY1','DAYN','NDAYS'},...
    'SELECTOR', {@(hsr) strncmp(hucList,hsr,4),'REACHCODE'},...
    'UseGeoCoords',true);
%
figure(handles.hHsr);
geoshow(StreamGageEvent,'MarkerFaceColor','b','Marker','^',...
    'MarkerSize',4,'MarkerEdgeColor','b');
set(handles.specifyWaterYearPanel,'BackgroundColor',[0.93 0.93 0.93]);
setappdata(hUFinchGUI,'StreamGageEvent',StreamGageEvent);
set(handles.streamgageRB','Value',1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ActiveLayerButtonGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ActiveLayerButtonGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function streamgageRB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to streamgageRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(handles.streamgagePanel,'BackgroundColor',[0.93 0.93 0.93]);
% set(handles.flowlinePanel,'BackgroundColor',[0.70 0.70 0.70]);
% set(handles.streamgageRB,'Callback',{@ActiveLayerButtonGroup_callback,handles,2});

% --- Executes when selected object is changed in ActiveLayerButtonGroup.
function ActiveLayerButtonGroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ActiveLayerButtonGroup
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% hUFinchGUI      = getappdata(0,'hUFinchGUI');
% handles         = getappdata(hUFinchGUI,'handles');
% guidata(hObject,handles);
% StreamGageEvent = getappdata(hUFinchGUI,'StreamGageEvent');

switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'flowlineRB'
        fprintf(1,'Radio button set to flowlineRB\n');
        hUFinchGUI  = getappdata(0,'hUFinchGUI');
        flowLine    = getappdata(hUFinchGUI,'flowLine');
        hMsg = msgbox('Please wait (commonly 40s).  This message box will automatically close when processing is complete.',...
            'Displaying flowlines...');
        figure(getappdata(hUFinchGUI,'hHsr'));
        h2          = geoshow(flowLine,'Color',[0.7 0.7 0.7]);
        set(hMsg,'Visible','off');
        ch2 = get(h2,'Children');
        nflowLine   = length(flowLine);         % Number of flowlines

        flinfo   = cell(nflowLine,4);
        for i = 1:nflowLine
            flinfo(i,1) = {ch2(i)};
            flinfo(i,2) = {flowLine(i).COMID};
            flinfo(i,3) = {flowLine(i).GNIS_NAME};
            flinfo(i,4) = {flowLine(i).LENGTHKM};
            % Set the callback function for the button-down operation
            set(ch2(i), 'ButtonDownFcn', @GetFlowlineCurrentPoint);
            set(ch2(i), 'UserData',...
                [num2str(flowLine(i).COMID),'#',...
                         flowLine(i).GNIS_NAME,'#',...
                 num2str(flowLine(i).LENGTHKM,'%6.2f')]);
        end
        setappdata(hUFinchGUI,'flinfo',flinfo);
        setappdata(hUFinchGUI, 'h2', h2); % Handle of streamgage figure
        setappdata(hUFinchGUI,'ch2',ch2); % Children (streamgages)
        setappdata(hUFinchGUI,'handles',handles); 
        % close(hMsg);
%         
    case 'streamgageRB'
        fprintf(1,'Radio button set to streamgageRB\n');
        hUFinchGUI           = getappdata(0,'hUFinchGUI');
        StreamGageEvent      = getappdata(hUFinchGUI,'StreamGageEvent');
        nGages               = length(StreamGageEvent);
        % Color symbols for active streamgages blue
        handles = getappdata(hUFinchGUI,'handles');
        thisWaterYear = str2double(get(handles.waterYearET,'String'));
        thisWaterYear = str2double([num2str(thisWaterYear-1),'1001']);
        for iGage = 1:nGages
            if StreamGageEvent(iGage,1).DAY1 <= thisWaterYear && ...
                    StreamGageEvent(iGage,1).DAYN > thisWaterYear
                StreamGageEvent(iGage,1).indActGage = '1' ;
            else
                StreamGageEvent(iGage,1).indActGage = '0' ;
            end
        end
        % Update StreamGageEvent with indicator
        setappdata(hUFinchGUI,'StreamGageEvent',StreamGageEvent);
        setappdata(hUFinchGUI,'handles',handles);
        % Symbol specification
        gageColors = makesymbolspec('Point',...
            {'indActGage','1','MarkerFaceColor',[ 0  0 1 ],'MarkerEdgeColor',[ 0  0 1 ],...
            'Marker','^','MarkerSize',4},...
            {'indActGage','0','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7],...
            'Marker','^','MarkerSize',4});
        setappdata(hUFinchGUI,'gageColors',gageColors);
        % Select figure
        figure(handles.hHsr);
        % Plot the active streamgages
        h2       = geoshow(StreamGageEvent,'SymbolSpec',gageColors);
        wYear    = get(handles.waterYearET,'String');
        title(['Active Streamgages in ',handles.titleText,' during Water Year ',wYear]);
        ch2 = get(h2,'Children');
        gageinfo = cell(nGages,3);
        for i = 1:nGages
            gageinfo(i,1) = {ch2(i)};
            gageinfo(i,2) = {StreamGageEvent(i).SOURCE_FEA}; % Station number
            gageinfo(i,3) = {StreamGageEvent(i).STATION_NM}; % Station name
            % Set the callback function for the button-down operation
            set(ch2(i), 'ButtonDownFcn', @GetGageCurrentPoint);
            set(ch2(i), 'UserData',[...
                'Num',StreamGageEvent(i).SOURCE_FEA,...
                'Name',StreamGageEvent(i).STATION_NM,...
                'Day1',datestr(datenum(num2str(StreamGageEvent(i).DAY1),...
                'yyyymmdd'),'yyyy-mm'),...
                'DayN',datestr(datenum(num2str(StreamGageEvent(i).DAYN),...
                'yyyymmdd'),'yyyy-mm'),...
                'DaM2',num2str(StreamGageEvent(i).DA_SQ_MILE),...
                'ndxI',num2str(i)]);
        end
        setappdata(hUFinchGUI,'gageinfo',gageinfo);
        setappdata(hUFinchGUI, 'h2', h2); % Handle of streamgage figure
        setappdata(hUFinchGUI,'ch2',ch2); % Children (streamgages)
        %
    otherwise
        % Code for when there is no match.
        fprintf(1,'Switch case not defined.\n');
end
% updates the handles structure
guidata(hObject, handles);
%

% Button-down callback function definition
function GetGageCurrentPoint(gcb,~)
hUFinchGUI = getappdata(0,'hUFinchGUI');
hParent    = get(gcb,'Parent');
hMain      = get(hParent,'Parent');
% Determine active (top) layer
% handles    = getappdata(hUFinchGUI,'handles');
% gagelayer  = get(handles.streamgageRB,'Value');
% Streamgage layer active
% h2        = getappdata(hUFinchGUI, 'h2');
% ch2        = getappdata(hUFinchGUI,'ch2');
gageloc    = get(hMain,'CurrentPoint');
setappdata(hUFinchGUI,'gageloc',gageloc);
userdata   = get(gcb,'UserData');
setappdata(hUFinchGUI,'userdata',userdata);
fprintf(1,'Streamgage UserData = %s.\',userdata);
gageLong   = mean(gageloc(:,1));
gageLat    = mean(gageloc(:,2));
%
gageNumber = userdata(4:(strfind(userdata,'Name')-1));
str        = lower(userdata((strfind(userdata,'Name')+4):(strfind(userdata,'Day1')-1)));
gageName   = regexprep(regexprep(str, '(^.)', '${upper($1)}'),...
    '(?<=\ \s*)([a-z])','${upper($1)}');
day1       = userdata((strfind(userdata,'Day1')+4):(strfind(userdata,'DayN')-1));
dayN       = userdata((strfind(userdata,'DayN')+4):(strfind(userdata,'DaM2')-1));
daSqMi     = userdata((strfind(userdata,'DaM2')+4):(strfind(userdata,'ndxI')-1));
ndxGage    = userdata((strfind(userdata,'ndxI')+4):end);
%
setappdata(hUFinchGUI,'gageLong',  gageLong);
setappdata(hUFinchGUI,'gageLat',   gageLat );
setappdata(hUFinchGUI,'gageNumber',gageNumber);
setappdata(hUFinchGUI,'gageName',  gageName);
%
disp(['Streamgage ', gageNumber,' ',gageName,...
    ' at longitude ',num2str(gageloc(1,1),6),...
    ' and latitude ',num2str(gageloc(1,2),6)]);
%
% StreamGageEvent = getappdata(hUFinchGUI,'StreamGageEvent');
% handles         = getappdata(hUFinchGUI,'handles');
% gageColors      = getappdata(hUFinchGUI,'gageColors');
% 
% figure(handles.hHsr);
% % Replot all streamgages
% geoshow(StreamGageEvent,'SymbolSpec',gageColors);
% % Overplot the selected streamgage
% geoshow(StreamGageEvent(ndxGage),'MarkerFaceColor','r',...
%     'MarkerSize',4,'Marker','^');
%        
% Update GUI
handles = getappdata(hUFinchGUI,'handles');
set(handles.GageNumberST,'String',gageNumber,...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.gageLatST,'String',num2str(gageLat),...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.gageLongST,'String',num2str(gageLong),...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.GageNameST,'String',gageName,...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.porFirstST,'String',day1,...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.porLastST,'String',dayN,...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.daMiSqST,'String',daSqMi,...
    'BackgroundColor',[0.93 0.93 0.93]);

% Button-down callback function definition
function GetFlowlineCurrentPoint(gcb,~)
hUFinchGUI = getappdata(0,'hUFinchGUI');
hParent    = get(gcb,'Parent');
hMain      = get(hParent,'Parent');
flineloc   = get(hMain,'CurrentPoint');
userdata   = get(gcb,'UserData');
fprintf(1,'Flowline UserData = %s.\n',userdata);
flineLong  = mean(flineloc(:,1));
flineLat   = mean(flineloc(:,2));
%
pdsign     = strfind(userdata,'#');
flineComID = userdata(1:pdsign(1)-1);
str        = lower(userdata(pdsign(1)+1:pdsign(2)-1));
if isempty(str)
    flineName = 'Unnamed flowline.';
else
    flineName = regexprep(regexprep(str, '(^.)', '${upper($1)}'),...
        '(?<=\ \s*)([a-z])','${upper($1)}');
end
flineLenMi = str2double(userdata(pdsign(2)+1:end))*1.609344;
%
setappdata(hUFinchGUI,'flineLong', flineLong );
setappdata(hUFinchGUI,'flineLat',  flineLat  );
setappdata(hUFinchGUI,'flineComID',flineComID);
setappdata(hUFinchGUI,'flineName', flineName );
setappdata(hUFinchGUI,'flineLenMi',flineLenMi);
%
disp(['Flowine ', flineComID,' ',flineName,...
    'at Longitude ',num2str(flineLong,6),...
    ' and Latitude ',num2str(flineLat,6)]);
% Update GUI
handles = getappdata(hUFinchGUI,'handles');
set(handles.flineComIDST,'String',flineComID,...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.flineLatST,'String',num2str(flineLat),...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.flineLongST,'String',num2str(flineLong),...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.flineNameST,'String',flineName,...
    'BackgroundColor',[0.93 0.93 0.93]);

% --- Executes on selection change in HydrologicRegionLB.
function HydrologicRegionLB_Callback(hObject, eventdata, handles)
% hObject    handle to HydrologicRegionLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI     = getappdata(0,'hUFinchGUI');
AllRegions     = cellstr(get(hObject,'String'));
HydroRegionNdx = AllRegions{get(hObject,'Value')};
fprintf(1,'%s \n',HydroRegionNdx);
% Check to see whether a corresponding Region is defined on
% HSR is Hydrologic (Sub)Region
curDir                  = pwd;
ndxSlash                = max(strfind(curDir,'\'));
handles.HR              = ['HR',HydroRegionNdx(2:3)];
setappdata(hUFinchGUI,'HR',handles.HR);
handles.dirHR           = [curDir(1:ndxSlash),handles.HR];
handles.shapefilefolder = [handles.dirHR,'\GIS'];
handles.HRname          = HydroRegionNdx(1:end);
setappdata(hUFinchGUI,'HRname',handles.HRname);
fprintf(1,'Dir %s expected for target hydrologic region %s.\n',...
    handles.HR,handles.HRname);
%
if exist(handles.dirHR,'dir')
    fprintf(1,'%s folder was found. Continue. \n',handles.dirHR);
    %
else
    % Run the directory selection tool.
    % handles.selectHucPB
%    set(handles.HucListButtonGroup,'BackgroundColor',[0.5 0.5 0.5]);
    errordlg({'Folder for selected region *NOT* found.';...
        'Select alternative folder or create folder ';...
        'outside of UFINCH with appropriate contents.'},...
        ['Folder ',handles.HR,' not found.']);
end
%
hUFinchGUI  = getappdata(0,'hUFinchGUI');
in4digit    = getappdata(hUFinchGUI,'in4digit');
%Have user select 8 or 4 digit HUCS depending on button value
currentfolder = pwd;
% shapefilefolder=regexprep(currentfolder,'AWork','HUC');
% shapefilefolder = handles.dirHSR;
%show map of 4-digit HUCS and ask user to select 1 or more HUCs
tempshapefile='HUC4_Project.shp';
hucshapefile=fullfile(handles.shapefilefolder,tempshapefile);
huclist = UFSelectHUC(hucshapefile);
setappdata(hUFinchGUI,'hucShapefile',hucshapefile);
setappdata(hUFinchGUI,'hucList',huclist);
handles.hHsr = figure();
huc4Select   = shaperead(hucshapefile,...
    'Selector',{@(hsr) (strcmp(hsr,huclist)),'HUC_4'},...
    'UseGeoCoords',true);
geoshow(huc4Select);
xlabel('Longitude, in decimal degrees'); 
ylabel('Latitude, in decimal degrees');
handles.titleText  = [HydroRegionNdx,'--',huc4Select.HUC_Name];
title(['Study Area: ',handles.titleText]);
set(handles.hydroSubregionST,'String',handles.titleText,...
    'BackgroundColor',[1 1 1]);
set(handles.OpenFlowlinePanel,'BackgroundColor',[0.93 0.93 0.93]);
setappdata(hUFinchGUI,'hHsr',handles.hHsr);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function HydrologicRegionLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HydrologicRegionLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function waterYearET_Callback(hObject, eventdata, handles)
% hObject    handle to waterYearET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of waterYearET as text
%        str2double(get(hObject,'String')) returns contents of waterYearET as a double
handles.thisWYearStr = get(hObject,'String');
handles.thisWYearNum = str2double([handles.thisWYearStr,'1001']);
hUFinchGUI           = getappdata(0,'hUFinchGUI');
StreamGageEvent      = getappdata(hUFinchGUI,'StreamGageEvent');
nGages               = length(StreamGageEvent);
% Color symbols for active streamgages blue
for iGage = 1:nGages
    if StreamGageEvent(iGage,1).DAY1 <= handles.thisWYearNum && ...
            StreamGageEvent(iGage,1).DAYN > handles.thisWYearNum
        StreamGageEvent(iGage,1).indActGage = '1' ; 
    else
        StreamGageEvent(iGage,1).indActGage = '0' ;
    end
end
% Update StreamGageEvent with indicator
setappdata(hUFinchGUI,'StreamGageEvent',StreamGageEvent);
setappdata(hUFinchGUI,'handles',handles);
% Select figure 
figure(handles.hHsr);
% Symbol specification
gageColors = makesymbolspec('Point',...
    {'indActGage','1','MarkerFaceColor',[ 0  0 1 ],'MarkerEdgeColor',[ 0  0 1 ],...
    'Marker','^','MarkerSize',4},...
    {'indActGage','0','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7],...
    'Marker','^','MarkerSize',4});
% Plot the active streamgages
h2 = geoshow(StreamGageEvent,'SymbolSpec',gageColors);
wYear = handles.thisWYearStr;
title(['Active Streamgages in ',handles.titleText,' during Water Year ',wYear]);
%
ch2      = get(h2,'Children');
% nGages   = numel(ch2); % Number of streamgages
gageinfo = cell(nGages,3);
for i = 1:nGages
    gageinfo(i,1) = {ch2(i)};
    gageinfo(i,2) = {StreamGageEvent(i).SOURCE_FEA}; % Station number
    gageinfo(i,3) = {StreamGageEvent(i).STATION_NM}; % Station name
    % Set the callback function for the button-down operation
    set(ch2(i), 'ButtonDownFcn', @GetGageCurrentPoint);
    % set(ch2(i), 'ButtonDownFcn', @GetFlowlineCurrentPoint);
    set(ch2(i), 'UserData',[...
        'Num',StreamGageEvent(i).SOURCE_FEA,...
        'Name',StreamGageEvent(i).STATION_NM,...
        'Day1',datestr(datenum(num2str(StreamGageEvent(i).DAY1),...
        'yyyymmdd'),'yyyy-mm'),...
        'DayN',datestr(datenum(num2str(StreamGageEvent(i).DAYN),...
        'yyyymmdd'),'yyyy-mm'),...
        'DaM2',num2str(StreamGageEvent(i).DA_SQ_MILE),...
        'ndxI',num2str(i)]);
end
fprintf(1,'Defined gageinfo.\n');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function flowlineRB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flowlineRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
