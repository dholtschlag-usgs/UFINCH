% UFinchGUIv2c reads a NHDFlowline (shapefile), a StreamGageEvent
% (shapefile), and an AFINCH formatted water-use data and displays
% flowlines color-coded by water use for the specified year and month.
% Streamgage locations are displayed and color-coded for activity status on
% the selected year and month.
%
function varargout = UFinchGUIv2c(varargin)
% UFINCHGUIV2C MATLAB code for UFinchGUIv2c.fig
%      UFINCHGUIV2C, by itself, creates a new UFINCHGUIV2C or raises the existing
%      singleton*.
%
%      H = UFINCHGUIV2C returns the handle to a new UFINCHGUIV2C or the handle to
%      the existing singleton*.
%
%      UFINCHGUIV2C('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UFINCHGUIV2C.M with the given input arguments.
%
%      UFINCHGUIV2C('Property','Value',...) creates a new UFINCHGUIV2C or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UFinchGUIv2c_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UFinchGUIv2c_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UFinchGUIv2c

% Last Modified by GUIDE v2.5 19-Sep-2014 15:02:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @UFinchGUIv2c_OpeningFcn, ...
    'gui_OutputFcn',  @UFinchGUIv2c_OutputFcn, ...
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
% --- Executes just before UFinchGUIv2c is made visible.
function UFinchGUIv2c_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UFinchGUIv2c (see VARARGIN)

% Choose default command line output for UFinchGUIv2c
handles.output = hObject;

% Update handles structure
set(handles.ActiveLayerButtonGroup,'SelectionChangeFcn',@ActiveLayerButtonGroup_SelectionChangeFcn);

% Setup hUFinchGUI link
setappdata(0, 'hUFinchGUI', gcf);
% Link hUFinchGUI workspace
hUFinchGUI = getappdata(0,'hUFinchGUI');
setappdata(hUFinchGUI,'in4digit',1);
setappdata(hUFinchGUI,'originalFmt',1);

% annotation('rectangle','Units','pixels','FaceColor',...
%     [0.831 0.816 0.784],'Position',[765,255,183,15]);

set(handles.hydroRegionPanel,'BackgroundColor',[0.93 0.93 0.93]);
guidata(hObject, handles);


% UIWAIT makes UFinchGUIv2c wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = UFinchGUIv2c_OutputFcn(hObject, eventdata, handles)
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
% Populate listbox with station numbers in plot flows at Streamgage panel

guidata(hObject,handles);
set(handles.OpenStreamgageShapefilePB,'BackgroundColor',[0.83,0.82,0.78]);

%
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
headerlinesIn = 1; delimiterIn = ',';
nhdStruct     = importdata([pname,fname],delimiterIn,headerlinesIn);
% % process A to get needed data fields
hUFinchGUI = getappdata(0,'hUFinchGUI');
             setappdata(hUFinchGUI,'nhdStruct',nhdStruct);
             setappdata(hUFinchGUI,'fname',fname);
             setappdata(hUFinchGUI,'pname',pname);
StreamGageEvent = getappdata(hUFinchGUI,'StreamGageEvent');             
% 
% Find common common ComIDs and indices of streamgages in active area
% Assumes the ComID is first column of the nhdStruct.data matrix
[gageComID,ndxComID] = intersect([StreamGageEvent.ComID],[nhdStruct.data(:,1)]);
% Populate streamgage listbox with gage numbers
set(handles.plotFlowsAtStreamgageLB,'String',...
    sort({StreamGageEvent(ndxComID).SOURCE_FEA}));
set(handles.numGagesInNetworkST,'String',num2str(length(gageComID)));
% 
% Store ComID where network streamgages are located
setappdata(hUFinchGUI,'gageComID',gageComID);
set(handles.gageTopologyST,'String',[pname,fname]);
set(handles.networkGeometryPB,'BackgroundColor',[0.83,0.82,0.78]);

% --- Executes on button press in travelTimesPB.
function travelTimesPB_Callback(hObject, eventdata, handles)
% hObject    handle to travelTimesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI  = getappdata(0,'hUFinchGUI');
nhdStruct   = getappdata(hUFinchGUI,'nhdStruct');
fname       = getappdata(hUFinchGUI,'fname');
%
% Identify column contents by header
ndxComID = find(strncmpi(nhdStruct.colheaders,'ComID',length('ComID')));
ndxLenKm = find(strncmpi(nhdStruct.colheaders,'LengthKm',length('LengthKm')));
ndxSlevl = find(strncmpi(nhdStruct.colheaders,'StreamLeve',length('StreamLeve')));
ndxFNode = find(strncmpi(nhdStruct.colheaders,'FromNode',length('FromNode')));
ndxTNode = find(strncmpi(nhdStruct.colheaders,'ToNode',length('ToNode')));
ndxHSequ = find(strncmpi(nhdStruct.colheaders,'HydroSeq',length('HydroSeq')));
ndxLPath = find(strncmpi(nhdStruct.colheaders,'LevelPathI',length('LevelPathI')));
% ndxSFlag = find(strncmpi(A.colheaders,'"startFlag"',length('"startFlag"')));
ndxAreaM = find(strncmpi(nhdStruct.colheaders,'AreaSqKm',length('AreaSqKm')));
% ndxMave  = find(strncmpi(A.colheaders,'MaVelU',4));
ndxV001c = find(strncmpi(nhdStruct.colheaders,'V0001c',length('V0001c')));
ndxV001e = find(strncmpi(nhdStruct.colheaders,'V0001e',length('V0001e')));
% Replace data structure with data.
nhdMatrix  = nhdStruct.data;
% Sort rows of A by HydroSeq in decreasing (-) order.
nhdMatrix  = sortrows(nhdMatrix,[ndxLPath,ndxHSequ]);
ComID      = nhdMatrix(:, ndxComID);
LengthKm   = nhdMatrix(:, ndxLenKm);
AreaSqKm   = nhdMatrix(:, ndxAreaM);
fprintf('AreaSqKm of Catchments: min = %8.4f %8.3f\n',min(AreaSqKm),max(AreaSqKm));
% V0001c     = A(:, ndxV001c);
% V0001e     = A(:, ndxV001e);
% MaVelU is the mean velocity metric selected 
MaVelU     = nhdMatrix(:, ndxV001c);
% 
StreamLeve = nhdMatrix(:, ndxSlevl);
FromNode   = nhdMatrix(:, ndxFNode);
ToNode     = nhdMatrix(:, ndxTNode);
HydroSeq   = nhdMatrix(:, ndxHSequ);
LevelPathI = nhdMatrix(:, ndxLPath);
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
setappdata(hUFinchGUI,'nhdMatrix',  nhdMatrix);
setappdata(hUFinchGUI,'nhdStruct',  nhdStruct);
%
% nLevels          = range(StreamLeve);
% minStreamLevel   = min(StreamLeve);
% maxStreamLevel   = max(StreamLeve);
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
%% Compute travel times in flowlines, branches, and network
% Compute travel times for each flowline
% Wave celerity (c) is the speed at which a flood wave travels donwstream
%   http://www.hydrocad.net/pdf/Merkel-MC-paper.pdf
%   c = m V, where V is the average velocity in ft/s, and m = 5/3.
% The number of 15-min time steps required for a flood wave to travel a
% 1-km long reach when the water is flowing at 1 ft/s is 2.1872.
% Thus, 1*km / (1*ft/s * 5/3) / 15*min = 2.1872
% 
% Get velocity adjustment factor from VelocityAdjustmentET
velAdj = str2num(get(handles.VelocityAdjustmentET,'String'));
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
    % Experimentin with high (*2) velocity
    ttFlowline(i) = max(1,floor(LengthKm(i) / (MaVelU(i)*velAdj) * 2.18723));
    fprintf(1,' %3u  %12u  %10u  %7.3f  %8.4f  %9.4f \n',...
        i,LevelPathI(i),ComID(i),LengthKm(i),MaVelU(i),ttFlowline(i));
end
fprintf(1,[repmat('-',1,ndash),'\n\n']);
% 
% Identify flowlines associated with each branch
% Determine how many branches there are in the network
nBranch = length(unique(LevelPathI));
fprintf(1,'%s \n',['There are ',num2str(nBranch),' branches in the ',fname,' network.']);
%
% Allocate vector for branch and reach identifiers
branchID      = nan(nBranch,5);
% Allocate vector for cum
ttBranch      = zeros(nFlowlines,1);
% Initialize branch as first LevelPathI
j             =  1;
iBranch       =  LevelPathI(j);
% ttBranch(j)   =  max(1,round(ttFlowline(j)));
ttBranch(j)   =  max(1,floor(ttFlowline(j)));
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
sBranchIDTable = sortrows(branchIDTable,'HydroSeq','descend');
%
% sorted travel time in network vector
sttNetwork = sort(ttNetwork);
%
setappdata(hUFinchGUI,'LevelPathSet',LevelPathSet);
minTTime = min(ttNetwork);
maxTTime = max(ttNetwork);
timeVec  = getappdata(hUFinchGUI,'timeVec');
setappdata(hUFinchGUI,'maxTTime',maxTTime);
setappdata(hUFinchGUI,'ttNetwork',ttNetwork);
setappdata(hUFinchGUI,'sBranchIDTable',sBranchIDTable);
setappdata(hUFinchGUI,'sttNetwork',sttNetwork);
%
fprintf(1,'Min 15-Min: %u, Max 15-min: %u Min Days: %f Max Days: %f \n',...
    minTTime,maxTTime,minTTime/96,maxTTime/96);
set(handles.traveltimeTable,'Data',[minTTime maxTTime;minTTime/96 maxTTime/96]);
% set(handles.startCompYearET,'String',datestr(timeVec(maxTTime+1),'yyyy'));
% set(handles.startCompMoET,'String',datestr(timeVec(maxTTime+1),'mm'));
% set(handles.startCompDayET,'String',datestr(timeVec(maxTTime+1),'dd'));
% set(handles.startCompHrET,'String',datestr(timeVec(maxTTime+1),'HH'));
% set(handles.startCompMnET,'String',datestr(timeVec(maxTTime+1),'MM'));
% nCompStep = str2double(get(handles.nTimeStepsST,'String')) - maxTTime;
% set(handles.nCompStepsST,'String',num2str(nCompStep));
set(handles.travelTimesPB,'BackgroundColor',[0.83,0.82,0.78]);

% --- Executes on button press in read15FlowPB.
function read15FlowPB_Callback(hObject, eventdata, handles)
% hObject    handle to read15FlowPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gageNumber      = get(handles.GageNumberST,'String');
[fname, pname]  = uigetfile({['..\',handles.HR,'\FlowData\',gageNumber,...
    '.uFlo*']},'Open Shapefile for Selected Streamgage');
set(handles.file15flowST,'String',[pname,fname]);
fid = fopen([pname,fname],'rt');
%
Q       = cell2mat(textscan(fid,'%f %f %f %f %f %f','Delimiter',',',...
    'CommentStyle','#'));
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
% LevelPathSet = getappdata(hUFinchGUI,'LevelPathSet');
flowVec      = getappdata(hUFinchGUI,'flowVec');
timeVec      = getappdata(hUFinchGUI,'timeVec');
maxTTime     = getappdata(hUFinchGUI,'maxTTime');
% Reset color of save computed flows button
set(handles.SaveComputedFlowsPB,'BackgroundColor',[0.93,0.93,0.93]);
%
% LevelPathSet   = getappdata(hUFinchGUI,'LevelPathSet');
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
vYrMoDaHrMn    = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
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
ComID          = getappdata(hUFinchGUI,'ComID');
% AreaSqKm       = getappdata(hUFinchGUI,'AreaSqKm');
% FromNode       = getappdata(hUFinchGUI,'FromNode');
% ToNode         = getappdata(hUFinchGUI,'ToNode');
% LevelPathI     = getappdata(hUFinchGUI,'LevelPathI');
ttNetwork      = getappdata(hUFinchGUI,'ttNetwork');
sBranchIDTable = getappdata(hUFinchGUI,'sBranchIDTable');
% sttNetwork     = getappdata(hUFinchGUI,'sttNetwork');
drAreaSqKm       = sBranchIDTable.AreaSqKm;
% trvlTimeInt      = sBranchIDTable.ttNetwork;
srtNdxID         = sBranchIDTable.Flowline;
% srtComID         = sBranchIDTable.ComID;


% nComID is the number of equations or flowlines he network
nComID     = length(ComID);
%
%% Initialize nComID, ComID-tagged variables for flow
% Allocate vector to describe flow partioning: 1=>convergent, 1=< divergent
flowPart = ones(nComID,1); % Initialize to convergening flowlines
% Allocate vector to describe the number of upstream tributaries
nUSTribs   = zeros(nComID,1);
% Allocate structure variable to contain indices of upstream tribs
USTribSet  = struct('ndxID',[]);
% Compute yields
Ylds       = flowVec(tbeg-maxTTime-1:tend) ./ sum(drAreaSqKm);
% Allocate big matrix to contain unit flows
qndxIDtDelay = zeros(nComID,nSim);
%
for i = 1:nComID,
    % Identify convergent (length(ndxCon)>1) and connected flowlines
    ndxCon = find(sBranchIDTable.FromNode(i) == sBranchIDTable.ToNode)  ;
    % Identifies divergent branches (length(ndxDiv>1)) 
    ndxDiv = find(sBranchIDTable.FromNode(i) == sBranchIDTable.FromNode);
    % Store the number of tribs
    nUSTribs(i) = length(ndxCon);
    % Set usFlowlines variable to empty
    usFlowlines = [];
%    if ~isempty(ndx)   
% Uncomment the next four lines to get full output
    fprintf(1,'%8u(%s) ',i,num2str(sBranchIDTable.ttNetwork(i),'%04u'));
    if  isempty(ndxCon) && length(ndxDiv) == 1
        fprintf(1,'\n');
    end
    if ~isempty(ndxCon) && length(ndxDiv) == 1 
        for j = 1:length(ndxCon)
            fprintf(1,'%8u(%s) ',ndxCon(j),num2str(sBranchIDTable.ttNetwork(ndxCon(j)),'%04u'));
            usFlowlines = [usFlowlines,' + C',num2str(sBranchIDTable.ComID(ndxCon(j))),...
                '(t - ',num2str(sBranchIDTable.ttNetwork(ndxCon(j)),'%04u'),')'];
            USTribSet(i).ndxID(j) = ndxCon(j);
        end
       fprintf(1,'\n');
    elseif ~isempty(ndxCon) && length(ndxDiv) > 1 
        flowPart(i) = length(ndxDiv);
        for j = 1:length(ndxCon)
            fprintf(1,'%8u(%04u) %8u(%04u)/%u.\n',i,sBranchIDTable.ttNetwork(i),...
                 ndxCon(j),sBranchIDTable.ttNetwork(ndxCon(j)),length(ndxDiv));
            USTribSet(i).ndxID(j) = ndxCon(j);
        end        
    end
end
%
%%
hWaitbar = waitbar(0,'Simulating unit flows in the network...');
% tic
for t = max(ttNetwork)+1:nSim,        % time frame for solution
    for i = 1:nComID,  % nComID is the number of flowlines in the system
        qndxIDtDelay(srtNdxID(i),t-ttNetwork(i)) = ...
            Ylds(t-ttNetwork(i)) * drAreaSqKm(i) ;
        for k = 1:nUSTribs(i),   % number of
            if isempty(USTribSet(i).ndxID);
                break;
            elseif isempty(USTribSet(i).ndxID)
            end
            qndxIDtDelay(srtNdxID(i), t-ttNetwork(i)) = ...
                qndxIDtDelay(srtNdxID(i), t-ttNetwork(i)) + ...
                qndxIDtDelay(srtNdxID(USTribSet(i).ndxID(k)),...
                t-ttNetwork(USTribSet(i).ndxID(k))) / flowPart(i);
        end
    end
    if mod(t,96)==0
        fracComplete = t/nSim;
        waitbar(fracComplete,hWaitbar);
    end
end
%
% Close the waitbar to signal that computation is done.
close(hWaitbar);
%
set(handles.computeDailyPB,'BackgroundColor',[0.83,0.82,0.78]);
setappdata(hUFinchGUI,'qndxIDtDelay',qndxIDtDelay);
setappdata(hUFinchGUI,'nSim',nSim');
setappdata(hUFinchGUI,'maxTTime',maxTTime);
setappdata(hUFinchGUI,'tbeg',tbeg);
setappdata(hUFinchGUI,'tend',tend);
setappdata(hUFinchGUI,'sYrMoDaHrMn',sYrMoDaHrMn);
setappdata(hUFinchGUI,'eYrMoDaHrMn',eYrMoDaHrMn);
setappdata(hUFinchGUI,'vYrMoDaHrMn',vYrMoDaHrMn);

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
nComID            = length(ComID);
% Retrieve results for each flowline computation from handle memory
for i = 1:nComID
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


% --- Executes on slider movement.
function VelocityAdjustmentSlider_Callback(hObject, eventdata, handles)
% hObject    handle to VelocityAdjustmentSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
VelAdjust = get(hObject,'Value');
set(handles.VelocityAdjustmentET,'String',num2str(VelAdjust));

% --- Executes during object creation, after setting all properties.
function VelocityAdjustmentSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VelocityAdjustmentSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function VelocityAdjustmentET_Callback(hObject, eventdata, handles)
% hObject    handle to VelocityAdjustmentET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VelocityAdjustmentET as text
%        str2double(get(hObject,'String')) returns contents of VelocityAdjustmentET as a double
VelAdjust = get(hObject,'String');
set(handles.computeDailyPB,'BackgroundColor',[0.93,0.93,0.93]);
set(handles.VelocityAdjustmentSlider,'Value',str2num(VelAdjust));
set(handles.VelocityAdjustmentSlider,'String',VelAdjust);

% --- Executes during object creation, after setting all properties.
function VelocityAdjustmentET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VelocityAdjustmentET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in writeEqnPB.
function writeEqnPB_Callback(hObject, eventdata, handles)
% hObject    handle to writeEqnPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Generate equations: 
fprintf(1,'Listing equations to console.\n');
% Get handle to memory variables 
hUFinchGUI     = getappdata(0,'hUFinchGUI');
% Get memory variables
sBranchIDTable = getappdata(hUFinchGUI,'sBranchIDTable');
 ComID         = getappdata(hUFinchGUI,'ComID');
nComID         = length(ComID);
%
for i = 1:nComID,
    % This statement takes care of one or more (convergent) flowlines with
    % no divergent flowlines 
    % Identify convergent (length(ndxCon)>1) and connected flowlines
    ndxCon = find(sBranchIDTable.FromNode(i) == sBranchIDTable.ToNode)  ;
    % Identifies divergent branches (length(ndxDiv>1)) 
    ndxDiv = find(sBranchIDTable.FromNode(i) == sBranchIDTable.FromNode);
    usFlowlines = [];
%    if ~isempty(ndx)   
    if ~isempty(ndxCon) && length(ndxDiv) == 1 
        for j = 1:length(ndxCon)
            usFlowlines = [usFlowlines,' + C',num2str(sBranchIDTable.ComID(ndxCon(j))),...
                '(t - ',num2str(sBranchIDTable.ttNetwork(ndxCon(j)),'%04u'),')'];
        end
    elseif ~isempty(ndxCon) && length(ndxDiv) > 1 
        for j = 1:length(ndxCon)
            usFlowlines = [usFlowlines,' + C',num2str(sBranchIDTable.ComID(ndxCon(j))),...
                '(t - ',num2str(sBranchIDTable.ttNetwork(ndxCon(j)),'%04u'),')' , ...
                ' * 1/',num2str(length(ndxDiv),'%u')];
        end        
    end
    % This statement takes care of two or more divergent flowlines
    
    fprintf(1,'%s \n',['C',num2str(sBranchIDTable.ComID(i)),...
        '(t - ',num2str(sBranchIDTable.ttNetwork(i),'%04u'),') = Ylds',...
        '(t - ',num2str(sBranchIDTable.ttNetwork(i),'%04u'),') * ',...
        num2str(sBranchIDTable.AreaSqKm(i),'%9.4f'),...
        usFlowlines,';']);
end
%
% --- Executes on button press in computeDailyPB.
function computeDailyPB_Callback(hObject, eventdata, handles)
% hObject    handle to computeDailyPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Use grpstats to average unit to daily values
% 
hUFinchGUI     = getappdata(0,'hUFinchGUI');
% Get memory variables
qndxIDtDelay   = getappdata(hUFinchGUI,'qndxIDtDelay');
ComID          = getappdata(hUFinchGUI,'ComID');
vYrMoDaHrMn    = getappdata(hUFinchGUI,'vYrMoDaHrMn');
% Compute grouping variable of date
grpDate        = cellstr(datestr(vYrMoDaHrMn,'yyyymmdd'));
dayMeans       = grpstats(qndxIDtDelay',grpDate,'mean');
%
varComID       = num2str(ComID);
% Prepend a 'C' to the ComID so that it looks like a string 
varName        = cellstr(strcat(repmat('C',length(ComID),1),varComID));
% Clear varComID 
clearvars varComID
%
% Eliminate any spaces preceding the start of the ComID
expression = '\W+';
replace = '';
varName = regexprep(varName,expression,replace);
% Develop cell array for row names
rowDate = unique(grpDate);
rowName = cellstr(datestr(datenum(rowDate,'yyyymmdd'),'yyyy/mm/dd'));
%
flowTable = array2table(dayMeans,'RowNames',rowName','VariableNames',varName);
fprintf(1,'Unit flows aggregated to daily flows.\n');
set(handles.storeDailyPB,'BackgroundColor',[0.83,0.82,0.78]);
% Store flowTable data
setappdata(hUFinchGUI,'flowTable',flowTable);

% --- Executes on button press in storeDailyPB.
function storeDailyPB_Callback(hObject, eventdata, handles)
% hObject    handle to storeDailyPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI       = getappdata(0,'hUFinchGUI');
flowTable        = getappdata(hUFinchGUI,'flowTable');
HR               = getappdata(hUFinchGUI,'HR');
staString        = get(handles.gageNumberST,'String');
ndx              = strfind(staString,' ');
staNumber        = staString(1:ndx(1)-1);
% Use user-interface dialog box to put file into
[FileName,PathName,FilterIndex] = uiputfile('*.txt',...
    'Daily values at all ComIDs without time correction',...
    ['..\',HR,'\FlowData\Simulated\Daily\network',staNumber,'.txt']);
writetable(flowTable,fullfile(PathName,FileName),'WriteRowName',true,...
    'Delimiter',',');
set(handles.computeDailyPB,'BackgroundColor',[0.93,0.93,0.93]);
set(hObject,'BackgroundColor',[0.93,0.93,0.93]);



% --- Executes on button press in simUnitFlowProcessPB.
function simUnitFlowProcessPB_Callback(hObject, eventdata, handles)
% hObject    handle to simUnitFlowProcessPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
hUFinchGUI       = getappdata(0,'hUFinchGUI');
% Get memory variables
sBranchIDTable   = getappdata(hUFinchGUI,'sBranchIDTable');
 ComID           = getappdata(hUFinchGUI,'ComID');
nComID           = length(ComID);
sBranchIDTable   = getappdata(hUFinchGUI,'sBranchIDTable');
srtNdxID         = sBranchIDTable.Flowline;
srtComID         = sBranchIDTable.ComID;
% Retrieve the big matrix of computed flows
qndxIDtDelay     = getappdata(hUFinchGUI,'qndxIDtDelay');
% Get vector of simulated time
staNum  = get(handles.GageNumberST,'String');
staName = get(handles.GageNameST,  'String');
%   
% Retrieve the selected ComID field in the ISA panel.
targetComID      = str2double(get(handles.GageComIdST,'String'));
setappdata(hUFinchGUI,'targetComID',targetComID);
%
% Find the index of the target ComID in the sorted ComID vector
ndxComID         = find(ComID == targetComID);
setappdata(hUFinchGUI,'ndxComID',ndxComID); 
fprintf(1,'The index for the target ComID %u is %u.\n',targetComID,ndxComID);
% Get range of computed date-times for x-axis. 
simTimeVec          = getappdata(hUFinchGUI,'vYrMoDaHrMn');
% Select vector of simulated flows
simFlowVec          = qndxIDtDelay(ndxComID,:)';
% Substitue missing value indicators for zero flows
simFlowVec(find(simFlowVec == 0)) = NaN;
% Compute the maximum travel time in the network
ttNetwork           = getappdata(hUFinchGUI,'ttNetwork');
maxTrvlTimeDay      = ceil(max(ttNetwork)/96) ;
% 
huc02               = getappdata(hUFinchGUI,'HR');
% Prompt for the input file name for measured flows
gageNumber          = get(handles.GageNumberST,'String');
%
[fname, pname]      = uigetfile({['..\',huc02,'\FlowData\',gageNumber,...
    '.uFlo']},'Open Measured Unit Flow File for Selected Streamgage');
% set(handles.file15flowST,'String',[pname,fname]);
fid = fopen([pname,fname],'rt');
Q      = cell2mat(textscan(fid,'%f %f %f %f %f %f','Delimiter',',',...
    'CommentStyle','#'));
meaTimeVec = datenum(Q(:,1),Q(:,2),Q(:,3),Q(:,4),Q(:,5),...
    zeros(length(Q(:,1)),1));
meaFlowVec = Q(:,6);
% Determine the travel time to the site of interest
[~,ndxMea,ndxSim] = intersect(meaTimeVec,simTimeVec);
% One time transpose
[r,c] = size(simFlowVec);
if c > r,
    simFlowVec = simFlowVec'; 
end
% 
% Loop to determine the lag time between simulated and measured flows
% Evaluating 1-hr lags for days up to the max travel time in days plus 1
trvlTimeLagSeq = 0:4:(maxTrvlTimeDay+1)*96;
% Allocating vector to contain the root-mean-square error
rmseLagTT      = NaN(length(trvlTimeLagSeq),1);
% Evaluate root mean square error for all travel time lags
for h = 1:length(trvlTimeLagSeq),
    rmseLagTT(h) = sqrt(nansum( (simFlowVec(1+trvlTimeLagSeq(h):ndxSim(end)) - ...
        meaFlowVec(ndxMea(1):ndxMea(end-trvlTimeLagSeq(h)))).^2) / ...
        (length(ndxSim)-trvlTimeLagSeq(h)));
    fprintf(1,'h = %u, trvlTimeLagSeq = %u  rmse = %f\n',...
        h,trvlTimeLagSeq(h),rmseLagTT(h));
end
% Get Proportional velocity adjustment
proVelAdj = get(handles.VelocityAdjustmentET,'String');
% Find the index of the min rmse
[~,ndxMin] = min(rmseLagTT);
% Compute the time delay in hours
tDelay15  = trvlTimeLagSeq(ndxMin);
% Create figure for plot
hPlotSimMeaUnitQ = figure('Name','UFINCH simulated and measured unit flows');
%
%% Compute Nash-Suttcliffe measure of efficiency using absolute values
nsE1 = 1 - nansum(abs(meaFlowVec(ndxMea(1:end-tDelay15+1)) - simFlowVec(tDelay15:end))) / ...
           nansum(abs(meaFlowVec(ndxMea(1:end-tDelay15+1)) - mean(meaFlowVec(ndxMea(1:end-tDelay15+1))))) ;
fprintf(1,'Nash-Suttcliffe measure of efficiency using absolute values: %6.4f\n',...
    nsE1);
%
%% Plot simulated and measured flows
clf();
% Plot the measured flow
subplot(2,2,[1,2]);
semilogy(meaTimeVec(ndxMea(1:end-tDelay15+1)),...
    meaFlowVec(ndxMea(1:end-tDelay15+1)),'b-');
datetick('x');
xlabel('Date');
ylabel('Flow, in cubic feet per second');
title(['Hydrograph of Unit Flows at ',staNum,' ',staName,' with optimum time delay of ',...
    num2str(tDelay15),' 15-minute intervals, and a velocity acceleration factor of ',num2str(proVelAdj)]);
hold on
% Plot the time adjusted simulated flows
semilogy(simTimeVec(ndxSim(1:end-tDelay15+1)),...
    simFlowVec(ndxSim(tDelay15:end)),'r-');
legend('Meaured','Simulated');
hold off
%
% Plot the relation between measured and simulated flows in log space
subplot(2,2,3);
loglog(meaFlowVec(ndxMea(1:end-tDelay15+1)),...
    simFlowVec(ndxSim(tDelay15:end)),'b.',...
    'MarkerSize',1);
xlabel('Measured Flow, ft^3/s');
ylabel('Simulated Flow, ft^3/s');
hold on
meaYlim = get(gca,'YLim'); meaXlim = get(gca,'XLim');

% Plot line of agreement
loglog([1.1*min(meaXlim(1),meaYlim(1)), 0.90*max(meaXlim(2),meaYlim(2))],...
    [1.1*min(meaXlim(1),meaYlim(1)), 0.90*max(meaXlim(2),meaYlim(2))],'k-');
title({['Scatter of Flows at ',staNum,' ',staName],...
    ['The Nash-Suttcliffe Measure of Efficiency for Absolute Values, E_1, is ',...
    num2str(nsE1,'%6.4f')]});
hold off
legend('Data Pairs','Line of Agreement','Location','NorthWest');
% Relation between measured flows and residuals
subplot(2,2,4);
plot(log10(meaFlowVec(ndxMea(1:end-tDelay15+1))),...
    log10(simFlowVec(ndxSim(tDelay15:end))) - ...
    log10(meaFlowVec(ndxMea(1:end-tDelay15+1))),'b.',...
    'MarkerSize',1);
xlabel('log_{10}Measured Flow, ft^3/s');
ylabel('log_{10}Simulated Flow - log_{10}Measured Flow, ft^3/s');
hold on
meaXlim = get(gca,'XLim');
% Plot zero reference
plot(meaXlim,[0,0],'k-');
title(['Relation Between Measured Flow and Flow Residuals at ',staNum,' ',staName]);
hold off
legend('Residuals','Zero Reference');
% Store results
% Time delay in 15-min intervals 
setappdata(hUFinchGUI,'tDelay15',tDelay15);
% Proportion velocity adjustment in computation of travel times
setappdata(hUFinchGUI,'proVelAdj',proVelAdj); 
% Nash-Suttcliffe efficiency of absolute flow values
setappdata(hUFinchGUI,'nsE1',nsE1);
% Store simulated time and flow data
setappdata(hUFinchGUI,'simTimeVec',simTimeVec);
setappdata(hUFinchGUI,'ndxSim',ndxSim);
setappdata(hUFinchGUI,'tDelay15',tDelay15);
setappdata(hUFinchGUI,'simFlowVec',simFlowVec);
% Store measured time and flow data
setappdata(hUFinchGUI,'ndxMea',ndxMea);
setappdata(hUFinchGUI,'meaTimeVec',meaTimeVec);
setappdata(hUFinchGUI,'meaFlowVec',meaFlowVec);
set(handles.modelErrorGuiPB,'BackgroundColor',[0.83, 0.82, 0.78]);



% --- Executes on selection change in plotFlowsAtStreamgageLB.
function plotFlowsAtStreamgageLB_Callback(hObject, eventdata, handles)
% hObject    handle to plotFlowsAtStreamgageLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotFlowsAtStreamgageLB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotFlowsAtStreamgageLB
%
% Clean up from previous analysis
hUFinchGUI      = getappdata(0,'hUFinchGUI');
StreamGageEvent = getappdata(hUFinchGUI,'StreamGageEvent');
%
% Retrieve list of streamgages in the listbox
GageSet    = cellstr(get(hObject,'String'));
% Retrieve the index of the selected streamgage
ndxGage    = get(hObject,'Value');
% Display the streamgage number in the Identify Streamgage Attributes panel
set(handles.GageNumberST,'String',GageSet{ndxGage});
% Find the index of the selected streamgage in the StreamGageEvent table
ndxEvent   = find(strcmp({StreamGageEvent.SOURCE_FEA},GageSet{ndxGage}));
% Populate fields in Panel with attributes in Table
set(handles.GageNameST,'String',StreamGageEvent(ndxEvent).STATION_NM);
set(handles.daMiSqST,'String',num2str(StreamGageEvent(ndxEvent).DA_SQ_MILE));
set(handles.gageNdxST,'String',num2str(ndxEvent));
set(handles.gageLatST,'String',num2str(StreamGageEvent(ndxEvent).Lat,'%6.4f'));
set(handles.gageLongST,'String',num2str(StreamGageEvent(ndxEvent).Lon,'%7.4f'));
set(handles.GageComIdST,'String',num2str(StreamGageEvent(ndxEvent).ComID,'%u'));
set(handles.porFirstST,'String',...
    datestr(datenum(num2str(StreamGageEvent(ndxEvent).DAY1),'yyyymmdd'),'mmm yyyy'));
set(handles.porLastST,'String',...
    datestr(datenum(num2str(StreamGageEvent(ndxEvent).DAYN),'yyyymmdd'),'mmm yyyy'));
% Select geo window for output
figure(getappdata(hUFinchGUI,'hHsr'));
% Try to retrieve old ndxEvent to overwrite previous station
ndxEventOld      = getappdata(hUFinchGUI,'ndxEventOld');
% If there was a previous station, then overwrite
if( ~isempty(ndxEventOld))    
    geoshow(StreamGageEvent(ndxEventOld),'MarkerFaceColor','b','Marker','^',...
        'MarkerSize',5,'MarkerEdgeColor','b');
end
geoshow(StreamGageEvent(ndxEvent),'MarkerFaceColor','m','Marker','^',...
    'MarkerSize',5,'MarkerEdgeColor','b');
setappdata(hUFinchGUI,'ndxEventOld',ndxEvent);

% --- Executes during object creation, after setting all properties.
function plotFlowsAtStreamgageLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotFlowsAtStreamgageLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in simUnitFlowSavePB.
function simUnitFlowSavePB_Callback(hObject, eventdata, handles)
% hObject    handle to simUnitFlowSavePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI      = getappdata(0,'hUFinchGUI');
% ndxSim
ndxSim          = getappdata(hUFinchGUI,'ndxSim');
% ComID 
ComID           = getappdata(hUFinchGUI,'ComID');
% Time delay in 15-min intervals 
tDelay15        = getappdata(hUFinchGUI,'tDelay15');
% Proportion velocity adjustment in computation of travel times
proVelAdj       = getappdata(hUFinchGUI,'proVelAdj'); 
% Nash-Suttcliffe efficiency of absolute flow values
nsE1            = getappdata(hUFinchGUI,'nsE1');
% Simulated flow matrix
qndxIDtDelay    = getappdata(hUFinchGUI,'qndxIDtDelay');
% Retrieve the selected ComID field in the ISA panel.
targetComID     = str2double(get(handles.GageComIdST,'String'));
%
% Find the index of the target ComID in the sorted ComID vector
ndxComID         = find(ComID == targetComID);

% Get current directory 
pname           = pwd;                            % Get the work directory
HR              = getappdata(hUFinchGUI,'HR');
pname           = regexprep(pname,'UWork',[HR,'\\FlowData\\']);
simGage         = get(handles.GageNumberST,'String');
baseGage        = get(handles.gageNumberST,'String');
[fname,pname]   = uiputfile([pname,simGage,'.uFloSim'],...
    'Save Simulated Unit Flows at Streamgage');
fid             = fopen(fullfile(pname,fname),'wt');
%
% targetComID      = str2double(get(handles.GageComIdST,'String'));
%
% % Find the index of the target ComID in the sorted ComID vector
% ndxComID         = find(ComID == targetComID);
% fprintf(1,'The index for the target ComID %u is %u.\n',targetComID,ndxComID);
% Get range of computed date-times for x-axis. 
simTimeVec          = getappdata(hUFinchGUI,'vYrMoDaHrMn');
% Select vector of simulated flows
simFlowVec          = qndxIDtDelay(ndxComID,:)';
% Substitue missing value indicators for zero flows
simFlowVec(find(simFlowVec == 0)) = NaN;
%
% Save yyyy,mm,dd,hr,mn,simFlow to file
fprintf(fid,'# Simulated flows at %s with base gage %s and %u 15-min time delays. \n',...
    simGage,baseGage,tDelay15);
fprintf(fid,'# Proportional velocity adjustment %5.3f and Nash-Suttcliffe Efficiency of %6.4f\n',...
    proVelAdj,nsE1);
fprintf(fid,'# Run date-time: %s\n',datestr(now()));
[yyyy,mm,dd,hr,mn,~] = datevec(simTimeVec(ndxSim(1:end-tDelay15+1)));
%
fprintf(fid,'%u,%u,%u,%u,%u,%f\n',[yyyy;mm;dd;hr;mn;simFlowVec(tDelay15:end)]);
fclose(fid);

    


% --- Executes on button press in readDiscreteDataPB.
function readDiscreteDataPB_Callback(hObject, eventdata, handles)
% hObject    handle to readDiscreteDataPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plotDiscreteDataPB.
function plotDiscreteDataPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotDiscreteDataPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in modelErrorGuiPB.
function modelErrorGuiPB_Callback(hObject, eventdata, handles)
% hObject    handle to modelErrorGuiPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Initiate handle to GUI memory
hUFinchGUI      = getappdata(0,'hUFinchGUI');
% Set memory variables to ID'd Streamgage Attributes
gageName   = get(handles.GageNameST,'String');
setappdata(hUFinchGUI,'gageName',gageName);
gageNumber = get(handles.GageNumberST,'String');
setappdata(hUFinchGUI,'gageNumber',gageNumber);
gageComID  = get(handles.GageComIdST,'String');
setappdata(hUFinchGUI,'gageComID',gageComID);
%
% Initiate ModelErrorGUI
ModelErrorGUI
%
% --- Executes on button press in applyCorrectPB.
function applyCorrectPB_Callback(hObject, eventdata, handles)
% hObject    handle to applyCorrectPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
