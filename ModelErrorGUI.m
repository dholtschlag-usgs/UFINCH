function varargout = ModelErrorGUI(varargin)
% MODELERRORGUI MATLAB code for ModelErrorGUI.fig
%      MODELERRORGUI, by itself, creates a new MODELERRORGUI or raises the existing
%      singleton*.
%
%      H = MODELERRORGUI returns the handle to a new MODELERRORGUI or the handle to
%      the existing singleton*.
%
%      MODELERRORGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODELERRORGUI.M with the given input arguments.
%
%      MODELERRORGUI('Property','Value',...) creates a new MODELERRORGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ModelErrorGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ModelErrorGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModelErrorGUI

% Last Modified by GUIDE v2.5 30-Sep-2014 09:48:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ModelErrorGUI_OpeningFcn, ...
    'gui_OutputFcn',  @ModelErrorGUI_OutputFcn, ...
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


% --- Executes just before ModelErrorGUI is made visible.
function ModelErrorGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModelErrorGUI (see VARARGIN)

% Choose default command line output for ModelErrorGUI
handles.output = hObject;
% Set default estimation series for differential correction to 'simFlowVec'
handles.estFlowVec = 'simFlowVec';
% Regression parameter estimation techinque
handles.regTech = 'olsRB'; % Tag associated with OLS regression
% The statement below is commented out because it is ineffective at setting
% the state of the corresponding radio button
% set(handles.selectFlowEstimateBP,'Tag','sttFlowEstRB');
% Setup handle to UFinchGUI memory space
hUFinchGUI = getappdata(0,'hUFinchGUI');
% get set of handles to main GUI
% hMain = getappdata(hUFinchGUI,'UsedByGUIData_m');
% Select handle for GageNumber in other GUI
% set(hMain.GageNumberST,'String','-9999999');
% fprintf(1,'%s \n',hMain.GageNumberST);
% Get preliminary estimate of optimum time delay
tDelay15   = getappdata(hUFinchGUI,'tDelay15');
% Update logOptimum ET field with an estimate
set(handles.parmDifLagET,'String',num2str(round(tDelay15)));
% Update slider limits based on tDelay
set(handles.parmDifLagSlider,'Min',round(0.5*tDelay15));
set(handles.parmDifLagSlider,'Max',round(1.5*tDelay15));
set(handles.parmDifLagSlider,'Value',round(  tDelay15));
setappdata(hUFinchGUI,'estFlowName','sim');
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes ModelErrorGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModelErrorGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in scatterQselQmeaPB.
function scatterQselQmeaPB_Callback(hObject, eventdata, handles)
% hObject    handle to scatterQselQmeaPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI = getappdata(0,'hUFinchGUI');
% Retrieve simulated flow matrix (nComID x nSim)
qSimMatrix = getappdata(hUFinchGUI,'qndxIDtDelay');
% Retrieve ComID of gage
handleMain = getappdata(hUFinchGUI,'handles');
% Target ComID
tarComID   = get(handleMain.GageComIdST,'String');
% Get vector of all ComIDs
ComID      = getappdata(hUFinchGUI,'ComID');
% Find index of tarComID in ComID vector
ndxComID   = find(ComID == str2double(tarComID));
% Retrieve simulated dateTime and Flows
simFlowVec = qSimMatrix(ndxComID,:)';
% Retrieve measured dateTime and Flows
meaFlowVec = getappdata(hUFinchGUI,'meaFlowVec');
% Retrieve gageNum and gageName
gageNumber = getappdata(hUFinchGUI,'gageNumber');
gageName   = getappdata(hUFinchGUI,'gageName');
% Retrieve time parameters
ndxSim     = getappdata(hUFinchGUI,'ndxSim');
ndxMea     = getappdata(hUFinchGUI,'ndxMea');
dynParm    = getappdata(hUFinchGUI,'dynParm');
% plot simulated and measured flows
labelQselQmeaPB = get(handles.scatterQselQmeaPB,'String');
cla(handles.scatterPlot,'reset');
estimator = labelQselQmeaPB(1:4);
switch estimator
    case 'Simu'
        % Measured Flows at non-zero simulated flows
        meaFlowCmp = getappdata(hUFinchGUI,'meaFlowCmp');
        % Simulated flows that are non-zero
        simFlowCmp = getappdata(hUFinchGUI,'simFlowCmp');
        % Compute Nash-Suttcliffe measure of efficiency using absolute values
        %     nsE1 = 1 - nansum(abs(meaFlowVec(ndxMea(1:end-dynParm(5)+1)) - ...
        %         simFlowVec(ndxSim(dynParm(5):end)))) / ...
        %         nansum(abs(meaFlowVec(ndxMea(1:end-dynParm(5)+1)) - ...
        %         mean(meaFlowVec(ndxMea(1:end-dynParm(5)+1))))) ;
        nsE1 = 1 - nansum(abs(meaFlowCmp - simFlowCmp)) / ...
            nansum(abs(meaFlowCmp - mean(meaFlowCmp))) ;
        
        colorPnt = 'r';
        loglog(simFlowCmp,meaFlowCmp,...
            'Color',colorPnt,'Marker','.','MarkerSize',1,...
            'parent',handles.scatterPlot);
        xlabel(handles.scatterPlot,'Simulated Flow, in cfs');
    case 'Stat'
        % Statically Corrected Flow
        % Measured Flows at non-zero simulated flows
        meaFlowCmp = getappdata(hUFinchGUI,'meaFlowCmp');
        % Simulated flows that are non-zero
        sttFlowCmp = getappdata(hUFinchGUI,'sttFlowCmp');
        %
        nsE1 = 1 - nansum(abs(meaFlowCmp - sttFlowCmp)) / ...
            nansum(abs(meaFlowCmp - mean(meaFlowCmp))) ;
        %
        colorPnt = 'g';
        loglog(sttFlowCmp,meaFlowCmp,...
            'Color',colorPnt,'Marker','.','MarkerSize',1,...
            'parent',handles.scatterPlot);
        xlabel(handles.scatterPlot,'Statically Adjusted Flow, in cfs');
end
fprintf(1,'Nash-Suttcliffe Model Efficiency Coefficient: %6.4f\n',...
    nsE1);
%
hold(handles.scatterPlot,'on');
xLim = get(handles.scatterPlot,'XLim');
yLim = get(handles.scatterPlot,'YLim');
%
% plot line of agreement
minXY = 10^floor(log10(min(nanmin(simFlowVec(simFlowVec>0)),...
    nanmin(meaFlowVec))));
maxXY = 10^floor( log10(max(nanmax(simFlowVec),nanmax(meaFlowVec))));
% Add line of agreement
fprintf(1,'minXY = %f, maxXY = %f\n',minXY,maxXY);
loglog([minXY,maxXY],[minXY,maxXY],'Color',[0.5 0.5 0.5],'LineStyle','--',...
    'parent',handles.scatterPlot);
ylabel(handles.scatterPlot,'Measured Flow, in cfs');
hold(handles.scatterPlot,'off');
legend(handles.scatterPlot,'Data Pairs','Line of Agreement',...
    'Location','Best');
text(xLim(1)*1.2,yLim(2)*0.75,['Nash-Suttcliffe Model Efficiency_1: ',num2str(nsE1)],...
    'parent',handles.scatterPlot);
title(handles.scatterPlot,['Scatter Plot of Flows for ',gageNumber,' ',gageName]);
%
% --- Executes on button press in plotStaticErrorModelPB.
function plotStaticErrorModelPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotStaticErrorModelPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Setup access to hUFinchGUI memory
hUFinchGUI = getappdata(0,'hUFinchGUI');
% retrieve model
mdl         = getappdata(hUFinchGUI,'mdl');
% get sttFlowVec
sttFlowVec  = getappdata(hUFinchGUI,'sttFlowVec');
minSttFlow  = 10.^(nanmin(log10(sttFlowVec)));
maxSttFlow  = 10.^(nanmax(log10(sttFlowVec)));
% generate sequence spanning flow of length 100
rngSttFlow  = linspace(log10(minSttFlow),log10(maxSttFlow))';
% predict error from flow sequence
estSttError = predict(mdl,rngSttFlow);
% Adjust for bias
estSttError = estSttError * 10^(mdl.MSE/2);
%
hold(handles.scatterPlot,'on');
plot(handles.scatterPlot,10.^(rngSttFlow),estSttError,'Color',[0.5,0.5,0.5],...
    'LineStyle','--');
% Load data from GUI workspace
% simFlowVec = getappdata(hModelErrorGUI,'simFlowVec');
% Adjust flows for bias
% simLogErr     = b0 + b1 * log10(simFlowVec) + b2 * exp(-b3 * log10(simFlowVec)) ;
% Compute the smearing estimate of bias correction as MSE/2
% mse2          = sum( (log10(simFlowVec) - log10(meaFlowVec)).^2 )/...
%     (length(meaFlowVec) * 2.);
fprintf(1,'mdl.MSE = %f.\n',mdl.MSE);
% adjFlowVec    = 10.^(log10(simFlowVec) - simLogErr) * 10^(mdl.MSE/2);
% Store bias adjusted flow to memory
setappdata(hUFinchGUI,'adjFlowVec',adjFlowVec);
set(handles.plotDifCorUnitFlowsPB,'BackgroundColor',[0.83,0.82,0.78]);


% --- Executes on button press in estStaticModelParametersPB.
function estStaticModelParametersPB_Callback(hObject, eventdata, handles)
% hObject    handle to estStaticModelParametersPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Get model parameter estimates
cnstParm = str2double(get(handles.constantMagnitudeET,'String'));
linrParm = str2double(get(handles.linearMagnitudeET,'String'));
quadParm = str2double(get(handles.quadraticMagnitudeET,'String'));
fprintf(1,'cnstParm = %f, linrParm = %f, quadParm + %f\n',...
    cnstParm, linrParm, quadParm);
fprintf(1,'~isnan(cnstParm) = %u, ~isnan(linrParm) = %u, ~isnan(quadTerm) = %u\n',...
    ~isnan(cnstParm),~isnan(linrParm),~isnan(quadParm));
%
% Find handle for GUI memory space
hUFinchGUI = getappdata(0,'hUFinchGUI');
% Load the measured unit flows
meaFlowVec   = getappdata(hUFinchGUI,'meaFlowVec');
ndxMea       = getappdata(hUFinchGUI,'ndxMea');
meaTimeVec   = getappdata(hUFinchGUI,'meaTimeVec');
% Load the simulated unit flows
simFlowVec   = getappdata(hUFinchGUI,'simFlowVec')';
ndxSim       = getappdata(hUFinchGUI,'ndxSim');
simTimeVec   = getappdata(hUFinchGUI,'vYrMoDaHrMn');
dynParm5     = str2double(get(handles.parmDifLagET,'String'));
[nRow, nCol] = size(meaFlowVec(ndxMea(1:end-dynParm5+1)));
fprintf(1,'meaFlowVec: nRow = %u, nCol = %u\n',nRow, nCol);
[nRow, nCol] = size(simFlowVec(ndxSim(dynParm5:end)));
fprintf(1,'simFlowVec: nRow = %u, nCol = %u\n',nRow, nCol);
%
meaFlow    = meaFlowVec(ndxMea(1:end-dynParm5+1));
simFlow    = simFlowVec(ndxSim(dynParm5:end));
% Find any simFlows that are not zeros (includes both real and artifact zeros)
ndxNaZ     = find(simFlow>0);
%
errFlow    = log10(meaFlow(ndxNaZ)) - log10(simFlow(ndxNaZ));
% Evaluate initial model parameters to select model
% set rb to 'on' for robust regression
regTech = handles.regTech;
fprintf(1,'regTech = %s\n',regTech);
if (strcmp(handles.regTech,'robustRB'))
    rb  = 'on';
else
    rb  = 'off';
end
if      ~isnan(cnstParm) && ~isnan(linrParm) && ~isnan(quadParm)
    fprintf(1,'A quadratic model will be used to describe the error as a function of simulated flow.\n');
    % Develop a quadratic regression model
    mdl = fitlm(log10(simFlow(ndxNaZ)), errFlow(ndxNaZ),'quadratic','RobustOpts',rb);
    disp(mdl);
    % Populate table of parameters
    set(handles.constantMagnitudeET,'String',num2str(mdl.Coefficients.Estimate(1)));
    set(handles.linearMagnitudeET,'String',num2str(mdl.Coefficients.Estimate(2)));
    set(handles.quadraticMagnitudeET,'String',num2str(mdl.Coefficients.Estimate(3)));
    
    set(handles.constantStdErrorET,'String',num2str(mdl.Coefficients.SE(1)));
    set(handles.linearStdErrorET,'String',num2str(mdl.Coefficients.SE(2)));
    set(handles.quadraticStdErrorET,'String',num2str(mdl.Coefficients.SE(3)));
    
    set(handles.constantTstatET,'String',num2str(mdl.Coefficients.tStat(1)));
    set(handles.linearTstatET,'String',num2str(mdl.Coefficients.tStat(2)));
    set(handles.quadraticTstatET,'String',num2str(mdl.Coefficients.tStat(3)));
    
    set(handles.constantPvalueET,'String',num2str(mdl.Coefficients.pValue(1)));
    set(handles.linearPvalueET,'String',num2str(mdl.Coefficients.pValue(2)));
    set(handles.quadraticPvalueET,'String',num2str(mdl.Coefficients.pValue(3)));
    
    set(handles.adjR2StaticModelST,'String',num2str(mdl.Rsquared.Adjusted));
    set(handles.rmseStaticModelST,'String',num2str(mdl.RMSE));
    % Change background color of push button to plot static estimates
    set(handles.plotSttCorUnitFlowsPB,'BackgroundColor',[0.831, 0.816, 0.784]);
    
elseif ~isnan(cnstParm) && ~isnan(linrParm) &&  isnan(quadParm)
    fprintf(1,'A linear model will be used to describe the error as a function of simulated flow.\n');
    % Develop a linear regression model
    mdl = fitlm(log10(simFlow(ndxNaZ)), errFlow(ndxNaZ),'linear','RobustOpts',rb);
    disp(mdl);
    % Populate table of parameters
    set(handles.constantMagnitudeET,'String',num2str(mdl.Coefficients.Estimate(1)));
    set(handles.linearMagnitudeET,'String',num2str(mdl.Coefficients.Estimate(2)));
    set(handles.quadraticMagnitudeET,'String','NaN');
    
    set(handles.constantStdErrorET,'String',num2str(mdl.Coefficients.SE(1)));
    set(handles.linearStdErrorET,'String',num2str(mdl.Coefficients.SE(2)));
    set(handles.quadraticStdErrorET,'String','NaN');
    
    set(handles.constantTstatET,'String',num2str(mdl.Coefficients.tStat(1)));
    set(handles.linearTstatET,'String',num2str(mdl.Coefficients.tStat(2)));
    set(handles.quadraticTstatET,'String','NaN');
    
    set(handles.constantPvalueET,'String',num2str(mdl.Coefficients.pValue(1)));
    set(handles.linearPvalueET,'String',num2str(mdl.Coefficients.pValue(2)));
    set(handles.quadraticPvalueET,'String','NaN');
    
    set(handles.adjR2StaticModelST,'String',num2str(mdl.Rsquared.Adjusted));
    set(handles.rmseStaticModelST,'String',num2str(mdl.RMSE));
    % Change background color of push button to plot static estimates
    set(handles.plotSttCorUnitFlowsPB,'BackgroundColor',[0.831, 0.816, 0.784]);
    
elseif ~isnan(cnstParm) &&  isnan(linrParm)
    fprintf(1,'A constant model will be used to describe the error\n');
    % Develop a constant regression model
    mdl = fitlm(log10(simFlow(ndxNaZ)), errFlow(ndxNaZ),'constant','RobustOpts',rb);
    disp(mdl);
    % Populate table of parameters
    set(handles.constantMagnitudeET,'String',num2str(mdl.Coefficients.Estimate(1)));
    set(handles.linearMagnitudeET,'String','NaN');
    set(handles.quadraticMagnitudeET,'String','NaN');
    
    set(handles.constantStdErrorET,'String',num2str(mdl.Coefficients.SE(1)));
    set(handles.linearStdErrorET,'String','NaN');
    set(handles.quadraticStdErrorET,'String','NaN');
    
    set(handles.constantTstatET,'String',num2str(mdl.Coefficients.tStat(1)));
    set(handles.linearTstatET,'String','NaN');
    set(handles.quadraticTstatET,'String','NaN');
    
    set(handles.constantPvalueET,'String',num2str(mdl.Coefficients.pValue(1)));
    set(handles.linearPvalueET,'String','NaN');
    set(handles.quadraticPvalueET,'String','NaN');
    
    set(handles.adjR2StaticModelST,'String','NaN');
    set(handles.rmseStaticModelST,'String',num2str(mdl.RMSE));
    % Change background color of push button to plot static estimates
    set(handles.plotSttCorUnitFlowsPB,'BackgroundColor',[0.831, 0.816, 0.784]);
else
    fprintf(1,'Model not defined.\n');
    warndlg('Specified static model not defined.','Re-specify static model');
    return
end
%
% Predict model error as a function of simulated flow
ypred              = predict(mdl,log10(simFlow(ndxNaZ)));
sttTimeVec         = simTimeVec;
ndxStt             = ndxSim;
% Initialize static flow vector
sttFlowVec         = NaN(size(simFlowVec));
% Use Smearing bias adjustment to correct flows
mse                = mdl.RMSE^2;
%
sttFlow            = NaN(size(simFlow));
sttFlow(ndxNaZ)    = 10.^(log10( simFlow(ndxNaZ))+ ypred ) .* 10^(mse/2);
sttFlowVec(ndxStt(dynParm5:end)) = sttFlow;
%
% figure(4); clf(4);
% plot(simTimeVec(ndxSim(1:end-dynParm5+1)),simFlowVec(ndxSim(dynParm5:end)),'r-');
% datetick('x');
% hold on
% plot(sttTimeVec(ndxStt(1:end-dynParm5+1)),sttFlowVec(ndxStt(dynParm5:end)),'g-');
% plot(meaTimeVec(ndxMea),meaFlowVec(ndxMea),'b-');
%
% Simulated flows comparable with contemporaneous measured flows
simFlowCmp  = simFlowVec(ndxSim(dynParm5:end));
% These indices omit zeros from simulated values
ndxCmp      = find(simFlowCmp > 0);
simFlowCmp  = simFlowCmp(ndxCmp);
% Measured flows comparable with contemporaneous simulated flows
meaFlowCmp  = meaFlowVec(ndxMea(1:end-dynParm5+1));
meaFlowCmp  = meaFlowCmp(ndxCmp);
% Differences between log simulated and measured flows
simDifMea   = log10(simFlowCmp(ndxCmp)) - log10(meaFlowCmp(ndxCmp));
fprintf(1,'Std of log10 simDifMea is %f\n',std(simDifMea));
% Statically corrected flows comparable with contermporaneous measured flows
sttFlowCmp  = sttFlowVec(ndxStt(dynParm5:end));
sttFlowCmp  = sttFlowCmp(ndxCmp);
% Differences between log statically corrected flows and measured flows
sttDifMea   = log10(sttFlowCmp(ndxCmp)) - log10(meaFlowCmp(ndxCmp));
fprintf(1,'Std of log10 sttDifMea is %f\n',std(sttDifMea));
%
setappdata(hUFinchGUI,'simFlowCmp',simFlowCmp);
setappdata(hUFinchGUI,'meaFlowCmp',meaFlowCmp);
setappdata(hUFinchGUI,'sttFlowCmp',sttFlowCmp);
setappdata(hUFinchGUI,'simDifMea',simDifMea);
setappdata(hUFinchGUI,'sttDifMea',sttDifMea);
setappdata(hUFinchGUI,'sttFlowVec',sttFlowVec');
setappdata(hUFinchGUI,'sttTimeVec',sttTimeVec');
setappdata(hUFinchGUI,'ndxStt',ndxStt);
setappdata(hUFinchGUI,'mdl',mdl);
plotSttCorUnitFlowsPB_Callback(handles.plotSttCorUnitFlowsPB, eventdata, handles)





% --- Executes on button press in plotMeasuredUnitFlowsPB.
function plotMeasuredUnitFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotMeasuredUnitFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Load the handles into the plotting function
handles=guidata(hObject);
%
hUFinchGUI       = getappdata(0,'hUFinchGUI');
% Get memory variables
meaTimeVec       = getappdata(hUFinchGUI,'meaTimeVec');
meaFlowVec       = getappdata(hUFinchGUI,'meaFlowVec');
tDelay15         = getappdata(hUFinchGUI,'tDelay15');
ndxMea           = getappdata(hUFinchGUI,'ndxMea');
gageName         = getappdata(hUFinchGUI,'gageName');
gageNumber       = getappdata(hUFinchGUI,'gageNumber');
%
% Clear hydrograph (The statement below cleared the figure)
cla(handles.hydrographPlot,'reset');
% Plot hydrograph of measured data
semilogy(meaTimeVec(ndxMea(1:end-tDelay15+1)),...
    meaFlowVec(ndxMea(1:end-tDelay15+1)),'b-',...
    'parent',handles.hydrographPlot);
%
datetick(handles.hydrographPlot,'x');
ylabel(handles.hydrographPlot,'Log_{10} Unit Flows, in ft^3/s');
title(handles.hydrographPlot,['Hydrograph of Flows at ',...
    gageNumber,' ',gageName]);
%

% --- Executes on button press in readSimulatedUnitFlowsPB.
function readSimulatedUnitFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to readSimulatedUnitFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Connect function with GUI workspace
hUFinchGUI   = getappdata(0,'hUFinchGUI');
% Get date time vector.
simTimeVec   = getappdata(hUFinchGUI,'vYrMoDaHrMn');
ndxSim       = getappdata(hUFinchGUI,'ndxSim');
% Get simulated flow matrix
qndxIDtDelay = getappdata(hUFinchGUI,'qndxIDtDelay');
% Identify and select the vector of simulated flows
ComID       = getappdata(hUFinchGUI,'ComID');
targetComID  = getappdata(hUFinchGUI,'targetComID');
ndxComID     = find(ComID == targetComID);
tDelay15     = getappdata(hUFinchGUI,'tDelay15');
% Find the index of the target ComID in the sorted ComID vector
fprintf(1,'The index for the target ComID %u is %u.\n',targetComID,ndxComID);
% Get the simulated flow series
simFlowVec   = qndxIDtDelay(ndxComID,:);
%
% Load the handles into the plotting function
handles=guidata(hObject);
% Hold on to overplot hydrographs
hold(handles.hydrographPlot,'on');
% Plot hydrograph of measured data
semilogy(simTimeVec(ndxSim(1:end-tDelay15+1)),...
    simFlowVec(ndxSim(tDelay15:end)),'r-',...
    'parent',handles.hydrographPlot);
hold off

datetick(handles.hydrographPlot,'x');
% Put legend on plot
legend(handles.hydrographPlot,'Measured','Simulated','Location','Best');
% Reset limits of time domain
set(handles.plotLowerLimitSlider,'Value',0);
set(handles.plotUpperLimitSlider,'Value',1);
% Store simFlowVec to GUI workspace memory
setappdata(hUFinchGUI,'simFlowVec',simFlowVec);


% --- Executes during object creation, after setting all properties.
function hydrographPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hydrographPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate hydrographPlot


% % --- Executes on slider movement.
% function constantTrendSlider_Callback(hObject, eventdata, handles)
% % hObject    handle to constantTrendSlider (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% % Hints: get(hObject,'Value') returns position of slider
% %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% biasB0 = get(hObject,'Value');
% set(handles.constantMagnitudeET,'String',num2str(biasB0));
%
% % --- Executes during object creation, after setting all properties.
% function constantTrendSlider_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to constantTrendSlider (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
%
% % Hint: slider controls usually have a light gray background.
% if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor',[.9 .9 .9]);
% end


% --- Executes on button press in plotDifCorUnitFlowsPB.
function plotDifCorUnitFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotDifCorUnitFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorVec   = get(handles.plotDifCorUnitFlowsPB,'BackgroundColor');
if ((colorVec - [0.933 0.933 0.933]) * (colorVec - [0.933 0.933 0.933])' < 1e-5)
    msgbox('Check whether adjusted flows have been computed');
    return
end
hUFinchGUI = getappdata(0,'hUFinchGUI');
% Load data from GUI workspace
% meaTimeVec = getappdata(hUFinchGUI,'meaTimeVec');
% meaFlowVec = getappdata(hUFinchGUI,'meaFlowVec');
% simFlowVec = getappdata(hUFinchGUI,'simFlowVec');
adjFlowVec = getappdata(hUFinchGUI,'adjFlowVec');
adjTimeVec = getappdata(hUFinchGUI,'adjTimeVec');
%
hold(handles.hydrographPlot,'on');
semilogy(adjTimeVec,adjFlowVec,'k-',...
    'parent',handles.hydrographPlot);
legend(handles.hydrographPlot,'Measured','Simulated',...
    'Adjusted','Location','Best');
hold(handles.hydrographPlot,'off');


% --- Executes on slider movement.
function plotUpperLimitSlider_Callback(hObject, eventdata, handles)
% hObject    handle to plotUpperLimitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Get handle to ModelErrorGUI memory space
hUFinchGUI = getappdata(0,'hUFinchGUI');
% Load time vector from GUI workspace
meaTimeVec = getappdata(hUFinchGUI,'meaTimeVec');
ndxMea     = getappdata(hUFinchGUI,'ndxMea');
% Get location from slider position
hiLimPlot  = get(hObject,'Value');
% fprintf(1,'hiLimPlot: %f\n',hiLimPlot);
loLimPlot  = get(handles.plotLowerLimitSlider,'Value');
% fprintf(1,'loLimPlot: %f\n',loLimPlot);
% Get the range of the full plot
loLimPlot  = min(hiLimPlot-0.01,max(loLimPlot,0));
set(handles.plotLowerLimitSlider,'Value',loLimPlot);
%
% xLim = get(handles.hydrographPlot,'XLim');
% fprintf(1,'Lower xLim: %f, Upper xLim: %f \n',xLim);
set(handles.hydrographPlot,'XLim',[prctile(meaTimeVec(ndxMea),loLimPlot*100),...
    prctile(meaTimeVec(ndxMea),hiLimPlot*100)]);


% --- Executes during object creation, after setting all properties.
function plotUpperLimitSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotUpperLimitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function plotLowerLimitSlider_Callback(hObject, eventdata, handles)
% hObject    handle to plotLowerLimitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI = getappdata(0,'hUFinchGUI');
% Load data from GUI workspace
meaTimeVec = getappdata(hUFinchGUI,'meaTimeVec');
ndxMea     = getappdata(hUFinchGUI,'ndxMea');
% Get location from slider position
loLimPlot  = get(hObject,'Value');
hiLimPlot  = get(handles.plotUpperLimitSlider,'Value');
% Get the range of the full plot
hiLimPlot  = max(hiLimPlot,min(loLimPlot+0.01,1));
set(handles.plotUpperLimitSlider,'Value',hiLimPlot);
% % Reset range of plot
% min(abs(locMidPlot-rngMaxPlot),abs(locMidPlot-rngMinPlot));
set(handles.hydrographPlot,'XLim',[prctile(meaTimeVec(ndxMea),loLimPlot*100),...
    prctile(meaTimeVec(ndxMea),hiLimPlot*100)]);

% --- Executes during object creation, after setting all properties.
function plotLowerLimitSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotLowerLimitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function linearMagnitudeET_Callback(hObject, eventdata, handles)
% hObject    handle to linearMagnitudeET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linearMagnitudeET as text
%        str2double(get(hObject,'String')) returns contents of linearMagnitudeET as a double

% --- Executes during object creation, after setting all properties.
function linearMagnitudeET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linearMagnitudeET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function constantMagnitudeET_Callback(hObject, eventdata, handles)
% hObject    handle to constantMagnitudeET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of constantMagnitudeET as text
%        str2double(get(hObject,'String')) returns contents of constantMagnitudeET as a double
%
% get string from text box and update slider position
biasB0 = get(hObject,'String');
if strcmpi(biasB0,'NaN')
    set(handles.constantTrendSlider,'Value',0);
else
    set(handles.constantTrendSlider,'Value',str2double(biasB0));
end

% --- Executes during object creation, after setting all properties.
function constantMagnitudeET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constantMagnitudeET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function parmDifQ1ET_Callback(hObject, eventdata, handles)
% hObject    handle to parmDifQ1ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parmDifQ1ET as text
%        str2double(get(hObject,'String')) returns contents of parmDifQ1ET as a double


% --- Executes during object creation, after setting all properties.
function parmDifQ1ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parmDifQ1ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parmDifQ2ET_Callback(hObject, eventdata, handles)
% hObject    handle to parmDifQ2ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parmDifQ2ET as text
%        str2double(get(hObject,'String')) returns contents of parmDifQ2ET as a double


% --- Executes during object creation, after setting all properties.
function parmDifQ2ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parmDifQ2ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function parmDifQ1Slider_Callback(hObject, eventdata, handles)
% hObject    handle to parmDifQ1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function parmDifQ1Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parmDifQ1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function parmDifQ2Slider_Callback(hObject, eventdata, handles)
% hObject    handle to parmDifQ2Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function parmDifQ2Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parmDifQ2Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function parmDifLagET_Callback(hObject, eventdata, handles)
% hObject    handle to parmDifLagET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parmDifLagET as text
%        str2double(get(hObject,'String')) returns contents of parmDifLagET as a double


% --- Executes during object creation, after setting all properties.
function parmDifLagET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parmDifLagET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function parmDifLagSlider_Callback(hObject, eventdata, handles)
% hObject    handle to parmDifLagSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function parmDifLagSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parmDifLagSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in estDifferentialModelPB.
function estDifferentialModelPB_Callback(hObject, eventdata, handles)
% hObject    handle to estDifferentialModelPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Initialize handle to UFinchGUI workspace
hUFinchGUI   = getappdata(0,'hUFinchGUI');
% Retrieve simulated dateTime and Flows
%
estFlowName  = getappdata(hUFinchGUI,'estFlowName');
% disp(estFlowVec);
fprintf(1,'Simulated or Statically Corrected Flow: %s\n',estFlowName);
% Note that simFlowVec ndxSim are aliases here and can refer to either
% simFlowVec and ndxSim or sttFlowVec and ndxStt depending on the state of
% the radio buttons in the Select Flow Estimate Button Group Panel
% Get initial parameter estimates from edit text boxes
difQ1      = str2double(get(handles.parmDifQ1ET,'String'));
difQ2      = str2double(get(handles.parmDifQ2ET,'String'));
difLag     = str2double(get(handles.parmDifLagET,'String'));
fprintf(1,'Starting Parameters are: difQ1 = %f, difQ2 = %f, difLag = %u\n',...
    difQ1, difQ2, difLag);
% Initial parameter vector
% Two parameter vector
b             = [difQ1,        difQ2,   difLag ];
%
meaFlowVec     = getappdata(hUFinchGUI,'meaFlowVec');
ndxMea         = getappdata(hUFinchGUI,'ndxMea');
simFlowVec     = getappdata(hUFinchGUI,'simFlowVec');
ndxSim         = getappdata(hUFinchGUI,'ndxSim');
sttFlowVec     = getappdata(hUFinchGUI,'sttFlowVec');
ndxStt         = getappdata(hUFinchGUI,'ndxStt');
%
tDelay15       = getappdata(hUFinchGUI,'tDelay15');
logSimFlowVec  = log10(simFlowVec(ndxSim(tDelay15+1:end)));
logMeaFlowVec  = log10(meaFlowVec(ndxMea(1:end-tDelay15)));
logSttFlowVec  = log10(sttFlowVec(ndxStt(tDelay15+1:end)));
%
estFlowName    = getappdata(hUFinchGUI,'estFlowName');
fprintf(1,'estFlowName is %s\n',estFlowName);
switch estFlowName
    case 'stt'
        logEstFlowVec = logSttFlowVec;
    case 'sim'
        logEstFlowVec = logSimFlowVec;
end
%
ndxIsF = find(isfinite(logEstFlowVec));
logEstFlowVec = logEstFlowVec(ndxIsF);
logMeaFlowVec = logMeaFlowVec(ndxIsF);
% [rS,cS] = size(logSimFlowVec);
% [rM,cM] = size(logMeaFlowVec);
% fprintf(1,'rS = %u, cS = %u, rM = %u, cM = %u \n',rS,cS,rM,cM);
figure(3); clf(3);
plot(logMeaFlowVec,'b-');
hold on
plot(logEstFlowVec,'r-');
hold off

fprintf(1,'min(logEst) = %f, max(logEst) = %f min(logMea) = %f, max(logMea) = %f\n',...
    min(logEstFlowVec),max(logEstFlowVec),...
    min(logEstFlowVec),max(logEstFlowVec));

Fsumsquares   = @(b)nansum(dynaCorrFunc(b,logEstFlowVec,logMeaFlowVec).^2);
%
disp(b);
% opts increase Maximum Function evaluations;
opts = optimset('MaxFunEvals',800*5,'TolX',1e-5,'TolFun',1e-6);
% [xunc,ressquared,eflag,outputu] = fminunc(Fsumsquares,b,opts);
[xunc,ressquared,eflag,optiInfo] = fminsearch(Fsumsquares,b,opts);
%
% Print info about the solution
switch eflag
    case 1
        fprintf(1,'\n *** SUCCESS: fminsearch converged to a solution x.  SUCCESS *** \n');
        set(handles.plotDifCorUnitFlowsPB,'BackgroundColor',[0.83, 0.82, 0.78]);
    case 0
        fprintf(1,'\n *** Maximum number of function evaluations or iterations was reached. *** \n');
    case -1
        fprintf(1,'\n *** Algorithm was terminated by the output function. *** \n');
end
%
% Print detailed info about the numerical optimization results
fprintf(1,'Optimization Info:\n');
fprintf(1,'   Algorithm: %s. \n',optiInfo.algorithm);
fprintf(1,'   Number of function evaluations: %u.\n',optiInfo.funcCount);
fprintf(1,'   Number of iterations: %u. \n',optiInfo.iterations);
fprintf(1,'   Exit message: %s. \n',optiInfo.message);
% Parameter estimates:
fprintf(1,'difQ1: %6.4f, difQ2: %6.3f.\n', xunc );
%
% Compute the smearing estimate of detransformed flow
bhat          = xunc;
% Pad first tDelay15 NaN values of logSimFlowVec with first ~isnan value
% ndxIaN        = find(logSimFlowVec>0,1,'first');
% logSimFlowVec(1:ndxIaN) = repmat(logSimFlowVec(ndxIaN),1,ndxIaN);
%%
% logSimFlowVec    = logSimFlowVec(bhat(3):end);
% logMeaFlowVec    = logMeaFlowVec(1:end-bhat(3)+1);
% Initialize vector for adjusted flows
logAdjFlowVec    = NaN(length(logSimFlowVec),1);
% Set initial condition for logAdjFlowVec
logAdjFlowVec(2) = logEstFlowVec(2);
% Derivative correction: First order and second order
%
[nrow, ncol]     = size(logSimFlowVec);
% fprintf(1,'logSimFlowVec: nrow = %u, ncol = %u\n',nrow,ncol);
[nrow, ncol]     = size(diff(logSimFlowVec));
% fprintf(1,'diff(logSimFlowVec): nrow = %u, ncol = %u\n',nrow,ncol);
%
d1LogSimFlowVec  = [NaN diff(logSimFlowVec)];
d2LogSimFlowVec  = [NaN NaN diff(logSimFlowVec,2)];
% Compute the adjusted log flows
for i=3:length(logSimFlowVec)
    logAdjFlowVec(i) = logAdjFlowVec(i-1) + ...
        b(1) * d1LogSimFlowVec(i) + b(2) * d2LogSimFlowVec(i)  ;
end
%%
% logAdjErrVec  = dynaCorrFunc(bhat,logSimFlowVec,logMeaFlowVec);
fprintf(1,'\n');
figure(4); clf(4);
plot(logMeaFlowVec,'b-');
hold on
plot(logEstFlowVec,'r-');
plot(logAdjFlowVec,'k-');
hold off

return
% logAdjFlowVec = logMeaFlowVec(1:end -bhat(5) +1)  + logAdjErrVec;
%
% Update parameter estimates in edit text boxes within GUI
set(handles.parmDifQ1ET,'String',num2str(xunc(1)));
set(handles.parmDifQ2ET,'String',num2str(xunc(2)));
% set(handles.parmDifLagET,'String',num2str(round(xunc(3))));
%

% Reference for Smearing Bias Correction
% http://www.vims.edu/people/newman_mc/pubs/Newman1993.pdf
%  Note: I'm dividing by n-5 to account for the parameters
% mse           = nansum(logAdjErrVec.^2)/(sum(~isnan(logAdjErrVec))-5);
mse = 0.0;  % place holder
% The correction for a normally distributed log values
adjFlowVec    = 10.^logAdjFlowVec .* 10^(mse/2);
setappdata(hUFinchGUI,'adjFlowVec',adjFlowVec);
simTimeVec   = getappdata(hUFinchGUI,'vYrMoDaHrMn')';
adjTimeVec   = simTimeVec(ndxSim(1:end-round(xunc(3))+1));
setappdata(hUFinchGUI,'adjTimeVec',  adjTimeVec);
% Compute daily means from unit values
% Compute grouping variable of date
uniDailyTimeVec   = unique(datenum(datestr(adjTimeVec,'yyyymmdd'),'yyyymmdd'));
grpDate           = cellstr(datestr(adjTimeVec,'yyyymmdd'));
setappdata(hUFinchGUI,'grpDate',grpDate);
% Compute daily means
dailyAdjFlows     = grpstats(adjFlowVec,grpDate,'nanmean');
setappdata(hUFinchGUI,'dailyAdjFlows',dailyAdjFlows);
% Interpolate daily means to unit values
% Add smoothed interpolated values with interp1-pchip
begUnitDate       = adjTimeVec(  1) + 0.5;
setappdata(hUFinchGUI,'begUnitDate',begUnitDate);
endUnitDate       = adjTimeVec(end) + 0.5;
setappdata(hUFinchGUI,'endUnitDate',endUnitDate);
adjTimeVec = linspace(begUnitDate,endUnitDate,4*24*(endUnitDate-begUnitDate)+1)';
setappdata(hUFinchGUI,'adjTimeVec',adjTimeVec);
adjFlowVec = interp1(uniDailyTimeVec +.5,dailyAdjFlows,adjTimeVec,'pchip')';
setappdata(hUFinchGUI,'adjFlowVec',  adjFlowVec);
% Store dynamic parameters
setappdata(hUFinchGUI,'dynParm',bhat);
%
plotDifCorUnitFlowsPB_Callback(handles.plotDifCorUnitFlowsPB, eventdata, handles)


function [ logAdjErrVec ] = dynaCorrFunc( b, logSimFlowVec, logMeaFlowVec )
% adjFlowFunction adjusts simulated log flow to more nearly match measured
%   measured log flow by using the derivative of simulated flow
%   Detailed explanation goes here
%
% Get initial parameters from ET boxes
% Round tDelay15 to nearest integer
% b(5) = round(b(5));
% b(3)   = max(round(b(3)),1);
fprintf(1,'b(1) = %f, b(2) = %f b(3) = %f\n',b);
% logSimFlowVec    = logSimFlowVec(b(3):end);
% logMeaFlowVec    = logMeaFlowVec(1:end-b(3)+1);
% Initialize vector for adjusted flows
logAdjFlowVec    = NaN(length(logSimFlowVec),1);
% Set initial condition for logAdjFlowVec
logAdjFlowVec(2) = logSimFlowVec(2);
% Derivative correction: First order and second order
%
[nrow, ncol] = size(logSimFlowVec);
% fprintf(1,'logSimFlowVec: nrow = %u, ncol = %u\n',nrow,ncol);
[nrow, ncol] = size(diff(logSimFlowVec));
% fprintf(1,'diff(logSimFlowVec): nrow = %u, ncol = %u\n',nrow,ncol);
%
fprintf(1,'.');
d1LogSimFlowVec = [NaN diff(logSimFlowVec)];
d2LogSimFlowVec = [NaN NaN diff(logSimFlowVec,2)];
% Compute the adjusted log flows
for i=3:length(logSimFlowVec)
    logAdjFlowVec(i) = b(3) * logSimFlowVec(i) + ...
        b(1) * d1LogSimFlowVec(i) + ...
        b(2) * d2LogSimFlowVec(i);
end
% [rA,cA] = size(logAdjFlowVec);
% [rM,cM] = size(logMeaFlowVec);
% fprintf(1,'rA = %u, cA = %u, rM = %u, cM = %u \n',rA,cA,rM,cM);
logAdjErrVec = logAdjFlowVec - logMeaFlowVec ;
fprintf(1,'SumSqResid: %f\n',nansum(logAdjErrVec.^2));


% --- Executes on button press in plotHydrographPB.
function plotHydrographPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotHydrographPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Initialize handle to UFinchGUI workspace
hUFinchGUI = getappdata(0,'hUFinchGUI');
% Retrieve simulated dateTime and Flows
simTimeVec = getappdata(hUFinchGUI,'simTimeVec');
simFlowVec = getappdata(hUFinchGUI,'simFlowVec');
% Retrieve measured dateTime and Flows
meaTimeVec = getappdata(hUFinchGUI,'meaTimeVec');
meaFlowVec = getappdata(hUFinchGUI,'meaFlowVec');
%
tDelay15   = getappdata(hUFinchGUI,'tDelay15');
ndxSim     = getappdata(hUFinchGUI,'ndxSim');
tDelay15   = getappdata(hUFinchGUI,'tDelay15');
ndxMea     = getappdata(hUFinchGUI,'ndxMea');
%
% Retrieve gageNum and gageName
gageNumber = getappdata(hUFinchGUI,'gageNumber');
gageName   = getappdata(hUFinchGUI,'gageName');
gageComID  = getappdata(hUFinchGUI,'gageComID');
%
% Plot hydrograph of measured unit flows
semilogy(meaTimeVec(ndxMea(1:end-tDelay15+1)),meaFlowVec(ndxMea(1:end-tDelay15+1)),...
    'b-','parent',handles.hydrographPlot);
% Set hold off
hold(handles.hydrographPlot,'on');
datetick(handles.hydrographPlot,'x');
ylabel(handles.hydrographPlot,'Log_{10} Unit Flows, in ft^3/s');
% Plot hydrograph of simulated flow
semilogy(simTimeVec(ndxSim(1:end-tDelay15+1)),...
    simFlowVec(ndxSim(tDelay15:end)),...
    'r-','parent',handles.hydrographPlot);
legend(handles.hydrographPlot,'Meaured','Simulated');
hold(handles.hydrographPlot,'off');
title(handles.hydrographPlot,['Hydrograph of Flows at ',...
    gageNumber,' ',gageName]);
% Reset hydrograph plot time domain sliders
set(handles.plotLowerLimitSlider,'Value',0);
set(handles.plotUpperLimitSlider,'Value',1);


% --- Executes on button press in scatterQselQerrPB.
function scatterQselQerrPB_Callback(hObject, eventdata, handles)
% hObject    handle to scatterQselQerrPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Initialize handle to UFinchGUI workspace
hUFinchGUI = getappdata(0,'hUFinchGUI');
% Retrieve simulated flow matrix (nComID x nSim)
qSimMatrix = getappdata(hUFinchGUI,'qndxIDtDelay');
% Retrieve ComID of gage
handleMain = getappdata(hUFinchGUI,'handles');
% Target ComID
tarComID   = get(handleMain.GageComIdST,'String');
% Get vector of all ComIDs
ComID      = getappdata(hUFinchGUI,'ComID');
% Find index of tarComID in ComID vector
ndxComID   = find(ComID == str2double(tarComID));
% Retrieve simulated dateTime and Flows
simFlowVec = qSimMatrix(ndxComID,:)';
adjFlowVec = getappdata(hUFinchGUI,'adjFlowVec')';
% simTimeVec = getappdata(hUFinchGUI,'simTimeVec');
% Retrieve measured dateTime and Flows
% meaTimeVec = getappdata(hUFinchGUI,'meaTimeVec');
meaFlowVec = getappdata(hUFinchGUI,'meaFlowVec');
% Retrieve gageNum and gageName
gageNumber = getappdata(hUFinchGUI,'gageNumber');
gageName   = getappdata(hUFinchGUI,'gageName');
%
% Retrieve time parameters
ndxSim     = getappdata(hUFinchGUI,'ndxSim');
ndxMea     = getappdata(hUFinchGUI,'ndxMea');
%
dynParm    = getappdata(hUFinchGUI,'dynParm');
% logAdjFlowVec = logMeaFlowVec(1:end -bhat(5) +1)  + logAdjErrVec;
[nrowMea, ncol] = size(meaFlowVec(ndxMea(1:end-dynParm(3)+1)));
fprintf(1,'size of meaFlowVec: nrow = %u, ncol = %u\n',nrowMea,ncol);
[nrowSim, ncol] = size(simFlowVec(ndxSim(dynParm(3):end)));
fprintf(1,'size of simFlowVec: nrow = %u, ncol = %u\n',nrowSim,ncol);
% plot simulated and measured flows
labelQselQerrPB = get(handles.scatterQselQerrPB,'String');
estimator = labelQselQerrPB(1:4);
switch estimator
    case 'Simu'
    % Simulated Flow
    colorPnt = 'r';
    % differences between log10 simulated flows and log10 measured
    % flows at contemporaneous times
    simDifMea  = getappdata(hUFinchGUI,'simDifMea');
    % Simulated flows that are non-zero
    simFlowCmp = getappdata(hUFinchGUI,'simFlowCmp');
%     errFlowVec = log10(meaFlowVec(ndxMea(1:end-dynParm(5)+1))) - ...
%         log10(simFlowVec(ndxSim(dynParm(5):end)));
%     semilogx(simFlowVec(ndxSim(dynParm(5):end)),...
%         errFlowVec,'Color',colorPnt,'Marker','.','MarkerSize',1,...
%         'parent',handles.scatterPlot);
    semilogx(simFlowCmp,simDifMea,'Color',colorPnt,'Marker','.',...
        'MarkerSize',1,'parent',handles.scatterPlot);
    hold(handles.scatterPlot,'on');
    semilogx([0.7*nanmin(simFlowCmp),...
        1.3*nanmax(simFlowCmp)],[0,0],...
        'Color',[0.5 0.5 0.5],'LineStyle','--',...
        'parent',handles.scatterPlot);
    xlabel(handles.scatterPlot,'Simulated Flow, in cfs');
    ylabel(handles.scatterPlot,'log_{10}Measured - log_{10}Simulated Flows, in cfs');
    meanErr = mean(simDifMea);
    varErr  = var( simDifMea);
    %
    case 'Stat'
    % Statically Corrected Flow
    colorPnt = 'g';
    [nrowAdj,ncol] = size(adjFlowVec);
    fprintf(1,'adjFlowVec: nrows = %u, ncols = %u\n',nrowAdj,ncol);
    if (nrowMea - nrowAdj) == 1
        last = 0;
    else
        last = 1;
    end
    [nrow,ncol] = size(meaFlowVec(ndxMea(1:end-dynParm(3) + last)));
    fprintf(1,'meaFlowVec(ndxMea(1:end-dynParm(5) + last )): nrows = %u, ncols = %u\n',nrow,ncol);
    fprintf(1,'dynParm(3): %u\n',dynParm(3));
    errFlowVec = log10(meaFlowVec(ndxMea(1:end-dynParm(3) + last))) - log10(adjFlowVec);
%%
    sttDifMea  = getappdata(hUFinchGUI,'sttDifMea');
    % Simulated flows that are non-zero
    sttFlowCmp = getappdata(hUFinchGUI,'sttFlowCmp');
%     errFlowVec = log10(meaFlowVec(ndxMea(1:end-dynParm(5)+1))) - ...
%         log10(simFlowVec(ndxSim(dynParm(5):end)));
%     semilogx(simFlowVec(ndxSim(dynParm(5):end)),...
%         errFlowVec,'Color',colorPnt,'Marker','.','MarkerSize',1,...
%         'parent',handles.scatterPlot);
    semilogx(sttFlowCmp,sttDifMea,'Color',colorPnt,'Marker','.',...
        'MarkerSize',1,'parent',handles.scatterPlot);
    hold(handles.scatterPlot,'on');
    semilogx([0.7*nanmin(sttFlowCmp),...
        1.3*nanmax(sttFlowCmp)],[0,0],...
        'Color',[0.5 0.5 0.5],'LineStyle','--',...
        'parent',handles.scatterPlot);
%%
    
%     semilogx(adjFlowVec,errFlowVec,'Color',colorPnt,'Marker','.','MarkerSize',1,...
%         'parent',handles.scatterPlot);
    hold(handles.scatterPlot,'on');
    semilogx([0.7*nanmin(sttFlowCmp),...
        1.3*nanmax(sttFlowCmp)],[0,0],...
        'Color',[0.5 0.5 0.5],'LineStyle','--',...
        'parent',handles.scatterPlot);
    xlabel(handles.scatterPlot,'Statically Corrected Flow, in cfs');
    ylabel(handles.scatterPlot,'log_{10}Measured - log_{10}Statically Corrected Flows, in cfs');
    % disp(errFlowVec(1:100));
    meanErr = mean(sttDifMea);
    varErr  = var( sttDifMea);
    %
end
%
hold(handles.scatterPlot,'off');
legend(handles.scatterPlot,'Data Pairs','Zero Reference',...
    'Location','SouthEast');
xLim = get(handles.scatterPlot,'XLim');
yLim = get(handles.scatterPlot,'YLim');
fprintf(1,'meanErr = %f\n',meanErr);
fprintf(1,'varErr  = %f\n',varErr );
text(xLim(1)*1.25,yLim(2)-0.05*(yLim(2)-yLim(1)),...
    ['MSE = bias^2 + var = ',num2str(meanErr,4),'^2 + ',num2str(varErr,4),...
    ' = ',num2str(meanErr^2 + varErr,'%8.4g')]);
title(handles.scatterPlot,['Error Scatter for ',gageNumber,' ',gageName]);


% --- Executes when selected object is changed in FlowEstimatorBG.
function FlowEstimatorBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in FlowEstimatorBG
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag');
    case 'simFlowRB'
        display('Simulated flow.');
        set(handles.scatterQselQmeaPB,'String','Simulated vs Measured Flow');
        set(handles.scatterQselQerrPB,'String','Simulated Flow vs Model Error');
    case 'sttFlowRB'
        display('Statically Corrected Flow.');
        set(handles.scatterQselQmeaPB,'String','Statically Corrected vs Measured Flow');
        set(handles.scatterQselQerrPB,'String','Statically Corrected Flow vs Model Error');
    case 'difFlowRB'
        display('Differentially Corrected Flow.');
        set(handles.scatterQselQmeaPB,'String','Differentially Corrected vs Measured Flow');
        set(handles.scatterQselQerrPB,'String','Differentially Corrected Flow vs Model Error');
end



function quadraticMagnitudeET_Callback(hObject, eventdata, handles)
% hObject    handle to quadraticMagnitudeET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quadraticMagnitudeET as text
%        str2double(get(hObject,'String')) returns contents of quadraticMagnitudeET as a double


% --- Executes during object creation, after setting all properties.
function quadraticMagnitudeET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadraticMagnitudeET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function quadraticTendSlider_Callback(hObject, eventdata, handles)
% hObject    handle to quadraticTendSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function quadraticTendSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadraticTendSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function linearStdErrorET_Callback(hObject, eventdata, handles)
% hObject    handle to linearStdErrorET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linearStdErrorET as text
%        str2double(get(hObject,'String')) returns contents of linearStdErrorET as a double


% --- Executes during object creation, after setting all properties.
function linearStdErrorET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linearStdErrorET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function quadraticStdErrorET_Callback(hObject, eventdata, handles)
% hObject    handle to quadraticStdErrorET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quadraticStdErrorET as text
%        str2double(get(hObject,'String')) returns contents of quadraticStdErrorET as a double


% --- Executes during object creation, after setting all properties.
function quadraticStdErrorET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadraticStdErrorET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function constantStdErrorET_Callback(hObject, eventdata, handles)
% hObject    handle to constantStdErrorET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of constantStdErrorET as text
%        str2double(get(hObject,'String')) returns contents of constantStdErrorET as a double


% --- Executes during object creation, after setting all properties.
function constantStdErrorET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constantStdErrorET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function linearPvalueET_Callback(hObject, eventdata, handles)
% hObject    handle to linearPvalueET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linearPvalueET as text
%        str2double(get(hObject,'String')) returns contents of linearPvalueET as a double


% --- Executes during object creation, after setting all properties.
function linearPvalueET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linearPvalueET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function quadraticPvalueET_Callback(hObject, eventdata, handles)
% hObject    handle to quadraticPvalueET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quadraticPvalueET as text
%        str2double(get(hObject,'String')) returns contents of quadraticPvalueET as a double


% --- Executes during object creation, after setting all properties.
function quadraticPvalueET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadraticPvalueET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function constantPvalueET_Callback(hObject, eventdata, handles)
% hObject    handle to constantPvalueET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of constantPvalueET as text
%        str2double(get(hObject,'String')) returns contents of constantPvalueET as a double


% --- Executes during object creation, after setting all properties.
function constantPvalueET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constantPvalueET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function linearTstatET_Callback(hObject, eventdata, handles)
% hObject    handle to linearTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linearTstatET as text
%        str2double(get(hObject,'String')) returns contents of linearTstatET as a double


% --- Executes during object creation, after setting all properties.
function linearTstatET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linearTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function quadraticTstatET_Callback(hObject, eventdata, handles)
% hObject    handle to quadraticTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quadraticTstatET as text
%        str2double(get(hObject,'String')) returns contents of quadraticTstatET as a double


% --- Executes during object creation, after setting all properties.
function quadraticTstatET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadraticTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function constantTstatET_Callback(hObject, eventdata, handles)
% hObject    handle to constantTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of constantTstatET as text
%        str2double(get(hObject,'String')) returns contents of constantTstatET as a double


% --- Executes during object creation, after setting all properties.
function constantTstatET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constantTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotSttCorUnitFlowsPB.
function plotSttCorUnitFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotSttCorUnitFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorVec   = get(handles.plotSttCorUnitFlowsPB,'BackgroundColor');
if ((colorVec - [0.933 0.933 0.933]) * (colorVec - [0.933 0.933 0.933])' < 1e-5)
    msgbox('Check whether adjusted flows have been computed');
    return
end
%
hUFinchGUI = getappdata(0,'hUFinchGUI');
meaTimeVec = getappdata(hUFinchGUI,'meaTimeVec');
meaFlowVec = getappdata(hUFinchGUI,'meaFlowVec');
ndxMea     = getappdata(hUFinchGUI,'ndxMea');
simTimeVec = getappdata(hUFinchGUI,'vYrMoDaHrMn')';
simFlowVec = getappdata(hUFinchGUI,'simFlowVec');
ndxSim     = getappdata(hUFinchGUI,'ndxSim');
sttTimeVec = getappdata(hUFinchGUI,'sttTimeVec');
sttFlowVec = getappdata(hUFinchGUI,'sttFlowVec');
ndxStt     = getappdata(hUFinchGUI,'ndxStt');
dynParm5   = str2double(get(handles.parmDifLagET,'String'));
%
% Clear hydrograph (The statement below cleared just the hydrograph)
cla(handles.hydrographPlot,'reset');
% Plot hydrograph of measured flows
semilogy(meaTimeVec(ndxMea(1:end-dynParm5+1)),...
    meaFlowVec(ndxMea(1:end-dynParm5+1)),'b-','LineWidth',0.25,...
    'parent',handles.hydrographPlot);
datetick(handles.hydrographPlot,'x');
hold(handles.hydrographPlot,'on');
%
semilogy(simTimeVec(ndxSim(1:end-dynParm5+1)),...
    simFlowVec(ndxSim(dynParm5:end)),'r-','LineWidth',0.25,...
    'parent',handles.hydrographPlot);
%
semilogy(sttTimeVec(ndxStt(1:end-dynParm5+1)),...
    sttFlowVec(ndxStt(dynParm5:end)),'g-','LineWidth',1.25,...
    'parent',handles.hydrographPlot);
hold(handles.hydrographPlot,'off');
legend(handles.hydrographPlot,'Measured','Simulated','Static Correction',...
    'Position','Best');


% --- Executes when selected object is changed in selectFlowEstimateBP.
function selectFlowEstimateBP_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in selectFlowEstimateBP
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
estFlowName = get(eventdata.NewValue,'Tag');
estFlowName = estFlowName(1:3);
hUFinchGUI = getappdata(0,'hUFinchGUI');
setappdata(hUFinchGUI,'estFlowName',estFlowName);
fprintf(1,'%s\n',estFlowName);
guidata(hObject,handles);
%


% --- Executes when selected object is changed in regTechBG.
function regTechBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in regTechBG
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.regTech = get(eventdata.NewValue,'Tag');
fprintf(1,'regression technique: %s\n',handles.regTech);
guidata(hObject,handles);
