% UFinchGUIv2a reads a NHDFlowline (shapefile), a StreamGageEvent
% (shapefile), and an AFINCH formatted water-use data and displays
% flowlines color-coded by water use for the specified year and month.
% Streamgage locations are displayed and color-coded for activity status on
% the selected year and month.
%
function varargout = UFinchGUIv2a(varargin)
% UFINCHGUIV2A MATLAB code for UFinchGUIv2a.fig
%      UFINCHGUIV2A, by itself, creates a new UFINCHGUIV2A or raises the existing
%      singleton*.
%
%      H = UFINCHGUIV2A returns the handle to a new UFINCHGUIV2A or the handle to
%      the existing singleton*.
%
%      UFINCHGUIV2A('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UFINCHGUIV2A.M with the given input arguments.
%
%      UFINCHGUIV2A('Property','Value',...) creates a new UFINCHGUIV2A or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UFinchGUIv2a_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UFinchGUIv2a_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UFinchGUIv2a

% Last Modified by GUIDE v2.5 07-May-2014 16:06:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @UFinchGUIv2a_OpeningFcn, ...
    'gui_OutputFcn',  @UFinchGUIv2a_OutputFcn, ...
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
% --- Executes just before UFinchGUIv2a is made visible.
function UFinchGUIv2a_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UFinchGUIv2a (see VARARGIN)

% Choose default command line output for UFinchGUIv2a
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


% UIWAIT makes UFinchGUIv2a wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = UFinchGUIv2a_OutputFcn(hObject, eventdata, handles)
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
A = importdata([pname,fname]);
% % process A to get needed data fields
hUFinchGUI = getappdata(0,'hUFinchGUI');
             setappdata(hUFinchGUI,'A',A);
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
A           = getappdata(hUFinchGUI,'A');
% Identify column contents by header
ndxComID = find(strncmpi(A.colheaders,'ComID',length('ComID')));
ndxLenKm = find(strncmpi(A.colheaders,'LengthKm',length('LengthKm')));
ndxSlevl = find(strncmpi(A.colheaders,'StreamLeve',length('StreamLeve')));
ndxFNode = find(strncmpi(A.colheaders,'FromNode',length('FromNode')));
ndxTNode = find(strncmpi(A.colheaders,'ToNode',length('ToNode')));
ndxHSequ = find(strncmpi(A.colheaders,'HydroSeq',length('HydroSeq')));
ndxLPath = find(strncmpi(A.colheaders,'LevelPathI',length('LevelPathI')));
% ndxSFlag = find(strncmpi(A.colheaders,'"startFlag"',length('"startFlag"')));
ndxAreaM = find(strncmpi(A.colheaders,'AreaSqKm',length('AreaSqKm')));
% ndxMave  = find(strncmpi(A.colheaders,'MaVelU',4));
ndxV001c = find(strncmpi(A.colheaders,'V0001c',length('V0001c')));
ndxV001e = find(strncmpi(A.colheaders,'V0001e',length('V0001e')));
% Replace data structure with data.
A           = A.data;
% Sort rows of A by HydroSeq in decreasing (-) order.
% A          = cell2mat(A);
A          = sortrows(A,-ndxHSequ);
ComID      = A(:, ndxComID);
LengthKm   = A(:, ndxLenKm);
AreaSqKm   = A(:, ndxAreaM);
fprintf('%8.1f\n',min(AreaSqKm));
fprintf('%8.1f\n',max(AreaSqKm));
% V0001c     = A(:, ndxV001c);
% V0001e     = A(:, ndxV001e);
% MaVelU is the mean velocity metric selected 
MaVelU      = A(:, ndxV001c);
% 
StreamLeve = A(:, ndxSlevl);
FromNode   = A(:, ndxFNode);
ToNode     = A(:, ndxTNode);
HydroSeq   = A(:, ndxHSequ);
LevelPathI = A(:, ndxLPath);
% startFlag  = A(:, ndxSFlag);
%
% store results in 
setappdata(hUFinchGUI,'ComID',      ComID);
setappdata(hUFinchGUI,'LengthKm',   LengthKm);
setappdata(hUFinchGUI,'AreaSqKm',   AreaSqKm);
setappdata(hUFinchGUI,'MaVelU',     MaVelU);
% setappdata(hUFinchGUI,'V0001c',     V00001c);
% setappdata(hUFinchGUI,'V0001e',     V00001e);
setappdata(hUFinchGUI,'StreamLeve', StreamLeve);
setappdata(hUFinchGUI,'FromNode',   FromNode);
setappdata(hUFinchGUI,'ToNode',     ToNode);
setappdata(hUFinchGUI,'HydroSeq',   HydroSeq);
setappdata(hUFinchGUI,'LevelPathI', LevelPathI);
setappdata(hUFinchGUI,'A',          A);
%
nLevels          = range(StreamLeve);
minStreamLevel   = min(StreamLeve);
maxStreamLevel   = max(StreamLeve);
% fprintf(1,'Netork %s has stream levels %u through %u.\n',...
%     NetName{:},minStreamLevel,maxStreamLevel);
%
%% Compute the number of flowlines in each LevelPath
nComID     = length(ComID);
% Structure variable LevelPathSet contains summary of travel time info
LevelPathSet      = struct('ComID',{},'LengthKm',{},'AreaSqKm',{},'MaVelU',{},...
    'StreamLeve',{},'FromNode',{},'ToNode',{},'HydroSeq',{},...
    'LevelPathI',{},'StartFlag',{},'TT',{},'CumTT',{});
%
% Unique level paths (branches) in network
uLevelPath = unique(LevelPathI);
% Number of unique level paths (branches)
nLevelPath = length(uLevelPath);
% Count flowlines in each level path
ndash = 70;
fprintf(1,['\n',repmat('-',1,ndash),'\n']);
fprintf(1,'      Stream LevelPath  Number of                         \n');
fprintf(1,'Index Level  Identifier flowlines ComIDs of flowlines in LevelPath ... \n');
fprintf(1,[repmat('-',1,ndash),'\n']);
for i = 1:nLevelPath,
    Ndx = find(LevelPathI==uLevelPath(i));
    fprintf(1,[' %3u   %3u   %10u   %3u   ',repmat('%10u',1,length(Ndx)),'\n'],...
        i,StreamLeve(Ndx(1)),uLevelPath(i),length(HydroSeq(Ndx)),ComID(Ndx));
end
fprintf(1,[repmat('-',1,ndash),'\n\n']);
%
%% Compute travel times for each flowline
% Wave celerity (c) is the speed at which a flood wave travels donwstream
%   http://www.hydrocad.net/pdf/Merkel-MC-paper.pdf
%   c = m V, where V is the average velocity in ft/s, and m = 5/3.
% The number of 15-min time steps required for a flood wave to travel a
% 1-km long reach when the water is flowing at 1 ft/s is 2.1872.
% Thus, 1*km / (1*ft/s * 5/3) / 15*min = 2.1872
%
tt = NaN(nComID,1);
ndash  = 45;
fprintf(1,[repmat('-',1,ndash),'\n']);
fprintf(1,'                                      Travel    \n');
fprintf(1,'                 Flowline    Mean     time in   \n');
fprintf(1,'                 length,in  velocity  15-min    \n');
fprintf(1,'Index   ComID    kilometers  ft/s     steps     \n');
fprintf(1,[repmat('-',1,ndash),'\n']);
for i = 1:nComID,
    % The constant 2.18723 converts 1*km/(1*fps * 5/3) into 15-min units
    tt(i) = LengthKm(i) / MaVelU(i) * 2.18723;
    fprintf(1,' %3u %10u  %7.3f  %8.4f  %7.2f \n',...
        i,ComID(i),LengthKm(i),MaVelU(i),tt(i));
end
fprintf(1,[repmat('-',1,ndash),'\n\n']);
%
%% Compute local cumulative travel times by LevelPath
%   Local implies that travel times from downstream Level Paths are not
%   acuumulated. Travel times are in 15-min time steps
%
fprintf(1,'Local Cumulative Travel Times by Level Paths. \n');
ndash  = 76;
fprintf(1,[repmat('-',1,ndash),'\n']);
fprintf(1,'                                                Travel  Rounded  Cumulative\n');
fprintf(1,'                                        MaVelU   Time    Time      Travel  \n');
fprintf(1,'Index LevelPath     ComID    LengthKm    (fps) (15-min) (15-min)    Time   \n');
fprintf(1,[repmat('-',1,ndash),'\n']);
%
for i = 1:nLevelPath;
    ndxi = find(LevelPathI==uLevelPath(i));
    lndxi = length(ndxi);
    LevelPathSet(i).LevelPathI = num2str(LevelPathI(ndxi(1)));
    LevelPathSet(i).StreamLeve =         StreamLeve(ndxi(1));
    % cumtt = 0;
    for j=lndxi:-1:1,
        if round(tt(ndxi(j)))==0
            CumTT(ndxi(j)) = round(sum(tt(ndxi(lndxi:-1:j)))) + 1;
            RndTT(ndxi(j)) =                                    1;
        else
            CumTT(ndxi(j)) = round(sum(tt(ndxi(lndxi:-1:j))));
            RndTT(ndxi(j)) = round(    tt(ndxi(         j))) ;
        end
        % Store results in structure variables
        % LevelPathSet(i).LevelPathI(j) = LevelPathI(ndxi(j));
        LevelPathSet(i).ComID(j)      = ComID(ndxi(j));
        LevelPathSet(i).LengthKm(j)   = LengthKm(ndxi(j));
        LevelPathSet(i).AreaSqKm(j)   = AreaSqKm(ndxi(j));
        LevelPathSet(i).FromNode{j}   = num2str(FromNode(ndxi(j)));
        LevelPathSet(i).ToNode{j}     = num2str(ToNode(ndxi(j)));
        LevelPathSet(i).MaVelU(j)     = MaVelU(ndxi(j));
        LevelPathSet(i).HydroSeq{j}   = num2str(HydroSeq(ndxi(j)));
        %        LevelPathSet(i).MaFlowU(j)    = MaFlowU(ndxi(j));
        LevelPathSet(i).TT(j)         = tt(   ndxi(j));
        LevelPathSet(i).RndTT(j)      = RndTT(ndxi(j));
        LevelPathSet(i).CumTT(j)      = CumTT(ndxi(j));
        %
        fprintf(1,' %3u  %10u %10u %7.3f   %8.4f  %6.2f   %6.0f   %6.0f  \n',...
            i,LevelPathI(ndxi(j)),ComID(ndxi(j)),LengthKm(ndxi(j)),MaVelU(ndxi(j)),...
            tt(ndxi(j)),RndTT(ndxi(j)),CumTT(ndxi(j)));
    end
    fprintf(1,'\n');
end
%
%% Accumulate travel times along the network by stream level
% Clear the command window
% clc;
fprintf(1,'Travel times along the main stem of stream network.\n\n');
% Flowlines are ordered from the headwaters (1) to the mouth (nLevelPath1);
% Starting at the mouth and working upstream to the headwaters
ndash = 85;
fprintf(1,['\n',repmat('-',1,ndash),'\n']);
fprintf(1,'                         Flow-                     Streams   Inter-    Receiving   \n');
fprintf(1,' Stream  --Level Path--  line                      in con-   secting   Reach Travel \n');
fprintf(1,' Level   Sequence   ID   Index  ComID    FromNode  fluence   LevelPath Time (15 min)\n');
fprintf(1,[repmat('-',1,ndash),'\n']);
%
LevelPathCum = [];
% Analyze each streamlevel
for g = minStreamLevel:maxStreamLevel;
    ndxLevelPath = find([LevelPathSet.StreamLeve]==g);
    % Number of level paths at stream level
    nLevelPath_StreamLevel = length(ndxLevelPath);
    % Analyze each level path within the streamlevel
    LevelPathSL = []; ndxLevelPath2 = [];
    % LevelPath = NaN(nLevelPath_StreamLevel,1);
    for h = 1:nLevelPath_StreamLevel,
        % Identify the level path being analyzed
        LevelPathSL = str2num(LevelPathSet(1,ndxLevelPath(h)).LevelPathI);
        % Identify all flowlines within the hth level path
        FlowLineT  = LevelPathSet(1,ndxLevelPath(h)).ComID;
        % The number of flowlines in the hth level path.
        nFlowLineT = length(LevelPathSet(1,ndxLevelPath(h)).ComID);
        %
        % Find the complementary set to the main stem
        % Indices of all flowlines not on the hth path level
        [~,NdxCSL1] = setdiff(LevelPathI,[LevelPathCum LevelPathSL]);
        %
        % Analyze all flowlines within the level path of the stream level
        for i = nFlowLineT:-1:1,
            % Store FromNode for each flowline along the main stem
            ndx1 = find(ToNode(NdxCSL1)==...
                str2double(LevelPathSet(1,ndxLevelPath(h)).FromNode{i}));
            % ID the target level path discharging to the receiving reach
            % If found, display the LevelPathI of the branch
            if ~isempty(ndx1)
                TargetLevelPath = LevelPathI(NdxCSL1(ndx1));
                for j = 1:length(TargetLevelPath)
                    % fprintf(1,' %5u %10u %5u ',i,TargetLevelPath(j),ndx1(j));
                    
                    LevelPathSL = [LevelPathSL TargetLevelPath(j)];
                    % Store the receiving reach cumulate travel time (rrctt)
                    rrctt = LevelPathSet(1,ndxLevelPath(h)).CumTT(i);
                    % fprintf(1,'  %6u \n',rrctt);
                    % Add the rrctt to all flowlines in the affected levelpath
                    %
                    % Find the LevelPathSet for the TargetLevelPath
                    % I'm not sure what this really does
                    for k = 1:nLevelPath
                        if TargetLevelPath(j) == ...
                                str2num(LevelPathSet(1,k).LevelPathI)
                            % Add rrctt to all flowlines in the levelpath
                            LevelPathSet(1,k).CumTT = ...
                                LevelPathSet(1,k).CumTT + rrctt;
                            ndxLevelPath2 = [ndxLevelPath2 k];
                        end
                    end
                    fprintf(1,'%5u %5u %11s %4u %9u %11s %5u    %11u  %6u \n',...
                        g,h,...
                        LevelPathSet(1,ndxLevelPath(h)).LevelPathI,...
                        i,...
                        LevelPathSet(1,ndxLevelPath(h)).ComID(i),...
                        LevelPathSet(1,ndxLevelPath(h)).FromNode{i},...
                        j,TargetLevelPath(j),...
                        LevelPathSet(1,ndxLevelPath(h)).CumTT(i));
                end
            end
        end
    end
    % Cumulates level paths in each Stream Level
    LevelPathCum = [LevelPathCum LevelPathSL];
end
setappdata(hUFinchGUI,'LevelPathSet',LevelPathSet);
minTTime = min([LevelPathSet.CumTT]);
maxTTime = max([LevelPathSet.CumTT]);
timeVec  = getappdata(hUFinchGUI,'timeVec');
setappdata(hUFinchGUI,'maxTTime',maxTTime);
setappdata(hUFinchGUI,'RndTT',RndTT);
setappdata(hUFinchGUI,'CumTT',CumTT);
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
    '.uFlo']},'Open Shapefile for Selected Streamgage');
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
% flowDesign is the flowline design matrix
flowDesign = eye(nEqn,nEqn);
% aCatch is a vector of catchment drainage areas
aCatch     = zeros(nEqn,1);
% ndxEqn is an index for the current equation
ndxEqn     = 0;
% tDelay = is vector of time delays
tDelay     = zeros(nEqn,1);
% seqComID is the ComID in order that they are processed
seqComID   = zeros(nEqn,1);
% strLevel is the streamlevel associated with a reach
strLevel   = zeros(nEqn,1);
%
%% Initialize nEqn, ComID-tagged variables for flow
for i = 1:nEqn
    eval(['C',num2str(ComID(i)),' = nan(nSim,1);']);
end
%
% Compute yields
Ylds   = flowVec(tbeg-maxTTime-1:tend) ./ sum(AreaSqKm);
% 
% 
% % Find highest and lowest Steam level
% StreamLevelMax = max([LevelPathSet.StreamLeve]);
% StreamLevelMin = min([LevelPathSet.StreamLeve]);
% %
% % Indices of StreamLevelMax
% StreamLevelNdx1  = find([LevelPathSet.StreamLeve]==StreamLevelMax);
% % nSteamLevelMaxNdx = length(SteamLevelMaxNdx);
% % Generate code for the highest order stream levels
% for i = 1:length(StreamLevelNdx1)
%     j = 1;
%     ndxEqn = ndxEqn + 1;
%     nFlowline = length(LevelPathSet(StreamLevelNdx1(i)).ComID);
%     EqnName   = ['C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j))];
%     seqComID(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).ComID(j);
%     EqnForm   = ['C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j)),...
%             '(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j),'%03u'),...
%             ') = Ylds(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j),'%03u'),...
%             ') * ',num2str(LevelPathSet(StreamLevelNdx1(i)).AreaSqKm(j),'%6.3f')];
%     % flowDesign(ndxEqn,ndxComID) = 1;
%     tDelay(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).CumTT(j);
%     aCatch(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).AreaSqKm(j);
%     strLevel(ndxEqn) = StreamLevelMax;
%     eval([EqnName ' = EqnForm;']);
%     fprintf(1,'i=%d, j=%d\n\n%s\n',i,j,[eval(EqnName),';']);
%     for j = 2:nFlowline
% %         EqnName = ['C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j))];
% %         EqnForm = ['C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j)),...
% %             '(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j),'%03u'),...
% %             ') = Ylds(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j),'%03u'),...
% %             ') * ',num2str(LevelPathSet(StreamLevelNdx1(i)).AreaSqKm(j),'%6.3f'),...
% %             ' + C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j-1)),...
% %             '(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j-1),'%03u'),')'];
%         % EvalStr = [eval(EqnName) EqnForm];
%         ndxComID = find(LevelPathSet(StreamLevelNdx1(i)).ComID(j-1)==seqComID);
%         ndxEqn = ndxEqn + 1;
%         seqComID(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).ComID(j);
%         flowDesign(ndxEqn,ndxComID) = 1;
%         tDelay(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).CumTT(j);
%         aCatch(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).AreaSqKm(j);
%         strLevel(ndxEqn) = StreamLevelMax;
%         %
%         %  eval([EqnName '= EqnForm ;']);
%         % fprintf(1,'%s \n',[eval(EqnName),';']);
%     end
% end
% %
% %% Generate code for all remaining stream levels 
% % 
% for h = StreamLevelMax-1:-1:StreamLevelMin,
%     %
%     StreamLevelNdx0 = find([LevelPathSet.StreamLeve]==h);
%     % Find terminal ToNodes for maximum stream level flowlines.
%     for i = 1:length(StreamLevelNdx1)
%         nFl= length([LevelPathSet(StreamLevelNdx1(i)).ComID]);
%         ToNodeTerm = LevelPathSet(StreamLevelNdx1(i)).ToNode(nFl);
%         % Find matching FromNodes in downstream level path
%         for j = 1:length(StreamLevelNdx0)
%             % Form a string containing the flowline name
%             % Search all flow lines along
%             MatchFlowLineNdx = find(strcmp(ToNodeTerm,[LevelPathSet(StreamLevelNdx0(j)).FromNode]));
%             if ~isempty(MatchFlowLineNdx)
%                 % Replaced statement below with statement above Apr. 22, 2014 djh
%             % if ~isnan(MatchFlowLineNdx)
%                 if length(MatchFlowLineNdx)>2
%                     fprintf(1,'Length MatchFlowLineNdx= %u.\n',length(MatchFlowLineNdx));
%                 end
%                 EqnName =  ['C',num2str(LevelPathSet(StreamLevelNdx0(j)).ComID(MatchFlowLineNdx))];
%                 EqnForm = ['C',num2str(LevelPathSet(StreamLevelNdx0(j)).ComID(MatchFlowLineNdx)),...
%                     '(t-',num2str(LevelPathSet(StreamLevelNdx0(j)).CumTT(MatchFlowLineNdx),'%03u'),')',...
%                     ' = C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(nFl)),'(t-',...
%                     num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(nFl),'%03u'),')'];
%                 EvalStr = EqnForm; 
%                 eval([EqnName ' = EvalStr;']);
%                 % fprintf(1,'%s \n',EqnForm);
%             end
%         end
%     end
%     %
%     %% Cycle through all level streams and generate code
% %
%     for i = 1:length(StreamLevelNdx0)
%         % 
%         % nFl= length([LevelPathSet(StreamLevelNdx0(i)).ComID]);
%         j = 1;
%         % The first flowline in the LevelPathSet is at the headwaters of the level path
%         EqnName  = ['C',num2str(LevelPathSet(StreamLevelNdx0(i)).ComID(j))];
%         EqnFormY = ['C',num2str(LevelPathSet(StreamLevelNdx0(i)).ComID(j)),...
%             '(t-',num2str(LevelPathSet(StreamLevelNdx0(i)).CumTT(j),'%03u'),...
%             ') = Ylds(t-',num2str(LevelPathSet(StreamLevelNdx0(i)).CumTT(j),'%03u'),...
%             ') * ',num2str(LevelPathSet(StreamLevelNdx0(i)).AreaSqKm(j),'%6.3f')];
%         if exist(EqnName,'var'),
%             % Find string and beginning and ending positions
%             EqnValue = eval(EqnName);
%             strbeg   = strfind(EqnValue,'=');
%             strend   =  length(EqnValue);
%             % Concatenate the string
%             EqnFormT = [EqnFormY,' + ',EqnValue(strbeg+1:strend)];
%         else
%             EqnFormT = [EqnFormY];
%         end
%             eval([EqnName ' =  EqnFormT;']);
%         %
%         ndxComID = find(LevelPathSet(StreamLevelNdx0(i)).ComID(j)==seqComID);
%         ndxEqn = ndxEqn + 1;
%         seqComID(ndxEqn) = LevelPathSet(StreamLevelNdx0(i)).ComID(j);
%         flowDesign(ndxEqn,ndxComID) = 1;
%         tDelay(ndxEqn) = LevelPathSet(StreamLevelNdx0(i)).CumTT(j);
%         aCatch(ndxEqn) = LevelPathSet(StreamLevelNdx0(i)).AreaSqKm(j);
%         strLevel(ndxEqn) = h;
%         %
%         fprintf(1,'%s\n',[eval(EqnName),';']);
%         % Continue downstream along level path to evaluate all flowlines
%         for j = 2:length(LevelPathSet(StreamLevelNdx0(i)).ComID)
%             % Form a string containing the flowline name
%             EqnName  = ['C',num2str(LevelPathSet(StreamLevelNdx0(i)).ComID(j))];
%             % Compute the yield*area to the flowline
%             EqnFormY = ['C',num2str(LevelPathSet(StreamLevelNdx0(i)).ComID(j)),...
%                 '(t-',num2str(LevelPathSet(StreamLevelNdx0(i)).CumTT(j),'%03u'),...
%                 ') = Ylds(t-',num2str(LevelPathSet(StreamLevelNdx0(i)).CumTT(j),'%03u'),...
%                 ') * ',num2str(LevelPathSet(StreamLevelNdx0(i)).AreaSqKm(j),'%6.3f')];
%             % 
%             ndxEqn = ndxEqn + 1;
%             seqComID(ndxEqn) = LevelPathSet(StreamLevelNdx0(i)).ComID(j);
%             tDelay(ndxEqn)   = LevelPathSet(StreamLevelNdx0(i)).CumTT(j);
%             aCatch(ndxEqn)   = LevelPathSet(StreamLevelNdx0(i)).AreaSqKm(j);
%             strLevel(ndxEqn) = h;
%             ndxComID =  find(LevelPathSet(StreamLevelNdx0(i)).ComID(j-1)==seqComID);
%             flowDesign(ndxEqn,ndxComID) = 1;
%             % Pick up flow from upstream flowline
%             EqnFormT = [' + C',num2str(LevelPathSet(StreamLevelNdx0(i)).ComID(j-1)),...
%                 '(t-',num2str(LevelPathSet(StreamLevelNdx0(i)).CumTT(j-1),'%03u'),')'];
%             % Match ComID to current flowline equation
%             FlowlineNdx = find(ComID==str2num(EqnName(2:end)));
%             % Find the FromNode for the target (current) flowline
%             FromNodeTrg = FromNode(FlowlineNdx);
%             % Find all ToNodes that match the FromNode
%             ToNodeNdx   = find(ToNode==FromNodeTrg);
%             % Null the variable that concatenates the contributing flows
%             % EqnFormT    = [];
%             % Loop over all ToNodes contributing to the flowline
%             % ADJUSTMENT FOR MID-ATLANTIC REGION 02
%             % for m = 2:length(ToNodeNdx)
%             for m = 2:length(ToNodeNdx)
%                 % Find the level path for the mth contributing flowline
%                 LevelPathNdx = find(strcmp({LevelPathSet.LevelPathI},...
%                     num2str(LevelPathI(ToNodeNdx(m)))));
%                 CumTTm   = LevelPathSet(LevelPathNdx).CumTT(end);
%                 EqnFormT = [EqnFormT,' + C',num2str(ComID(ToNodeNdx(m)),'%u'),'(t-',...
%                     num2str(CumTTm,'%03u'),')'];
%                 ndxComID = find(ComID(ToNodeNdx(m))==seqComID);
%                 flowDesign(ndxEqn,ndxComID) = 1;
%             end
%             EqnStr = [EqnFormY,EqnFormT]; 
%             eval([EqnName ' = EqnStr;']);
%             fprintf(1,'%s;\n',eval(EqnName));
%         end
%         % Evaluate next level path
%     end
%     StreamLevelNdx1 = StreamLevelNdx0;
% end
% %
% %% Compute flow estimates for each catchment
% %
% runOff = 1e-5*ones(nSim,nEqn);
% fprintf('%6.0f\n',tbeg);
% fprintf('%6.0f\n',maxTTime);
% fprintf('%6.0f\n',tend);
% fprintf('%12.1f\n',sum(AreaSqKm));
% Ylds   = flowVec(tbeg-maxTTime-1:tend) ./ sum(AreaSqKm);
% %
% for t=1+maxTTime:nSim
%     for s=1:nEqn,
%         runOff(t-tDelay(s),s) = Ylds(t-tDelay(s)) .* aCatch(s);
%     end
% end
% %
% flowOffDiag = flowDesign - eye(size(flowDesign));
% %% Combine catchment flows using a matrix approach
% floOut = 1e-15*ones(nSim,nEqn);
% floVec      = zeros(nEqn,1);
% annotation('rectangle','Units','pixels','FaceColor',...
%     [0.831 0.816 0.784],'Position',[775,110,183,15]);
% drawnow;
%
fprintf(1,'Max travel time is %u \n',maxTTime);
maxTTime = 104;
for t=1+maxTTime:nSim
    %     for s=1:nEqn,
    %         floOut(t-tDelay(s),s) = ...
    %             sum(floVec(find(flowOffDiag(s,1:s)))) + ...
    %             + runOff(t-tDelay(s),s);
    %         floVec(s) = floOut(t-tDelay(s),s);
    %     end
    C5908933(t - 0098) = Ylds(t - 0098) * 12.5901;
    C5908935(t - 0095) = Ylds(t - 0095) * 5.8041;
    C5908999(t - 0045) = Ylds(t - 0045) * 21.9906;
    C5909003(t - 0053) = Ylds(t - 0053) * 8.0874;
    C5909023(t - 0045) = Ylds(t - 0045) * 27.5220;
    C5909053(t - 0084) = Ylds(t - 0084) * 8.4573;
    C5909061(t - 0096) = Ylds(t - 0096) * 37.1430;
    C5909165(t - 0070) = Ylds(t - 0070) * 45.5346;
    C5909167(t - 0063) = Ylds(t - 0063) * 17.5176;
    C5909169(t - 0067) = Ylds(t - 0067) * 27.0180;
    C5909171(t - 0067) = Ylds(t - 0067) * 33.2469;
    C5909173(t - 0103) = Ylds(t - 0103) * 59.4693;
    C5909005(t - 0048) = Ylds(t - 0048) * 11.2716 + C5909165(t - 0070) + C5909167(t - 0063);
    C5909011(t - 0047) = Ylds(t - 0047) * 6.2280 + C5909003(t - 0053);
    C5909019(t - 0048) = Ylds(t - 0048) * 2.8836 + C5909169(t - 0067) + C5909171(t - 0067);
    C5909041(t - 0076) = Ylds(t - 0076) * 28.8207 + C5909053(t - 0084);
    C5909157(t - 0086) = Ylds(t - 0086) * 42.7707 + C5908933(t - 0098) + C5908935(t - 0095);
    C5909187(t - 0075) = Ylds(t - 0075) * 4.9392 + C5909173(t - 0103);
    C5909009(t - 0039) = Ylds(t - 0039) * 3.6261 + C5909005(t - 0048) + C5909011(t - 0047);
    C5909031(t - 0074) = Ylds(t - 0074) * 9.2349 + C5909187(t - 0075);
    C5909185(t - 0070) = Ylds(t - 0070) * 1.7028 + C5909157(t - 0086);
    C5908983(t - 0068) = Ylds(t - 0068) * 2.9565 + C5909185(t - 0070);
    C5909029(t - 0068) = Ylds(t - 0068) * 12.8970 + C5909061(t - 0096) + C5909031(t - 0074);
    C5909021(t - 0054) = Ylds(t - 0054) * 4.9599 + C5909041(t - 0076) + C5909029(t - 0068);
    C5909183(t - 0065) = Ylds(t - 0065) * 1.6083 + C5908983(t - 0068);
    C5908981(t - 0064) = Ylds(t - 0064) * 0.1134 + C5909183(t - 0065);
    C5909017(t - 0045) = Ylds(t - 0045) * 9.0756 + C5909019(t - 0048) + C5909021(t - 0054);
    C5909007(t - 0036) = Ylds(t - 0036) * 5.2146 + C5909009(t - 0039) + C5909017(t - 0045);
    C5909159(t - 0063) = Ylds(t - 0063) * 36.7821 + C5908981(t - 0064);
    C5909001(t - 0030) = Ylds(t - 0030) * 7.9803 + C5909023(t - 0045) + C5909007(t - 0036);
    C5909163(t - 0031) = Ylds(t - 0031) * 11.2545 + C5908999(t - 0045) + C5909159(t - 0063);
    C5909161(t - 0024) = Ylds(t - 0024) * 41.2839 + C5909001(t - 0030) + C5909163(t - 0031);
    if mod(t,96)==0
        annotation('rectangle','Units','pixels','FaceColor',...
            [0.5 0.5 0.5],'Position',[775,110,183*t/nSim,15]);
        drawnow;
    end
end
%% Save results
% setappdata(hUFinchGUI,'floOut',floOut);
setappdata(hUFinchGUI,'tDelay',tDelay);
setappdata(hUFinchGUI,'nSim',nSim');
setappdata(hUFinchGUI,'maxTTime',maxTTime);
setappdata(hUFinchGUI,'aCatch',aCatch);
setappdata(hUFinchGUI,'tbeg',tbeg);
setappdata(hUFinchGUI,'tend',tend);
setappdata(hUFinchGUI,'sYrMoDaHrMn',sYrMoDaHrMn);
setappdata(hUFinchGUI,'eYrMoDaHrMn',eYrMoDaHrMn);
setappdata(hUFinchGUI,'seqComID',seqComID);
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
endComIDndx = find(seqComID == ComID(end));
%
plot(timeVec(tbeg:tend-maxTTime),...
      C5909161(maxTTime-1:nSim-2),'b:','MarkerSize',2);
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
seqComID        = getappdata(hUFinchGUI,'seqComID');
% LevelPathSet
LevelPathSet    = getappdata(hUFinchGUI,'LevelPathSet');
% ComIDLPS extracted from LevelPathSet 
ComIDLPS        = reshape([LevelPathSet.ComID],length(ComID),1);
% gageComID is the ComID of the flowline at the downstream gage
gageComID       = getappdata(hUFinchGUI,'gageComID');
% gageNumber is the USGS station number of the streamgage
gageNumber      = getappdata(hUFinchGUI,'gageNumber');
% gageName is the USGS station name
gageName        = getappdata(hUFinchGUI,'gageName');
% an nSim x length(ComID) matrix of computed flows at all flowlines 
floOut          = getappdata(hUFinchGUI,'floOut');
% timeVec is the 15-min vector for all measured flow
timeVec         = getappdata(hUFinchGUI,'timeVec');
% flowVec is the 15-min vector of measured flow, commonly from daily values
flowVec         = getappdata(hUFinchGUI,'flowVec');
% maxTTime is the maximum travel time from tDelay
maxTTime        = getappdata(hUFinchGUI,'maxTTime');
% tDelay is a vector of time delays, 15-min intervals, for all flowlines
tDelay          = getappdata(hUFinchGUI,'tDelay');
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
% Cumulative rounded travel time
CumTT           = getappdata(hUFinchGUI,'CumTT');
% Incremental rounded travel time
RndTT           = getappdata(hUFinchGUI,'RndTT');
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
