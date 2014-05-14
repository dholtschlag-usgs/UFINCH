% UFinchGUIv2a01636500 reads a NHDFlowline (shapefile), a StreamGageEvent
% (shapefile), and an AFINCH formatted water-use data and displays
% flowlines color-coded by water use for the specified year and month.
% Streamgage locations are displayed and color-coded for activity status on
% the selected year and month.
%
function varargout = UFinchGUIv2a01636500(varargin)
% UFINCHGUIV2A01636500 MATLAB code for UFinchGUIv2a01636500.fig
%      UFINCHGUIV2A01636500, by itself, creates a new UFINCHGUIV2A01636500 or raises the existing
%      singleton*.
%
%      H = UFINCHGUIV2A01636500 returns the handle to a new UFINCHGUIV2A01636500 or the handle to
%      the existing singleton*.
%
%      UFINCHGUIV2A01636500('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UFINCHGUIV2A01636500.M with the given input arguments.
%
%      UFINCHGUIV2A01636500('Property','Value',...) creates a new UFINCHGUIV2A01636500 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UFinchGUIv2a01636500_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UFinchGUIv2a01636500_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UFinchGUIv2a01636500

% Last Modified by GUIDE v2.5 08-May-2014 14:32:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @UFinchGUIv2a01636500_OpeningFcn, ...
    'gui_OutputFcn',  @UFinchGUIv2a01636500_OutputFcn, ...
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
% --- Executes just before UFinchGUIv2a01636500 is made visible.
function UFinchGUIv2a01636500_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UFinchGUIv2a01636500 (see VARARGIN)

% Choose default command line output for UFinchGUIv2a01636500
handles.output = hObject;

% Update handles structure
set(handles.ActiveLayerButtonGroup,'SelectionChangeFcn',@ActiveLayerButtonGroup_SelectionChangeFcn);

% Setup hUFinchGUI link
setappdata(0, 'hUFinchGUI', gcf);
% Link hUFinchGUI workspace
hUFinchGUI = getappdata(0,'hUFinchGUI');
setappdata(hUFinchGUI,'in4digit',1);
setappdata(hUFinchGUI,'originalFmt',1);

annotation('rectangle','Units','pixels','FaceColor',...
    [0.831 0.816 0.784],'Position',[775,110,183,15]);

set(handles.hydroRegionPanel,'BackgroundColor',[0.93 0.93 0.93]);
guidata(hObject, handles);


% UIWAIT makes UFinchGUIv2a01636500 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = UFinchGUIv2a01636500_OutputFcn(hObject, eventdata, handles)
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
hUFinchGUI = getappdata(0,'hUFinchGUI');
[handles.flinefile,handles.flinepath] = uigetfile({['..\',handles.HR,...
    '\GIS\nhdFlowline\NHDFlowline.shp']},'Open Flowline Shapefile');
set(handles.DisplayFlowlineShapefileST,'string',[handles.flinepath,handles.flinefile],...
    'BackgroundColor',[0.93 0.93 0.93]);
% hMsg = msgbox('Please wait (commonly 45s).  This message box will automatically close when processing is complete.',...
%     'Reading and displaying flowlines...');
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
set(handles.OpenFlowlineShapefilePB,'BackgroundColor',[0.83,0.82,0.78]);
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
res = questdlg({'Exiting UFINCH Streamflow Routing Tool.';...
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
[handles.sgagefile,handles.sgagepath] = uigetfile({['..\',handles.HR,...
    '\GIS\Streamgage\','StreamGageEvent.shp']},'Open Streamgage Shapefile');
set(handles.StreamgageShapefileST,'string',fullfile(handles.sgagepath,handles.sgagefile),...
    'BackgroundColor',[0.93 0.93 0.93]);
%
hUFinchGUI = getappdata(0,'hUFinchGUI');
hucList    = getappdata(hUFinchGUI,'hucList');
% StreamGageEvent_1 has been augmented to include ComIDs at streamgages
StreamGageEvent = shaperead(fullfile(handles.sgagepath,handles.sgagefile),...
    'ATTRIBUTES',{'EVENTDATE','REACHCODE','SOURCE_FEA','MEASURE',...
    'STATION_NM','DA_SQ_MILE','DAY1','DAYN','NDAYS','ComID'},...
    'SELECTOR', {@(hsr) strncmp(hucList,hsr,4),'REACHCODE'},...
    'UseGeoCoords',true);
%
figure(handles.hHsr);
geoshow(StreamGageEvent,'MarkerFaceColor','b','Marker','^',...
    'MarkerSize',5,'MarkerEdgeColor','b');
set(handles.specifyWaterYearPanel,'BackgroundColor',[0.93 0.93 0.93]);
setappdata(hUFinchGUI,'StreamGageEvent',StreamGageEvent);
set(handles.streamgageRB','Value',1);
guidata(hObject,handles);
set(handles.OpenStreamgageShapefilePB,'BackgroundColor',[0.83,0.82,0.78]);

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
            'Marker','^','MarkerSize',5},...
            {'indActGage','0','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7],...
            'Marker','^','MarkerSize',5});
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
                'ComID',num2str(StreamGageEvent(i).ComID),...
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
fprintf(1,'Streamgage UserData = %s.\n',userdata);
gageLong   = mean(gageloc(:,1));
gageLat    = mean(gageloc(:,2));
%
gageNumber = userdata(4:(strfind(userdata,'Name')-1));
str        = lower(userdata((strfind(userdata,'Name')+4):(strfind(userdata,'Day1')-1)));
gageName   = regexprep(regexprep(str, '(^.)', '${upper($1)}'),...
    '(?<=\ \s*)([a-z])','${upper($1)}');
day1       = userdata((strfind(userdata,'Day1')+4):(strfind(userdata,'DayN')-1));
dayN       = userdata((strfind(userdata,'DayN')+4):(strfind(userdata,'DaM2')-1));
daSqMi     = userdata((strfind(userdata,'DaM2')+4):(strfind(userdata,'ComID')-1));
gageComID  = userdata((strfind(userdata,'ComID')+5):(strfind(userdata,'ndxI')-1));
gageNdx    = userdata((strfind(userdata,'ndxI')+4):end);
%
setappdata(hUFinchGUI,'gageLat',   gageLat );
setappdata(hUFinchGUI,'gageLong',  gageLong);
setappdata(hUFinchGUI,'gageNdx',   gageNdx);
setappdata(hUFinchGUI,'gageNumber',gageNumber);
setappdata(hUFinchGUI,'gageName',  gageName);
setappdata(hUFinchGUI,'gageComID', gageComID);
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
set(handles.GageNameST,'String',gageName,...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.gageLatST,'String',num2str(gageLat),...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.gageLongST,'String',num2str(gageLong),...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.gageNdxST,'String',num2str(gageNdx),...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.daMiSqST,'String',daSqMi,...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.GageComIdST,'String',gageComID,...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.porFirstST,'String',day1,...
    'BackgroundColor',[0.93 0.93 0.93]);
set(handles.porLastST,'String',dayN,...
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
    'Marker','^','MarkerSize',5},...
    {'indActGage','0','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7],...
    'Marker','^','MarkerSize',5});
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
        'ComID',num2str(StreamGageEvent(i).ComID),...
        'ndxI',num2str(i)]);
end
fprintf(1,'Defined gageinfo.\n');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function flowlineRB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flowlineRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in selectGagePB.
function selectGagePB_Callback(hObject, eventdata, handles)
% hObject    handle to selectGagePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Change color of selected streamgage symbol
hUFinchGUI      = getappdata(0,'hUFinchGUI');
StreamGageEvent = getappdata(hUFinchGUI,'StreamGageEvent');
gageNumber      = get(handles.GageNumberST,'String');
gageName        = get(handles.GageNameST,'String');
ndxGageSel      = str2double(get(handles.gageNdxST,'String'));
gageComID       = getappdata(hUFinchGUI,'gageComID');
waterYear       = get(handles.waterYearET,'String');
%
StreamGageEvent(ndxGageSel).indActGage = '2';
%
gageColors = makesymbolspec('Point',...
    {'indActGage','1','MarkerFaceColor',[0  0  1 ],'MarkerEdgeColor',[0  0  1 ],...
    'Marker','^','MarkerSize',5},...
    {'indActGage','0','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7],...
    'Marker','^','MarkerSize',5},...
    {'indActGage','2','MarkerFaceColor',[1  0  0 ],'MarkerEdgeColor',[1  0  0 ],...
    'Marker','^','MarkerSize',5});
% Plot the active streamgages
figure(handles.hHsr);
geoshow(StreamGageEvent,'SymbolSpec',gageColors);
% wYear = handles.thisWYearStr;
title({['Selected streamgage ',gageNumber,' ',gageName];...
    [' in ',waterYear,' within ',handles.titleText]});
set(handles.gageNumberST,'String',[gageNumber,' ',gageName]);
set(handles.selectGagePB,'BackgroundColor',[0.83,0.82,0.78]);
% legend('Inactive','Active','Selected');
%
% Find all flowlines upstream from the selected streamgage and color blue


% --- Executes on button press in gageShapefilePB.
function gageShapefilePB_Callback(hObject, eventdata, handles)
% hObject    handle to gageShapefilePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gageNumber      = get(handles.GageNumberST,'String');
[fname, pname]  = uigetfile({['..\',handles.HR,'\GIS\Streamgage\',...
   gageNumber,'.shp']},'Open Shapefile for Selected Streamgage');
% Read shapefile
[gageStruc,gageAttri] = shaperead([pname,fname],'UseGeoCoords',true);
nFlowlines = length(gageStruc);
set(handles.numberFlowlinesST,'String',num2str(nFlowlines));
% Specify file identifier to read in
% latlim = [min([gageStruc.Lat]) max([gageStruc.Lat])];
% lonlim = [min([gageStruc.Lon]) max([gageStruc.Lon])];

% Display the DEM values as a texture map. 
figure(handles.hHsr);
% usamap(latlim, lonlim)
geoshow(gageStruc,'Color',[ 0  1  0],'LineWidth',2);
set(handles.gageFlowlineST,'String',[pname,fname]);
set(handles.gageShapefilePB,'BackgroundColor',[0.83,0.82,0.78]);
%

% --- Executes on button press in networkGeometryPB.
function networkGeometryPB_Callback(hObject, eventdata, handles)
% hObject    handle to networkGeometryPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gageNumber      = get(handles.GageNumberST,'String');
[fname, pname]  = uigetfile({['..\',handles.HR,'\GIS\nhdFlowline\',...
    gageNumber,'.nhd']},'Open Geometry for Selected Streamgage');
% fid = fopen([pname fname],'rt');
%% Read in network geometry
% Use dialog box to get input NHDPlus geometry file containing fields
%   "COMID","LENGTHKM","AREASQKM","MAVELU","STREAMLEVE","FROMNODE",
%   "TONODE","HYDROSEQ","LEVELPATHI","STARTFLAG"
% Read in the nhd geometry data
nhdGeom    = importdata([pname,fname]);
% % process A to get needed data fields
hUFinchGUI = getappdata(0,'hUFinchGUI');
             setappdata(hUFinchGUI,'nhdGeom',nhdGeom);
% fclose(fid);
%
set(handles.gageTopologyST,'String',[pname,fname]);
set(handles.networkGeometryPB,'BackgroundColor',[0.83,0.82,0.78]);

% --- Executes on button press in travelTimesPB.
function travelTimesPB_Callback(hObject, eventdata, handles)
% hObject    handle to travelTimesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI  = getappdata(0,'hUFinchGUI');
nhdGeom     = getappdata(hUFinchGUI,'nhdGeom');
% Identify column contents by header
ndxComID = find(strncmpi(nhdGeom.colheaders,'ComID',     length('ComID')));
ndxLenKm = find(strncmpi(nhdGeom.colheaders,'LengthKm',  length('LengthKm')));
ndxFNode = find(strncmpi(nhdGeom.colheaders,'FromNode',  length('FromNode')));
ndxTNode = find(strncmpi(nhdGeom.colheaders,'ToNode',    length('ToNode')));
ndxHSequ = find(strncmpi(nhdGeom.colheaders,'HydroSeq',  length('HydroSeq')));
ndxLPath = find(strncmpi(nhdGeom.colheaders,'LevelPathI',length('LevelPathI')));
ndxAreaM = find(strncmpi(nhdGeom.colheaders,'AreaSqKm',  length('AreaSqKm')));
ndxV001C = find(strncmpi(nhdGeom.colheaders,'V0001C',    length('V0001C')));
ndxV001E = find(strncmpi(nhdGeom.colheaders,'V0001E',    length('V0001E')));
% Create nhdMatrix with data field of nhdGeom
nhdMatrix           = nhdGeom.data;
% Sort rows of A by HydroSeq in decreasing (-) order.
% A          = cell2mat(A);
nhdMatrix  = sortrows(nhdMatrix,[ndxLPath,ndxHSequ]);
ComID      = nhdMatrix(:, ndxComID);
LengthKm   = nhdMatrix(:, ndxLenKm);
AreaSqKm   = nhdMatrix(:, ndxAreaM);
fprintf('%8.1f\n',min(AreaSqKm));
fprintf('%8.1f\n',max(AreaSqKm));
V0001C     = nhdMatrix(:, ndxV001C);
V0001E     = nhdMatrix(:, ndxV001E);
% MaVelU is the mean velocity metric selected 
MaVelU      = nhdMatrix(:, ndxV001C);
% 
FromNode   = nhdMatrix(:, ndxFNode);
ToNode     = nhdMatrix(:, ndxTNode);
HydroSeq   = nhdMatrix(:, ndxHSequ);
LevelPathI = nhdMatrix(:, ndxLPath);
%
% store results in 
setappdata(hUFinchGUI,'ComID',      ComID);
setappdata(hUFinchGUI,'LengthKm',   LengthKm);
setappdata(hUFinchGUI,'AreaSqKm',   AreaSqKm);
setappdata(hUFinchGUI,'MaVelU',     MaVelU);
% setappdata(hUFinchGUI,'V0001c',     V00001c);
% setappdata(hUFinchGUI,'V0001e',     V00001e);
% setappdata(hUFinchGUI,'StreamLeve', StreamLeve);
setappdata(hUFinchGUI,'FromNode',   FromNode);
setappdata(hUFinchGUI,'ToNode',     ToNode);
setappdata(hUFinchGUI,'HydroSeq',   HydroSeq);
setappdata(hUFinchGUI,'LevelPathI', LevelPathI);
setappdata(hUFinchGUI,'nhdGeom',    nhdGeom);
setappdata(hUFinchGUI,'nhdMatrix',  nhdMatrix);
gageNumber = getappdata(hUFinchGUI,'gageNumber');
LevelPathI = getappdata(hUFinchGUI,'LevelPathI');
%
nFlowlines = length(ComID);
ttFlowline = nan(nFlowlines,1); 
%
ndash  = 60;
fprintf(1,[repmat('-',1,ndash),'\n']);
fprintf(1,'                                                     Travel    \n');
fprintf(1,'                                Flowline    Mean     time in   \n');
fprintf(1,'                                length,in  velocity  15-min    \n');
fprintf(1,'Index   LevelPathID    ComID    kilometers  ft/s     steps     \n');
fprintf(1,[repmat('-',1,ndash),'\n']);
for i = 1:nFlowlines,
    % The constant 2.18723 converts 1*km/(1*fps * 5/3) into 15-min units
    % Experimenting with higher (*2) velocitye
    ttFlowline(i) = max(1,floor(LengthKm(i) / (V0001C(i)*2) * 2.18723));
    % ttFlowline(i) =       LengthKm(i) / V0001C(i) * 2.18723; 
    fprintf(1,' %3u  %12u  %10u  %7.3f  %8.4f  %8u  \n',...
        i,LevelPathI(i),ComID(i),LengthKm(i),V0001C(i),ttFlowline(i));
end
fprintf(1,[repmat('-',1,ndash),'\n\n']);
% 
% Identify flowlines associated with each branch
% Determine how many branches there are in the network
nBranch = length(unique(LevelPathI));
fprintf(1,'%s \n',['There are ',num2str(nBranch),' branches in the ',gageNumber,' network.']);
%
% Allocate vector for branch and reach identifiers
branchID      = nan(nBranch,5);
% Allocate vector for cum
ttBranch      = zeros(nFlowlines,1);
% Initialize branch as first LevelPathI
j             =  1;
iBranch       =  LevelPathI(j);
ttBranch(j)   =  max(1,floor(ttFlowline(j)));
% ttBranch(j)   =  max(1,ttFlowline(j));
% ttBranch(j)   =  round(ttFlowline(j));
branchID(j,1) =  1;  % First Branch
branchID(j,2) =  1;  % First Flowline of Branch
branchID(j,3) =  1;  % First Flowline
branchID(j,4) =  HydroSeq(j);
branchID(j,5) =  ComID(j);
% Print header for branch output
ndash = 82;
fprintf(1,'%s \n',repmat('-',1,ndash));
fprintf(1,'%s \n','  Flowline   Branch   Branch  Sequence  Flowline  Flowline travel-  Branch travel- ');
fprintf(1,'%s \n','  sequence  sequence    ID    in Branch   ComID     time (15-min)    time (15-min)  ');
fprintf(1,'%s \n',repmat('-',1,ndash));
fprintf(1,'%6u   %6u   %12u  %5u  %10u    %12.4f    %12.4f  %12u \n',j, branchID(j,1),...
    LevelPathI(j),branchID(j,2),ComID(j),ttFlowline(j),ttBranch(j),HydroSeq(j));
for j = 2:nFlowlines
    if (iBranch       == LevelPathI(j))
        % max(1,ttFlowline(j)) is intended to take care of short reaches
%         if ttFlowline(j) < 1
%             fprintf(1,'%u %8.4f \n',j,ttFlowline(j));
%         end
%         ttBranch(j)   =  max(round(ttBranch(j-1) + ttFlowline(j)),...
%                              round(ttBranch(j-1) + 1) );        
        ttBranch(j)   =  ttBranch(j-1) + ttFlowline(j);        
        branchID(j,1) =  branchID(j-1,1);
        branchID(j,2) =  branchID(j-1,2) + 1;
    else
        fprintf(1,'%s \n',repmat('.',1,3));
        iBranch       = LevelPathI(j);
        ttBranch(j)   = ttFlowline(j);
        branchID(j,1) = branchID(j-1) + 1;
        branchID(j,2) = 1; 
    end
    branchID(j,3) =  j;
    branchID(j,4) =  HydroSeq(j);
    branchID(j,5) =  ComID(j);
    fprintf(1,'%6u   %6u   %12u  %5u  %10u    %12.4f    %12.4f  %12u \n',j, branchID(j,1),...
        LevelPathI(j),branchID(j,2),ComID(j),ttFlowline(j),ttBranch(j),HydroSeq(j));
end
fprintf(1,'%s \n',repmat('-',1,ndash));
%
%% Update ttNetworks in downstream order
% Just print some stuff out about the branches
ndxBrBase = find(branchID(:,2) == 1);
% Initially set the travel times in the network to that of the branches
ttNetwork = ttBranch; 
%
brOrder   = nan(nBranch,4); 
for i = 1:nBranch,
    brOrder(i,1) = branchID(ndxBrBase(i),1);
    brOrder(i,2) = branchID(ndxBrBase(i),3);
    brOrder(i,3) = HydroSeq(ndxBrBase(i));
    brOrder(i,4) = ComID(   ndxBrBase(i));
    fprintf(1,'%5u %5u %5u %5u %10u %10u\n',i,ndxBrBase(i),...
        brOrder(i,1),brOrder(i,2),brOrder(i,3),brOrder(i,4));
end
%
[srtBrOrder,ndx] = sortrows(brOrder,3);
% Start index at 2 because the minimum hydroseq is the main stem
for i = 2:nBranch
    % Print: Branch being updated, Flowline index
    fprintf(1,'%6u %6u %10u \n',srtBrOrder(i,1),srtBrOrder(i,2),...
        ComID(srtBrOrder(i,2)));
    % ndxFromNode is the index of the 
    ndxFromNode = find(ToNode(srtBrOrder(i,2)) == FromNode);
    if ~isempty(ndxFromNode)
        ndxAdd            = find( srtBrOrder(i,1) == branchID(:,1));        
        ttNetwork(ndxAdd) = floor(ttNetwork(ndxFromNode) + ttBranch(ndxAdd));
    end
end
%
branchIDTable = table(branchID(:,1),branchID(:,2),branchID(:,3),...
    branchID(:,4),branchID(:,5),FromNode,ToNode,LengthKm,AreaSqKm,...
    MaVelU,LevelPathI,ttNetwork,'VariableNames',...
    {'branch','branchElement','Flowline','HydroSeq','ComID',...
    'FromNode','ToNode','LengthKm','AreaSqKm','MaVelU','LevelPathI',...
    'ttNetwork'});
%
ndash = 110;
fprintf(1,'%s \n',repmat('-',1,ndash));
fprintf(1,'%s \n','  Branch               Branch-   Flowline  Flowline  Flowline travel-  Branch travel-  Network travel-   Hydro- ');
fprintf(1,'%s \n',' sequence  LevelPathI  flowline  sequence   ComID     time (15-min)    time (15-min)    time (15-min)   sequence' );
fprintf(1,'%s \n',repmat('-',1,ndash));
for j = 1:nFlowlines
    fprintf(1,'%6u   %12u %5u     %5u   %10u    %12.4f    %12.4f     %11.4f  %12u \n',...
        branchID(j,1),LevelPathI(j),branchID(j,2),j,ComID(j),...
        ttFlowline(j),ttBranch(j),ttNetwork(j),HydroSeq(j));
end
fprintf(1,'%s \n',repmat('-',1,ndash));
%
minTTime = min(ttNetwork);
maxTTime = max(ttNetwork);
timeVec  = getappdata(hUFinchGUI,'timeVec');
setappdata(hUFinchGUI,'minTTime',minTTime);
setappdata(hUFinchGUI,'maxTTime',maxTTime);
setappdata(hUFinchGUI,'ttFlowline',ttFlowline);
setappdata(hUFinchGUI,'ttBranch',  ttBranch);
setappdata(hUFinchGUI,'ttNetwork',ttNetwork);
set(handles.traveltimeTable,'Data',[minTTime maxTTime;minTTime/96 maxTTime/96]);
set(handles.startCompYearET,'String',datestr(timeVec(maxTTime+1),'yyyy'));
set(handles.startCompMoET,'String',datestr(timeVec(maxTTime+1),'mm'));
set(handles.startCompDayET,'String',datestr(timeVec(maxTTime+1),'dd'));
set(handles.startCompHrET,'String',datestr(timeVec(maxTTime+1),'HH'));
set(handles.startCompMnET,'String',datestr(timeVec(maxTTime+1),'MM'));
nCompStep = str2double(get(handles.nTimeStepsST,'String')) - maxTTime;
set(handles.nCompStepsST,'String',num2str(nCompStep));
set(handles.travelTimesPB,'BackgroundColor',[0.83,0.82,0.78]);

% --- Executes on button press in read15FlowPB.
function read15FlowPB_Callback(hObject, eventdata, handles)
% hObject    handle to read15FlowPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gageNumber      = get(handles.GageNumberST,'String');
[fname, pname]  = uigetfile({['..\',handles.HR,'\FlowData\',gageNumber,...
    '.uFlo']},'Open File of Unit Flow Data for Selected Streamgage');
set(handles.file15flowST,'String',[pname,fname]);
fid = fopen([pname,fname],'rt');
Q       = cell2mat(textscan(fid,'%f %f %f %f %f %f','Delimiter',','));
timeVec = datenum(Q(:,1),Q(:,2),Q(:,3),Q(:,4),Q(:,5),zeros(length(Q(:,1)),1));
flowVec = Q(:,6);
hFlowSeries = figure('Name','Flow Time Series Plot'); 
semilogy(timeVec,flowVec,'b-');
datetick('x');
xlabel('Date'); ylabel('Flow, in cubic feet per second');
title([get(handles.GageNumberST,'String'),' ',get(handles.GageNameST,'String')]);
% Save results
hUFinchGUI  = getappdata(0,'hUFinchGUI');
setappdata(hUFinchGUI,'timeVec',timeVec);
setappdata(hUFinchGUI,'flowVec',flowVec);
% Show time span
n = length(timeVec);
% Start times
set(handles.timeStartST,'String',datestr(timeVec(1),'yyyy-mm-dd HH MM'));
set(handles.timeEndST,'String',datestr(timeVec(n),'yyyy-mm-dd HH MM'));
set(handles.nTimeStepsST,'String',num2str(n));
set(handles.startCompYearET,'String',datestr(timeVec(1),'yyyy'));
set(handles.startCompMoET,'String',datestr(timeVec(1),'mm'));
set(handles.startCompDayET,'String',datestr(timeVec(1),'dd'));
set(handles.startCompHrET,'String',datestr(timeVec(1),'HH'));
set(handles.startCompMnET,'String',datestr(timeVec(1),'MM'));
% End times
set(handles.endCompYearET,'String',datestr(timeVec(n),'yyyy'));
set(handles.endCompMoET,'String',datestr(timeVec(n),'mm'));
set(handles.endCompDayET,'String',datestr(timeVec(n),'dd'));
set(handles.endCompHrET,'String',datestr(timeVec(n),'HH'));
set(handles.endCompMnET,'String',datestr(timeVec(n),'MM'));
set(handles.nCompStepsST,'String',num2str(n));
set(handles.read15FlowPB,'BackgroundColor',[0.83,0.82,0.78]);
%

function endCompYearET_Callback(hObject, eventdata, handles)
% hObject    handle to endCompYearET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
s_yr = str2double(get(handles.startCompYearET,'String'));
s_mm = str2double(get(handles.startCompMoET,'String'));
s_da = str2double(get(handles.startCompDayET,'String'));
e_yr = str2double(get(hObject,'String'));
e_mm = str2double(get(handles.endCompMoET,'String'));
e_da = str2double(get(handles.endCompDayET,'String'));
nCompSteps = ceil((datenum([e_yr,e_mm,e_da,1,0,0])-datenum([s_yr,s_mm,s_da,24,0,0]))*96);
set(handles.nCompStepsST,'String',num2str(nCompSteps));



% --- Executes during object creation, after setting all properties.
function endCompYearET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endCompYearET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endCompMoET_Callback(hObject, eventdata, handles)
% hObject    handle to endCompMoET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s_yr = str2double(get(handles.startCompYearET,'String'));
s_mm = str2double(get(handles.startCompMoET,'String'));
s_da = str2double(get(handles.startCompDayET,'String'));
e_yr = str2double(get(handles.endCompYearET,'String'));
e_mm = str2double(get(hObject,'String'));
e_da = str2double(get(handles.endCompDayET,'String'));
nCompSteps = ceil((datenum([e_yr,e_mm,e_da,1,0,0])-datenum([s_yr,s_mm,s_da,24,0,0]))*96);
set(handles.nCompStepsST,'String',num2str(nCompSteps));


% --- Executes during object creation, after setting all properties.
function endCompMoET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endCompMoET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endCompDayET_Callback(hObject, eventdata, handles)
% hObject    handle to endCompDayET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s_yr = str2double(get(handles.startCompYearET,'String'));
s_mm = str2double(get(handles.startCompMoET,'String'));
s_da = str2double(get(handles.startCompDayET,'String'));
e_yr = str2double(get(handles.endCompYearET,'String'));
e_mm = str2double(get(handles.endCompMoET,'String'));
e_da = str2double(get(hObject,'String'));
nCompSteps = ceil((datenum([e_yr,e_mm,e_da,1,0,0])-datenum([s_yr,s_mm,s_da,24,0,0]))*96);
set(handles.nCompStepsST,'String',num2str(nCompSteps));


% --- Executes during object creation, after setting all properties.
function endCompDayET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endCompDayET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startCompYearET_Callback(hObject, eventdata, handles)
% hObject    handle to startCompYearET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s_yr = str2double(get(hObject,'String'));
s_mm = str2double(get(handles.startCompMoET,'String'));
s_da = str2double(get(handles.startCompDayET,'String'));
e_yr = str2double(get(handles.endCompYearET,'String'));
e_mm = str2double(get(handles.endCompMoET,'String'));
e_da = str2double(get(handles.endCompDayET,'String'));
nCompSteps = ceil((datenum([e_yr,e_mm,e_da,1,0,0])-datenum([s_yr,s_mm,s_da,24,0,0]))*96);
set(handles.nCompStepsST,'String',num2str(nCompSteps));


% --- Executes during object creation, after setting all properties.
function startCompYearET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startCompYearET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startCompMoET_Callback(hObject, eventdata, handles)
% hObject    handle to startCompMoET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s_yr = str2double(get(handles.startCompYearET,'String'));
s_mm = str2double(get(hObject,'String'));
s_da = str2double(get(handles.startCompDayET,'String'));
e_yr = str2double(get(handles.endCompYearET,'String'));
e_mm = str2double(get(handles.endCompMoET,'String'));
e_da = str2double(get(handles.endCompDayET,'String'));
nCompSteps = ceil((datenum([e_yr,e_mm,e_da,1,0,0])-datenum([s_yr,s_mm,s_da,24,0,0]))*96);
set(handles.nCompStepsST,'String',num2str(nCompSteps));


% --- Executes during object creation, after setting all properties.
function startCompMoET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startCompMoET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function startCompDayET_Callback(hObject, eventdata, handles)
% hObject    handle to startCompDayET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s_yr = str2double(get(handles.startCompYearET,'String'));
s_mm = str2double(get(handles.startCompMoET,'String'));
s_da = str2double(get(hObject,'String'));
e_yr = str2double(get(handles.endCompYearET,'String'));
e_mm = str2double(get(handles.endCompMoET,'String'));
e_da = str2double(get(handles.endCompDayET,'String'));
nCompSteps = ceil((datenum([e_yr,e_mm,e_da,1,0,0])-datenum([s_yr,s_mm,s_da,24,0,0]))*96);
set(handles.nCompStepsST,'String',num2str(nCompSteps));


% --- Executes during object creation, after setting all properties.
function startCompDayET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startCompDayET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in computeUnitFlowsPB.
function computeUnitFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to computeUnitFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI   = getappdata(0,'hUFinchGUI');
LevelPathSet = getappdata(hUFinchGUI,'LevelPathSet');
flowVec      = getappdata(hUFinchGUI,'flowVec');
timeVec      = getappdata(hUFinchGUI,'timeVec');
minTTime     = getappdata(hUFinchGUI,'minTTime');     
maxTTime     = getappdata(hUFinchGUI,'maxTTime');
% Reset color of save computed flows button
set(handles.SaveComputedFlowsPB,'BackgroundColor',[0.93,0.93,0.93]);
%
LevelPathSet   = getappdata(hUFinchGUI,'LevelPathSet');
travelTimes    = get(handles.traveltimeTable,'Data');
maxTravelTime  = travelTimes(1,2)+1;
begCompTime    = timeVec(maxTravelTime);
%
sYr            = str2double(get(handles.startCompYearET,'String'));
sMo            = str2double(get(handles.startCompMoET,'String'));
sDa            = str2double(get(handles.startCompDayET,'String'));
sHr            = str2double(get(handles.startCompHrET,'String'));
sMn            = str2double(get(handles.startCompMnET,'String'));
sYrMoDaHrMn    = datenum(sYr,sMo,sDa,sHr,sMn,0);
%
% Determine the index in timeVec that corresponds to start
tbeg           = find(timeVec == sYrMoDaHrMn);
fprintf(1,'Simulations start at timeVec(%u) = %s.\n',tbeg,...
    datestr(timeVec(tbeg),'yyyy-mmm-dd HH:MM'));

eYr            = str2double(get(handles.endCompYearET,'String'));
eMo            = str2double(get(handles.endCompMoET,'String'));
eDa            = str2double(get(handles.endCompDayET,'String'));
eHr            = str2double(get(handles.endCompHrET,'String'));
eMn            = str2double(get(handles.endCompMnET,'String'));
eYrMoDaHrMn    = datenum(eYr,eMo,eDa,eHr,eMn,0);
%
% Determine the index in timeVec that corresponds to start
tend           = find(timeVec == eYrMoDaHrMn);
fprintf(1,'Simulations end   at timeVec(%u) = %s.\n',tend,...
    datestr(timeVec(tend),'yyyy-mmm-dd HH:MM'));

nSim = tend - tbeg + 1;

fprintf(1,'The number of 15-min time intervals simulated will be %u.\n',nSim);

set(handles.nCompStepsST,'String',num2str(nSim));

% Check if specified start computation time is greater than possible start time 
if begCompTime > sYrMoDaHrMn
    get(handles.timeStartST,'String',datestr(timeVec(1),'yyyy-mm-dd HH'));
    [sYr,sMo,sDa,sHr,sMn,~] = datevec(begCompTime); 
    set(handles.startCompYearET,'String',num2str(sYr));
    set(handles.startCompMoET,  'String',num2str(sMo));
    set(handles.startCompDayET, 'String',num2str(sDa));
    set(handles.startCompHrET,  'String',num2str(sHr));
    set(handles.startCompMnET,  'String',num2str(sMn));
end
%
% A            = getappdata(hUFinchGUI,'A');
% % Sort rows of A by HydroSeq (column 8) in decreasing (-) order.
% A            = cell2mat(A);
% A            = sortrows(A,-8);
ComID      = getappdata(hUFinchGUI,'ComID');
AreaSqKm   = getappdata(hUFinchGUI,'AreaSqKm');
FromNode   = getappdata(hUFinchGUI,'FromNode');
ToNode     = getappdata(hUFinchGUI,'ToNode');
LevelPathI = getappdata(hUFinchGUI,'LevelPathI');

% nEqn is the number of equations or flowlines he network
nEqn       = length(ComID);
% % flowDesign is the flowline design matrix
% flowDesign = eye(nEqn,nEqn);
% % aCatch is a vector of catchment drainage areas
% aCatch     = zeros(nEqn,1);
% % ndxEqn is an index for the current equation
% ndxEqn     = 0;
% % tDelay = is vector of time delays
% tDelay     = zeros(nEqn,1);
% % seqComID is the ComID in order that they are processed
% seqComID   = zeros(nEqn,1);
% % strLevel is the streamlevel associated with a reach
% strLevel   = zeros(nEqn,1);
%
%% Initialize nEqn, ComID-tagged variables for flow
for i = 1:nEqn
    eval(['C',num2str(ComID(i)),' = nan(nSim,1);']);
end
% Max Travel time
fprintf(1,'Min network travel time is: %u 15-min time steps.\n',minTTime);
fprintf(1,'Max network travel time is: %u 15-min time steps.\n',maxTTime);
% Compute yields
Ylds   = flowVec(tbeg-maxTTime-1:tend) ./ sum(AreaSqKm);
%
for t=1+maxTTime:nSim
C5906763(t - 0118) = Ylds(t - 0118) * 7.4412; 
C5906799(t - 0105) = Ylds(t - 0105) * 23.0175; 
C5906807(t - 0117) = Ylds(t - 0117) * 8.4384; 
C5906809(t - 0119) = Ylds(t - 0119) * 14.8185; 
C5906813(t - 0117) = Ylds(t - 0117) * 13.9644; 
C5906817(t - 0136) = Ylds(t - 0136) * 13.7475; 
C5906835(t - 0163) = Ylds(t - 0163) * 21.4074; 
C5906839(t - 0164) = Ylds(t - 0164) * 5.7249; 
C5906845(t - 0167) = Ylds(t - 0167) * 10.2330; 
C5906851(t - 0167) = Ylds(t - 0167) * 8.6058; 
C5906859(t - 0180) = Ylds(t - 0180) * 6.8571; 
C5906861(t - 0176) = Ylds(t - 0176) * 0.0000; 
C5906863(t - 0169) = Ylds(t - 0169) * 44.1207; 
C5906865(t - 0175) = Ylds(t - 0175) * 7.6743; 
C5906875(t - 0173) = Ylds(t - 0173) * 23.0949; 
C5906879(t - 0172) = Ylds(t - 0172) * 16.7553; 
C5906881(t - 0175) = Ylds(t - 0175) * 17.3889; 
C5906883(t - 0175) = Ylds(t - 0175) * 23.8176; 
C5906885(t - 0197) = Ylds(t - 0197) * 1.3455; 
C5906887(t - 0196) = Ylds(t - 0196) * 6.7986; 
C5906889(t - 0194) = Ylds(t - 0194) * 1.1106; 
C5906891(t - 0179) = Ylds(t - 0179) * 5.2542; 
C5906897(t - 0257) = Ylds(t - 0257) * 23.6502; 
C5907045(t - 0107) = Ylds(t - 0107) * 28.6128; 
C5907051(t - 0119) = Ylds(t - 0119) * 11.6928; 
C5907053(t - 0119) = Ylds(t - 0119) * 23.7105; 
C5907055(t - 0138) = Ylds(t - 0138) * 20.6577; 
C5907057(t - 0154) = Ylds(t - 0154) * 47.9970; 
C5907059(t - 0169) = Ylds(t - 0169) * 33.4647; 
C5907201(t - 0103) = Ylds(t - 0103) * 6.2199; 
C5907203(t - 0164) = Ylds(t - 0164) * 6.5934; 
C5907281(t - 0274) = Ylds(t - 0274) * 1.2978; 
C5907283(t - 0271) = Ylds(t - 0271) * 2.4534; 
C5907287(t - 0272) = Ylds(t - 0272) * 4.2597; 
C5907289(t - 0271) = Ylds(t - 0271) * 1.5507; 
C5907291(t - 0266) = Ylds(t - 0266) * 0.9855; 
C5907303(t - 0271) = Ylds(t - 0271) * 6.8823; 
C5907309(t - 0265) = Ylds(t - 0265) * 1.1961; 
C5907311(t - 0262) = Ylds(t - 0262) * 0.8253; 
C5907313(t - 0260) = Ylds(t - 0260) * 0.8037; 
C5907319(t - 0260) = Ylds(t - 0260) * 2.5839; 
C5907325(t - 0265) = Ylds(t - 0265) * 1.7451; 
C5907327(t - 0259) = Ylds(t - 0259) * 1.4859; 
C5907329(t - 0260) = Ylds(t - 0260) * 0.9270; 
C5907339(t - 0259) = Ylds(t - 0259) * 1.1331; 
C5907351(t - 0269) = Ylds(t - 0269) * 1.0260; 
C5907355(t - 0259) = Ylds(t - 0259) * 1.4706; 
C5907359(t - 0266) = Ylds(t - 0266) * 1.4778; 
C5907375(t - 0257) = Ylds(t - 0257) * 2.8017; 
C5907379(t - 0255) = Ylds(t - 0255) * 0.8892; 
C5907381(t - 0256) = Ylds(t - 0256) * 2.3292; 
C5907389(t - 0267) = Ylds(t - 0267) * 1.3356; 
C5907391(t - 0256) = Ylds(t - 0256) * 1.3122; 
C5907399(t - 0255) = Ylds(t - 0255) * 1.7136; 
C5907405(t - 0255) = Ylds(t - 0255) * 0.8478; 
C5907423(t - 0270) = Ylds(t - 0270) * 1.1295; 
C5907425(t - 0271) = Ylds(t - 0271) * 7.3332; 
C5907429(t - 0259) = Ylds(t - 0259) * 1.2510; 
C5907431(t - 0257) = Ylds(t - 0257) * 2.6667; 
C5907433(t - 0256) = Ylds(t - 0256) * 2.9790; 
C5907435(t - 0272) = Ylds(t - 0272) * 1.8693; 
C5907441(t - 0259) = Ylds(t - 0259) * 1.2969; 
C5907455(t - 0271) = Ylds(t - 0271) * 1.1754; 
C5907469(t - 0260) = Ylds(t - 0260) * 2.2626; 
C5907471(t - 0257) = Ylds(t - 0257) * 1.6011; 
C5907473(t - 0259) = Ylds(t - 0259) * 0.8568; 
C5908041(t - 0189) = Ylds(t - 0189) * 4.1571; 
C5908049(t - 0185) = Ylds(t - 0185) * 4.6026; 
C5908053(t - 0188) = Ylds(t - 0188) * 1.9548; 
C5908057(t - 0183) = Ylds(t - 0183) * 1.9152; 
C5908061(t - 0184) = Ylds(t - 0184) * 5.1426; 
C5908063(t - 0185) = Ylds(t - 0185) * 1.4103; 
C5908071(t - 0193) = Ylds(t - 0193) * 2.7045; 
C5908079(t - 0248) = Ylds(t - 0248) * 0.0045; 
C5908089(t - 0187) = Ylds(t - 0187) * 2.2338; 
C5908095(t - 0187) = Ylds(t - 0187) * 2.5398; 
C5908099(t - 0187) = Ylds(t - 0187) * 2.7081; 
C5908103(t - 0254) = Ylds(t - 0254) * 12.9582; 
C5908111(t - 0196) = Ylds(t - 0196) * 2.0295; 
C5908113(t - 0255) = Ylds(t - 0255) * 8.3799; 
C5908115(t - 0188) = Ylds(t - 0188) * 3.1338; 
C5908117(t - 0195) = Ylds(t - 0195) * 1.5858; 
C5908133(t - 0192) = Ylds(t - 0192) * 3.4515; 
C5908139(t - 0211) = Ylds(t - 0211) * 2.4516; 
C5908143(t - 0242) = Ylds(t - 0242) * 16.4457; 
C5908145(t - 0195) = Ylds(t - 0195) * 3.4596; 
C5908149(t - 0193) = Ylds(t - 0193) * 3.3246; 
C5908155(t - 0193) = Ylds(t - 0193) * 4.7511; 
C5908159(t - 0191) = Ylds(t - 0191) * 0.0018; 
C5908161(t - 0198) = Ylds(t - 0198) * 3.5865; 
C5908167(t - 0197) = Ylds(t - 0197) * 1.4445; 
C5908175(t - 0230) = Ylds(t - 0230) * 2.9412; 
C5908177(t - 0189) = Ylds(t - 0189) * 2.5209; 
C5908181(t - 0198) = Ylds(t - 0198) * 1.4094; 
C5908183(t - 0201) = Ylds(t - 0201) * 1.5678; 
C5908191(t - 0198) = Ylds(t - 0198) * 2.5830; 
C5908195(t - 0242) = Ylds(t - 0242) * 6.1902; 
C5908201(t - 0197) = Ylds(t - 0197) * 8.6580; 
C5908219(t - 0197) = Ylds(t - 0197) * 4.5081; 
C5908221(t - 0206) = Ylds(t - 0206) * 2.1015; 
C5908225(t - 0195) = Ylds(t - 0195) * 1.7028; 
C5908227(t - 0197) = Ylds(t - 0197) * 2.2923; 
C5908241(t - 0223) = Ylds(t - 0223) * 9.3789; 
C5908245(t - 0200) = Ylds(t - 0200) * 3.2004; 
C5908249(t - 0197) = Ylds(t - 0197) * 7.2981; 
C5908251(t - 0240) = Ylds(t - 0240) * 4.3848; 
C5908253(t - 0223) = Ylds(t - 0223) * 5.1894; 
C5908257(t - 0220) = Ylds(t - 0220) * 4.9554; 
C5908263(t - 0234) = Ylds(t - 0234) * 5.4018; 
C5908265(t - 0231) = Ylds(t - 0231) * 2.4930; 
C5908267(t - 0203) = Ylds(t - 0203) * 2.5875; 
C5908277(t - 0220) = Ylds(t - 0220) * 6.1353; 
C5908287(t - 0205) = Ylds(t - 0205) * 2.0466; 
C5908291(t - 0230) = Ylds(t - 0230) * 10.3374; 
C5908295(t - 0204) = Ylds(t - 0204) * 1.7892; 
C5908309(t - 0205) = Ylds(t - 0205) * 2.2545; 
C5908315(t - 0201) = Ylds(t - 0201) * 4.6944; 
C5908317(t - 0230) = Ylds(t - 0230) * 5.4360; 
C5908325(t - 0209) = Ylds(t - 0209) * 8.4402; 
C5908329(t - 0211) = Ylds(t - 0211) * 2.7216; 
C5908333(t - 0212) = Ylds(t - 0212) * 6.8130; 
C5908339(t - 0231) = Ylds(t - 0231) * 0.0072; 
C5908341(t - 0225) = Ylds(t - 0225) * 5.2182; 
C5908343(t - 0223) = Ylds(t - 0223) * 6.1308; 
C5908349(t - 0232) = Ylds(t - 0232) * 1.4562; 
C5908351(t - 0211) = Ylds(t - 0211) * 3.6648; 
C5908357(t - 0233) = Ylds(t - 0233) * 1.9152; 
C5908359(t - 0228) = Ylds(t - 0228) * 11.1951; 
C5908363(t - 0220) = Ylds(t - 0220) * 2.4147; 
C5908365(t - 0232) = Ylds(t - 0232) * 9.3636; 
C5908367(t - 0221) = Ylds(t - 0221) * 2.0367; 
C5908371(t - 0225) = Ylds(t - 0225) * 2.5731; 
C5908379(t - 0237) = Ylds(t - 0237) * 9.4761; 
C5908391(t - 0224) = Ylds(t - 0224) * 5.1957; 
C5908411(t - 0229) = Ylds(t - 0229) * 6.1389; 
C5908427(t - 0233) = Ylds(t - 0233) * 2.6280; 
C5908431(t - 0237) = Ylds(t - 0237) * 8.2305; 
C5908439(t - 0233) = Ylds(t - 0233) * 5.2416; 
C5908445(t - 0246) = Ylds(t - 0246) * 4.4802; 
C5908449(t - 0239) = Ylds(t - 0239) * 1.2060; 
C5908461(t - 0239) = Ylds(t - 0239) * 4.4658; 
C5908467(t - 0241) = Ylds(t - 0241) * 4.1931; 
C5908471(t - 0250) = Ylds(t - 0250) * 32.1075; 
C5908475(t - 0241) = Ylds(t - 0241) * 2.5803; 
C5908477(t - 0242) = Ylds(t - 0242) * 11.8242; 
C5908481(t - 0244) = Ylds(t - 0244) * 16.3188; 
C5908487(t - 0245) = Ylds(t - 0245) * 7.4412; 
C5908497(t - 0264) = Ylds(t - 0264) * 2.5137; 
C5908501(t - 0262) = Ylds(t - 0262) * 4.6071; 
C5908503(t - 0245) = Ylds(t - 0245) * 12.4101; 
C5908507(t - 0242) = Ylds(t - 0242) * 4.3884; 
C5908515(t - 0249) = Ylds(t - 0249) * 1.8432; 
C5908517(t - 0249) = Ylds(t - 0249) * 0.0000; 
C5908519(t - 0255) = Ylds(t - 0255) * 5.5134; 
C5908525(t - 0258) = Ylds(t - 0258) * 3.0735; 
C5908529(t - 0250) = Ylds(t - 0250) * 5.6745; 
C5908533(t - 0257) = Ylds(t - 0257) * 5.7177; 
C5908581(t - 0193) = Ylds(t - 0193) * 5.0202; 
C5908583(t - 0220) = Ylds(t - 0220) * 18.3285; 
C5908585(t - 0208) = Ylds(t - 0208) * 8.9577; 
C5908591(t - 0216) = Ylds(t - 0216) * 5.3991; 
C5908595(t - 0221) = Ylds(t - 0221) * 6.7446; 
C5908599(t - 0222) = Ylds(t - 0222) * 12.4794; 
C5908605(t - 0229) = Ylds(t - 0229) * 4.2669; 
C5908607(t - 0233) = Ylds(t - 0233) * 2.5794; 
C5908797(t - 0232) = Ylds(t - 0232) * 0.6750; 
C5908799(t - 0237) = Ylds(t - 0237) * 0.0621; 
C5908805(t - 0194) = Ylds(t - 0194) * 0.0000; 
C5908905(t - 0251) = Ylds(t - 0251) * 0.3609; 
C5908907(t - 0250) = Ylds(t - 0250) * 3.8034; 
C5908909(t - 0257) = Ylds(t - 0257) * 20.4012; 
C5908913(t - 0251) = Ylds(t - 0251) * 18.2772; 
C5908915(t - 0250) = Ylds(t - 0250) * 3.9492; 
C5908917(t - 0258) = Ylds(t - 0258) * 23.4018; 
C5908923(t - 0261) = Ylds(t - 0261) * 2.4588; 
C5908929(t - 0263) = Ylds(t - 0263) * 18.0468; 
C5908931(t - 0263) = Ylds(t - 0263) * 12.1878; 
C5908933(t - 0277) = Ylds(t - 0277) * 12.5901; 
C5908935(t - 0276) = Ylds(t - 0276) * 5.8041; 
C5908945(t - 0251) = Ylds(t - 0251) * 13.0644; 
C5908957(t - 0249) = Ylds(t - 0249) * 14.3136; 
C5908975(t - 0241) = Ylds(t - 0241) * 0.2664; 
C5908985(t - 0248) = Ylds(t - 0248) * 10.8333; 
C5908987(t - 0258) = Ylds(t - 0258) * 21.7629; 
C5908989(t - 0255) = Ylds(t - 0255) * 9.6975; 
C5908991(t - 0257) = Ylds(t - 0257) * 10.7937; 
C5908993(t - 0236) = Ylds(t - 0236) * 6.4818; 
C5908997(t - 0252) = Ylds(t - 0252) * 10.3545; 
C5908999(t - 0271) = Ylds(t - 0271) * 21.9906; 
C5909003(t - 0275) = Ylds(t - 0275) * 8.0874; 
C5909015(t - 0257) = Ylds(t - 0257) * 10.4607; 
C5909023(t - 0272) = Ylds(t - 0272) * 27.5220; 
C5909027(t - 0257) = Ylds(t - 0257) * 11.5857; 
C5909035(t - 0252) = Ylds(t - 0252) * 1.2897; 
C5909037(t - 0266) = Ylds(t - 0266) * 20.8071; 
C5909053(t - 0289) = Ylds(t - 0289) * 8.4573; 
C5909055(t - 0275) = Ylds(t - 0275) * 28.1421; 
C5909059(t - 0272) = Ylds(t - 0272) * 5.9211; 
C5909061(t - 0295) = Ylds(t - 0295) * 37.1430; 
C5909063(t - 0266) = Ylds(t - 0266) * 17.4492; 
C5909069(t - 0280) = Ylds(t - 0280) * 69.8652; 
C5909155(t - 0262) = Ylds(t - 0262) * 5.9382; 
C5909165(t - 0282) = Ylds(t - 0282) * 45.5346; 
C5909167(t - 0279) = Ylds(t - 0279) * 17.5176; 
C5909169(t - 0281) = Ylds(t - 0281) * 27.0180; 
C5909171(t - 0281) = Ylds(t - 0281) * 33.2469; 
C5909173(t - 0299) = Ylds(t - 0299) * 59.4693; 
C5909617(t - 0258) = Ylds(t - 0258) * 1.6488; 
C5909627(t - 0262) = Ylds(t - 0262) * 0.7947; 
C5909633(t - 0258) = Ylds(t - 0258) * 0.9063; 
C5909643(t - 0259) = Ylds(t - 0259) * 1.8297; 
C5909645(t - 0256) = Ylds(t - 0256) * 1.7613; 
C5909651(t - 0259) = Ylds(t - 0259) * 2.5461; 
C5909655(t - 0266) = Ylds(t - 0266) * 1.2654; 
C5909661(t - 0257) = Ylds(t - 0257) * 1.7802; 
C5909663(t - 0266) = Ylds(t - 0266) * 1.1601; 
C5909667(t - 0270) = Ylds(t - 0270) * 1.5885; 
C5909669(t - 0266) = Ylds(t - 0266) * 3.0357; 
C5909695(t - 0269) = Ylds(t - 0269) * 3.1554; 
C5909697(t - 0265) = Ylds(t - 0265) * 3.1437; 
C5909701(t - 0261) = Ylds(t - 0261) * 4.4451; 
C5909703(t - 0263) = Ylds(t - 0263) * 2.6838; 
C5909713(t - 0265) = Ylds(t - 0265) * 0.7695; 
C5909717(t - 0267) = Ylds(t - 0267) * 0.8847; 
C5909721(t - 0266) = Ylds(t - 0266) * 1.1952; 
C5909745(t - 0266) = Ylds(t - 0266) * 0.2439; 
C5909947(t - 0281) = Ylds(t - 0281) * 2.6685; 
C5909957(t - 0284) = Ylds(t - 0284) * 2.5326; 
C5909975(t - 0275) = Ylds(t - 0275) * 1.7865; 
C5909983(t - 0270) = Ylds(t - 0270) * 1.3491; 
C5909989(t - 0284) = Ylds(t - 0284) * 3.8016; 
C5909993(t - 0273) = Ylds(t - 0273) * 0.7137; 
C5910001(t - 0271) = Ylds(t - 0271) * 1.6929; 
C5910005(t - 0271) = Ylds(t - 0271) * 0.9063; 
C5910007(t - 0271) = Ylds(t - 0271) * 1.3599; 
C5910009(t - 0282) = Ylds(t - 0282) * 1.5804; 
C5910011(t - 0266) = Ylds(t - 0266) * 1.9926; 
C5910017(t - 0280) = Ylds(t - 0280) * 1.1907; 
C5910019(t - 0276) = Ylds(t - 0276) * 0.9585; 
C5910025(t - 0275) = Ylds(t - 0275) * 3.2958; 
C5910029(t - 0279) = Ylds(t - 0279) * 2.3967; 
C5910031(t - 0283) = Ylds(t - 0283) * 2.9817; 
C5910033(t - 0278) = Ylds(t - 0278) * 2.0835; 
C5910035(t - 0281) = Ylds(t - 0281) * 0.6453; 
C5910037(t - 0279) = Ylds(t - 0279) * 1.7037; 
C5910039(t - 0271) = Ylds(t - 0271) * 1.6812; 
C5910041(t - 0275) = Ylds(t - 0275) * 2.8638; 
C5910045(t - 0278) = Ylds(t - 0278) * 2.4642; 
C5910049(t - 0281) = Ylds(t - 0281) * 3.3813; 
C5910051(t - 0285) = Ylds(t - 0285) * 2.0907; 
C5910053(t - 0284) = Ylds(t - 0284) * 1.5606; 
C5910055(t - 0272) = Ylds(t - 0272) * 2.3310; 
C5910061(t - 0282) = Ylds(t - 0282) * 3.6675; 
C5910065(t - 0281) = Ylds(t - 0281) * 1.0143; 
C5910067(t - 0281) = Ylds(t - 0281) * 1.7640; 
C5910069(t - 0269) = Ylds(t - 0269) * 1.6056; 
C5910071(t - 0270) = Ylds(t - 0270) * 1.8684; 
C5910079(t - 0273) = Ylds(t - 0273) * 2.8341; 
C5910085(t - 0271) = Ylds(t - 0271) * 2.6253; 
C5910093(t - 0272) = Ylds(t - 0272) * 1.5075; 
C5910097(t - 0271) = Ylds(t - 0271) * 1.0530; 
C5910101(t - 0273) = Ylds(t - 0273) * 1.5381; 
C8440061(t - 0139) = Ylds(t - 0139) * 1.4355; 
C8440063(t - 0140) = Ylds(t - 0140) * 1.3212; 
C8440067(t - 0141) = Ylds(t - 0141) * 1.4193; 
C8440073(t - 0137) = Ylds(t - 0137) * 1.6776; 
C8440077(t - 0139) = Ylds(t - 0139) * 0.7101; 
C8440079(t - 0135) = Ylds(t - 0135) * 0.3420; 
C8440085(t - 0138) = Ylds(t - 0138) * 2.8566; 
C8440087(t - 0135) = Ylds(t - 0135) * 1.2474; 
C8440089(t - 0134) = Ylds(t - 0134) * 1.2843; 
C8440093(t - 0140) = Ylds(t - 0140) * 1.4688; 
C8440099(t - 0139) = Ylds(t - 0139) * 2.8008; 
C8440109(t - 0141) = Ylds(t - 0141) * 1.9224; 
C8440111(t - 0135) = Ylds(t - 0135) * 1.1421; 
C8440121(t - 0136) = Ylds(t - 0136) * 1.2357; 
C8440133(t - 0132) = Ylds(t - 0132) * 0.8865; 
C8440137(t - 0135) = Ylds(t - 0135) * 1.0881; 
C8440139(t - 0137) = Ylds(t - 0137) * 2.8530; 
C8440145(t - 0132) = Ylds(t - 0132) * 0.7227; 
C8440147(t - 0134) = Ylds(t - 0134) * 1.1934; 
C8440149(t - 0130) = Ylds(t - 0130) * 7.7517; 
C8440151(t - 0138) = Ylds(t - 0138) * 1.4607; 
C8440153(t - 0136) = Ylds(t - 0136) * 1.1043; 
C8440161(t - 0133) = Ylds(t - 0133) * 2.7513; 
C8440167(t - 0129) = Ylds(t - 0129) * 6.4458; 
C8440175(t - 0138) = Ylds(t - 0138) * 1.2069; 
C8440185(t - 0139) = Ylds(t - 0139) * 1.1565; 
C8440195(t - 0136) = Ylds(t - 0136) * 1.6209; 
C8440209(t - 0142) = Ylds(t - 0142) * 3.6072; 
C8440213(t - 0134) = Ylds(t - 0134) * 1.2357; 
C8440215(t - 0124) = Ylds(t - 0124) * 0.6768; 
C8440219(t - 0140) = Ylds(t - 0140) * 1.3743; 
C8440221(t - 0138) = Ylds(t - 0138) * 2.4921; 
C8440229(t - 0125) = Ylds(t - 0125) * 1.3932; 
C8440233(t - 0132) = Ylds(t - 0132) * 1.9422; 
C8440235(t - 0127) = Ylds(t - 0127) * 2.6451; 
C8440251(t - 0124) = Ylds(t - 0124) * 1.6056; 
C8440257(t - 0141) = Ylds(t - 0141) * 1.8243; 
C8440259(t - 0120) = Ylds(t - 0120) * 1.3806; 
C8440265(t - 0135) = Ylds(t - 0135) * 1.6128; 
C8440267(t - 0125) = Ylds(t - 0125) * 2.1825; 
C8440271(t - 0141) = Ylds(t - 0141) * 1.7604; 
C8440279(t - 0120) = Ylds(t - 0120) * 2.5722; 
C8440281(t - 0118) = Ylds(t - 0118) * 1.0908; 
C8440287(t - 0121) = Ylds(t - 0121) * 2.2779; 
C8440293(t - 0143) = Ylds(t - 0143) * 2.8701; 
C8440299(t - 0140) = Ylds(t - 0140) * 0.8532; 
C8440301(t - 0131) = Ylds(t - 0131) * 0.1737; 
C8440303(t - 0141) = Ylds(t - 0141) * 0.9639; 
C8440305(t - 0142) = Ylds(t - 0142) * 2.1978; 
C8440319(t - 0126) = Ylds(t - 0126) * 4.9338; 
C8440321(t - 0126) = Ylds(t - 0126) * 1.1214; 
C8440325(t - 0119) = Ylds(t - 0119) * 2.6937; 
C8440345(t - 0126) = Ylds(t - 0126) * 0.6588; 
C8440347(t - 0121) = Ylds(t - 0121) * 1.7766; 
C8440349(t - 0128) = Ylds(t - 0128) * 2.9637; 
C8440351(t - 0153) = Ylds(t - 0153) * 4.2840; 
C8440359(t - 0120) = Ylds(t - 0120) * 0.9234; 
C8440361(t - 0116) = Ylds(t - 0116) * 1.4958; 
C8440369(t - 0109) = Ylds(t - 0109) * 0.7758; 
C8440371(t - 0109) = Ylds(t - 0109) * 1.5354; 
C8440377(t - 0119) = Ylds(t - 0119) * 1.5120; 
C8440381(t - 0108) = Ylds(t - 0108) * 1.0161; 
C8440383(t - 0108) = Ylds(t - 0108) * 1.7091; 
C8440387(t - 0119) = Ylds(t - 0119) * 2.0376; 
C8440407(t - 0116) = Ylds(t - 0116) * 1.6767; 
C8440411(t - 0109) = Ylds(t - 0109) * 2.3886; 
C8440415(t - 0152) = Ylds(t - 0152) * 3.0654; 
C8440419(t - 0112) = Ylds(t - 0112) * 3.5199; 
C8440429(t - 0155) = Ylds(t - 0155) * 1.4094; 
C8440435(t - 0155) = Ylds(t - 0155) * 3.9780; 
C8440437(t - 0156) = Ylds(t - 0156) * 3.1248; 
C8440461(t - 0150) = Ylds(t - 0150) * 1.5210; 
C8440465(t - 0149) = Ylds(t - 0149) * 0.9198; 
C8440467(t - 0148) = Ylds(t - 0148) * 3.3696; 
C8440471(t - 0149) = Ylds(t - 0149) * 2.4183; 
C8440753(t - 0116) = Ylds(t - 0116) * 5.7006; 
C8440757(t - 0116) = Ylds(t - 0116) * 0.0432; 
C8440771(t - 0154) = Ylds(t - 0154) * 0.5895; 
C8440779(t - 0153) = Ylds(t - 0153) * 4.6845; 
C8440785(t - 0156) = Ylds(t - 0156) * 15.3765; 
C8440787(t - 0119) = Ylds(t - 0119) * 7.9083; 
C8440797(t - 0130) = Ylds(t - 0130) * 27.5265; 
C8440799(t - 0128) = Ylds(t - 0128) * 14.3127; 
C8440805(t - 0174) = Ylds(t - 0174) * 19.6515; 
C8440821(t - 0165) = Ylds(t - 0165) * 14.6475; 
C8440833(t - 0122) = Ylds(t - 0122) * 6.9552; 
C8440835(t - 0174) = Ylds(t - 0174) * 0.0477; 
C8440837(t - 0178) = Ylds(t - 0178) * 15.8832; 
C8440851(t - 0123) = Ylds(t - 0123) * 3.0591; 
C8440859(t - 0160) = Ylds(t - 0160) * 5.6736; 
C8440869(t - 0162) = Ylds(t - 0162) * 0.0000; 
C8440871(t - 0177) = Ylds(t - 0177) * 0.0252; 
C8440873(t - 0177) = Ylds(t - 0177) * 3.5955; 
C8440877(t - 0130) = Ylds(t - 0130) * 0.0198; 
C8440917(t - 0136) = Ylds(t - 0136) * 10.7325; 
C8440919(t - 0182) = Ylds(t - 0182) * 8.1162; 
C8440923(t - 0162) = Ylds(t - 0162) * 12.2832; 
C8440929(t - 0187) = Ylds(t - 0187) * 5.3550; 
C8440931(t - 0171) = Ylds(t - 0171) * 15.8274; 
C8440937(t - 0212) = Ylds(t - 0212) * 8.2980; 
C8440939(t - 0210) = Ylds(t - 0210) * 5.2902; 
C8440941(t - 0168) = Ylds(t - 0168) * 23.5773; 
C8440945(t - 0162) = Ylds(t - 0162) * 20.1033; 
C8440949(t - 0155) = Ylds(t - 0155) * 5.4342; 
C8440951(t - 0209) = Ylds(t - 0209) * 20.9034; 
C8440963(t - 0187) = Ylds(t - 0187) * 16.9056; 
C8440981(t - 0174) = Ylds(t - 0174) * 17.3358; 
C8440989(t - 0175) = Ylds(t - 0175) * 5.4387; 
C8440999(t - 0201) = Ylds(t - 0201) * 11.4849; 
C8441003(t - 0148) = Ylds(t - 0148) * 26.2782; 
C8441005(t - 0148) = Ylds(t - 0148) * 7.9812; 
C8441009(t - 0199) = Ylds(t - 0199) * 19.8504; 
C8441013(t - 0196) = Ylds(t - 0196) * 5.4810; 
C8441023(t - 0189) = Ylds(t - 0189) * 13.7133; 
C8441033(t - 0190) = Ylds(t - 0190) * 5.9490; 
C8441051(t - 0190) = Ylds(t - 0190) * 8.6949; 
C8441053(t - 0192) = Ylds(t - 0192) * 24.5286; 
C8441059(t - 0191) = Ylds(t - 0191) * 0.0216; 
C8441063(t - 0193) = Ylds(t - 0193) * 5.1435; 
C8441069(t - 0191) = Ylds(t - 0191) * 11.3436; 
C8441073(t - 0202) = Ylds(t - 0202) * 2.2302; 
C8441079(t - 0205) = Ylds(t - 0205) * 4.1895; 
C8441089(t - 0201) = Ylds(t - 0201) * 37.4643; 
C8441091(t - 0214) = Ylds(t - 0214) * 0.8928; 
C8441259(t - 0140) = Ylds(t - 0140) * 35.5464; 
C8441261(t - 0146) = Ylds(t - 0146) * 24.0993; 
C8441269(t - 0179) = Ylds(t - 0179) * 15.3189; 
C8441281(t - 0183) = Ylds(t - 0183) * 21.4893; 
C8441283(t - 0140) = Ylds(t - 0140) * 8.1729; 
C8441285(t - 0181) = Ylds(t - 0181) * 18.9171; 
C8441289(t - 0202) = Ylds(t - 0202) * 38.8476; 
C8441293(t - 0207) = Ylds(t - 0207) * 41.2578; 
C8441299(t - 0185) = Ylds(t - 0185) * 28.9647; 
C8441301(t - 0185) = Ylds(t - 0185) * 18.6093; 
C8441305(t - 0197) = Ylds(t - 0197) * 15.7653; 
C8441321(t - 0194) = Ylds(t - 0194) * 38.0295; 
C8441343(t - 0122) = Ylds(t - 0122) * 2.3850; 
C8441345(t - 0125) = Ylds(t - 0125) * 0.7398; 
C8441407(t - 0212) = Ylds(t - 0212) * 1.2870; 
C8441411(t - 0212) = Ylds(t - 0212) * 8.2782; 
C8441413(t - 0209) = Ylds(t - 0209) * 1.1898; 
C8441415(t - 0210) = Ylds(t - 0210) * 5.5368; 
C8441425(t - 0212) = Ylds(t - 0212) * 2.6280; 
C8441431(t - 0208) = Ylds(t - 0208) * 2.4057; 
C8441437(t - 0211) = Ylds(t - 0211) * 0.9891; 
C8441447(t - 0213) = Ylds(t - 0213) * 1.3743; 
C8441453(t - 0213) = Ylds(t - 0213) * 2.5029; 
C8441455(t - 0212) = Ylds(t - 0212) * 1.3113; 
C8441457(t - 0213) = Ylds(t - 0213) * 1.7055; 
C8441461(t - 0214) = Ylds(t - 0214) * 1.2528; 
C8441467(t - 0217) = Ylds(t - 0217) * 6.5196; 
C8441471(t - 0205) = Ylds(t - 0205) * 1.3203; 
C8441473(t - 0204) = Ylds(t - 0204) * 1.4337; 
C8441477(t - 0204) = Ylds(t - 0204) * 0.1764; 
C8441479(t - 0204) = Ylds(t - 0204) * 2.3445; 
C8441485(t - 0204) = Ylds(t - 0204) * 1.5687; 
C8441493(t - 0219) = Ylds(t - 0219) * 10.4922; 
C8441501(t - 0206) = Ylds(t - 0206) * 2.7909; 
C8441503(t - 0204) = Ylds(t - 0204) * 1.7748; 
C8441521(t - 0203) = Ylds(t - 0203) * 2.0898; 
C8441523(t - 0206) = Ylds(t - 0206) * 4.1112; 
C8441525(t - 0205) = Ylds(t - 0205) * 0.9927; 
C8441529(t - 0207) = Ylds(t - 0207) * 0.4500; 
C8441535(t - 0206) = Ylds(t - 0206) * 2.1321; 
C8441537(t - 0206) = Ylds(t - 0206) * 0.6516; 
C8441539(t - 0208) = Ylds(t - 0208) * 0.9126; 
C8442057(t - 0209) = Ylds(t - 0209) * 5.7258; 
C8442061(t - 0204) = Ylds(t - 0204) * 4.3443; 
C8442065(t - 0213) = Ylds(t - 0213) * 3.6270; 
C8442069(t - 0215) = Ylds(t - 0215) * 1.5039; 
C8442071(t - 0215) = Ylds(t - 0215) * 5.2164; 
C8442073(t - 0213) = Ylds(t - 0213) * 24.7653; 
C8442091(t - 0213) = Ylds(t - 0213) * 6.0057; 
C8442093(t - 0216) = Ylds(t - 0216) * 10.4031; 
C8444704(t - 0030) = Ylds(t - 0030) * 11.2023; 
C8444706(t - 0023) = Ylds(t - 0023) * 3.7809; 
C8444710(t - 0030) = Ylds(t - 0030) * 11.0826; 
C8444722(t - 0011) = Ylds(t - 0011) * 12.1491; 
C8444730(t - 0009) = Ylds(t - 0009) * 4.6197; 
C8444734(t - 0021) = Ylds(t - 0021) * 5.7807; 
C8444746(t - 0023) = Ylds(t - 0023) * 2.7639; 
C8444768(t - 0029) = Ylds(t - 0029) * 4.6305; 
C8444770(t - 0027) = Ylds(t - 0027) * 1.8711; 
C8444778(t - 0035) = Ylds(t - 0035) * 6.6798; 
C8444780(t - 0029) = Ylds(t - 0029) * 2.3310; 
C8444786(t - 0031) = Ylds(t - 0031) * 2.0979; 
C8444796(t - 0023) = Ylds(t - 0023) * 5.6727; 
C8444798(t - 0038) = Ylds(t - 0038) * 21.8502; 
C8444800(t - 0029) = Ylds(t - 0029) * 5.5359; 
C8444802(t - 0029) = Ylds(t - 0029) * 0.8730; 
C8444806(t - 0030) = Ylds(t - 0030) * 15.0534; 
C8444808(t - 0031) = Ylds(t - 0031) * 1.9521; 
C8444810(t - 0043) = Ylds(t - 0043) * 2.8521; 
C8444812(t - 0032) = Ylds(t - 0032) * 1.3698; 
C8444814(t - 0032) = Ylds(t - 0032) * 4.3173; 
C8444820(t - 0049) = Ylds(t - 0049) * 11.1096; 
C8444822(t - 0047) = Ylds(t - 0047) * 5.6043; 
C8444826(t - 0039) = Ylds(t - 0039) * 2.8881; 
C8444830(t - 0039) = Ylds(t - 0039) * 3.0591; 
C8444832(t - 0031) = Ylds(t - 0031) * 2.9709; 
C8444840(t - 0040) = Ylds(t - 0040) * 4.1364; 
C8444844(t - 0037) = Ylds(t - 0037) * 3.0879; 
C8444846(t - 0039) = Ylds(t - 0039) * 0.9855; 
C8444852(t - 0052) = Ylds(t - 0052) * 2.9034; 
C8444856(t - 0049) = Ylds(t - 0049) * 2.4120; 
C8444860(t - 0040) = Ylds(t - 0040) * 2.4831; 
C8444864(t - 0052) = Ylds(t - 0052) * 9.2979; 
C8444882(t - 0040) = Ylds(t - 0040) * 1.8486; 
C8444884(t - 0041) = Ylds(t - 0041) * 5.4405; 
C8444896(t - 0041) = Ylds(t - 0041) * 3.6333; 
C8444910(t - 0045) = Ylds(t - 0045) * 3.1986; 
C8444916(t - 0043) = Ylds(t - 0043) * 5.8149; 
C8444918(t - 0057) = Ylds(t - 0057) * 1.8315; 
C8444928(t - 0061) = Ylds(t - 0061) * 2.8188; 
C8444930(t - 0062) = Ylds(t - 0062) * 6.2739; 
C8444934(t - 0060) = Ylds(t - 0060) * 2.5497; 
C8444938(t - 0062) = Ylds(t - 0062) * 3.0492; 
C8444942(t - 0070) = Ylds(t - 0070) * 6.2109; 
C8444946(t - 0072) = Ylds(t - 0072) * 4.1625; 
C8444948(t - 0072) = Ylds(t - 0072) * 3.0042; 
C8445006(t - 0035) = Ylds(t - 0035) * 26.6229; 
C8445008(t - 0035) = Ylds(t - 0035) * 13.3389; 
C8445010(t - 0029) = Ylds(t - 0029) * 1.4841; 
C8445012(t - 0019) = Ylds(t - 0019) * 1.7676; 
C8445016(t - 0011) = Ylds(t - 0011) * 7.4106; 
C8445380(t - 0061) = Ylds(t - 0061) * 4.0086; 
C8445384(t - 0060) = Ylds(t - 0060) * 0.0000; 
C8445386(t - 0057) = Ylds(t - 0057) * 1.3734; 
C8445390(t - 0061) = Ylds(t - 0061) * 2.2779; 
C8445392(t - 0075) = Ylds(t - 0075) * 2.4318; 
C8445394(t - 0075) = Ylds(t - 0075) * 1.8648; 
C8445396(t - 0074) = Ylds(t - 0074) * 3.3363; 
C8445400(t - 0073) = Ylds(t - 0073) * 0.7668; 
C8445412(t - 0056) = Ylds(t - 0056) * 4.7637; 
C8445418(t - 0072) = Ylds(t - 0072) * 2.7432; 
C8445422(t - 0073) = Ylds(t - 0073) * 2.3013; 
C8445430(t - 0066) = Ylds(t - 0066) * 1.1988; 
C8445440(t - 0113) = Ylds(t - 0113) * 1.6398; 
C8445442(t - 0074) = Ylds(t - 0074) * 4.2957; 
C8445444(t - 0113) = Ylds(t - 0113) * 0.6993; 
C8445446(t - 0113) = Ylds(t - 0113) * 2.0016; 
C8445448(t - 0068) = Ylds(t - 0068) * 4.6287; 
C8445452(t - 0114) = Ylds(t - 0114) * 2.4795; 
C8445458(t - 0092) = Ylds(t - 0092) * 3.6927; 
C8445460(t - 0092) = Ylds(t - 0092) * 2.6424; 
C8445462(t - 0079) = Ylds(t - 0079) * 2.2842; 
C8445464(t - 0072) = Ylds(t - 0072) * 7.8102; 
C8445470(t - 0110) = Ylds(t - 0110) * 4.9365; 
C8445472(t - 0078) = Ylds(t - 0078) * 1.8036; 
C8445478(t - 0106) = Ylds(t - 0106) * 1.2852; 
C8445484(t - 0108) = Ylds(t - 0108) * 2.2203; 
C8445486(t - 0105) = Ylds(t - 0105) * 1.0683; 
C8445492(t - 0108) = Ylds(t - 0108) * 8.5320; 
C8445496(t - 0083) = Ylds(t - 0083) * 3.3543; 
C8445498(t - 0107) = Ylds(t - 0107) * 2.4120; 
C8445500(t - 0087) = Ylds(t - 0087) * 1.4913; 
C8445506(t - 0106) = Ylds(t - 0106) * 1.1763; 
C8445508(t - 0077) = Ylds(t - 0077) * 1.6965; 
C8445518(t - 0111) = Ylds(t - 0111) * 6.9849; 
C8445528(t - 0076) = Ylds(t - 0076) * 1.7523; 
C8445530(t - 0077) = Ylds(t - 0077) * 1.1187; 
C8445532(t - 0077) = Ylds(t - 0077) * 0.6840; 
C8445536(t - 0076) = Ylds(t - 0076) * 0.8064; 
C8445538(t - 0076) = Ylds(t - 0076) * 3.3318; 
C8445548(t - 0106) = Ylds(t - 0106) * 2.5254; 
C8445550(t - 0105) = Ylds(t - 0105) * 1.9152; 
C8445552(t - 0095) = Ylds(t - 0095) * 4.5882; 
C8445638(t - 0115) = Ylds(t - 0115) * 4.6827; 
C8445640(t - 0112) = Ylds(t - 0112) * 0.0576; 
C8446252(t - 0082) = Ylds(t - 0082) * 14.7681; 
C8446256(t - 0098) = Ylds(t - 0098) * 0.1071; 
C8446270(t - 0086) = Ylds(t - 0086) * 13.5081; 
C8446286(t - 0096) = Ylds(t - 0096) * 8.9451; 
C8446288(t - 0096) = Ylds(t - 0096) * 4.3893; 
C24808921(t - 0205) = Ylds(t - 0205) * 0.7092; 
C24808935(t - 0139) = Ylds(t - 0139) * 0.2979; 
C932070100(t - 0102) = Ylds(t - 0102) * 7.5186; 
C5906765(t - 0102) = Ylds(t - 0102) * 4.2543 + C5907201(t - 0103); 
C5906769(t - 0115) = Ylds(t - 0115) * 1.8027 + C5906763(t - 0118); 
C5906797(t - 0111) = Ylds(t - 0111) * 7.0200 + C5906809(t - 0119) + C5906813(t - 0117); 
C5906805(t - 0114) = Ylds(t - 0114) * 0.3087 + C5906807(t - 0117) + C5907053(t - 0119); 
C5906841(t - 0162) = Ylds(t - 0162) * 6.9822 + C5906839(t - 0164); 
C5906843(t - 0163) = Ylds(t - 0163) * 29.3472 + C5907203(t - 0164); 
C5906847(t - 0163) = Ylds(t - 0163) * 8.1954 + C5906845(t - 0167) + C5906851(t - 0167); 
C5906857(t - 0167) = Ylds(t - 0167) * 39.2760 + C5906875(t - 0173) + C5906881(t - 0175); 
C5906871(t - 0175) = Ylds(t - 0175) * 2.0826 + C5906859(t - 0180) + C5906861(t - 0176); 
C5907073(t - 0099) = Ylds(t - 0099) * 0.0018 + C5907045(t - 0107); 
C5907129(t - 0131) = Ylds(t - 0131) * 0.0018 + C5906817(t - 0136); 
C5907135(t - 0135) = Ylds(t - 0135) * 0.0027 + C5907055(t - 0138); 
C5907151(t - 0140) = Ylds(t - 0140) * 0.0000 + C5907057(t - 0154); 
C5907165(t - 0158) = Ylds(t - 0158) * 0.0018 + C5907059(t - 0169); 
C5907173(t - 0164) = Ylds(t - 0164) * 0.0000 + C5906883(t - 0175); 
C5907179(t - 0165) = Ylds(t - 0165) * 0.0135 + C5906879(t - 0172); 
C5907285(t - 0269) = Ylds(t - 0269) * 1.1961 + C5907283(t - 0271); 
C5907293(t - 0270) = Ylds(t - 0270) * 2.1816 + C5907289(t - 0271); 
C5907301(t - 0265) = Ylds(t - 0265) * 0.3726 + C5907291(t - 0266); 
C5907307(t - 0264) = Ylds(t - 0264) * 0.8505 + C5907309(t - 0265); 
C5907321(t - 0261) = Ylds(t - 0261) * 0.8955 + C5907311(t - 0262); 
C5907331(t - 0264) = Ylds(t - 0264) * 1.4715 + C5907325(t - 0265); 
C5907333(t - 0259) = Ylds(t - 0259) * 3.4785 + C5907319(t - 0260); 
C5907335(t - 0259) = Ylds(t - 0259) * 1.0026 + C5907313(t - 0260); 
C5907345(t - 0259) = Ylds(t - 0259) * 1.7442 + C5907329(t - 0260); 
C5907347(t - 0258) = Ylds(t - 0258) * 1.0872 + C5907327(t - 0259); 
C5907365(t - 0258) = Ylds(t - 0258) * 2.1924 + C5907339(t - 0259); 
C5907369(t - 0268) = Ylds(t - 0268) * 0.9018 + C5907351(t - 0269); 
C5907377(t - 0266) = Ylds(t - 0266) * 2.1960 + C5907389(t - 0267); 
C5907383(t - 0255) = Ylds(t - 0255) * 0.3483 + C5907375(t - 0257); 
C5907385(t - 0259) = Ylds(t - 0259) * 5.0823 + C5907469(t - 0260); 
C5907397(t - 0254) = Ylds(t - 0254) * 0.6237 + C5907379(t - 0255); 
C5907401(t - 0254) = Ylds(t - 0254) * 1.5201 + C5907391(t - 0256); 
C5907403(t - 0254) = Ylds(t - 0254) * 0.5760 + C5907399(t - 0255); 
C5907407(t - 0269) = Ylds(t - 0269) * 2.1222 + C5907423(t - 0270); 
C5907413(t - 0254) = Ylds(t - 0254) * 0.8892 + C5907405(t - 0255); 
C5907415(t - 0255) = Ylds(t - 0255) * 3.3804 + C5907471(t - 0257); 
C5907417(t - 0271) = Ylds(t - 0271) * 8.8596 + C5907435(t - 0272); 
C5907443(t - 0258) = Ylds(t - 0258) * 1.6110 + C5907429(t - 0259); 
C5907445(t - 0258) = Ylds(t - 0258) * 0.8361 + C5907441(t - 0259); 
C5907447(t - 0254) = Ylds(t - 0254) * 0.6543 + C5907431(t - 0257) + C5907433(t - 0256); 
C5907453(t - 0258) = Ylds(t - 0258) * 1.6641 + C5907473(t - 0259); 
C5907457(t - 0273) = Ylds(t - 0273) * 5.6142 + C5907281(t - 0274); 
C5907459(t - 0270) = Ylds(t - 0270) * 6.1002 + C5907455(t - 0271); 
C5907483(t - 0264) = Ylds(t - 0264) * 0.0153 + C5907359(t - 0266); 
C5908035(t - 0196) = Ylds(t - 0196) * 1.0746 + C5906885(t - 0197); 
C5908043(t - 0181) = Ylds(t - 0181) * 3.1392 + C5908057(t - 0183); 
C5908045(t - 0193) = Ylds(t - 0193) * 2.9574 + C5906889(t - 0194); 
C5908047(t - 0188) = Ylds(t - 0188) * 2.1726 + C5908041(t - 0189); 
C5908051(t - 0250) = Ylds(t - 0250) * 0.3960 + C5908905(t - 0251); 
C5908067(t - 0249) = Ylds(t - 0249) * 1.4769 + C5908907(t - 0250); 
C5908075(t - 0184) = Ylds(t - 0184) * 4.7691 + C5908063(t - 0185); 
C5908085(t - 0251) = Ylds(t - 0251) * 19.2159 + C5906897(t - 0257); 
C5908093(t - 0186) = Ylds(t - 0186) * 5.3469 + C5908095(t - 0187); 
C5908097(t - 0194) = Ylds(t - 0194) * 4.0941 + C5908111(t - 0196); 
C5908107(t - 0194) = Ylds(t - 0194) * 0.7083 + C5908117(t - 0195); 
C5908119(t - 0191) = Ylds(t - 0191) * 7.1118 + C5908581(t - 0193); 
C5908131(t - 0192) = Ylds(t - 0192) * 2.6595 + C5908149(t - 0193); 
C5908147(t - 0192) = Ylds(t - 0192) * 7.5663 + C5908145(t - 0195); 
C5908151(t - 0209) = Ylds(t - 0209) * 2.1177 + C5908139(t - 0211); 
C5908165(t - 0196) = Ylds(t - 0196) * 13.4262 + C5908167(t - 0197); 
C5908173(t - 0196) = Ylds(t - 0196) * 4.0761 + C5908181(t - 0198); 
C5908193(t - 0195) = Ylds(t - 0195) * 2.3445 + C5908191(t - 0198); 
C5908199(t - 0194) = Ylds(t - 0194) * 0.9027 + C5908219(t - 0197); 
C5908203(t - 0200) = Ylds(t - 0200) * 4.0725 + C5908183(t - 0201); 
C5908205(t - 0250) = Ylds(t - 0250) * 41.8491 + C5908113(t - 0255); 
C5908207(t - 0249) = Ylds(t - 0249) * 44.1630 + C5908103(t - 0254); 
C5908211(t - 0195) = Ylds(t - 0195) * 5.7033 + C5908227(t - 0197); 
C5908213(t - 0194) = Ylds(t - 0194) * 1.9917 + C5908225(t - 0195); 
C5908229(t - 0195) = Ylds(t - 0195) * 2.0844 + C5908249(t - 0197); 
C5908237(t - 0239) = Ylds(t - 0239) * 14.7312 + C5908195(t - 0242); 
C5908247(t - 0201) = Ylds(t - 0201) * 7.6905 + C5908267(t - 0203); 
C5908259(t - 0240) = Ylds(t - 0240) * 5.8743 + C5908975(t - 0241); 
C5908269(t - 0204) = Ylds(t - 0204) * 7.1217 + C5908287(t - 0205); 
C5908271(t - 0199) = Ylds(t - 0199) * 18.4608 + C5908315(t - 0201); 
C5908273(t - 0217) = Ylds(t - 0217) * 5.6025 + C5908257(t - 0220); 
C5908275(t - 0204) = Ylds(t - 0204) * 2.3436 + C5908309(t - 0205); 
C5908279(t - 0203) = Ylds(t - 0203) * 0.8334 + C5908295(t - 0204); 
C5908293(t - 0232) = Ylds(t - 0232) * 9.6318 + C5908993(t - 0236); 
C5908305(t - 0209) = Ylds(t - 0209) * 0.9360 + C5908329(t - 0211); 
C5908313(t - 0228) = Ylds(t - 0228) * 0.9315 + C5908317(t - 0230); 
C5908337(t - 0230) = Ylds(t - 0230) * 11.4120 + C5908339(t - 0231) + C5908349(t - 0232); 
C5908347(t - 0210) = Ylds(t - 0210) * 12.1374 + C5908351(t - 0211); 
C5908353(t - 0232) = Ylds(t - 0232) * 11.3121 + C5908357(t - 0233); 
C5908361(t - 0223) = Ylds(t - 0223) * 4.8852 + C5908359(t - 0228) + C5908605(t - 0229); 
C5908373(t - 0224) = Ylds(t - 0224) * 3.8988 + C5908371(t - 0225); 
C5908397(t - 0231) = Ylds(t - 0231) * 12.8556 + C5908607(t - 0233); 
C5908399(t - 0231) = Ylds(t - 0231) * 2.3859 + C5908797(t - 0232); 
C5908429(t - 0242) = Ylds(t - 0242) * 12.9060 + C5908445(t - 0246) + C5908471(t - 0250); 
C5908447(t - 0238) = Ylds(t - 0238) * 9.2232 + C5908449(t - 0239); 
C5908451(t - 0251) = Ylds(t - 0251) * 9.6714 + C5909035(t - 0252); 
C5908455(t - 0236) = Ylds(t - 0236) * 4.3929 + C5908799(t - 0237); 
C5908457(t - 0235) = Ylds(t - 0235) * 2.9565 + C5908477(t - 0242); 
C5908489(t - 0242) = Ylds(t - 0242) * 1.3545 + C5908503(t - 0245) * 1/2; 
C5908491(t - 0243) = Ylds(t - 0243) * 0.0000 + C5908503(t - 0245) * 1/2; 
C5908495(t - 0241) = Ylds(t - 0241) * 4.5162 + C5908507(t - 0242); 
C5908499(t - 0261) = Ylds(t - 0261) * 5.1543 + C5908497(t - 0264) + C5908501(t - 0262); 
C5908511(t - 0248) = Ylds(t - 0248) * 12.1176 + C5908515(t - 0249) + C5908517(t - 0249); 
C5908579(t - 0192) = Ylds(t - 0192) * 6.0867 + C5908071(t - 0193); 
C5908587(t - 0213) = Ylds(t - 0213) * 37.9539 + C5908583(t - 0220); 
C5908597(t - 0219) = Ylds(t - 0219) * 0.6417 + C5908363(t - 0220) + C5908367(t - 0221); 
C5908615(t - 0180) = Ylds(t - 0180) * 0.0000 + C5908049(t - 0185); 
C5908625(t - 0184) = Ylds(t - 0184) * 0.0018 + C5908115(t - 0188); 
C5908641(t - 0188) = Ylds(t - 0188) * 0.0018 + C5908177(t - 0189); 
C5908645(t - 0196) = Ylds(t - 0196) * 0.3330 + C5908161(t - 0198); 
C5908673(t - 0228) = Ylds(t - 0228) * 0.1746 + C5908175(t - 0230); 
C5908735(t - 0228) = Ylds(t - 0228) * 0.0063 + C5908263(t - 0234); 
C5908745(t - 0227) = Ylds(t - 0227) * 0.0000 + C5908265(t - 0231); 
C5908749(t - 0209) = Ylds(t - 0209) * 0.0018 + C5908591(t - 0216); 
C5908787(t - 0246) = Ylds(t - 0246) * 0.8622 + C5908529(t - 0250); 
C5908789(t - 0255) = Ylds(t - 0255) * 0.0054 + C5908533(t - 0257); 
C5908813(t - 0176) = Ylds(t - 0176) * 0.0981 + C5906891(t - 0179); 
C5908815(t - 0194) = Ylds(t - 0194) * 1.3194 + C5906887(t - 0196); 
C5908925(t - 0246) = Ylds(t - 0246) * 19.7910 + C5908913(t - 0251) + C5908915(t - 0250); 
C5908939(t - 0259) = Ylds(t - 0259) * 10.5939 + C5908929(t - 0263) + C5908931(t - 0263); 
C5908949(t - 0246) = Ylds(t - 0246) * 0.1278 + C5908957(t - 0249); 
C5908953(t - 0259) = Ylds(t - 0259) * 8.0793 + C5908923(t - 0261); 
C5908959(t - 0259) = Ylds(t - 0259) * 4.0140 + C5909155(t - 0262); 
C5908977(t - 0253) = Ylds(t - 0253) * 4.0500 + C5908991(t - 0257); 
C5908995(t - 0249) = Ylds(t - 0249) * 15.6087 + C5908997(t - 0252); 
C5909005(t - 0272) = Ylds(t - 0272) * 11.2716 + C5909165(t - 0282) + C5909167(t - 0279); 
C5909011(t - 0272) = Ylds(t - 0272) * 6.2280 + C5909003(t - 0275); 
C5909019(t - 0272) = Ylds(t - 0272) * 2.8836 + C5909169(t - 0281) + C5909171(t - 0281); 
C5909041(t - 0285) = Ylds(t - 0285) * 28.8207 + C5909053(t - 0289); 
C5909051(t - 0269) = Ylds(t - 0269) * 4.3587 + C5909059(t - 0272); 
C5909057(t - 0263) = Ylds(t - 0263) * 4.1688 + C5909063(t - 0266); 
C5909157(t - 0272) = Ylds(t - 0272) * 42.7707 + C5908933(t - 0277) + C5908935(t - 0276); 
C5909175(t - 0253) = Ylds(t - 0253) * 1.1367 + C5908909(t - 0257); 
C5909177(t - 0253) = Ylds(t - 0253) * 0.9270 + C5908917(t - 0258); 
C5909187(t - 0286) = Ylds(t - 0286) * 4.9392 + C5909173(t - 0299); 
C5909199(t - 0259) = Ylds(t - 0259) * 17.0676 + C5909037(t - 0266); 
C5909615(t - 0257) = Ylds(t - 0257) * 0.2763 + C5909617(t - 0258) + C5909633(t - 0258); 
C5909623(t - 0257) = Ylds(t - 0257) * 0.1197 + C5909643(t - 0259); 
C5909639(t - 0263) = Ylds(t - 0263) * 1.3302 + C5909655(t - 0266) + C5909695(t - 0269); 
C5909641(t - 0265) = Ylds(t - 0265) * 0.4779 + C5909745(t - 0266); 
C5909653(t - 0256) = Ylds(t - 0256) * 1.4661 + C5909651(t - 0259); 
C5909665(t - 0265) = Ylds(t - 0265) * 0.1359 + C5909669(t - 0266); 
C5909679(t - 0263) = Ylds(t - 0263) * 2.5875 + C5909697(t - 0265); 
C5909689(t - 0259) = Ylds(t - 0259) * 1.5597 + C5909701(t - 0261); 
C5909715(t - 0265) = Ylds(t - 0265) * 0.1251 + C5909717(t - 0267) + C5909721(t - 0266); 
C5909743(t - 0269) = Ylds(t - 0269) * 0.0900 + C5909667(t - 0270); 
C5909951(t - 0271) = Ylds(t - 0271) * 0.0162 + C5909993(t - 0273) + C5910025(t - 0275); 
C5909955(t - 0269) = Ylds(t - 0269) * 0.6588 + C5910001(t - 0271) + C5910005(t - 0271); 
C5909967(t - 0282) = Ylds(t - 0282) * 2.1411 + C5909957(t - 0284); 
C5909971(t - 0264) = Ylds(t - 0264) * 0.0891 + C5910011(t - 0266) * 1/2; 
C5909979(t - 0270) = Ylds(t - 0270) * 0.4815 + C5910011(t - 0266) * 1/2; 
C5909985(t - 0277) = Ylds(t - 0277) * 0.8325 + C5910029(t - 0279) + C5910037(t - 0279); 
C5909987(t - 0280) = Ylds(t - 0280) * 3.4389 + C5909989(t - 0284) + C5910009(t - 0282); 
C5909995(t - 0278) = Ylds(t - 0278) * 0.5796 + C5910035(t - 0281) + C5910049(t - 0281); 
C5909997(t - 0274) = Ylds(t - 0274) * 1.4139 + C5910019(t - 0276) + C5910033(t - 0278); 
C5910013(t - 0281) = Ylds(t - 0281) * 4.1364 + C5910031(t - 0283); 
C5910015(t - 0274) = Ylds(t - 0274) * 3.6675 + C5910041(t - 0275); 
C5910021(t - 0282) = Ylds(t - 0282) * 3.5289 + C5910051(t - 0285) + C5910053(t - 0284); 
C5910023(t - 0270) = Ylds(t - 0270) * 3.0978 + C5910039(t - 0271); 
C5910047(t - 0271) = Ylds(t - 0271) * 4.0338 + C5910055(t - 0272); 
C5910057(t - 0279) = Ylds(t - 0279) * 0.7380 + C5910065(t - 0281) + C5910067(t - 0281); 
C5910063(t - 0269) = Ylds(t - 0269) * 6.9435 + C5910071(t - 0270); 
C5910075(t - 0271) = Ylds(t - 0271) * 3.9024 + C5910079(t - 0273); 
C5910091(t - 0270) = Ylds(t - 0270) * 1.9080 + C5910097(t - 0271); 
C5910095(t - 0271) = Ylds(t - 0271) * 1.1628 + C5910093(t - 0272); 
C5910099(t - 0272) = Ylds(t - 0272) * 0.8496 + C5910101(t - 0273); 
C5910143(t - 0277) = Ylds(t - 0277) * 0.0036 + C5910017(t - 0280); 
C5910159(t - 0279) = Ylds(t - 0279) * 0.0027 + C5910061(t - 0282); 
C8440065(t - 0139) = Ylds(t - 0139) * 2.1411 + C8440067(t - 0141); 
C8440069(t - 0138) = Ylds(t - 0138) * 0.5760 + C8440061(t - 0139); 
C8440075(t - 0138) = Ylds(t - 0138) * 1.0791 + C24808935(t - 0139); 
C8440091(t - 0138) = Ylds(t - 0138) * 0.3096 + C8440077(t - 0139); 
C8440095(t - 0135) = Ylds(t - 0135) * 3.2526 + C8440073(t - 0137); 
C8440103(t - 0138) = Ylds(t - 0138) * 0.6750 + C8440109(t - 0141); 
C8440113(t - 0133) = Ylds(t - 0133) * 0.6642 + C8440087(t - 0135); 
C8440115(t - 0133) = Ylds(t - 0133) * 0.1323 + C8440111(t - 0135); 
C8440117(t - 0136) = Ylds(t - 0136) * 0.5823 + C8440139(t - 0137); 
C8440119(t - 0136) = Ylds(t - 0136) * 0.8892 + C8440085(t - 0138); 
C8440123(t - 0132) = Ylds(t - 0132) * 0.6633 + C8440089(t - 0134); 
C8440157(t - 0133) = Ylds(t - 0133) * 2.0223 + C8440147(t - 0134); 
C8440159(t - 0135) = Ylds(t - 0135) * 0.8793 + C8440153(t - 0136); 
C8440165(t - 0137) = Ylds(t - 0137) * 3.1401 + C8440151(t - 0138); 
C8440181(t - 0131) = Ylds(t - 0131) * 3.8376 + C8440133(t - 0132); 
C8440191(t - 0131) = Ylds(t - 0131) * 2.5632 + C8440145(t - 0132); 
C8440201(t - 0141) = Ylds(t - 0141) * 5.4225 + C8440209(t - 0142); 
C8440217(t - 0123) = Ylds(t - 0123) * 0.2502 + C8440215(t - 0124); 
C8440227(t - 0129) = Ylds(t - 0129) * 11.4156 + C8440149(t - 0130); 
C8440237(t - 0123) = Ylds(t - 0123) * 0.7317 + C8440229(t - 0125); 
C8440239(t - 0139) = Ylds(t - 0139) * 2.8584 + C8440219(t - 0140); 
C8440253(t - 0124) = Ylds(t - 0124) * 1.2528 + C8440267(t - 0125); 
C8440269(t - 0140) = Ylds(t - 0140) * 1.1583 + C8440271(t - 0141); 
C8440283(t - 0126) = Ylds(t - 0126) * 12.1680 + C8440167(t - 0129); 
C8440291(t - 0140) = Ylds(t - 0140) * 0.1314 + C8440293(t - 0143) + C8440305(t - 0142); 
C8440295(t - 0130) = Ylds(t - 0130) * 0.7875 + C8440301(t - 0131) * 1/2; 
C8440297(t - 0139) = Ylds(t - 0139) * 0.9360 + C8440301(t - 0131) * 1/2; 
C8440307(t - 0117) = Ylds(t - 0117) * 1.7604 + C8440281(t - 0118); 
C8440309(t - 0119) = Ylds(t - 0119) * 2.1051 + C8440259(t - 0120); 
C8440337(t - 0125) = Ylds(t - 0125) * 0.3717 + C8440321(t - 0126); 
C8440339(t - 0120) = Ylds(t - 0120) * 5.0490 + C8440347(t - 0121); 
C8440341(t - 0148) = Ylds(t - 0148) * 0.2871 + C8440461(t - 0150); 
C8440343(t - 0125) = Ylds(t - 0125) * 0.6687 + C8440345(t - 0126); 
C8440375(t - 0146) = Ylds(t - 0146) * 0.9162 + C8440471(t - 0149); 
C8440379(t - 0115) = Ylds(t - 0115) * 4.5081 + C8440361(t - 0116); 
C8440385(t - 0117) = Ylds(t - 0117) * 0.5661 + C8440377(t - 0119); 
C8440391(t - 0107) = Ylds(t - 0107) * 2.1897 + C8440369(t - 0109) + C8440371(t - 0109); 
C8440393(t - 0118) = Ylds(t - 0118) * 1.8981 + C8440359(t - 0120); 
C8440397(t - 0106) = Ylds(t - 0106) * 0.8172 + C8440381(t - 0108) + C8440383(t - 0108); 
C8440439(t - 0153) = Ylds(t - 0153) * 0.1170 + C8440429(t - 0155) + C8440437(t - 0156); 
C8440463(t - 0152) = Ylds(t - 0152) * 25.0623 + C8440351(t - 0153); 
C8440477(t - 0133) = Ylds(t - 0133) * 0.2907 + C8440137(t - 0135); 
C8440485(t - 0148) = Ylds(t - 0148) * 0.1332 + C8440415(t - 0152); 
C8440773(t - 0153) = Ylds(t - 0153) * 10.9935 + C8440771(t - 0154) + C8440785(t - 0156); 
C8440803(t - 0120) = Ylds(t - 0120) * 0.4662 + C8440797(t - 0130) + C8440799(t - 0128); 
C8440819(t - 0121) = Ylds(t - 0121) * 7.8696 + C8441343(t - 0122); 
C8440823(t - 0158) = Ylds(t - 0158) * 10.0035 + C8440821(t - 0165) * 1/2; 
C8440825(t - 0158) = Ylds(t - 0158) * 0.1683 + C8440821(t - 0165) * 1/2; 
C8440853(t - 0120) = Ylds(t - 0120) * 1.7424 + C8440851(t - 0123); 
C8440897(t - 0124) = Ylds(t - 0124) * 0.0342 + C8441345(t - 0125); 
C8440909(t - 0129) = Ylds(t - 0129) * 2.6082 + C8440877(t - 0130) + C8440917(t - 0136); 
C8440953(t - 0208) = Ylds(t - 0208) * 7.6293 + C8440937(t - 0212) + C8440939(t - 0210); 
C8440975(t - 0207) = Ylds(t - 0207) * 3.0375 + C8441411(t - 0212); 
C8440983(t - 0174) = Ylds(t - 0174) * 36.0027 + C8441285(t - 0181) + C8441299(t - 0185); 
C8440993(t - 0173) = Ylds(t - 0173) * 11.8197 + C8440989(t - 0175); 
C8441001(t - 0178) = Ylds(t - 0178) * 29.9079 + C8441301(t - 0185); 
C8441065(t - 0190) = Ylds(t - 0190) * 1.1628 + C8441059(t - 0191) + C8441063(t - 0193); 
C8441085(t - 0201) = Ylds(t - 0201) * 16.4304 + C8441073(t - 0202); 
C8441103(t - 0200) = Ylds(t - 0200) * 0.1431 + C8442061(t - 0204); 
C8441263(t - 0173) = Ylds(t - 0173) * 1.8657 + C8440835(t - 0174) + C8440837(t - 0178); 
C8441265(t - 0176) = Ylds(t - 0176) * 9.9189 + C8440871(t - 0177) + C8440873(t - 0177); 
C8441297(t - 0141) = Ylds(t - 0141) * 20.5920 + C8441003(t - 0148) + C8441005(t - 0148); 
C8441307(t - 0191) = Ylds(t - 0191) * 10.8549 + C8441289(t - 0202) + C8441305(t - 0197); 
C8441315(t - 0182) = Ylds(t - 0182) * 1.9611 + C8441321(t - 0194); 
C8441333(t - 0168) = Ylds(t - 0168) * 0.2556 + C8440805(t - 0174); 
C8441335(t - 0182) = Ylds(t - 0182) * 6.6042 + C8440929(t - 0187); 
C8441337(t - 0183) = Ylds(t - 0183) * 1.8288 + C8440963(t - 0187); 
C8441341(t - 0203) = Ylds(t - 0203) * 0.0261 + C8441079(t - 0205); 
C8441351(t - 0115) = Ylds(t - 0115) * 7.7067 + C8440753(t - 0116) + C8440757(t - 0116); 
C8441353(t - 0109) = Ylds(t - 0109) * 3.2193 + C8440419(t - 0112); 
C8441409(t - 0211) = Ylds(t - 0211) * 6.1416 + C8441407(t - 0212); 
C8441419(t - 0207) = Ylds(t - 0207) * 1.3041 + C8441413(t - 0209); 
C8441423(t - 0207) = Ylds(t - 0207) * 1.1709 + C8441431(t - 0208); 
C8441435(t - 0210) = Ylds(t - 0210) * 1.7172 + C8441437(t - 0211); 
C8441441(t - 0212) = Ylds(t - 0212) * 0.5580 + C8441453(t - 0213); 
C8441443(t - 0212) = Ylds(t - 0212) * 0.7578 + C8441457(t - 0213); 
C8441449(t - 0211) = Ylds(t - 0211) * 0.9396 + C8441455(t - 0212); 
C8441451(t - 0212) = Ylds(t - 0212) * 1.4625 + C8441447(t - 0213); 
C8441463(t - 0213) = Ylds(t - 0213) * 0.6552 + C8441461(t - 0214); 
C8441469(t - 0215) = Ylds(t - 0215) * 2.5695 + C8441467(t - 0217); 
C8441475(t - 0204) = Ylds(t - 0204) * 0.5841 + C8441471(t - 0205); 
C8441483(t - 0203) = Ylds(t - 0203) * 2.0277 + C8441473(t - 0204); 
C8441489(t - 0203) = Ylds(t - 0203) * 3.4398 + C8441477(t - 0204) + C8441479(t - 0204); 
C8441491(t - 0202) = Ylds(t - 0202) * 4.6530 + C8441485(t - 0204); 
C8441507(t - 0203) = Ylds(t - 0203) * 0.0711 + C8441503(t - 0204); 
C8441509(t - 0205) = Ylds(t - 0205) * 2.1375 + C8441501(t - 0206); 
C8441513(t - 0204) = Ylds(t - 0204) * 2.5407 + C8441523(t - 0206); 
C8441515(t - 0202) = Ylds(t - 0202) * 1.0242 + C8441521(t - 0203); 
C8441531(t - 0205) = Ylds(t - 0205) * 2.4480 + C8441535(t - 0206); 
C8441533(t - 0205) = Ylds(t - 0205) * 1.2492 + C8441537(t - 0206); 
C8441541(t - 0207) = Ylds(t - 0207) * 6.0633 + C8441539(t - 0208); 
C8441545(t - 0206) = Ylds(t - 0206) * 9.5247 + C8441529(t - 0207); 
C8441547(t - 0204) = Ylds(t - 0204) * 3.3408 + C8441525(t - 0205); 
C8442051(t - 0213) = Ylds(t - 0213) * 0.7569 + C8441091(t - 0214); 
C8442055(t - 0207) = Ylds(t - 0207) * 0.9891 + C8442057(t - 0209) + C8442073(t - 0213); 
C8442059(t - 0211) = Ylds(t - 0211) * 1.8054 + C8442071(t - 0215) + C8442093(t - 0216); 
C8442063(t - 0214) = Ylds(t - 0214) * 2.3652 + C8442069(t - 0215); 
C8442067(t - 0204) = Ylds(t - 0204) * 6.2568 + C24808921(t - 0205); 
C8444708(t - 0023) = Ylds(t - 0023) * 2.5200 + C8444704(t - 0030) + C8444710(t - 0030); 
C8444748(t - 0027) = Ylds(t - 0027) * 2.0952 + C8445008(t - 0035) + C8445010(t - 0029); 
C8444782(t - 0020) = Ylds(t - 0020) * 2.1222 + C8444796(t - 0023); 
C8444784(t - 0026) = Ylds(t - 0026) * 1.3707 + C8444780(t - 0029); 
C8444788(t - 0031) = Ylds(t - 0031) * 13.2120 + C8444778(t - 0035); 
C8444804(t - 0027) = Ylds(t - 0027) * 1.6560 + C8444802(t - 0029) + C8444806(t - 0030); 
C8444818(t - 0041) = Ylds(t - 0041) * 3.8133 + C8444810(t - 0043); 
C8444836(t - 0035) = Ylds(t - 0035) * 2.7108 + C8444844(t - 0037); 
C8444838(t - 0055) = Ylds(t - 0055) * 2.2419 + C8445386(t - 0057); 
C8444848(t - 0038) = Ylds(t - 0038) * 0.2790 + C8444860(t - 0040); 
C8444854(t - 0044) = Ylds(t - 0044) * 7.6257 + C8444820(t - 0049) + C8444822(t - 0047); 
C8444866(t - 0038) = Ylds(t - 0038) * 0.6273 + C8444882(t - 0040) + C8444884(t - 0041); 
C8444870(t - 0039) = Ylds(t - 0039) * 1.4121 + C8444896(t - 0041) + C8444916(t - 0043); 
C8444912(t - 0058) = Ylds(t - 0058) * 0.7308 + C8444930(t - 0062); 
C8444922(t - 0058) = Ylds(t - 0058) * 0.0198 + C8444938(t - 0062); 
C8444936(t - 0067) = Ylds(t - 0067) * 1.9134 + C8444942(t - 0070); 
C8444944(t - 0070) = Ylds(t - 0070) * 1.7208 + C8444946(t - 0072); 
C8445076(t - 0004) = Ylds(t - 0004) * 0.0261 + C8444722(t - 0011); 
C8445078(t - 0007) = Ylds(t - 0007) * 0.0027 + C8444730(t - 0009); 
C8445094(t - 0008) = Ylds(t - 0008) * 0.0306 + C8445016(t - 0011); 
C8445104(t - 0020) = Ylds(t - 0020) * 0.0225 + C8444746(t - 0023); 
C8445140(t - 0026) = Ylds(t - 0026) * 0.0045 + C8444800(t - 0029); 
C8445146(t - 0028) = Ylds(t - 0028) * 0.0000 + C8444808(t - 0031); 
C8445150(t - 0028) = Ylds(t - 0028) * 0.0171 + C8444814(t - 0032); 
C8445156(t - 0030) = Ylds(t - 0030) * 0.0018 + C8444812(t - 0032); 
C8445158(t - 0029) = Ylds(t - 0029) * 0.2592 + C8444832(t - 0031); 
C8445206(t - 0041) = Ylds(t - 0041) * 0.0027 + C8444910(t - 0045); 
C8445210(t - 0045) = Ylds(t - 0045) * 0.0126 + C8444864(t - 0052); 
C8445214(t - 0046) = Ylds(t - 0046) * 0.0090 + C8444856(t - 0049); 
C8445382(t - 0060) = Ylds(t - 0060) * 0.0612 + C8445380(t - 0061); 
C8445404(t - 0072) = Ylds(t - 0072) * 2.8395 + C8445392(t - 0075) + C8445394(t - 0075); 
C8445406(t - 0072) = Ylds(t - 0072) * 1.9566 + C8445396(t - 0074); 
C8445414(t - 0072) = Ylds(t - 0072) * 5.9148 + C8445400(t - 0073); 
C8445428(t - 0071) = Ylds(t - 0071) * 2.7855 + C8445442(t - 0074); 
C8445432(t - 0064) = Ylds(t - 0064) * 0.0135 + C8445430(t - 0066); 
C8445450(t - 0111) = Ylds(t - 0111) * 0.8325 + C8445440(t - 0113); 
C8445454(t - 0112) = Ylds(t - 0112) * 1.2384 + C8445444(t - 0113) + C8445446(t - 0113); 
C8445456(t - 0111) = Ylds(t - 0111) * 1.4247 + C8445640(t - 0112); 
C8445466(t - 0078) = Ylds(t - 0078) * 2.5209 + C8445462(t - 0079); 
C8445480(t - 0105) = Ylds(t - 0105) * 0.8541 + C8445470(t - 0110); 
C8445494(t - 0105) = Ylds(t - 0105) * 0.0711 + C8445484(t - 0108); 
C8445502(t - 0114) = Ylds(t - 0114) * 15.8742 + C8445638(t - 0115); 
C8445504(t - 0089) = Ylds(t - 0089) * 10.4112 + C8445458(t - 0092) + C8445460(t - 0092); 
C8445510(t - 0075) = Ylds(t - 0075) * 0.4077 + C8445530(t - 0077) + C8445532(t - 0077); 
C8445514(t - 0074) = Ylds(t - 0074) * 0.0441 + C8445528(t - 0076); 
C8445526(t - 0075) = Ylds(t - 0075) * 0.1206 + C8445538(t - 0076); 
C8445540(t - 0078) = Ylds(t - 0078) * 0.7902 + C8446252(t - 0082); 
C8445560(t - 0102) = Ylds(t - 0102) * 0.0693 + C8445548(t - 0106) + C8445550(t - 0105); 
C8445586(t - 0105) = Ylds(t - 0105) * 6.2208 + C8445498(t - 0107); 
C8445596(t - 0081) = Ylds(t - 0081) * 0.3978 + C8445496(t - 0083); 
C8445630(t - 0068) = Ylds(t - 0068) * 0.0027 + C8445464(t - 0072); 
C8445642(t - 0075) = Ylds(t - 0075) * 0.0000 + C8445508(t - 0077); 
C8446248(t - 0092) = Ylds(t - 0092) * 0.1521 + C8445552(t - 0095); 
C8446278(t - 0093) = Ylds(t - 0093) * 25.1874 + C8446286(t - 0096) + C8446288(t - 0096); 
C8446502(t - 0081) = Ylds(t - 0081) * 0.0009 + C8446270(t - 0086); 
C932070026(t - 0260) = Ylds(t - 0260) * 0.0054 + C5909703(t - 0263); 
C5906833(t - 0158) = Ylds(t - 0158) * 19.6812 + C5906835(t - 0163) + C5906841(t - 0162); 
C5906837(t - 0158) = Ylds(t - 0158) * 9.8172 + C5906863(t - 0169) + C5906857(t - 0167); 
C5906895(t - 0179) = Ylds(t - 0179) * 14.4369 + C5908043(t - 0181); 
C5907047(t - 0100) = Ylds(t - 0100) * 23.7510 + C5906799(t - 0105) + C5906765(t - 0102); 
C5907049(t - 0113) = Ylds(t - 0113) * 26.5311 + C5907051(t - 0119) + C5906805(t - 0114); 
C5907085(t - 0113) = Ylds(t - 0113) * 0.0027 + C5906769(t - 0115); 
C5907095(t - 0108) = Ylds(t - 0108) * 0.0054 + C5906797(t - 0111); 
C5907163(t - 0157) = Ylds(t - 0157) * 0.0054 + C5907165(t - 0158); 
C5907169(t - 0160) = Ylds(t - 0160) * 0.0009 + C5906847(t - 0163); 
C5907295(t - 0268) = Ylds(t - 0268) * 0.0207 + C5907293(t - 0270) + C5907457(t - 0273); 
C5907341(t - 0257) = Ylds(t - 0257) * 0.1152 + C5907333(t - 0259) + C5907335(t - 0259); 
C5907353(t - 0257) = Ylds(t - 0257) * 3.0357 + C5907355(t - 0259) + C5907385(t - 0259); 
C5907363(t - 0257) = Ylds(t - 0257) * 3.4938 + C5907345(t - 0259) + C5907347(t - 0258); 
C5907367(t - 0267) = Ylds(t - 0267) * 0.2025 + C5907369(t - 0268) + C5907417(t - 0271); 
C5907387(t - 0267) = Ylds(t - 0267) * 1.3581 + C5907425(t - 0271) + C5907407(t - 0269); 
C5907395(t - 0254) = Ylds(t - 0254) * 2.2464 + C5907381(t - 0256) + C5907383(t - 0255); 
C5907409(t - 0253) = Ylds(t - 0253) * 0.4212 + C5907401(t - 0254) + C5907403(t - 0254); 
C5907461(t - 0268) = Ylds(t - 0268) * 1.8657 + C5907287(t - 0272) + C5907285(t - 0269); 
C5907475(t - 0257) = Ylds(t - 0257) * 0.9324 + C5907443(t - 0258) + C5907445(t - 0258); 
C5907479(t - 0263) = Ylds(t - 0263) * 0.0666 + C5907331(t - 0264); 
C5908033(t - 0175) = Ylds(t - 0175) * 0.5229 + C5908813(t - 0176); 
C5908037(t - 0195) = Ylds(t - 0195) * 1.1295 + C5908035(t - 0196); 
C5908059(t - 0180) = Ylds(t - 0180) * 0.9405 + C5908061(t - 0184) + C5908075(t - 0184); 
C5908081(t - 0185) = Ylds(t - 0185) * 2.1672 + C5908053(t - 0188) + C5908047(t - 0188); 
C5908121(t - 0187) = Ylds(t - 0187) * 0.1746 + C5908133(t - 0192) + C5908165(t - 0196); 
C5908123(t - 0190) = Ylds(t - 0190) * 7.6122 + C5908119(t - 0191) + C5908131(t - 0192); 
C5908137(t - 0193) = Ylds(t - 0193) * 8.4582 + C5908097(t - 0194) + C5908107(t - 0194); 
C5908163(t - 0195) = Ylds(t - 0195) * 9.9513 + C5908645(t - 0196); 
C5908179(t - 0193) = Ylds(t - 0193) * 1.5552 + C5908201(t - 0197) + C5908199(t - 0194); 
C5908209(t - 0196) = Ylds(t - 0196) * 2.2284 + C5908245(t - 0200) + C5908247(t - 0201); 
C5908217(t - 0193) = Ylds(t - 0193) * 6.8184 + C5908229(t - 0195) + C5908271(t - 0199); 
C5908233(t - 0234) = Ylds(t - 0234) * 2.9889 + C5908251(t - 0240) + C5908259(t - 0240); 
C5908235(t - 0236) = Ylds(t - 0236) * 6.7617 + C5908205(t - 0250) + C5908207(t - 0249); 
C5908243(t - 0202) = Ylds(t - 0202) * 4.2129 + C5908585(t - 0208) + C5908587(t - 0213); 
C5908261(t - 0202) = Ylds(t - 0202) * 2.9385 + C5908275(t - 0204) + C5908279(t - 0203); 
C5908281(t - 0215) = Ylds(t - 0215) * 1.1691 + C5908277(t - 0220) + C5908273(t - 0217); 
C5908311(t - 0227) = Ylds(t - 0227) * 2.2311 + C5908313(t - 0228) + C5908337(t - 0230); 
C5908321(t - 0207) = Ylds(t - 0207) * 10.6875 + C5908325(t - 0209) + C5908347(t - 0210); 
C5908387(t - 0228) = Ylds(t - 0228) * 7.2630 + C5908431(t - 0237) + C5908399(t - 0231); 
C5908479(t - 0238) = Ylds(t - 0238) * 1.0944 + C5908481(t - 0244) + C5908495(t - 0241); 
C5908513(t - 0245) = Ylds(t - 0245) * 7.6275 + C5908787(t - 0246); 
C5908575(t - 0193) = Ylds(t - 0193) * 4.7610 + C5908805(t - 0194) + C5908815(t - 0194); 
C5908589(t - 0208) = Ylds(t - 0208) * 1.3392 + C5908333(t - 0212) + C5908305(t - 0209); 
C5908593(t - 0218) = Ylds(t - 0218) * 10.4310 + C5908595(t - 0221) + C5908597(t - 0219); 
C5908647(t - 0208) = Ylds(t - 0208) * 0.2961 + C5908151(t - 0209); 
C5908665(t - 0191) = Ylds(t - 0191) * 0.0000 + C5908213(t - 0194); 
C5908675(t - 0227) = Ylds(t - 0227) * 0.0387 + C5908673(t - 0228); 
C5908679(t - 0195) = Ylds(t - 0195) * 0.0009 + C5908203(t - 0200); 
C5908687(t - 0198) = Ylds(t - 0198) * 0.0000 + C5908269(t - 0204); 
C5908715(t - 0231) = Ylds(t - 0231) * 0.0009 + C5908237(t - 0239); 
C5908781(t - 0226) = Ylds(t - 0226) * 0.0027 + C5908397(t - 0231); 
C5908791(t - 0254) = Ylds(t - 0254) * 0.4113 + C5908789(t - 0255); 
C5908807(t - 0193) = Ylds(t - 0193) * 0.0009 + C5908193(t - 0195); 
C5908811(t - 0183) = Ylds(t - 0183) * 0.0027 + C5908093(t - 0186); 
C5908897(t - 0253) = Ylds(t - 0253) * 1.2177 + C5907447(t - 0254); 
C5908901(t - 0256) = Ylds(t - 0256) * 0.0252 + C5907453(t - 0258); 
C5908919(t - 0252) = Ylds(t - 0252) * 6.1668 + C5909175(t - 0253); 
C5908921(t - 0252) = Ylds(t - 0252) * 18.3357 + C5909177(t - 0253); 
C5908951(t - 0245) = Ylds(t - 0245) * 9.8433 + C5908945(t - 0251) + C5908949(t - 0246); 
C5908967(t - 0241) = Ylds(t - 0241) * 3.2112 + C5908985(t - 0248) + C5908995(t - 0249); 
C5908973(t - 0249) = Ylds(t - 0249) * 16.2126 + C5908989(t - 0255) + C5908977(t - 0253); 
C5909009(t - 0268) = Ylds(t - 0268) * 3.6261 + C5909005(t - 0272) + C5909011(t - 0272); 
C5909031(t - 0285) = Ylds(t - 0285) * 9.2349 + C5909187(t - 0286); 
C5909033(t - 0258) = Ylds(t - 0258) * 15.3441 + C5909199(t - 0259); 
C5909043(t - 0259) = Ylds(t - 0259) * 4.9932 + C5908499(t - 0261); 
C5909047(t - 0266) = Ylds(t - 0266) * 9.5391 + C5909055(t - 0275) + C5909051(t - 0269); 
C5909179(t - 0257) = Ylds(t - 0257) * 0.3834 + C5908939(t - 0259); 
C5909181(t - 0258) = Ylds(t - 0258) * 0.1233 + C5908959(t - 0259); 
C5909185(t - 0264) = Ylds(t - 0264) * 1.7028 + C5909157(t - 0272); 
C5909203(t - 0266) = Ylds(t - 0266) * 0.6939 + C5910023(t - 0270); 
C5909207(t - 0270) = Ylds(t - 0270) * 2.4714 + C5910015(t - 0274); 
C5909659(t - 0268) = Ylds(t - 0268) * 0.0036 + C5909743(t - 0269); 
C5909675(t - 0264) = Ylds(t - 0264) * 1.4922 + C5909663(t - 0266) + C5909665(t - 0265); 
C5909737(t - 0256) = Ylds(t - 0256) * 0.8622 + C5909623(t - 0257); 
C5909747(t - 0264) = Ylds(t - 0264) * 0.0045 + C5909641(t - 0265); 
C5909941(t - 0279) = Ylds(t - 0279) * 0.0945 + C5909947(t - 0281) + C5909967(t - 0282); 
C5909945(t - 0268) = Ylds(t - 0268) * 0.1926 + C5910007(t - 0271) + C5909955(t - 0269); 
C5909949(t - 0270) = Ylds(t - 0270) * 0.8919 + C5909951(t - 0271); 
C5909953(t - 0277) = Ylds(t - 0277) * 0.8667 + C5909987(t - 0280) + C5910013(t - 0281); 
C5909961(t - 0263) = Ylds(t - 0263) * 1.1628 + C5909971(t - 0264) + C5910063(t - 0269); 
C5910059(t - 0267) = Ylds(t - 0267) * 0.9720 + C5910069(t - 0269) + C5910075(t - 0271); 
C5910081(t - 0269) = Ylds(t - 0269) * 1.0827 + C5910085(t - 0271) + C5910095(t - 0271); 
C5910141(t - 0276) = Ylds(t - 0276) * 0.0567 + C5909985(t - 0277); 
C5910145(t - 0277) = Ylds(t - 0277) * 0.0189 + C5909995(t - 0278); 
C5910147(t - 0268) = Ylds(t - 0268) * 0.2952 + C5910047(t - 0271); 
C5910149(t - 0278) = Ylds(t - 0278) * 1.0602 + C5910021(t - 0282); 
C5910155(t - 0278) = Ylds(t - 0278) * 0.0036 + C5910057(t - 0279); 
C5910157(t - 0278) = Ylds(t - 0278) * 0.9162 + C5910159(t - 0279); 
C5910165(t - 0269) = Ylds(t - 0269) * 0.1629 + C5910091(t - 0270); 
C5910167(t - 0271) = Ylds(t - 0271) * 0.0666 + C5910099(t - 0272); 
C5911299(t - 0256) = Ylds(t - 0256) * 0.1161 + C5909615(t - 0257); 
C5911309(t - 0261) = Ylds(t - 0261) * 0.0018 + C5909639(t - 0263); 
C8440071(t - 0138) = Ylds(t - 0138) * 0.0144 + C8440063(t - 0140) + C8440065(t - 0139); 
C8440101(t - 0137) = Ylds(t - 0137) * 0.0522 + C8440093(t - 0140) + C8440091(t - 0138); 
C8440125(t - 0132) = Ylds(t - 0132) * 1.0881 + C8440113(t - 0133) + C8440115(t - 0133); 
C8440127(t - 0134) = Ylds(t - 0134) * 0.0315 + C8440121(t - 0136) + C8440119(t - 0136); 
C8440135(t - 0132) = Ylds(t - 0132) * 0.0270 + C8440477(t - 0133); 
C8440155(t - 0135) = Ylds(t - 0135) * 2.6694 + C8440117(t - 0136); 
C8440179(t - 0137) = Ylds(t - 0137) * 0.2196 + C8440185(t - 0139) + C8440201(t - 0141); 
C8440255(t - 0139) = Ylds(t - 0139) * 3.5874 + C8440257(t - 0141) + C8440269(t - 0140); 
C8440277(t - 0129) = Ylds(t - 0129) * 10.8333 + C8440295(t - 0130); 
C8440315(t - 0117) = Ylds(t - 0117) * 1.9323 + C8440279(t - 0120) + C8440283(t - 0126); 
C8440323(t - 0122) = Ylds(t - 0122) * 5.2965 + C8440235(t - 0127) + C8440237(t - 0123); 
C8440329(t - 0115) = Ylds(t - 0115) * 0.7236 + C8440307(t - 0117) + C8440309(t - 0119); 
C8440335(t - 0124) = Ylds(t - 0124) * 1.3779 + C8440337(t - 0125) + C8440343(t - 0125); 
C8440353(t - 0147) = Ylds(t - 0147) * 1.4058 + C8440465(t - 0149) + C8440341(t - 0148); 
C8440395(t - 0116) = Ylds(t - 0116) * 0.1314 + C8440387(t - 0119) + C8440385(t - 0117); 
C8440401(t - 0105) = Ylds(t - 0105) * 0.0423 + C8440391(t - 0107) + C8440397(t - 0106); 
C8440473(t - 0136) = Ylds(t - 0136) * 0.8613 + C8440075(t - 0138); 
C8440479(t - 0134) = Ylds(t - 0134) * 0.1575 + C8440159(t - 0135); 
C8440827(t - 0167) = Ylds(t - 0167) * 7.7994 + C8441333(t - 0168); 
C8440857(t - 0157) = Ylds(t - 0157) * 8.4042 + C8440823(t - 0158) + C8440825(t - 0158); 
C8440935(t - 0181) = Ylds(t - 0181) * 0.0702 + C8441335(t - 0182); 
C8440947(t - 0182) = Ylds(t - 0182) * 10.3761 + C8441337(t - 0183); 
C8440969(t - 0137) = Ylds(t - 0137) * 54.1422 + C8441283(t - 0140) + C8441297(t - 0141); 
C8440971(t - 0204) = Ylds(t - 0204) * 4.3362 + C8440951(t - 0209) + C8440953(t - 0208); 
C8441075(t - 0204) = Ylds(t - 0204) * 6.4539 + C8441541(t - 0207); 
C8441099(t - 0206) = Ylds(t - 0206) * 11.3958 + C8442055(t - 0207); 
C8441101(t - 0200) = Ylds(t - 0200) * 0.0459 + C8442067(t - 0204); 
C8441251(t - 0150) = Ylds(t - 0150) * 10.3419 + C8440779(t - 0153) + C8440773(t - 0153); 
C8441287(t - 0167) = Ylds(t - 0167) * 19.2231 + C8440981(t - 0174) + C8440983(t - 0174); 
C8441339(t - 0202) = Ylds(t - 0202) * 0.3177 + C8441341(t - 0203); 
C8441361(t - 0152) = Ylds(t - 0152) * 0.8235 + C8440439(t - 0153); 
C8441433(t - 0211) = Ylds(t - 0211) * 2.1816 + C8441441(t - 0212) + C8441443(t - 0212); 
C8441465(t - 0213) = Ylds(t - 0213) * 0.4194 + C8441493(t - 0219) + C8441469(t - 0215); 
C8441511(t - 0203) = Ylds(t - 0203) * 0.7605 + C8441509(t - 0205) + C8441513(t - 0204); 
C8441519(t - 0201) = Ylds(t - 0201) * 1.4940 + C8441515(t - 0202) + C8441547(t - 0204); 
C8441527(t - 0204) = Ylds(t - 0204) * 3.7008 + C8441531(t - 0205) + C8441533(t - 0205); 
C8441549(t - 0208) = Ylds(t - 0208) * 0.0180 + C8441409(t - 0211); 
C8441551(t - 0203) = Ylds(t - 0203) * 1.1457 + C8441475(t - 0204); 
C8442049(t - 0212) = Ylds(t - 0212) * 7.1613 + C8442051(t - 0213) + C8442063(t - 0214); 
C8442053(t - 0209) = Ylds(t - 0209) * 0.7695 + C8442091(t - 0213) + C8442059(t - 0211); 
C8444732(t - 0021) = Ylds(t - 0021) * 6.2073 + C8444706(t - 0023) + C8444708(t - 0023); 
C8444766(t - 0026) = Ylds(t - 0026) * 0.8253 + C8445006(t - 0035) + C8444748(t - 0027); 
C8444790(t - 0027) = Ylds(t - 0027) * 0.0063 + C8444786(t - 0031) + C8444788(t - 0031); 
C8444824(t - 0037) = Ylds(t - 0037) * 0.3321 + C8444830(t - 0039) + C8444818(t - 0041); 
C8444842(t - 0037) = Ylds(t - 0037) * 2.3850 + C8444846(t - 0039) + C8444848(t - 0038); 
C8444850(t - 0052) = Ylds(t - 0052) * 1.2375 + C8444838(t - 0055); 
C8444914(t - 0057) = Ylds(t - 0057) * 1.4094 + C8444928(t - 0061) + C8444912(t - 0058); 
C8444920(t - 0057) = Ylds(t - 0057) * 4.4892 + C8444934(t - 0060) + C8444922(t - 0058); 
C8444940(t - 0069) = Ylds(t - 0069) * 2.5146 + C8444948(t - 0072) + C8444944(t - 0070); 
C8445082(t - 0006) = Ylds(t - 0006) * 0.0378 + C8445078(t - 0007); 
C8445126(t - 0019) = Ylds(t - 0019) * 2.6073 + C8444782(t - 0020); 
C8445136(t - 0026) = Ylds(t - 0026) * 0.0000 + C8444804(t - 0027); 
C8445144(t - 0027) = Ylds(t - 0027) * 0.0054 + C8445146(t - 0028); 
C8445172(t - 0034) = Ylds(t - 0034) * 0.0027 + C8444836(t - 0035); 
C8445188(t - 0037) = Ylds(t - 0037) * 0.0000 + C8444866(t - 0038); 
C8445194(t - 0038) = Ylds(t - 0038) * 0.0000 + C8444870(t - 0039); 
C8445198(t - 0038) = Ylds(t - 0038) * 0.0018 + C8444854(t - 0044); 
C8445274(t - 0065) = Ylds(t - 0065) * 0.0036 + C8444936(t - 0067); 
C8445388(t - 0059) = Ylds(t - 0059) * 0.7479 + C8445384(t - 0060) + C8445382(t - 0060); 
C8445420(t - 0069) = Ylds(t - 0069) * 0.2196 + C8445422(t - 0073) + C8445428(t - 0071); 
C8445424(t - 0069) = Ylds(t - 0069) * 7.2351 + C8445404(t - 0072) + C8445406(t - 0072); 
C8445476(t - 0110) = Ylds(t - 0110) * 4.2354 + C8445452(t - 0114) + C8445450(t - 0111); 
C8445488(t - 0104) = Ylds(t - 0104) * 0.5013 + C8445478(t - 0106) + C8445480(t - 0105); 
C8445490(t - 0076) = Ylds(t - 0076) * 6.8472 + C8445472(t - 0078) + C8445466(t - 0078); 
C8445520(t - 0074) = Ylds(t - 0074) * 0.5058 + C8445536(t - 0076) + C8445526(t - 0075); 
C8445522(t - 0104) = Ylds(t - 0104) * 0.8541 + C8445506(t - 0106) + C8445502(t - 0114); 
C8445534(t - 0080) = Ylds(t - 0080) * 4.2075 + C8445596(t - 0081); 
C8445542(t - 0084) = Ylds(t - 0084) * 5.2398 + C8445500(t - 0087) + C8445504(t - 0089); 
C8445544(t - 0104) = Ylds(t - 0104) * 4.3740 + C8445492(t - 0108) + C8445494(t - 0105); 
C8445590(t - 0110) = Ylds(t - 0110) * 0.9027 + C8445456(t - 0111); 
C8445592(t - 0111) = Ylds(t - 0111) * 1.5588 + C8445454(t - 0112); 
C8445598(t - 0077) = Ylds(t - 0077) * 0.0099 + C8445540(t - 0078); 
C8445636(t - 0074) = Ylds(t - 0074) * 0.0000 + C8445510(t - 0075); 
C8446260(t - 0091) = Ylds(t - 0091) * 13.1301 + C8446248(t - 0092); 
C8446516(t - 0085) = Ylds(t - 0085) * 0.0000 + C8446278(t - 0093); 
C8446528(t - 0101) = Ylds(t - 0101) * 0.1449 + C8445560(t - 0102); 
C932070068(t - 0206) = Ylds(t - 0206) * 5.0616 + C8441423(t - 0207); 
C5906831(t - 0155) = Ylds(t - 0155) * 6.8067 + C5906843(t - 0163) + C5906837(t - 0158); 
C5906867(t - 0173) = Ylds(t - 0173) * 0.5454 + C5906871(t - 0175) + C5906895(t - 0179); 
C5906893(t - 0174) = Ylds(t - 0174) * 4.6872 + C5908033(t - 0175); 
C5907063(t - 0094) = Ylds(t - 0094) * 0.0027 + C5907047(t - 0100); 
C5907205(t - 0107) = Ylds(t - 0107) * 0.0000 + C5907049(t - 0113); 
C5907297(t - 0266) = Ylds(t - 0266) * 0.0180 + C5907459(t - 0270) + C5907461(t - 0268); 
C5907361(t - 0266) = Ylds(t - 0266) * 0.5625 + C5907367(t - 0267) + C5907387(t - 0267); 
C5907371(t - 0255) = Ylds(t - 0255) * 0.0387 + C5907365(t - 0258) + C5907363(t - 0257); 
C5907419(t - 0253) = Ylds(t - 0253) * 3.2400 + C5907397(t - 0254) + C5907395(t - 0254); 
C5907427(t - 0252) = Ylds(t - 0252) * 1.0701 + C5907415(t - 0255) + C5907409(t - 0253); 
C5907463(t - 0267) = Ylds(t - 0267) * 3.3651 + C5907303(t - 0271) + C5907295(t - 0268); 
C5908039(t - 0194) = Ylds(t - 0194) * 0.4122 + C5908037(t - 0195); 
C5908069(t - 0191) = Ylds(t - 0191) * 4.0095 + C5908045(t - 0193) + C5908575(t - 0193); 
C5908135(t - 0188) = Ylds(t - 0188) * 2.1600 + C5908147(t - 0192) + C5908137(t - 0193); 
C5908171(t - 0192) = Ylds(t - 0192) * 1.1439 + C5908173(t - 0196) + C5908179(t - 0193); 
C5908197(t - 0226) = Ylds(t - 0226) * 1.5462 + C5908675(t - 0227); 
C5908215(t - 0238) = Ylds(t - 0238) * 7.8777 + C5908967(t - 0241); 
C5908223(t - 0207) = Ylds(t - 0207) * 11.6181 + C5908647(t - 0208); 
C5908297(t - 0226) = Ylds(t - 0226) * 6.0075 + C5908293(t - 0232) + C5908311(t - 0227); 
C5908535(t - 0253) = Ylds(t - 0253) * 0.2205 + C5908791(t - 0254); 
C5908549(t - 0255) = Ylds(t - 0255) * 1.6155 + C5911299(t - 0256); 
C5908555(t - 0260) = Ylds(t - 0260) * 2.0124 + C5911309(t - 0261); 
C5908613(t - 0179) = Ylds(t - 0179) * 0.0009 + C5908059(t - 0180); 
C5908633(t - 0186) = Ylds(t - 0186) * 0.0000 + C5908121(t - 0187); 
C5908653(t - 0189) = Ylds(t - 0189) * 0.0027 + C5908217(t - 0193); 
C5908663(t - 0190) = Ylds(t - 0190) * 0.0000 + C5908665(t - 0191); 
C5908671(t - 0194) = Ylds(t - 0194) * 0.0036 + C5908209(t - 0196); 
C5908685(t - 0197) = Ylds(t - 0197) * 0.0000 + C5908687(t - 0198); 
C5908697(t - 0199) = Ylds(t - 0199) * 0.0000 + C5908261(t - 0202); 
C5908701(t - 0200) = Ylds(t - 0200) * 0.0063 + C5908243(t - 0202); 
C5908703(t - 0201) = Ylds(t - 0201) * 0.0198 + C5908321(t - 0207); 
C5908713(t - 0233) = Ylds(t - 0233) * 0.0180 + C5908233(t - 0234); 
C5908719(t - 0232) = Ylds(t - 0232) * 0.0000 + C5908235(t - 0236); 
C5908721(t - 0206) = Ylds(t - 0206) * 0.0000 + C5908589(t - 0208); 
C5908755(t - 0214) = Ylds(t - 0214) * 0.0000 + C5908281(t - 0215); 
C5908767(t - 0211) = Ylds(t - 0211) * 0.0000 + C5908593(t - 0218); 
C5908779(t - 0225) = Ylds(t - 0225) * 0.4599 + C5908781(t - 0226); 
C5908903(t - 0256) = Ylds(t - 0256) * 3.1131 + C5907475(t - 0257); 
C5908927(t - 0248) = Ylds(t - 0248) * 14.6178 + C5908919(t - 0252) + C5908921(t - 0252); 
C5908955(t - 0256) = Ylds(t - 0256) * 0.7695 + C5909179(t - 0257); 
C5908965(t - 0257) = Ylds(t - 0257) * 7.5546 + C5909181(t - 0258); 
C5908983(t - 0263) = Ylds(t - 0263) * 2.9565 + C5909185(t - 0264); 
C5909025(t - 0252) = Ylds(t - 0252) * 1.1106 + C5909027(t - 0257) + C5909033(t - 0258); 
C5909029(t - 0282) = Ylds(t - 0282) * 12.8970 + C5909061(t - 0295) + C5909031(t - 0285); 
C5909049(t - 0261) = Ylds(t - 0261) * 2.6712 + C5909069(t - 0280) + C5909047(t - 0266); 
C5909075(t - 0269) = Ylds(t - 0269) * 2.6397 + C5909949(t - 0270); 
C5909619(t - 0255) = Ylds(t - 0255) * 0.4311 + C5909737(t - 0256); 
C5909677(t - 0262) = Ylds(t - 0262) * 0.0576 + C5909679(t - 0263) + C5909675(t - 0264); 
C5909723(t - 0270) = Ylds(t - 0270) * 1.2888 + C5910167(t - 0271); 
C5909741(t - 0267) = Ylds(t - 0267) * 0.0873 + C5909659(t - 0268); 
C5909939(t - 0267) = Ylds(t - 0267) * 0.1107 + C5909983(t - 0270) + C5909945(t - 0268); 
C5909969(t - 0277) = Ylds(t - 0277) * 1.2051 + C5910149(t - 0278); 
C5909999(t - 0267) = Ylds(t - 0267) * 0.2133 + C5910147(t - 0268); 
C5910089(t - 0268) = Ylds(t - 0268) * 0.1386 + C5910165(t - 0269); 
C5910139(t - 0276) = Ylds(t - 0276) * 0.0054 + C5910143(t - 0277) + C5910145(t - 0277); 
C5910151(t - 0266) = Ylds(t - 0266) * 0.6876 + C5910059(t - 0267); 
C5910153(t - 0277) = Ylds(t - 0277) * 0.1782 + C5910155(t - 0278) + C5910157(t - 0278); 
C5910163(t - 0268) = Ylds(t - 0268) * 0.3096 + C5910081(t - 0269); 
C8440081(t - 0135) = Ylds(t - 0135) * 0.4968 + C8440473(t - 0136); 
C8440083(t - 0137) = Ylds(t - 0137) * 2.1987 + C8440069(t - 0138) + C8440071(t - 0138); 
C8440107(t - 0136) = Ylds(t - 0136) * 1.3500 + C8440099(t - 0139) + C8440103(t - 0138) + C8440101(t - 0137); 
C8440143(t - 0131) = Ylds(t - 0131) * 0.5832 + C8440123(t - 0132) + C8440125(t - 0132); 
C8440163(t - 0131) = Ylds(t - 0131) * 0.4383 + C8440157(t - 0133) + C8440155(t - 0135); 
C8440173(t - 0136) = Ylds(t - 0136) * 0.3231 + C8440175(t - 0138) + C8440179(t - 0137); 
C8440183(t - 0133) = Ylds(t - 0133) * 0.8361 + C8440479(t - 0134); 
C8440231(t - 0122) = Ylds(t - 0122) * 0.3267 + C8440217(t - 0123) + C8440277(t - 0129); 
C8440243(t - 0136) = Ylds(t - 0136) * 1.1115 + C8440239(t - 0139) + C8440255(t - 0139); 
C8440327(t - 0123) = Ylds(t - 0123) * 0.3645 + C8440349(t - 0128) + C8440335(t - 0124); 
C8440355(t - 0116) = Ylds(t - 0116) * 5.5953 + C8440325(t - 0119) + C8440323(t - 0122); 
C8440363(t - 0145) = Ylds(t - 0145) * 0.4284 + C8440467(t - 0148) + C8440353(t - 0147); 
C8440405(t - 0115) = Ylds(t - 0115) * 0.0828 + C8440393(t - 0118) + C8440395(t - 0116); 
C8440751(t - 0104) = Ylds(t - 0104) * 1.7757 + C8440401(t - 0105); 
C8440899(t - 0154) = Ylds(t - 0154) * 13.9149 + C8440859(t - 0160) + C8440857(t - 0157); 
C8440911(t - 0125) = Ylds(t - 0125) * 6.1686 + C8440909(t - 0129) + C8440969(t - 0137); 
C8440933(t - 0180) = Ylds(t - 0180) * 4.2066 + C8440935(t - 0181) + C8440947(t - 0182); 
C8440965(t - 0207) = Ylds(t - 0207) * 2.3355 + C8441549(t - 0208); 
C8441049(t - 0202) = Ylds(t - 0202) * 16.2666 + C8441527(t - 0204); 
C8441071(t - 0201) = Ylds(t - 0201) * 1.6425 + C8441339(t - 0202); 
C8441087(t - 0205) = Ylds(t - 0205) * 13.6998 + C8441099(t - 0206); 
C8441095(t - 0208) = Ylds(t - 0208) * 0.0261 + C8442053(t - 0209); 
C8441097(t - 0199) = Ylds(t - 0199) * 41.2128 + C8441103(t - 0200) + C8441101(t - 0200); 
C8441359(t - 0151) = Ylds(t - 0151) * 0.0252 + C8440435(t - 0155) + C8441361(t - 0152); 
C8441429(t - 0210) = Ylds(t - 0210) * 1.5759 + C8441425(t - 0212) + C8441433(t - 0211); 
C8441459(t - 0212) = Ylds(t - 0212) * 2.1240 + C8441463(t - 0213) + C8441465(t - 0213); 
C8441481(t - 0202) = Ylds(t - 0202) * 0.0171 + C8441551(t - 0203); 
C8441505(t - 0202) = Ylds(t - 0202) * 2.9493 + C8441507(t - 0203) + C8441511(t - 0203); 
C8441517(t - 0200) = Ylds(t - 0200) * 4.3587 + C8441545(t - 0206) + C8441519(t - 0201); 
C8442047(t - 0209) = Ylds(t - 0209) * 0.0324 + C8442065(t - 0213) + C8442049(t - 0212); 
C8444744(t - 0017) = Ylds(t - 0017) * 2.0394 + C8444734(t - 0021) + C8444732(t - 0021); 
C8444772(t - 0025) = Ylds(t - 0025) * 0.6480 + C8444768(t - 0029) + C8444766(t - 0026); 
C8444774(t - 0018) = Ylds(t - 0018) * 4.5720 + C8445126(t - 0019); 
C8444792(t - 0026) = Ylds(t - 0026) * 2.5218 + C8444798(t - 0038) + C8444790(t - 0027); 
C8444828(t - 0036) = Ylds(t - 0036) * 0.8235 + C8444840(t - 0040) + C8444824(t - 0037); 
C8444872(t - 0050) = Ylds(t - 0050) * 4.8411 + C8444852(t - 0052) + C8444850(t - 0052); 
C8444908(t - 0054) = Ylds(t - 0054) * 0.0072 + C8444918(t - 0057) + C8444920(t - 0057); 
C8445134(t - 0025) = Ylds(t - 0025) * 0.0108 + C8445136(t - 0026); 
C8445170(t - 0033) = Ylds(t - 0033) * 0.0018 + C8445172(t - 0034); 
C8445182(t - 0036) = Ylds(t - 0036) * 0.0000 + C8444842(t - 0037); 
C8445186(t - 0036) = Ylds(t - 0036) * 0.0072 + C8445188(t - 0037); 
C8445192(t - 0037) = Ylds(t - 0037) * 0.0018 + C8445194(t - 0038); 
C8445240(t - 0056) = Ylds(t - 0056) * 0.0198 + C8444914(t - 0057); 
C8445280(t - 0067) = Ylds(t - 0067) * 0.0000 + C8444940(t - 0069); 
C8445402(t - 0058) = Ylds(t - 0058) * 4.8906 + C8445390(t - 0061) + C8445388(t - 0059); 
C8445416(t - 0068) = Ylds(t - 0068) * 1.9071 + C8445418(t - 0072) + C8445420(t - 0069); 
C8445512(t - 0073) = Ylds(t - 0073) * 3.6999 + C8445514(t - 0074) + C8445520(t - 0074); 
C8445562(t - 0103) = Ylds(t - 0103) * 3.6999 + C8445486(t - 0105) + C8445488(t - 0104); 
C8445564(t - 0100) = Ylds(t - 0100) * 1.1025 + C8445586(t - 0105) + C8445544(t - 0104); 
C8445594(t - 0108) = Ylds(t - 0108) * 0.0567 + C8445590(t - 0110) + C8445592(t - 0111); 
C8445610(t - 0072) = Ylds(t - 0072) * 0.0018 + C8445490(t - 0076); 
C8445614(t - 0073) = Ylds(t - 0073) * 0.0009 + C8445636(t - 0074); 
C8445618(t - 0076) = Ylds(t - 0076) * 0.0018 + C8445534(t - 0080); 
C8446250(t - 0081) = Ylds(t - 0081) * 1.4085 + C8445542(t - 0084); 
C8446504(t - 0088) = Ylds(t - 0088) * 0.0018 + C8446260(t - 0091); 
C932070022(t - 0252) = Ylds(t - 0252) * 11.1348 + C5908897(t - 0253); 
C932070062(t - 0278) = Ylds(t - 0278) * 1.3275 + C5909941(t - 0279); 
C932070083(t - 0262) = Ylds(t - 0262) * 1.6191 + C5909961(t - 0263); 
C5906829(t - 0151) = Ylds(t - 0151) * 0.5760 + C5906833(t - 0158) + C5906831(t - 0155); 
C5906869(t - 0172) = Ylds(t - 0172) * 3.1590 + C5906865(t - 0175) + C5906867(t - 0173); 
C5907195(t - 0171) = Ylds(t - 0171) * 0.0018 + C5906893(t - 0174); 
C5907299(t - 0265) = Ylds(t - 0265) * 0.2835 + C5907297(t - 0266) + C5907463(t - 0267); 
C5907357(t - 0265) = Ylds(t - 0265) * 1.4481 + C5907377(t - 0266) + C5907361(t - 0266); 
C5908055(t - 0193) = Ylds(t - 0193) * 6.5979 + C5908039(t - 0194); 
C5908125(t - 0186) = Ylds(t - 0186) * 2.9178 + C5908163(t - 0195) + C5908135(t - 0188); 
C5908169(t - 0191) = Ylds(t - 0191) * 1.2969 + C5908211(t - 0195) + C5908171(t - 0192); 
C5908231(t - 0200) = Ylds(t - 0200) * 1.5903 + C5908221(t - 0206) + C5908223(t - 0207); 
C5908301(t - 0223) = Ylds(t - 0223) * 2.5668 + C5908353(t - 0232) + C5908297(t - 0226); 
C5908395(t - 0224) = Ylds(t - 0224) * 1.5498 + C5908779(t - 0225); 
C5908421(t - 0251) = Ylds(t - 0251) * 6.2955 + C5909025(t - 0252); 
C5908681(t - 0224) = Ylds(t - 0224) * 5.8194 + C5908197(t - 0226); 
C5908709(t - 0235) = Ylds(t - 0235) * 0.0459 + C5908215(t - 0238); 
C5908717(t - 0205) = Ylds(t - 0205) * 0.0027 + C5908721(t - 0206); 
C5908793(t - 0254) = Ylds(t - 0254) * 1.4985 + C5908549(t - 0255); 
C5908795(t - 0259) = Ylds(t - 0259) * 0.4122 + C5908555(t - 0260); 
C5908899(t - 0255) = Ylds(t - 0255) * 0.4662 + C5908901(t - 0256) + C5908903(t - 0256); 
C5908937(t - 0241) = Ylds(t - 0241) * 1.0404 + C5908925(t - 0246) + C5908927(t - 0248); 
C5908961(t - 0255) = Ylds(t - 0255) * 13.2075 + C5908953(t - 0259) + C5908955(t - 0256); 
C5909021(t - 0275) = Ylds(t - 0275) * 4.9599 + C5909041(t - 0285) + C5909029(t - 0282); 
C5909045(t - 0259) = Ylds(t - 0259) * 22.5747 + C5909057(t - 0263) + C5909049(t - 0261); 
C5909183(t - 0262) = Ylds(t - 0262) * 1.6083 + C5908983(t - 0263); 
C5909189(t - 0276) = Ylds(t - 0276) * 0.1701 + C5909969(t - 0277); 
C5909205(t - 0266) = Ylds(t - 0266) * 3.2391 + C5909939(t - 0267); 
C5909657(t - 0266) = Ylds(t - 0266) * 1.4805 + C5909741(t - 0267); 
C5909977(t - 0266) = Ylds(t - 0266) * 1.8225 + C5909979(t - 0270) + C5909999(t - 0267); 
C5910027(t - 0276) = Ylds(t - 0276) * 1.0404 + C5910153(t - 0277); 
C5910043(t - 0265) = Ylds(t - 0265) * 0.0252 + C5910151(t - 0266); 
C5910077(t - 0267) = Ylds(t - 0267) * 2.7630 + C5910163(t - 0268); 
C5910137(t - 0275) = Ylds(t - 0275) * 0.0324 + C5910141(t - 0276) + C5910139(t - 0276); 
C5910169(t - 0269) = Ylds(t - 0269) * 0.0144 + C5909723(t - 0270); 
C5911307(t - 0254) = Ylds(t - 0254) * 0.0054 + C5909619(t - 0255); 
C8440097(t - 0134) = Ylds(t - 0134) * 0.3357 + C8440079(t - 0135) + C8440081(t - 0135); 
C8440171(t - 0130) = Ylds(t - 0130) * 2.0493 + C8440161(t - 0133) + C8440163(t - 0131); 
C8440177(t - 0135) = Ylds(t - 0135) * 1.7586 + C8440165(t - 0137) + C8440173(t - 0136); 
C8440245(t - 0121) = Ylds(t - 0121) * 0.8253 + C8440253(t - 0124) + C8440231(t - 0122); 
C8440317(t - 0122) = Ylds(t - 0122) * 2.9610 + C8440319(t - 0126) + C8440327(t - 0123); 
C8440423(t - 0114) = Ylds(t - 0114) * 0.0666 + C8440407(t - 0116) + C8440405(t - 0115); 
C8440433(t - 0150) = Ylds(t - 0150) * 0.0954 + C8441359(t - 0151); 
C8440475(t - 0136) = Ylds(t - 0136) * 0.7128 + C8440083(t - 0137); 
C8440895(t - 0123) = Ylds(t - 0123) * 22.8357 + C8440897(t - 0124) + C8440911(t - 0125); 
C8440973(t - 0204) = Ylds(t - 0204) * 4.9329 + C8440975(t - 0207) + C8440965(t - 0207); 
C8441021(t - 0198) = Ylds(t - 0198) * 0.7848 + C8441517(t - 0200); 
C8441067(t - 0200) = Ylds(t - 0200) * 18.3564 + C8441075(t - 0204) + C8441071(t - 0201); 
C8441077(t - 0193) = Ylds(t - 0193) * 17.5968 + C8441085(t - 0201) + C8441097(t - 0199); 
C8441093(t - 0207) = Ylds(t - 0207) * 0.3429 + C8441095(t - 0208); 
C8441277(t - 0178) = Ylds(t - 0178) * 6.1668 + C8440919(t - 0182) + C8440933(t - 0180); 
C8441329(t - 0102) = Ylds(t - 0102) * 1.6677 + C8440751(t - 0104); 
C8441445(t - 0211) = Ylds(t - 0211) * 1.4103 + C8441451(t - 0212) + C8441459(t - 0212); 
C8441487(t - 0201) = Ylds(t - 0201) * 1.8207 + C8441483(t - 0203) + C8441481(t - 0202); 
C8441497(t - 0200) = Ylds(t - 0200) * 0.7956 + C8441491(t - 0202) + C8441505(t - 0202); 
C8442095(t - 0208) = Ylds(t - 0208) * 0.0000 + C8442047(t - 0209); 
C8444776(t - 0024) = Ylds(t - 0024) * 4.7367 + C8444770(t - 0027) + C8444772(t - 0025); 
C8444794(t - 0025) = Ylds(t - 0025) * 0.9216 + C8444784(t - 0026) + C8444792(t - 0026); 
C8444834(t - 0035) = Ylds(t - 0035) * 1.1493 + C8444826(t - 0039) + C8444828(t - 0036); 
C8445014(t - 0016) = Ylds(t - 0016) * 7.6239 + C8445012(t - 0019) + C8444744(t - 0017); 
C8445116(t - 0016) = Ylds(t - 0016) * 0.0000 + C8444774(t - 0018); 
C8445180(t - 0035) = Ylds(t - 0035) * 0.0009 + C8445182(t - 0036); 
C8445226(t - 0048) = Ylds(t - 0048) * 0.0000 + C8444872(t - 0050); 
C8445244(t - 0055) = Ylds(t - 0055) * 0.1044 + C8445240(t - 0056); 
C8445278(t - 0066) = Ylds(t - 0066) * 0.0018 + C8445280(t - 0067); 
C8445426(t - 0067) = Ylds(t - 0067) * 1.0647 + C8445414(t - 0072) + C8445416(t - 0068); 
C8445474(t - 0107) = Ylds(t - 0107) * 1.0935 + C8445594(t - 0108); 
C8445588(t - 0054) = Ylds(t - 0054) * 0.6111 + C8445402(t - 0058); 
C8445634(t - 0072) = Ylds(t - 0072) * 0.0045 + C8445512(t - 0073); 
C8446498(t - 0080) = Ylds(t - 0080) * 0.0009 + C8446250(t - 0081); 
C932070024(t - 0261) = Ylds(t - 0261) * 0.0954 + C5909677(t - 0262); 
C932070054(t - 0251) = Ylds(t - 0251) * 1.0377 + C932070022(t - 0252); 
C932070061(t - 0277) = Ylds(t - 0277) * 0.4914 + C932070062(t - 0278); 
C932070088(t - 0099) = Ylds(t - 0099) * 0.8127 + C8445564(t - 0100); 
C932070103(t - 0099) = Ylds(t - 0099) * 0.4050 + C8445562(t - 0103); 
C5907159(t - 0150) = Ylds(t - 0150) * 0.0018 + C5906829(t - 0151); 
C5907187(t - 0169) = Ylds(t - 0169) * 0.0018 + C5906869(t - 0172); 
C5907305(t - 0264) = Ylds(t - 0264) * 2.1195 + C5907301(t - 0265) + C5907299(t - 0265); 
C5907451(t - 0254) = Ylds(t - 0254) * 5.3703 + C5908899(t - 0255); 
C5907485(t - 0264) = Ylds(t - 0264) * 0.0351 + C5907357(t - 0265); 
C5908157(t - 0190) = Ylds(t - 0190) * 0.1197 + C5908159(t - 0191) + C5908169(t - 0191); 
C5908239(t - 0223) = Ylds(t - 0223) * 4.4640 + C5908681(t - 0224); 
C5908539(t - 0258) = Ylds(t - 0258) * 2.1762 + C5908795(t - 0259); 
C5908547(t - 0253) = Ylds(t - 0253) * 1.4616 + C5908793(t - 0254); 
C5908551(t - 0253) = Ylds(t - 0253) * 0.6471 + C5911307(t - 0254); 
C5908577(t - 0191) = Ylds(t - 0191) * 2.1537 + C5908055(t - 0193); 
C5908629(t - 0185) = Ylds(t - 0185) * 0.0036 + C5908125(t - 0186); 
C5908819(t - 0198) = Ylds(t - 0198) * 0.0000 + C5908231(t - 0200); 
C5908981(t - 0261) = Ylds(t - 0261) * 0.1134 + C5909183(t - 0262); 
C5909017(t - 0271) = Ylds(t - 0271) * 9.0756 + C5909019(t - 0272) + C5909021(t - 0275); 
C5909039(t - 0256) = Ylds(t - 0256) * 2.6892 + C5909043(t - 0259) + C5909045(t - 0259); 
C5909079(t - 0276) = Ylds(t - 0276) * 4.4892 + C5909953(t - 0277) + C932070061(t - 0277); 
C5909201(t - 0263) = Ylds(t - 0263) * 0.9441 + C5909977(t - 0266); 
C5909213(t - 0275) = Ylds(t - 0275) * 0.0117 + C5909189(t - 0276); 
C5909699(t - 0264) = Ylds(t - 0264) * 0.3078 + C5910043(t - 0265); 
C5909959(t - 0274) = Ylds(t - 0274) * 0.8046 + C5910137(t - 0275); 
C5910003(t - 0275) = Ylds(t - 0275) * 1.0008 + C5910045(t - 0278) + C5910027(t - 0276); 
C5910087(t - 0268) = Ylds(t - 0268) * 0.0126 + C5910169(t - 0269); 
C5910161(t - 0266) = Ylds(t - 0266) * 0.4707 + C5910077(t - 0267); 
C5911301(t - 0264) = Ylds(t - 0264) * 0.0045 + C5909657(t - 0266); 
C8440105(t - 0135) = Ylds(t - 0135) * 0.0171 + C8440475(t - 0136); 
C8440131(t - 0133) = Ylds(t - 0133) * 1.4076 + C8440095(t - 0135) + C8440097(t - 0134); 
C8440187(t - 0133) = Ylds(t - 0133) * 0.8595 + C8440195(t - 0136) + C8440177(t - 0135); 
C8440285(t - 0119) = Ylds(t - 0119) * 0.2493 + C8440287(t - 0121) + C8440317(t - 0122); 
C8440759(t - 0101) = Ylds(t - 0101) * 0.6075 + C8441329(t - 0102); 
C8440839(t - 0118) = Ylds(t - 0118) * 0.5886 + C8440853(t - 0120) + C8440895(t - 0123); 
C8440893(t - 0174) = Ylds(t - 0174) * 1.5498 + C8441269(t - 0179) + C8441277(t - 0178); 
C8440979(t - 0202) = Ylds(t - 0202) * 1.6317 + C8440971(t - 0204) + C8440973(t - 0204); 
C8441061(t - 0189) = Ylds(t - 0189) * 10.3716 + C8441065(t - 0190) + C8441077(t - 0193); 
C8441317(t - 0196) = Ylds(t - 0196) * 30.4353 + C8441049(t - 0202) + C8441067(t - 0200); 
C8441325(t - 0207) = Ylds(t - 0207) * 2.2581 + C8442095(t - 0208); 
C8441355(t - 0113) = Ylds(t - 0113) * 2.3112 + C8440423(t - 0114); 
C8441357(t - 0149) = Ylds(t - 0149) * 0.1620 + C8440433(t - 0150); 
C8441439(t - 0210) = Ylds(t - 0210) * 2.7162 + C8441449(t - 0211) + C8441445(t - 0211); 
C8441495(t - 0200) = Ylds(t - 0200) * 0.2934 + C8441489(t - 0203) + C8441487(t - 0201); 
C8444906(t - 0054) = Ylds(t - 0054) * 0.4662 + C8445244(t - 0055); 
C8445102(t - 0013) = Ylds(t - 0013) * 0.0378 + C8445014(t - 0016); 
C8445114(t - 0015) = Ylds(t - 0015) * 0.0009 + C8445116(t - 0016); 
C8445124(t - 0021) = Ylds(t - 0021) * 0.0009 + C8444776(t - 0024); 
C8445130(t - 0024) = Ylds(t - 0024) * 0.0036 + C8444794(t - 0025); 
C8445176(t - 0034) = Ylds(t - 0034) * 0.0009 + C8444834(t - 0035); 
C8445224(t - 0047) = Ylds(t - 0047) * 0.0054 + C8445226(t - 0048); 
C8445408(t - 0053) = Ylds(t - 0053) * 0.2538 + C8445588(t - 0054); 
C8445434(t - 0066) = Ylds(t - 0066) * 3.1275 + C8445424(t - 0069) + C8445426(t - 0067); 
C8445516(t - 0106) = Ylds(t - 0106) * 1.6947 + C8445476(t - 0110) + C8445474(t - 0107); 
C8445606(t - 0071) = Ylds(t - 0071) * 0.0063 + C8445634(t - 0072); 
C932070025(t - 0260) = Ylds(t - 0260) * 0.0477 + C932070024(t - 0261); 
C932070044(t - 0250) = Ylds(t - 0250) * 2.0970 + C932070054(t - 0251); 
C932070077(t - 0098) = Ylds(t - 0098) * 0.7587 + C932070088(t - 0099) + C932070103(t - 0099); 
C5907439(t - 0251) = Ylds(t - 0251) * 2.4399 + C5907427(t - 0252) + C5907451(t - 0254); 
C5907465(t - 0263) = Ylds(t - 0263) * 5.9292 + C5907307(t - 0264) + C5907305(t - 0264); 
C5907481(t - 0263) = Ylds(t - 0263) * 2.2410 + C5907483(t - 0264) + C5907485(t - 0264); 
C5908065(t - 0249) = Ylds(t - 0249) * 2.6505 + C5908051(t - 0250) + C932070044(t - 0250); 
C5908073(t - 0190) = Ylds(t - 0190) * 4.6125 + C5908579(t - 0192) + C5908577(t - 0191); 
C5908153(t - 0189) = Ylds(t - 0189) * 3.6810 + C5908155(t - 0193) + C5908157(t - 0190); 
C5908255(t - 0218) = Ylds(t - 0218) * 0.2034 + C5908241(t - 0223) + C5908239(t - 0223); 
C5908465(t - 0254) = Ylds(t - 0254) * 15.3063 + C5909039(t - 0256); 
C5908537(t - 0252) = Ylds(t - 0252) * 0.6048 + C5908535(t - 0253) + C5908547(t - 0253); 
C5908979(t - 0260) = Ylds(t - 0260) * 15.2208 + C5908981(t - 0261) * 1/2; 
C5909007(t - 0267) = Ylds(t - 0267) * 5.2146 + C5909009(t - 0268) + C5909017(t - 0271); 
C5909159(t - 0280) = Ylds(t - 0280) * 36.7821 + C5908981(t - 0261) * 1/2; 
C5909211(t - 0274) = Ylds(t - 0274) * 0.4194 + C5909213(t - 0275); 
C5909691(t - 0263) = Ylds(t - 0263) * 0.0603 + C5909699(t - 0264) * 1/2; 
C5909693(t - 0263) = Ylds(t - 0263) * 0.0711 + C5909699(t - 0264) * 1/2; 
C5909739(t - 0263) = Ylds(t - 0263) * 0.8406 + C5909747(t - 0264) + C5911301(t - 0264); 
C5909943(t - 0273) = Ylds(t - 0273) * 0.2520 + C5909975(t - 0275) + C5909959(t - 0274); 
C5909965(t - 0273) = Ylds(t - 0273) * 1.0791 + C5909997(t - 0274) + C5910003(t - 0275); 
C5910073(t - 0265) = Ylds(t - 0265) * 0.6138 + C5910161(t - 0266); 
C5910083(t - 0267) = Ylds(t - 0267) * 0.0117 + C5910089(t - 0268) + C5910087(t - 0268); 
C8440129(t - 0134) = Ylds(t - 0134) * 1.0224 + C8440107(t - 0136) + C8440105(t - 0135); 
C8440141(t - 0131) = Ylds(t - 0131) * 0.5337 + C8440135(t - 0132) + C8440131(t - 0133); 
C8440189(t - 0132) = Ylds(t - 0132) * 0.0936 + C8440183(t - 0133) + C8440187(t - 0133); 
C8440765(t - 0111) = Ylds(t - 0111) * 12.1023 + C8441351(t - 0115) + C8441355(t - 0113); 
C8440831(t - 0117) = Ylds(t - 0117) * 8.6418 + C8440833(t - 0122) + C8440839(t - 0118); 
C8441047(t - 0185) = Ylds(t - 0185) * 2.9196 + C8441069(t - 0191) + C8441061(t - 0189); 
C8441267(t - 0173) = Ylds(t - 0173) * 4.3578 + C8441265(t - 0176) + C8440893(t - 0174); 
C8441323(t - 0206) = Ylds(t - 0206) * 12.1815 + C8441093(t - 0207) + C8441325(t - 0207); 
C8441349(t - 0148) = Ylds(t - 0148) * 0.7416 + C8441251(t - 0150) + C8441357(t - 0149); 
C8441427(t - 0209) = Ylds(t - 0209) * 0.1548 + C8441429(t - 0210) + C8441439(t - 0210); 
C8441499(t - 0199) = Ylds(t - 0199) * 0.1665 + C8441497(t - 0200) + C8441495(t - 0200); 
C8444904(t - 0053) = Ylds(t - 0053) * 0.0936 + C8444908(t - 0054) + C8444906(t - 0054); 
C8445410(t - 0052) = Ylds(t - 0052) * 0.5751 + C8445412(t - 0056) + C8445408(t - 0053); 
C8445438(t - 0065) = Ylds(t - 0065) * 3.8655 + C8445448(t - 0068) + C8445434(t - 0066); 
C8445524(t - 0104) = Ylds(t - 0104) * 0.6192 + C8445518(t - 0111) + C8445516(t - 0106); 
C932070039(t - 0259) = Ylds(t - 0259) * 0.1908 + C932070026(t - 0260) + C932070025(t - 0260); 
C932070108(t - 0097) = Ylds(t - 0097) * 4.6359 + C932070100(t - 0102) + C932070077(t - 0098); 
C5907315(t - 0261) = Ylds(t - 0261) * 0.0405 + C5907465(t - 0263) * 1/2; 
C5907317(t - 0261) = Ylds(t - 0261) * 0.0405 + C5907465(t - 0263) * 1/2; 
C5907477(t - 0262) = Ylds(t - 0262) * 0.8946 + C5907479(t - 0263) + C5907481(t - 0263); 
C5908077(t - 0248) = Ylds(t - 0248) * 0.9621 + C5908067(t - 0249) + C5908065(t - 0249); 
C5908109(t - 0189) = Ylds(t - 0189) * 7.8462 + C5908069(t - 0191) + C5908073(t - 0190); 
C5908289(t - 0217) = Ylds(t - 0217) * 9.1062 + C5908253(t - 0223) + C5908255(t - 0218); 
C5908437(t - 0248) = Ylds(t - 0248) * 17.6400 + C5908451(t - 0251) + C5908465(t - 0254); 
C5908639(t - 0187) = Ylds(t - 0187) * 0.0000 + C5908153(t - 0189); 
C5908963(t - 0254) = Ylds(t - 0254) * 1.7325 + C5908965(t - 0257) + C5908979(t - 0260); 
C5909001(t - 0265) = Ylds(t - 0265) * 7.9803 + C5909023(t - 0272) + C5909007(t - 0267); 
C5909073(t - 0273) = Ylds(t - 0273) * 0.2025 + C5909211(t - 0274); 
C5909077(t - 0272) = Ylds(t - 0272) * 0.0648 + C5909943(t - 0273); 
C5909163(t - 0265) = Ylds(t - 0265) * 11.2545 + C5908999(t - 0271) + C5909159(t - 0280); 
C5909209(t - 0272) = Ylds(t - 0272) * 0.1944 + C5909965(t - 0273); 
C5909631(t - 0262) = Ylds(t - 0262) * 0.3042 + C5909739(t - 0263); 
C5909687(t - 0262) = Ylds(t - 0262) * 0.0630 + C5909691(t - 0263) + C5909693(t - 0263); 
C5909707(t - 0264) = Ylds(t - 0264) * 2.4075 + C5910073(t - 0265); 
C5909719(t - 0266) = Ylds(t - 0266) * 2.0241 + C5910083(t - 0267); 
C8440169(t - 0133) = Ylds(t - 0133) * 4.9770 + C8440127(t - 0134) + C8440129(t - 0134); 
C8440203(t - 0130) = Ylds(t - 0130) * 5.5440 + C8440143(t - 0131) + C8440141(t - 0131); 
C8440431(t - 0147) = Ylds(t - 0147) * 7.5699 + C8440485(t - 0148) + C8441349(t - 0148); 
C8440483(t - 0131) = Ylds(t - 0131) * 0.0792 + C8440189(t - 0132); 
C8440879(t - 0171) = Ylds(t - 0171) * 0.4581 + C8441263(t - 0173) + C8441267(t - 0173); 
C8441017(t - 0198) = Ylds(t - 0198) * 1.3599 + C8441499(t - 0199); 
C8441257(t - 0114) = Ylds(t - 0114) * 35.7264 + C8440819(t - 0121) + C8440831(t - 0117); 
C8441319(t - 0200) = Ylds(t - 0200) * 20.5506 + C8441087(t - 0205) + C8441323(t - 0206); 
C8441543(t - 0208) = Ylds(t - 0208) * 3.1257 + C8441435(t - 0210) + C8441427(t - 0209); 
C8444880(t - 0051) = Ylds(t - 0051) * 1.6578 + C8445410(t - 0052); 
C8445242(t - 0052) = Ylds(t - 0052) * 0.0234 + C8444904(t - 0053); 
C8445436(t - 0063) = Ylds(t - 0063) * 1.0017 + C8445432(t - 0064) + C8445438(t - 0065); 
C8445558(t - 0103) = Ylds(t - 0103) * 2.4597 + C8445522(t - 0104) + C8445524(t - 0104); 
C5907323(t - 0260) = Ylds(t - 0260) * 0.0558 + C5907315(t - 0261) + C5907317(t - 0261); 
C5907467(t - 0261) = Ylds(t - 0261) * 7.2765 + C5907477(t - 0262); 
C5908087(t - 0247) = Ylds(t - 0247) * 0.4428 + C5908079(t - 0248) + C5908077(t - 0248); 
C5908105(t - 0186) = Ylds(t - 0186) * 2.5254 + C5908123(t - 0190) + C5908109(t - 0189); 
C5908403(t - 0237) = Ylds(t - 0237) * 0.0432 + C5908429(t - 0242) + C5908437(t - 0248); 
C5908757(t - 0213) = Ylds(t - 0213) * 0.0000 + C5908289(t - 0217); 
C5908971(t - 0253) = Ylds(t - 0253) * 11.1168 + C5908961(t - 0255) + C5908963(t - 0254); 
C5909071(t - 0272) = Ylds(t - 0272) * 1.8405 + C5909079(t - 0276) + C5909073(t - 0273); 
C5909161(t - 0262) = Ylds(t - 0262) * 41.2839 + C5909001(t - 0265) + C5909163(t - 0265); 
C5909197(t - 0271) = Ylds(t - 0271) * 1.8180 + C5909077(t - 0272) + C5909209(t - 0272); 
C5909621(t - 0261) = Ylds(t - 0261) * 0.3672 + C5909627(t - 0262) + C5909631(t - 0262); 
C5909683(t - 0261) = Ylds(t - 0261) * 0.0666 + C5909687(t - 0262) * 1/2; 
C5909685(t - 0261) = Ylds(t - 0261) * 0.0612 + C5909687(t - 0262) * 1/2; 
C5909711(t - 0264) = Ylds(t - 0264) * 0.0054 + C5909715(t - 0265) + C5909719(t - 0266); 
C8440193(t - 0129) = Ylds(t - 0129) * 0.5796 + C8440171(t - 0130) + C8440169(t - 0133); 
C8440373(t - 0145) = Ylds(t - 0145) * 0.3177 + C8440375(t - 0146) + C8440431(t - 0147); 
C8440875(t - 0170) = Ylds(t - 0170) * 12.1626 + C8441281(t - 0183) + C8440879(t - 0171); 
C8441019(t - 0197) = Ylds(t - 0197) * 17.1198 + C8441021(t - 0198) + C8441017(t - 0198); 
C8441303(t - 0191) = Ylds(t - 0191) * 76.0122 + C8441089(t - 0201) + C8441319(t - 0200); 
C8441421(t - 0207) = Ylds(t - 0207) * 1.1916 + C8441415(t - 0210) + C8441543(t - 0208); 
C8445232(t - 0049) = Ylds(t - 0049) * 0.0000 + C8444880(t - 0051); 
C8445626(t - 0062) = Ylds(t - 0062) * 0.0018 + C8445436(t - 0063); 
C8446524(t - 0101) = Ylds(t - 0101) * 0.1908 + C8445558(t - 0103); 
C5907337(t - 0259) = Ylds(t - 0259) * 3.4668 + C5907321(t - 0261) + C5907323(t - 0260); 
C5908101(t - 0185) = Ylds(t - 0185) * 3.1878 + C5908099(t - 0187) + C5908105(t - 0186); 
C5908127(t - 0246) = Ylds(t - 0246) * 6.6186 + C5908085(t - 0251) + C5908087(t - 0247); 
C5908557(t - 0260) = Ylds(t - 0260) * 1.3329 + C5909621(t - 0261); 
C5908969(t - 0248) = Ylds(t - 0248) * 13.9743 + C5908987(t - 0258) + C5908971(t - 0253); 
C5909013(t - 0251) = Ylds(t - 0251) * 5.4585 + C5909015(t - 0257) + C5909161(t - 0262); 
C5909067(t - 0270) = Ylds(t - 0270) * 9.3987 + C5909071(t - 0272) + C5909197(t - 0271); 
C5909681(t - 0260) = Ylds(t - 0260) * 2.2248 + C5909683(t - 0261) + C5909685(t - 0261); 
C5909709(t - 0263) = Ylds(t - 0263) * 0.9387 + C5909713(t - 0265) + C5909711(t - 0264); 
C8440365(t - 0144) = Ylds(t - 0144) * 2.2023 + C8440363(t - 0145) + C8440373(t - 0145); 
C8440867(t - 0165) = Ylds(t - 0165) * 17.3574 + C8440827(t - 0167) + C8440875(t - 0170); 
C8440991(t - 0168) = Ylds(t - 0168) * 9.1287 + C8440993(t - 0173) + C8441303(t - 0191); 
C8441417(t - 0206) = Ylds(t - 0206) * 0.1035 + C8441419(t - 0207) + C8441421(t - 0207); 
C8445230(t - 0048) = Ylds(t - 0048) * 0.0018 + C8445232(t - 0049); 
C8445624(t - 0061) = Ylds(t - 0061) * 0.0054 + C8445626(t - 0062); 
C8446254(t - 0100) = Ylds(t - 0100) * 9.2502 + C8446528(t - 0101) + C8446524(t - 0101); 
C5907343(t - 0257) = Ylds(t - 0257) * 0.5112 + C5907467(t - 0261) + C5907337(t - 0259); 
C5908091(t - 0184) = Ylds(t - 0184) * 9.5310 + C5908089(t - 0187) + C5908101(t - 0185); 
C5908409(t - 0249) = Ylds(t - 0249) * 10.8909 + C5909013(t - 0251); 
C5908947(t - 0244) = Ylds(t - 0244) * 18.2817 + C5908951(t - 0245) + C5908969(t - 0248); 
C5909195(t - 0268) = Ylds(t - 0268) * 6.1461 + C5909207(t - 0270) + C5909067(t - 0270); 
C5909705(t - 0262) = Ylds(t - 0262) * 11.5875 + C5909707(t - 0264) + C5909709(t - 0263); 
C8440469(t - 0143) = Ylds(t - 0143) * 10.5282 + C8440463(t - 0152) + C8440365(t - 0144); 
C8440905(t - 0161) = Ylds(t - 0161) * 23.4720 + C8440869(t - 0162) + C8440867(t - 0165); 
C8446258(t - 0097) = Ylds(t - 0097) * 0.1026 + C8446256(t - 0098) + C8446254(t - 0100); 
C932070094(t - 0205) = Ylds(t - 0205) * 1.2528 + C8441417(t - 0206); 
C5907349(t - 0256) = Ylds(t - 0256) * 1.2042 + C5907341(t - 0257) + C5907343(t - 0257); 
C5908083(t - 0182) = Ylds(t - 0182) * 2.2788 + C5908081(t - 0185) + C5908091(t - 0184); 
C5908407(t - 0247) = Ylds(t - 0247) * 17.0397 + C5908421(t - 0251) + C5908409(t - 0249); 
C5908943(t - 0240) = Ylds(t - 0240) * 2.9583 + C5908937(t - 0241) + C5908947(t - 0244); 
C5909065(t - 0265) = Ylds(t - 0265) * 2.6937 + C5909075(t - 0269) + C5909195(t - 0268); 
C5909671(t - 0258) = Ylds(t - 0258) * 0.0756 + C932070039(t - 0259) + C5909705(t - 0262); 
C8440289(t - 0139) = Ylds(t - 0139) * 0.4248 + C8440291(t - 0140) + C8440469(t - 0143); 
C8440913(t - 0158) = Ylds(t - 0158) * 0.6732 + C8440931(t - 0171) + C8440905(t - 0161); 
C8446268(t - 0096) = Ylds(t - 0096) * 4.0671 + C932070108(t - 0097) + C8446258(t - 0097); 
C932070101(t - 0204) = Ylds(t - 0204) * 10.2132 + C932070068(t - 0206) + C932070094(t - 0205); 
C5907373(t - 0255) = Ylds(t - 0255) * 2.1285 + C5907353(t - 0257) + C5907349(t - 0256); 
C5908401(t - 0236) = Ylds(t - 0236) * 8.9001 + C5908403(t - 0237) + C5908407(t - 0247); 
C5908621(t - 0181) = Ylds(t - 0181) * 0.0045 + C5908083(t - 0182); 
C5908941(t - 0239) = Ylds(t - 0239) * 1.8108 + C5908973(t - 0249) + C5908943(t - 0240); 
C5909191(t - 0264) = Ylds(t - 0264) * 19.5804 + C5909203(t - 0266) + C5909205(t - 0266) + C5909065(t - 0265); 
C5909735(t - 0257) = Ylds(t - 0257) * 1.4004 + C5909689(t - 0259) + C5909671(t - 0258); 
C8440275(t - 0138) = Ylds(t - 0138) * 1.4616 + C8440303(t - 0141) + C8440289(t - 0139); 
C8440915(t - 0157) = Ylds(t - 0157) * 0.6921 + C8440941(t - 0168) + C8440913(t - 0158); 
C8441295(t - 0201) = Ylds(t - 0201) * 19.9323 + C8440979(t - 0202) + C932070101(t - 0204); 
C8446518(t - 0093) = Ylds(t - 0093) * 0.0000 + C8446268(t - 0096); 
C5907411(t - 0254) = Ylds(t - 0254) * 5.6367 + C5907371(t - 0255) + C5907373(t - 0255); 
C5908189(t - 0238) = Ylds(t - 0238) * 7.4448 + C5908941(t - 0239); 
C5908377(t - 0233) = Ylds(t - 0233) * 8.0559 + C5908379(t - 0237) + C5908401(t - 0236); 
C5909193(t - 0261) = Ylds(t - 0261) * 0.2124 + C5909201(t - 0263) + C5909191(t - 0264); 
C5909649(t - 0256) = Ylds(t - 0256) * 0.0324 + C5909681(t - 0260) + C5909735(t - 0257); 
C8440263(t - 0137) = Ylds(t - 0137) * 0.1764 + C8440299(t - 0140) + C8440275(t - 0138); 
C8440925(t - 0156) = Ylds(t - 0156) * 4.9617 + C8440945(t - 0162) + C8440915(t - 0157); 
C8440997(t - 0198) = Ylds(t - 0198) * 16.1370 + C8441293(t - 0207) + C8441295(t - 0201); 
C5907421(t - 0252) = Ylds(t - 0252) * 0.1728 + C5907413(t - 0254) + C5907411(t - 0254); 
C5908369(t - 0228) = Ylds(t - 0228) * 4.0617 + C5908365(t - 0232) + C5908377(t - 0233); 
C5908543(t - 0260) = Ylds(t - 0260) * 1.9836 + C932070083(t - 0262) + C5909193(t - 0261); 
C5908693(t - 0237) = Ylds(t - 0237) * 0.1782 + C5908189(t - 0238); 
C5909647(t - 0255) = Ylds(t - 0255) * 0.1458 + C5909653(t - 0256) + C5909649(t - 0256); 
C8440261(t - 0136) = Ylds(t - 0136) * 0.9171 + C8440297(t - 0139) + C8440263(t - 0137); 
C8440927(t - 0154) = Ylds(t - 0154) * 0.7992 + C8440923(t - 0162) + C8440925(t - 0156); 
C8441007(t - 0195) = Ylds(t - 0195) * 7.5429 + C8440999(t - 0201) + C8440997(t - 0198); 
C5907437(t - 0251) = Ylds(t - 0251) * 1.2231 + C5907419(t - 0253) + C5907421(t - 0252); 
C5908541(t - 0259) = Ylds(t - 0259) * 1.8639 + C5908557(t - 0260) + C5908543(t - 0260); 
C5908603(t - 0226) = Ylds(t - 0226) * 6.9759 + C5908387(t - 0228) + C5908369(t - 0228); 
C5909637(t - 0254) = Ylds(t - 0254) * 0.8892 + C5909661(t - 0257) + C5909647(t - 0255); 
C8440241(t - 0135) = Ylds(t - 0135) * 0.8613 + C8440243(t - 0136) + C8440261(t - 0136); 
C8441011(t - 0193) = Ylds(t - 0193) * 9.5346 + C8441009(t - 0199) + C8441007(t - 0195); 
C5907449(t - 0250) = Ylds(t - 0250) * 0.3852 + C5907439(t - 0251) + C5907437(t - 0251); 
C5908355(t - 0220) = Ylds(t - 0220) * 6.4287 + C5908361(t - 0223) + C5908603(t - 0226); 
C5908531(t - 0257) = Ylds(t - 0257) * 4.1580 + C5908539(t - 0258) + C5908541(t - 0259); 
C5908553(t - 0253) = Ylds(t - 0253) * 1.1043 + C5909645(t - 0256) + C5909637(t - 0254); 
C8440225(t - 0134) = Ylds(t - 0134) * 0.2007 + C8440221(t - 0138) + C8440241(t - 0135); 
C8441015(t - 0192) = Ylds(t - 0192) * 4.8105 + C8441019(t - 0197) + C8441011(t - 0193); 
C5908527(t - 0254) = Ylds(t - 0254) * 5.3748 + C5908525(t - 0258) + C5908531(t - 0257); 
C5908545(t - 0252) = Ylds(t - 0252) * 3.2760 + C5908551(t - 0253) + C5908553(t - 0253); 
C5908777(t - 0217) = Ylds(t - 0217) * 0.0135 + C5908355(t - 0220); 
C5908911(t - 0249) = Ylds(t - 0249) * 13.1832 + C5907449(t - 0250); 
C8440223(t - 0133) = Ylds(t - 0133) * 1.8639 + C8440265(t - 0135) + C8440225(t - 0134); 
C8441027(t - 0191) = Ylds(t - 0191) * 5.0022 + C8441013(t - 0196) + C8441015(t - 0192); 
C5908523(t - 0251) = Ylds(t - 0251) * 2.0700 + C5908519(t - 0255) + C5908527(t - 0254); 
C5908609(t - 0251) = Ylds(t - 0251) * 3.7935 + C5908537(t - 0252) + C5908545(t - 0252); 
C5911293(t - 0244) = Ylds(t - 0244) * 0.0000 + C5908911(t - 0249); 
C8440211(t - 0132) = Ylds(t - 0132) * 2.6757 + C8440213(t - 0134) + C8440223(t - 0133); 
C8441029(t - 0189) = Ylds(t - 0189) * 1.3383 + C8441317(t - 0196) + C8441027(t - 0191); 
C5908129(t - 0243) = Ylds(t - 0243) * 2.9592 + C5911293(t - 0244); 
C5908521(t - 0249) = Ylds(t - 0249) * 9.1998 + C5908523(t - 0251) + C5908609(t - 0251); 
C8440481(t - 0130) = Ylds(t - 0130) * 1.0890 + C8440483(t - 0131) + C8440211(t - 0132); 
C8441037(t - 0188) = Ylds(t - 0188) * 7.9074 + C8441307(t - 0191) + C8441029(t - 0189); 
C5908141(t - 0241) = Ylds(t - 0241) * 0.3384 + C5908127(t - 0246) + C5908129(t - 0243); 
C5908509(t - 0246) = Ylds(t - 0246) * 6.5340 + C5908511(t - 0248) + C5908521(t - 0249); 
C8440205(t - 0129) = Ylds(t - 0129) * 1.4697 + C8440233(t - 0132) + C8440481(t - 0130); 
C8441035(t - 0186) = Ylds(t - 0186) * 0.0045 + C8441053(t - 0192) + C8441037(t - 0188); 
C5908187(t - 0240) = Ylds(t - 0240) * 7.2621 + C5908143(t - 0242) + C5908141(t - 0241); 
C5908505(t - 0243) = Ylds(t - 0243) * 5.9607 + C5908513(t - 0245) + C5908509(t - 0246); 
C8440199(t - 0128) = Ylds(t - 0128) * 1.1250 + C8440193(t - 0129) + C8440205(t - 0129); 
C8441039(t - 0185) = Ylds(t - 0185) * 5.9085 + C8441033(t - 0190) + C8441035(t - 0186); 
C5908493(t - 0242) = Ylds(t - 0242) * 0.1053 + C5908491(t - 0243) + C5908505(t - 0243); 
C5908689(t - 0238) = Ylds(t - 0238) * 0.0000 + C5908187(t - 0240); 
C8440197(t - 0127) = Ylds(t - 0127) * 2.1123 + C8440191(t - 0131) + C8440199(t - 0128); 
C8441045(t - 0184) = Ylds(t - 0184) * 7.3170 + C8441051(t - 0190) + C8441039(t - 0185); 
C5908485(t - 0241) = Ylds(t - 0241) * 0.6507 + C5908489(t - 0242) + C5908493(t - 0242); 
C5908691(t - 0237) = Ylds(t - 0237) * 0.0018 + C5908689(t - 0238); 
C8440207(t - 0126) = Ylds(t - 0126) * 1.3698 + C8440181(t - 0131) + C8440197(t - 0127); 
C8441043(t - 0183) = Ylds(t - 0183) * 3.3372 + C8441047(t - 0185) + C8441045(t - 0184); 
C5908483(t - 0240) = Ylds(t - 0240) * 4.1742 + C5908487(t - 0245) + C5908485(t - 0241); 
C5908707(t - 0236) = Ylds(t - 0236) * 4.8312 + C5908693(t - 0237) + C5908691(t - 0237); 
C8440459(t - 0125) = Ylds(t - 0125) * 1.8909 + C8440203(t - 0130) + C8440207(t - 0126); 
C8441031(t - 0182) = Ylds(t - 0182) * 27.7677 + C8441023(t - 0189) + C8441043(t - 0183); 
C5908473(t - 0238) = Ylds(t - 0238) * 0.0954 + C5908475(t - 0241) + C5908483(t - 0240); 
C5908711(t - 0234) = Ylds(t - 0234) * 5.2038 + C5908709(t - 0235) + C5908707(t - 0236); 
C8440247(t - 0123) = Ylds(t - 0123) * 0.9207 + C8440227(t - 0129) + C8440459(t - 0125); 
C8441025(t - 0180) = Ylds(t - 0180) * 0.0990 + C8441031(t - 0182) * 1/2; 
C8441313(t - 0181) = Ylds(t - 0181) * 0.0261 + C8441031(t - 0182) * 1/2; 
C5908469(t - 0237) = Ylds(t - 0237) * 6.5430 + C5908479(t - 0238) + C5908473(t - 0238); 
C5908725(t - 0232) = Ylds(t - 0232) * 1.0521 + C5908713(t - 0233) + C5908711(t - 0234); 
C8440249(t - 0121) = Ylds(t - 0121) * 0.7479 + C8440251(t - 0124) + C8440247(t - 0123); 
C8441311(t - 0180) = Ylds(t - 0180) * 0.2016 + C8441315(t - 0182) + C8441313(t - 0181); 
C5908463(t - 0236) = Ylds(t - 0236) * 0.6273 + C5908467(t - 0241) + C5908469(t - 0237); 
C5908727(t - 0231) = Ylds(t - 0231) * 1.5525 + C5908719(t - 0232) + C5908725(t - 0232); 
C8440273(t - 0120) = Ylds(t - 0120) * 2.9970 + C8440245(t - 0121) + C8440249(t - 0121); 
C8441309(t - 0179) = Ylds(t - 0179) * 54.6714 + C8441025(t - 0180) + C8441311(t - 0180); 
C5908459(t - 0235) = Ylds(t - 0235) * 0.3168 + C5908461(t - 0239) + C5908463(t - 0236); 
C5908733(t - 0230) = Ylds(t - 0230) * 4.5135 + C5908715(t - 0231) + C5908727(t - 0231); 
C8440311(t - 0118) = Ylds(t - 0118) * 3.1293 + C8440285(t - 0119) + C8440273(t - 0120); 
C8440995(t - 0169) = Ylds(t - 0169) * 13.5225 + C8441001(t - 0178) + C8441309(t - 0179); 
C5908453(t - 0234) = Ylds(t - 0234) * 2.8836 + C5908457(t - 0235) + C5908459(t - 0235); 
C5908751(t - 0227) = Ylds(t - 0227) * 2.8386 + C5908735(t - 0228) + C5908733(t - 0230); 
C8440313(t - 0116) = Ylds(t - 0116) * 0.7191 + C8440339(t - 0120) + C8440311(t - 0118); 
C8440987(t - 0165) = Ylds(t - 0165) * 2.1933 + C8440991(t - 0168) + C8440995(t - 0169); 
C5908443(t - 0233) = Ylds(t - 0233) * 0.1512 + C5908455(t - 0236) + C5908453(t - 0234); 
C5908753(t - 0226) = Ylds(t - 0226) * 0.1737 + C5908745(t - 0227) + C5908751(t - 0227); 
C8440331(t - 0115) = Ylds(t - 0115) * 1.1934 + C8440315(t - 0117) + C8440313(t - 0116); 
C8441291(t - 0164) = Ylds(t - 0164) * 68.1444 + C8441287(t - 0167) + C8440987(t - 0165); 
C5908285(t - 0225) = Ylds(t - 0225) * 2.6622 + C5908753(t - 0226); 
C5908441(t - 0232) = Ylds(t - 0232) * 4.5369 + C5908447(t - 0238) + C5908443(t - 0233); 
C8440357(t - 0114) = Ylds(t - 0114) * 3.9735 + C8440329(t - 0115) + C8440331(t - 0115); 
C8440921(t - 0153) = Ylds(t - 0153) * 2.7837 + C8440927(t - 0154) + C8441291(t - 0164); 
C5908419(t - 0230) = Ylds(t - 0230) * 2.0970 + C5908439(t - 0233) + C5908441(t - 0232); 
C5908803(t - 0224) = Ylds(t - 0224) * 0.1440 + C5908285(t - 0225); 
C8440367(t - 0112) = Ylds(t - 0112) * 0.6957 + C8440355(t - 0116) + C8440357(t - 0114); 
C8441279(t - 0151) = Ylds(t - 0151) * 7.9866 + C8440949(t - 0155) + C8440921(t - 0153); 
C5908299(t - 0223) = Ylds(t - 0223) * 0.0720 + C5908803(t - 0224); 
C5908415(t - 0229) = Ylds(t - 0229) * 4.7403 + C5908427(t - 0233) + C5908419(t - 0230); 
C8440399(t - 0111) = Ylds(t - 0111) * 2.0763 + C8440379(t - 0115) + C8440367(t - 0112); 
C8440901(t - 0148) = Ylds(t - 0148) * 4.8105 + C8440899(t - 0154) + C8441279(t - 0151); 
C5908303(t - 0222) = Ylds(t - 0222) * 8.4357 + C5908301(t - 0223) + C5908299(t - 0223); 
C5908785(t - 0228) = Ylds(t - 0228) * 0.0000 + C5908415(t - 0229); 
C8440413(t - 0108) = Ylds(t - 0108) * 0.1071 + C8440411(t - 0109) + C8440399(t - 0111); 
C8441271(t - 0147) = Ylds(t - 0147) * 0.2574 + C8440901(t - 0148) * 1/2; 
C8441275(t - 0148) = Ylds(t - 0148) * 1.8972 + C8440901(t - 0148) * 1/2; 
C5908319(t - 0221) = Ylds(t - 0221) * 5.4234 + C5908291(t - 0230) + C5908303(t - 0222); 
C5908783(t - 0227) = Ylds(t - 0227) * 18.2700 + C5908785(t - 0228); 
C8440749(t - 0107) = Ylds(t - 0107) * 0.1062 + C8440413(t - 0108); 
C8441273(t - 0146) = Ylds(t - 0146) * 15.8985 + C8441271(t - 0147) + C8441275(t - 0148); 
C5908331(t - 0219) = Ylds(t - 0219) * 1.1475 + C5908341(t - 0225) + C5908319(t - 0221); 
C5908405(t - 0226) = Ylds(t - 0226) * 5.4297 + C5908783(t - 0227); 
C8440417(t - 0106) = Ylds(t - 0106) * 1.3689 + C8440749(t - 0107); 
C8440841(t - 0136) = Ylds(t - 0136) * 6.4998 + C8441261(t - 0146) + C8441273(t - 0146); 
C5908335(t - 0218) = Ylds(t - 0218) * 0.5805 + C5908343(t - 0223) + C5908331(t - 0219); 
C5908393(t - 0224) = Ylds(t - 0224) * 1.7964 + C5908411(t - 0229) + C5908405(t - 0226); 
C8440755(t - 0105) = Ylds(t - 0105) * 4.8402 + C8440417(t - 0106); 
C8440829(t - 0132) = Ylds(t - 0132) * 6.0939 + C8441259(t - 0140) + C8440841(t - 0136); 
C5908389(t - 0223) = Ylds(t - 0223) * 1.1106 + C5908395(t - 0224) + C5908393(t - 0224); 
C5908809(t - 0217) = Ylds(t - 0217) * 0.0018 + C5908335(t - 0218); 
C8440813(t - 0128) = Ylds(t - 0128) * 0.1674 + C8440829(t - 0132) * 1/2; 
C8440815(t - 0128) = Ylds(t - 0128) * 0.2142 + C8440829(t - 0132) * 1/2; 
C5908383(t - 0222) = Ylds(t - 0222) * 0.0360 + C5908389(t - 0223) * 1/2; 
C5908385(t - 0222) = Ylds(t - 0222) * 0.0612 + C5908389(t - 0223) * 1/2; 
C5911273(t - 0216) = Ylds(t - 0216) * 7.0218 + C5908777(t - 0217) + C5908809(t - 0217); 
C8440817(t - 0127) = Ylds(t - 0127) * 16.8381 + C8440813(t - 0128) + C8440815(t - 0128); 
C5908381(t - 0221) = Ylds(t - 0221) * 0.4923 + C5908383(t - 0222) + C5908385(t - 0222); 
C5908759(t - 0213) = Ylds(t - 0213) * 0.9396 + C5908755(t - 0214) + C5911273(t - 0216); 
C8440801(t - 0119) = Ylds(t - 0119) * 9.4176 + C8440803(t - 0120) + C8440817(t - 0127); 
C5908375(t - 0220) = Ylds(t - 0220) * 10.2636 + C5908391(t - 0224) + C5908381(t - 0221); 
C5908771(t - 0212) = Ylds(t - 0212) * 1.0503 + C5908757(t - 0213) + C5908759(t - 0213); 
C8440791(t - 0115) = Ylds(t - 0115) * 5.9211 + C8440787(t - 0119) + C8440801(t - 0119); 
C5908601(t - 0218) = Ylds(t - 0218) * 20.6100 + C5908373(t - 0224) + C5908375(t - 0220); 
C8440781(t - 0111) = Ylds(t - 0111) * 0.2223 + C8440791(t - 0115) * 1/2; 
C8440783(t - 0112) = Ylds(t - 0112) * 0.3537 + C8440791(t - 0115) * 1/2; 
C5908775(t - 0215) = Ylds(t - 0215) * 1.0395 + C5908601(t - 0218); 
C8440777(t - 0110) = Ylds(t - 0110) * 6.7338 + C8440781(t - 0111) + C8440783(t - 0112); 
C5908327(t - 0214) = Ylds(t - 0214) * 2.3067 + C5908775(t - 0215); 
C8441347(t - 0109) = Ylds(t - 0109) * 13.4298 + C8440765(t - 0111) + C8440777(t - 0110); 
C5908323(t - 0213) = Ylds(t - 0213) * 4.5918 + C5908599(t - 0222) + C5908327(t - 0214); 
C8441253(t - 0106) = Ylds(t - 0106) * 11.4381 + C8441353(t - 0109) + C8441347(t - 0109); 
C5908773(t - 0212) = Ylds(t - 0212) * 0.0018 + C5908323(t - 0213); 
C8440763(t - 0103) = Ylds(t - 0103) * 15.6078 + C8440755(t - 0105) + C8441253(t - 0106); 
C5908769(t - 0211) = Ylds(t - 0211) * 0.1413 + C5908771(t - 0212) + C5908773(t - 0212); 
C8440761(t - 0101) = Ylds(t - 0101) * 0.3735 + C8441257(t - 0114) + C8440763(t - 0103); 
C5908765(t - 0210) = Ylds(t - 0210) * 0.3429 + C5908767(t - 0211) + C5908769(t - 0211); 
C8441255(t - 0100) = Ylds(t - 0100) * 14.5089 + C8440759(t - 0101) + C8440761(t - 0101); 
C5908761(t - 0209) = Ylds(t - 0209) * 6.5772 + C5908765(t - 0210) * 1/2; 
C5908763(t - 0211) = Ylds(t - 0211) * 0.0000 + C5908765(t - 0210) * 1/2; 
C8441331(t - 0095) = Ylds(t - 0095) * 0.0090 + C8441255(t - 0100); 
C5908307(t - 0210) = Ylds(t - 0210) * 2.6982 + C5908763(t - 0211); 
C5908747(t - 0208) = Ylds(t - 0208) * 0.1305 + C5908749(t - 0209) + C5908761(t - 0209); 
C5908739(t - 0207) = Ylds(t - 0207) * 0.0279 + C5908307(t - 0210); 
C5908741(t - 0209) = Ylds(t - 0209) * 0.0000 + C5908747(t - 0208) * 1/2; 
C5908743(t - 0207) = Ylds(t - 0207) * 0.0738 + C5908747(t - 0208) * 1/2; 
C5908283(t - 0207) = Ylds(t - 0207) * 1.2042 + C5908741(t - 0209); 
C5908737(t - 0206) = Ylds(t - 0206) * 0.5940 + C5908739(t - 0207) + C5908743(t - 0207); 
C5908731(t - 0206) = Ylds(t - 0206) * 0.0126 + C5908283(t - 0207); 
C5908729(t - 0205) = Ylds(t - 0205) * 11.3472 + C5908737(t - 0206) + C5908731(t - 0206); 
C5908723(t - 0204) = Ylds(t - 0204) * 18.8739 + C5908717(t - 0205) + C5908729(t - 0205); 
C5908705(t - 0200) = Ylds(t - 0200) * 0.0585 + C5908703(t - 0201) + C5908723(t - 0204); 
C5908699(t - 0199) = Ylds(t - 0199) * 4.8528 + C5908701(t - 0200) + C5908705(t - 0200); 
C5908695(t - 0198) = Ylds(t - 0198) * 0.3771 + C5908697(t - 0199) + C5908699(t - 0199); 
C5908817(t - 0197) = Ylds(t - 0197) * 2.9862 + C5908819(t - 0198) + C5908695(t - 0198); 
C5908683(t - 0196) = Ylds(t - 0196) * 10.0746 + C5908685(t - 0197) + C5908817(t - 0197); 
C5908677(t - 0194) = Ylds(t - 0194) * 1.3221 + C5908679(t - 0195) + C5908683(t - 0196); 
C5908669(t - 0193) = Ylds(t - 0193) * 0.9630 + C5908671(t - 0194) + C5908677(t - 0194); 
C5908667(t - 0192) = Ylds(t - 0192) * 4.6611 + C5908807(t - 0193) + C5908669(t - 0193); 
C5908649(t - 0193) = Ylds(t - 0193) * 0.0000 + C5908667(t - 0192) * 1/2; 
C5908657(t - 0191) = Ylds(t - 0191) * 3.1212 + C5908667(t - 0192) * 1/2; 
C5908185(t - 0192) = Ylds(t - 0192) * 0.4968 + C5908649(t - 0193); 
C5908655(t - 0191) = Ylds(t - 0191) * 0.0000 + C5908185(t - 0192); 
C5908659(t - 0190) = Ylds(t - 0190) * 0.0450 + C5908657(t - 0191) + C5908655(t - 0191); 
C5908661(t - 0189) = Ylds(t - 0189) * 0.2997 + C5908663(t - 0190) + C5908659(t - 0190); 
C5908651(t - 0188) = Ylds(t - 0188) * 2.0583 + C5908653(t - 0189) + C5908661(t - 0189); 
C5908643(t - 0187) = Ylds(t - 0187) * 2.4921 + C5908641(t - 0188) + C5908651(t - 0188); 
C5908637(t - 0186) = Ylds(t - 0186) * 6.6789 + C5908639(t - 0187) + C5908643(t - 0187); 
C5908631(t - 0185) = Ylds(t - 0185) * 1.4886 + C5908633(t - 0186) + C5908637(t - 0186); 
C5908627(t - 0184) = Ylds(t - 0184) * 0.2493 + C5908629(t - 0185) + C5908631(t - 0185); 
C5911303(t - 0183) = Ylds(t - 0183) * 6.0723 + C5908625(t - 0184) + C5908627(t - 0184); 
C5908623(t - 0182) = Ylds(t - 0182) * 2.1681 + C5908811(t - 0183) + C5911303(t - 0183); 
C5908619(t - 0180) = Ylds(t - 0180) * 2.3094 + C5908621(t - 0181) + C5908623(t - 0182); 
C5908617(t - 0179) = Ylds(t - 0179) * 0.5895 + C5908615(t - 0180) + C5908619(t - 0180); 
C5908611(t - 0178) = Ylds(t - 0178) * 5.3856 + C5908613(t - 0179) + C5908617(t - 0179); 
C5907199(t - 0177) = Ylds(t - 0177) * 14.6547 + C5908611(t - 0178); 
C5907197(t - 0174) = Ylds(t - 0174) * 3.4758 + C5907199(t - 0177); 
C5907189(t - 0172) = Ylds(t - 0172) * 7.1163 + C5907197(t - 0174); 
C5907193(t - 0171) = Ylds(t - 0171) * 8.7984 + C5907189(t - 0172); 
C5907191(t - 0170) = Ylds(t - 0170) * 16.2999 + C5907195(t - 0171) + C5907193(t - 0171); 
C5907185(t - 0168) = Ylds(t - 0168) * 16.3575 + C5907187(t - 0169) + C5907191(t - 0170); 
C5907183(t - 0166) = Ylds(t - 0166) * 3.2121 + C5907185(t - 0168); 
C5907181(t - 0165) = Ylds(t - 0165) * 0.2043 + C5907183(t - 0166); 
C5907177(t - 0164) = Ylds(t - 0164) * 3.6729 + C5907179(t - 0165) + C5907181(t - 0165); 
C5907175(t - 0163) = Ylds(t - 0163) * 15.8346 + C5907173(t - 0164) + C5907177(t - 0164); 
C5907171(t - 0161) = Ylds(t - 0161) * 3.2508 + C5907175(t - 0163); 
C5907167(t - 0159) = Ylds(t - 0159) * 23.3226 + C5907169(t - 0160) + C5907171(t - 0161); 
C5907161(t - 0156) = Ylds(t - 0156) * 40.3506 + C5907163(t - 0157) + C5907167(t - 0159); 
C5907157(t - 0149) = Ylds(t - 0149) * 37.6731 + C5907159(t - 0150) + C5907161(t - 0156); 
C5907155(t - 0144) = Ylds(t - 0144) * 1.2141 + C5907157(t - 0149); 
C5907153(t - 0143) = Ylds(t - 0143) * 5.8221 + C5907155(t - 0144); 
C5907143(t - 0142) = Ylds(t - 0142) * 0.3312 + C5907153(t - 0143); 
C5907145(t - 0141) = Ylds(t - 0141) * 0.6156 + C5907143(t - 0142); 
C5907149(t - 0140) = Ylds(t - 0140) * 1.4562 + C5907145(t - 0141); 
C5907147(t - 0139) = Ylds(t - 0139) * 1.7370 + C5907151(t - 0140) + C5907149(t - 0140); 
C5907141(t - 0138) = Ylds(t - 0138) * 0.5283 + C5907147(t - 0139); 
C5907139(t - 0137) = Ylds(t - 0137) * 0.5319 + C5907141(t - 0138); 
C5907137(t - 0136) = Ylds(t - 0136) * 11.1843 + C5907139(t - 0137); 
C5907133(t - 0134) = Ylds(t - 0134) * 11.8386 + C5907135(t - 0135) + C5907137(t - 0136); 
C5907131(t - 0131) = Ylds(t - 0131) * 3.4704 + C5907133(t - 0134); 
C5907127(t - 0130) = Ylds(t - 0130) * 13.5495 + C5907129(t - 0131) + C5907131(t - 0131); 
C5907125(t - 0128) = Ylds(t - 0128) * 0.6768 + C5907127(t - 0130); 
C5907123(t - 0127) = Ylds(t - 0127) * 13.3740 + C5907125(t - 0128); 
C5907119(t - 0124) = Ylds(t - 0124) * 0.3114 + C5907123(t - 0127); 
C5907117(t - 0123) = Ylds(t - 0123) * 0.3672 + C5907119(t - 0124); 
C5907121(t - 0122) = Ylds(t - 0122) * 2.8611 + C5907117(t - 0123); 
C5907115(t - 0121) = Ylds(t - 0121) * 0.2259 + C5907121(t - 0122); 
C5907113(t - 0120) = Ylds(t - 0120) * 0.2313 + C5907115(t - 0121); 
C5907111(t - 0119) = Ylds(t - 0119) * 3.7044 + C5907113(t - 0120); 
C5907109(t - 0118) = Ylds(t - 0118) * 0.2988 + C5907111(t - 0119); 
C5907107(t - 0117) = Ylds(t - 0117) * 0.3384 + C5907109(t - 0118); 
C5907099(t - 0116) = Ylds(t - 0116) * 1.9845 + C5907107(t - 0117); 
C5907093(t - 0115) = Ylds(t - 0115) * 8.6805 + C5907099(t - 0116); 
C5907081(t - 0114) = Ylds(t - 0114) * 0.1881 + C5907093(t - 0115); 
C5907087(t - 0113) = Ylds(t - 0113) * 1.3383 + C5907081(t - 0114); 
C5907089(t - 0112) = Ylds(t - 0112) * 0.0000 + C5907085(t - 0113) + C5907087(t - 0113); 
C5907097(t - 0111) = Ylds(t - 0111) * 0.5373 + C5907089(t - 0112); 
C5907103(t - 0110) = Ylds(t - 0110) * 1.5516 + C5907097(t - 0111); 
C5907105(t - 0109) = Ylds(t - 0109) * 3.3642 + C5907103(t - 0110); 
C5907101(t - 0108) = Ylds(t - 0108) * 0.8703 + C5907105(t - 0109); 
C5907091(t - 0107) = Ylds(t - 0107) * 0.3033 + C5907095(t - 0108) + C5907101(t - 0108); 
C5907083(t - 0106) = Ylds(t - 0106) * 16.9785 + C5907205(t - 0107) + C5907091(t - 0107); 
C5907075(t - 0103) = Ylds(t - 0103) * 0.8397 + C5907083(t - 0106); 
C5907077(t - 0102) = Ylds(t - 0102) * 0.5742 + C5907075(t - 0103); 
C5907079(t - 0101) = Ylds(t - 0101) * 20.9673 + C5907077(t - 0102); 
C5907071(t - 0098) = Ylds(t - 0098) * 0.0882 + C5907073(t - 0099) + C5907079(t - 0101); 
C5907069(t - 0097) = Ylds(t - 0097) * 3.9852 + C5907071(t - 0098); 
C5907067(t - 0096) = Ylds(t - 0096) * 0.1386 + C5907069(t - 0097); 
C5907065(t - 0095) = Ylds(t - 0095) * 2.0439 + C5907067(t - 0096); 
C8446522(t - 0094) = Ylds(t - 0094) * 0.0036 + C8441331(t - 0095) + C5907065(t - 0095); 
C8446526(t - 0093) = Ylds(t - 0093) * 1.2771 + C5907063(t - 0094) + C8446522(t - 0094); 
C8446520(t - 0092) = Ylds(t - 0092) * 13.5351 + C8446518(t - 0093) + C8446526(t - 0093); 
C8446506(t - 0087) = Ylds(t - 0087) * 1.0584 + C8446504(t - 0088) + C8446520(t - 0092); 
C8446508(t - 0086) = Ylds(t - 0086) * 0.4491 + C8446506(t - 0087); 
C8446512(t - 0085) = Ylds(t - 0085) * 3.5397 + C8446508(t - 0086); 
C8446510(t - 0084) = Ylds(t - 0084) * 0.1098 + C8446516(t - 0085) + C8446512(t - 0085); 
C8446514(t - 0083) = Ylds(t - 0083) * 19.6326 + C8446510(t - 0084); 
C8446500(t - 0080) = Ylds(t - 0080) * 9.3123 + C8446502(t - 0081) + C8446514(t - 0083); 
C8446496(t - 0079) = Ylds(t - 0079) * 7.5510 + C8446498(t - 0080) + C8446500(t - 0080); 
C8445602(t - 0077) = Ylds(t - 0077) * 0.0900 + C8446496(t - 0079); 
C8445600(t - 0076) = Ylds(t - 0076) * 0.0675 + C8445598(t - 0077) + C8445602(t - 0077); 
C8445616(t - 0075) = Ylds(t - 0075) * 2.2338 + C8445618(t - 0076) + C8445600(t - 0076); 
C8445644(t - 0074) = Ylds(t - 0074) * 2.5317 + C8445642(t - 0075) + C8445616(t - 0075); 
C8445612(t - 0072) = Ylds(t - 0072) * 1.7550 + C8445614(t - 0073) + C8445644(t - 0074); 
C8445608(t - 0071) = Ylds(t - 0071) * 0.0333 + C8445610(t - 0072) + C8445612(t - 0072); 
C8445604(t - 0070) = Ylds(t - 0070) * 0.0738 + C8445606(t - 0071) + C8445608(t - 0071); 
C8445632(t - 0069) = Ylds(t - 0069) * 3.0267 + C8445604(t - 0070); 
C8445628(t - 0067) = Ylds(t - 0067) * 0.0000 + C8445630(t - 0068) + C8445632(t - 0069); 
C8445282(t - 0066) = Ylds(t - 0066) * 0.0108 + C8445628(t - 0067); 
C8445276(t - 0065) = Ylds(t - 0065) * 0.1071 + C8445278(t - 0066) + C8445282(t - 0066); 
C8445272(t - 0064) = Ylds(t - 0064) * 0.1125 + C8445274(t - 0065) + C8445276(t - 0065); 
C8445268(t - 0063) = Ylds(t - 0063) * 3.0546 + C8445272(t - 0064) * 1/2; 
C8445270(t - 0071) = Ylds(t - 0071) * 0.0000 + C8445272(t - 0064) * 1/2; 
C8444926(t - 0070) = Ylds(t - 0070) * 3.0834 + C8445270(t - 0071); 
C8445262(t - 0064) = Ylds(t - 0064) * 0.0036 + C8444926(t - 0070); 
C8445264(t - 0063) = Ylds(t - 0063) * 0.0000 + C8445262(t - 0064); 
C8445266(t - 0062) = Ylds(t - 0062) * 1.8252 + C8445268(t - 0063) + C8445264(t - 0063); 
C8445622(t - 0061) = Ylds(t - 0061) * 0.0891 + C8445266(t - 0062); 
C8445620(t - 0060) = Ylds(t - 0060) * 2.0268 + C8445624(t - 0061) + C8445622(t - 0061); 
C8445260(t - 0059) = Ylds(t - 0059) * 0.9576 + C8445620(t - 0060); 
C8445258(t - 0058) = Ylds(t - 0058) * 0.4707 + C8445260(t - 0059); 
C8445256(t - 0057) = Ylds(t - 0057) * 0.3654 + C8445258(t - 0058); 
C8445254(t - 0056) = Ylds(t - 0056) * 0.2250 + C8445256(t - 0057); 
C8445250(t - 0055) = Ylds(t - 0055) * 0.2925 + C8445254(t - 0056); 
C8445248(t - 0054) = Ylds(t - 0054) * 0.3564 + C8445250(t - 0055); 
C8445252(t - 0053) = Ylds(t - 0053) * 1.0224 + C8445248(t - 0054); 
C8445246(t - 0052) = Ylds(t - 0052) * 0.8280 + C8445252(t - 0053); 
C8445238(t - 0051) = Ylds(t - 0051) * 0.0000 + C8445242(t - 0052) + C8445246(t - 0052); 
C8445236(t - 0050) = Ylds(t - 0050) * 2.4192 + C8445238(t - 0051); 
C8445234(t - 0048) = Ylds(t - 0048) * 0.4491 + C8445236(t - 0050); 
C8445228(t - 0047) = Ylds(t - 0047) * 0.1836 + C8445230(t - 0048) + C8445234(t - 0048); 
C8445222(t - 0046) = Ylds(t - 0046) * 0.6687 + C8445224(t - 0047) + C8445228(t - 0047); 
C8445212(t - 0045) = Ylds(t - 0045) * 0.3051 + C8445214(t - 0046) + C8445222(t - 0046); 
C8445218(t - 0044) = Ylds(t - 0044) * 2.9133 + C8445210(t - 0045) + C8445212(t - 0045); 
C8445220(t - 0043) = Ylds(t - 0043) * 1.4976 + C8445218(t - 0044); 
C8445216(t - 0042) = Ylds(t - 0042) * 0.4194 + C8445220(t - 0043); 
C8445208(t - 0041) = Ylds(t - 0041) * 0.1782 + C8445216(t - 0042); 
C8445204(t - 0040) = Ylds(t - 0040) * 1.0926 + C8445206(t - 0041) + C8445208(t - 0041); 
C8445202(t - 0039) = Ylds(t - 0039) * 0.1053 + C8445204(t - 0040); 
C8445200(t - 0038) = Ylds(t - 0038) * 0.0378 + C8445202(t - 0039); 
C8445196(t - 0037) = Ylds(t - 0037) * 1.9629 + C8445198(t - 0038) + C8445200(t - 0038); 
C8445190(t - 0036) = Ylds(t - 0036) * 1.5903 + C8445192(t - 0037) + C8445196(t - 0037); 
C8445184(t - 0035) = Ylds(t - 0035) * 0.5598 + C8445186(t - 0036) + C8445190(t - 0036); 
C8445178(t - 0034) = Ylds(t - 0034) * 2.6046 + C8445180(t - 0035) + C8445184(t - 0035); 
C8445174(t - 0033) = Ylds(t - 0033) * 1.2969 + C8445176(t - 0034) + C8445178(t - 0034); 
C8445168(t - 0032) = Ylds(t - 0032) * 0.0432 + C8445170(t - 0033) + C8445174(t - 0033); 
C8445164(t - 0031) = Ylds(t - 0031) * 0.6084 + C8445168(t - 0032) * 1/2; 
C8445166(t - 0033) = Ylds(t - 0033) * 0.0000 + C8445168(t - 0032) * 1/2; 
C8444816(t - 0032) = Ylds(t - 0032) * 1.5570 + C8445166(t - 0033); 
C8445162(t - 0031) = Ylds(t - 0031) * 0.0000 + C8444816(t - 0032); 
C8445160(t - 0030) = Ylds(t - 0030) * 0.2241 + C8445164(t - 0031) + C8445162(t - 0031); 
C8445154(t - 0029) = Ylds(t - 0029) * 0.0927 + C8445156(t - 0030) + C8445160(t - 0030); 
C8445152(t - 0028) = Ylds(t - 0028) * 0.1116 + C8445158(t - 0029) + C8445154(t - 0029); 
C8445148(t - 0027) = Ylds(t - 0027) * 1.2897 + C8445150(t - 0028) + C8445152(t - 0028); 
C8445142(t - 0026) = Ylds(t - 0026) * 0.2466 + C8445144(t - 0027) + C8445148(t - 0027); 
C8445138(t - 0025) = Ylds(t - 0025) * 0.7767 + C8445140(t - 0026) + C8445142(t - 0026); 
C8445132(t - 0024) = Ylds(t - 0024) * 1.9827 + C8445134(t - 0025) + C8445138(t - 0025); 
C8445128(t - 0023) = Ylds(t - 0023) * 8.1225 + C8445130(t - 0024) + C8445132(t - 0024); 
C8445122(t - 0020) = Ylds(t - 0020) * 4.2795 + C8445124(t - 0021) + C8445128(t - 0023); 
C8445106(t - 0019) = Ylds(t - 0019) * 0.0054 + C8445104(t - 0020) + C8445122(t - 0020); 
C8445108(t - 0018) = Ylds(t - 0018) * 0.0702 + C8445106(t - 0019); 
C8445110(t - 0017) = Ylds(t - 0017) * 0.8307 + C8445108(t - 0018); 
C8445118(t - 0016) = Ylds(t - 0016) * 0.5769 + C8445110(t - 0017); 
C8445120(t - 0015) = Ylds(t - 0015) * 0.7317 + C8445118(t - 0016); 
C8445112(t - 0014) = Ylds(t - 0014) * 5.5413 + C8445114(t - 0015) + C8445120(t - 0015); 
C8445100(t - 0012) = Ylds(t - 0012) * 0.0009 + C8445102(t - 0013) + C8445112(t - 0014); 
C8445098(t - 0011) = Ylds(t - 0011) * 0.0072 + C8445100(t - 0012); 
C8445096(t - 0010) = Ylds(t - 0010) * 4.2939 + C8445098(t - 0011); 
C8445088(t - 0009) = Ylds(t - 0009) * 0.1224 + C8445096(t - 0010); 
C8445090(t - 0008) = Ylds(t - 0008) * 0.4149 + C8445088(t - 0009); 
C8445092(t - 0007) = Ylds(t - 0007) * 2.1546 + C8445094(t - 0008) + C8445090(t - 0008); 
C8445086(t - 0006) = Ylds(t - 0006) * 0.4518 + C8445092(t - 0007); 
C8445084(t - 0005) = Ylds(t - 0005) * 0.0045 + C8445082(t - 0006) + C8445086(t - 0006); 
C8445080(t - 0004) = Ylds(t - 0004) * 0.6390 + C8445084(t - 0005); 
C8445074(t - 0003) = Ylds(t - 0003) * 0.0045 + C8445076(t - 0004) + C8445080(t - 0004); 
C8445072(t - 0002) = Ylds(t - 0002) * 0.0927 + C8445074(t - 0003); 
C8445070(t - 0001) = Ylds(t - 0001) * 0.8649 + C8445072(t - 0002); 
    if mod(t,96)==0
        annotation('rectangle','Units','pixels','FaceColor',...
            [0.5 0.5 0.5],'Position',[775,110,183*t/nSim,15]);
        drawnow;
    end
end
%% Save results
% setappdata(hUFinchGUI,'floOut',floOut);
% setappdata(hUFinchGUI,'tDelay',tDelay);
setappdata(hUFinchGUI,'nSim',nSim');
setappdata(hUFinchGUI,'maxTTime',maxTTime);
% setappdata(hUFinchGUI,'aCatch',aCatch);
setappdata(hUFinchGUI,'tbeg',tbeg);
setappdata(hUFinchGUI,'tend',tend);
setappdata(hUFinchGUI,'sYrMoDaHrMn',sYrMoDaHrMn);
setappdata(hUFinchGUI,'eYrMoDaHrMn',eYrMoDaHrMn);
% setappdata(hUFinchGUI,'seqComID',seqComID);
setappdata(hUFinchGUI,'Ylds',Ylds);
% Store results for each flowline computation in the handle memory
for i = 1:nEqn
    eval(['setappdata(hUFinchGUI,','''C',num2str(ComID(i)),''',C',num2str(ComID(i)),');']);
end

% 
% Plot the flows at the most downstream flowline
figure(5); clf(5);
plot(timeVec(tbeg:tend),...
    flowVec( tbeg:tend),'r-');
datetick('x');
gageName   = getappdata(hUFinchGUI,'gageName');
gageNumber = getappdata(hUFinchGUI,'gageNumber');
title(strcat('Unit flows at ',gageNumber,' ',gageName));
%
hold on
% plot(timeVec(tbeg:tend-maxTTime-96),...
%       floOut(maxTTime+96+1:nSim,end),'b:','MarkerSize',2);
% Select the floOut index that corresponds to the most downstream flowline
%    ComID of the most downstream flowline is ComID(end)
% ndxComID has the ComIDs in the same order as floOut
% endComIDndx = find(seqComID == ComID(end));
%
maxTTime = 548;
plot(timeVec(tbeg:tend-maxTTime),...
      C8445070(maxTTime-1:nSim-2),'b:','MarkerSize',2);
xlabel('Date');
ylabel('Flow, in cubic feet per second');
legend('Measured','Simulated');
hold off
set(handles.computeUnitFlowsPB,'BackgroundColor',[0.83,0.82,0.78]);

function startCompHrET_Callback(hObject, eventdata, handles)
% hObject    handle to startCompHrET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startCompHrET as text
%        str2double(get(hObject,'String')) returns contents of startCompHrET as a double


% --- Executes during object creation, after setting all properties.
function startCompHrET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startCompHrET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startCompMnET_Callback(hObject, eventdata, handles)
% hObject    handle to startCompMnET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startCompMnET as text
%        str2double(get(hObject,'String')) returns contents of startCompMnET as a double


% --- Executes during object creation, after setting all properties.
function startCompMnET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startCompMnET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endCompHrET_Callback(hObject, eventdata, handles)
% hObject    handle to endCompHrET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endCompHrET as text
%        str2double(get(hObject,'String')) returns contents of endCompHrET as a double


% --- Executes during object creation, after setting all properties.
function endCompHrET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endCompHrET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endCompMnET_Callback(hObject, eventdata, handles)
% hObject    handle to endCompMnET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endCompMnET as text
%        str2double(get(hObject,'String')) returns contents of endCompMnET as a double


% --- Executes during object creation, after setting all properties.
function endCompMnET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endCompMnET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in usgsLogo.
function usgsLogo_Callback(hObject, eventdata, handles)
% hObject    handle to usgsLogo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function usgsLogo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to usgsLogo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
USGSlogo = imread('UsgsLogo168x62_black.jpg');
set(hObject,'CData',USGSlogo);


% --- Executes on button press in SaveComputedFlowsPB.
function SaveComputedFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to SaveComputedFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
hUFinchGUI = getappdata(0,'hUFinchGUI');
% a vector of ComID for all flowlines in the analysis
ComID           = getappdata(hUFinchGUI,'ComID');
% seqComID is the ComID in the order they were processed
% seqComID        = getappdata(hUFinchGUI,'seqComID');
% LevelPathSet
% LevelPathSet    = getappdata(hUFinchGUI,'LevelPathSet');
% ComIDLPS extracted from LevelPathSet 
% ComIDLPS        = reshape([LevelPathSet.ComID],length(ComID),1);
% gageComID is the ComID of the flowline at the downstream gage
gageComID       = getappdata(hUFinchGUI,'gageComID');
% gageNumber is the USGS station number of the streamgage
gageNumber      = getappdata(hUFinchGUI,'gageNumber');
% gageName is the USGS station name
gageName        = getappdata(hUFinchGUI,'gageName');
% an nSim x length(ComID) matrix of computed flows at all flowlines 
% floOut          = getappdata(hUFinchGUI,'floOut');
% timeVec is the 15-min vector for all measured flow
timeVec         = getappdata(hUFinchGUI,'timeVec');
% flowVec is the 15-min vector of measured flow, commonly from daily values
flowVec         = getappdata(hUFinchGUI,'flowVec');
% minTTime is the maximum travel time from tDelay
minTTime        = getappdata(hUFinchGUI,'minTTime');
% maxTTime is the maximum travel time from tDelay
maxTTime        = getappdata(hUFinchGUI,'maxTTime');
% tDelay is a vector of time delays, 15-min intervals, for all flowlines
ttNetwork       = getappdata(hUFinchGUI,'ttNetwork');
% nSim is the number of time steps simulated in the analysis
nSim            = getappdata(hUFinchGUI,'nSim');
% tbeg is the specified beginning of the simulation
tbeg            = getappdata(hUFinchGUI,'tbeg');
% tend is the specified ending of the simulation
tend            = getappdata(hUFinchGUI,'tend');
% HR is the hydrologic region of the analysis
HR              = getappdata(hUFinchGUI,'HR');
% StreamGageEvent contains info on the streamgages
StreamGageEvent = getappdata(hUFinchGUI,'StreamGageEvent');
% Get start time
sYrMoDaHrMn     = getappdata(hUFinchGUI,'sYrMoDaHrMn');
% Get end time
eYrMoDaHrMn     = getappdata(hUFinchGUI,'eYrMoDaHrMn');
%
nEqn            = length(ComID);
% Retrieve results for each flowline computation from handle memory
for i = 1:nEqn
    eval(['C',num2str(ComID(i)),' = getappdata(hUFinchGUI,','''C',num2str(ComID(i)),''');']);
end
%
% filename of output file
fName = strcat(gageNumber,...
               '_b',datestr(sYrMoDaHrMn,'yyyy_mm_dd_HH_MM'),...
               '_e',datestr(eYrMoDaHrMn,'yyyy_mm_dd_HH_MM'));
pName = strcat('..\..\..\Data\UFinch\',HR,'\FlowData\Model\');
% output fullname
oName = fullfile(pName,fName);
save(oName);
set(handles.SaveComputedFlowsPB,'BackgroundColor',[0.83,0.82,0.78]);
% Reset color of button to compute flows for another simulation
set(handles.computeUnitFlowsPB,'BackgroundColor', [0.93,0.93,0.93]);
% Reset color of Computation Progress Bar to default color
annotation('rectangle','Units','pixels','FaceColor',...
    [0.93 0.93 0.93],'Position',[775,110,183,15]);
drawnow;
fprintf(1,'Output saved in Matlab format as %s \n', fullfile(pName,fName));
