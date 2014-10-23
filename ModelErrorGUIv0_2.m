function varargout = ModelErrorGUIv0_2(varargin)
% MODELERRORGUIV0_2 MATLAB code for ModelErrorGUIv0_2.fig
%      MODELERRORGUIV0_2, by itself, creates a new MODELERRORGUIV0_2 or raises the existing
%      singleton*.
%
%      H = MODELERRORGUIV0_2 returns the handle to a new MODELERRORGUIV0_2 or the handle to
%      the existing singleton*.
%
%      MODELERRORGUIV0_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODELERRORGUIV0_2.M with the given input arguments.
%
%      MODELERRORGUIV0_2('Property','Value',...) creates a new MODELERRORGUIV0_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ModelErrorGUIv0_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ModelErrorGUIv0_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModelErrorGUIv0_2

% Last Modified by GUIDE v2.5 07-Oct-2014 15:17:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ModelErrorGUIv0_2_OpeningFcn, ...
    'gui_OutputFcn',  @ModelErrorGUIv0_2_OutputFcn, ...
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


% --- Executes just before ModelErrorGUIv0_2 is made visible.
function ModelErrorGUIv0_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModelErrorGUIv0_2 (see VARARGIN)

% Choose default command line output for ModelErrorGUIv0_2
handles.output = hObject;
% Set default estimation series for differential correction to 'simFlowVec'
handles.estFlowVec = 'simFlowVec';
% Regression parameter estimation techinque
handles.regTech = 'olsRB'; % Tag associated with OLS regression
% Setup handle to UFinchGUI memory space
hUFinchGUI     = getappdata(0,'hUFinchGUI');
 main          = getappdata(hUFinchGUI);
hMain          = main.handles;
trgtDrnArea    = get(hMain.daMiSqST,'String');
set(handles.trgtDrnAreaST,'String',trgtDrnArea);
gageDrnArea    = getappdata(hUFinchGUI,'gageDrnArea');
set(handles.baseDrnAreaST,'String',gageDrnArea);
gageNumber     = getappdata(hUFinchGUI,'gageNumber');
set(handles.baseGageST,'String',gageNumber);
trgtGageNumber = get(hMain.GageNumberST,'String');
set(handles.trgtGageST,'String',trgtGageNumber);
set(handles.drnAreaRatioST,'String',num2str(str2double(trgtDrnArea)/...
    str2double(gageDrnArea),'%5.3f'));
cla(handles.scatterPlot,'reset');
cla(handles.hydrographPlot,'reset');
setappdata(hUFinchGUI,'selFlow','simFlowVec');
% Get preliminary estimate of delay in 15-min intervals
% tDelay15   = getappdata(hUFinchGUI,'tDelay15');
guidata(hObject, handles);
% plotSttCorUnitFlowsPB_Callback(handles.plotSttCorUnitFlowsPB, eventdata, handles)
plotMeasuredUnitFlowsPB_Callback(handles.plotMeasuredUnitFlowsPB, eventdata, handles)
plotSimulatedUnitFlowsPB_Callback(handles.plotSimulatedUnitFlowsPB, eventdata, handles)
plotEcdfPB_Callback(handles.plotSimulatedUnitFlowsPB, eventdata, handles)


% UIWAIT makes ModelErrorGUIv0_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModelErrorGUIv0_2_OutputFcn(hObject, eventdata, handles)
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
trgtComID   = get(handleMain.GageComIdST,'String');
% Get vector of all ComIDs
ComID      = getappdata(hUFinchGUI,'ComID');
% Find index of trgtComID in ComID vector
ndxComID   = find(ComID == str2double(trgtComID));
% Retrieve simulated dateTime and Flows
simFlowVec = qSimMatrix(ndxComID,:)';
% Retrieve measured dateTime and Flows
meaFlowVec = getappdata(hUFinchGUI,'meaFlowVec');
% Retrieve target gageNum and gageName
trgtGageNumber   = getappdata(hUFinchGUI,'trgtGageNumber');
trgtGageName     = getappdata(hUFinchGUI,'trgtGageName'); 
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
        colorPnt = 'k';
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
title(handles.scatterPlot,['Scatter Plot of Flows for ',trgtGageNumber,' ',trgtGageName]);
%
% --- Executes on button press in plotStaticErrorModelPB.
function plotStaticErrorModelPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotStaticErrorModelPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Setup access to hUFinchGUI memory
hUFinchGUI  = getappdata(0,'hUFinchGUI');
simFlowCmp  = getappdata(hUFinchGUI,'simFlowCmp');
meaFlowCmp  = getappdata(hUFinchGUI,'meaFlowCmp');
tbl         = getappdata(hUFinchGUI,'tbl');
linrParm    = get(handles.linrTermCB,'Value');
quadParm    = get(handles.quadTermCB,'Value');
dif1Parm    = get(handles.dif1TermCB,'Value');
%
% assign main gui handles
handleMain   = getappdata(hUFinchGUI,'handles');
% retrieve model
mdl         = getappdata(hUFinchGUI,'mdl');
% compute spanning simulated flow vector 
minSimFlow  = min(simFlowCmp);
maxSimFlow  = max(simFlowCmp);
prdSimFlow  = linspace(log10(minSimFlow),log10(maxSimFlow),100);
if (mdl.NumCoefficients > 1 && mdl.NumCoefficients < 4)
    prdErrFlow  = feval(mdl,prdSimFlow);
elseif linrParm==1 && quadParm==1 && dif1Parm==1
    p055095 = prctile(tbl.dif1LogSimFlow,[5,50,95]);
        prdDif1Flo  = p055095(2) .* ones(size(prdSimFlow));
        prdErrFlow  = feval(mdl,prdSimFlow,prdDif1Flo);
else
    prdErrFlow = mdl.Coefficients{1,1}*ones(size(prdSimFlow));
end
% 
cla(handles.scatterPlot,'reset');
simMinusMea    = log10(meaFlowCmp) - log10(simFlowCmp);
simMinusMea    =     mdl.Fitted + mdl.Residuals{:,1};
simFlowCmp     = 10.^tbl.logSimFlow;
semilogx(simFlowCmp,simMinusMea,'g.','MarkerSize',0.1);
hold(handles.scatterPlot,'on');
% Get parameter estimation technique

if (strcmp(handles.regTech,'robustRB'))
    linestyle  = '-.';
    parmEstTech   = 'Robust';
else
    linestyle  = '-';
    parmEstTech   = 'OLS';
end
% 
if      linrParm==1 && quadParm==1 && dif1Parm==1
    fprintf(1,'A quadratic model with differential correction will be used as the error model\n');
    p055095     = prctile(tbl.dif1LogSimFlow,[5,50,95]);
    prdDif1Flo  = p055095(2) .* ones(size(prdSimFlow));
    prdErrFlow  = feval(mdl,prdSimFlow,prdDif1Flo);
    semilogx(10.^prdSimFlow,prdErrFlow,'b','LineWidth',2,'LineStyle',linestyle,...
        'parent',handles.scatterPlot);
    prdDif1Flo  = p055095(1) .* ones(size(prdSimFlow));
    prdErrFlow  = feval(mdl,prdSimFlow,prdDif1Flo);
    semilogx(10.^prdSimFlow,prdErrFlow,'r','LineWidth',2,'LineStyle',':',...
        'parent',handles.scatterPlot);
    prdDif1Flo  = p055095(3) .* ones(size(prdSimFlow));
    prdErrFlow  = feval(mdl,prdSimFlow,prdDif1Flo);
    semilogx(10.^prdSimFlow,prdErrFlow,'r','LineWidth',2,'LineStyle',':',...
        'parent',handles.scatterPlot);
    
    
else
    semilogx(10.^prdSimFlow,prdErrFlow,'b','LineWidth',2,'LineStyle',linestyle,...
        'parent',handles.scatterPlot);
end
    xlabel(handles.scatterPlot,'Simulated Flow, in cfs');
    ylabel(handles.scatterPlot,'log_{10}Measured - log_{10}Simulated Flows, in cfs');
    trgtGageNumber = get(handleMain.GageNumberST,'String');
    trgtGageName   = get(handleMain.GageNameST,'String');
    title(handles.scatterPlot,['Static Correction at ',trgtGageNumber,' ',trgtGageName]);
    hold(handles.scatterPlot,'on');
legend('Data pairs',parmEstTech,'Location','Best');



%%
% Target ComID
% Get date time vector.
simTimeVec   = getappdata(hUFinchGUI,'vYrMoDaHrMn');
ndxSim       = getappdata(hUFinchGUI,'ndxSim');
% Get simulated flow matrix
qndxIDtDelay = getappdata(hUFinchGUI,'qndxIDtDelay');
% Identify and select the vector of simulated flows
ComID       = getappdata(hUFinchGUI,'ComID');
trgtComID    = str2double(get(handleMain.GageComIdST,'String'));
ndxComID     = find(ComID == trgtComID);
tDelay15     = getappdata(hUFinchGUI,'tDelay15');

%%






% minSttFlow  = 10.^(nanmin(log10(sttFlowVec)));
% maxSttFlow  = 10.^(nanmax(log10(sttFlowVec)));
% % generate sequence spanning flow of length 100
% rngSttFlow  = linspace(log10(minSttFlow),log10(maxSttFlow))';
% % predict error from flow sequence
% estSttError = predict(mdl,rngSttFlow);
% % Adjust for bias
% estSttError = estSttError * 10^(mdl.MSE/2);
% %
% hold(handles.scatterPlot,'on');
% plot(handles.scatterPlot,10.^(rngSttFlow),estSttError,'Color',[0.5,0.5,0.5],...
%     'LineStyle','--');
% fprintf(1,'mdl.MSE = %f.\n',mdl.MSE);
% % adjFlowVec    = 10.^(log10(simFlowVec) - simLogErr) * 10^(mdl.MSE/2);
% % Store bias adjusted flow to memory
% setappdata(hUFinchGUI,'adjFlowVec',adjFlowVec);
% set(handles.plotDifCorUnitFlowsPB,'BackgroundColor',[0.83,0.82,0.78]);


% --- Executes on button press in estStaticModelParametersPB.
function estStaticModelParametersPB_Callback(hObject, eventdata, handles)
% hObject    handle to estStaticModelParametersPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Get model parameter estimates
% Always including an intercept term so don't need to check active status
% cnstParm = str2double(get(handles.interceptMagET,'String'));
% Get active status for linear, quadratic, and difference models
linrParm = get(handles.linrTermCB,'Value');
quadParm = get(handles.quadTermCB,'Value');
dif1Parm = get(handles.dif1TermCB,'Value');

fprintf(1,'linrParm = %u, quadParm = %u, dif1Parm = %u\n',...
    linrParm, quadParm, dif1Parm);
%
% Establish handle for GUI memory space
hUFinchGUI = getappdata(0,'hUFinchGUI');
% Load the measured unit flows
meaFlowVec   = getappdata(hUFinchGUI,'meaFlowVec');
ndxMea       = getappdata(hUFinchGUI,'ndxMea');
meaTimeVec   = getappdata(hUFinchGUI,'meaTimeVec');
% Load the simulated unit flows
simFlowVec   = getappdata(hUFinchGUI,'simFlowVec')';
ndxSim       = getappdata(hUFinchGUI,'ndxSim');
simTimeVec   = getappdata(hUFinchGUI,'vYrMoDaHrMn');
tDelay15     = getappdata(hUFinchGUI,'tDelay15');
[nRow, nCol] = size(meaFlowVec(ndxMea(1:end-tDelay15+1)));
fprintf(1,'meaFlowVec: nRow = %u, nCol = %u\n',nRow, nCol);
[nRow, nCol] = size(simFlowVec(ndxSim(tDelay15:end)));
fprintf(1,'simFlowVec: nRow = %u, nCol = %u\n',nRow, nCol);
%
meaFlow    = meaFlowVec(ndxMea(1:end-tDelay15+1));
simFlow    = simFlowVec(ndxSim(tDelay15:end));
% Find any simFlows that are not zeros (includes both real and artifact zeros)
ndxNaZ     = find(simFlow>0);
%
errFlow    = log10(meaFlow(ndxNaZ)) - log10(simFlow(ndxNaZ));
% Compute first difference in logSimFlow
dif1LogSimFlow = [NaN; diff(log10(simFlow(ndxNaZ))) ];
tbl = table(log10(simFlow(ndxNaZ)), dif1LogSimFlow, errFlow(ndxNaZ),...
    'VariableNames',{'logSimFlow','dif1LogSimFlow','logSimErr'}); 
% Evaluate initial model parameters to select model
% set rb to 'on' for robust regression
regTech = handles.regTech;
fprintf(1,'regTech = %s\n',regTech);
if (strcmp(handles.regTech,'robustRB'))
    rb  = 'on';
else
    rb  = 'off';
end
if      linrParm==1 && quadParm==1 && dif1Parm==1 
    fprintf(1,'A quadratic model with differential correction will be used as the error model\n');
    % Develop a quadratic regression model
    mdl = fitlm(tbl,'logSimErr ~ logSimFlow + logSimFlow^2 + dif1LogSimFlow','RobustOpts',rb);
    disp(mdl);
    X       = [tbl.logSimFlow,tbl.dif1LogSimFlow];
    ypred   = predict(mdl,X);
    % Find explanatory variable positions in regression
    p1 = find(strcmp(mdl.CoefficientNames,'(Intercept)')==1);
    p2 = find(strcmp(mdl.CoefficientNames,'logSimFlow')==1);
    p3 = find(strcmp(mdl.CoefficientNames,'logSimFlow^2')==1);
    p4 = find(strcmp(mdl.CoefficientNames,'dif1LogSimFlow')==1);
    % Populate table of parameters
    set(handles.interceptMagET,'String',num2str(mdl.Coefficients.Estimate(p1)));
    set(handles.linrLogSimMagET,'String',num2str(mdl.Coefficients.Estimate(p2)));
    set(handles.quadLogSimMagET,'String',num2str(mdl.Coefficients.Estimate(p3)));
    set(handles.dif1LogSimMagET,'String',num2str(mdl.Coefficients.Estimate(p4)));
    
    set(handles.interceptStdET,'String',num2str(mdl.Coefficients.SE(p1)));
    set(handles.linrLogSimStdET,'String',num2str(mdl.Coefficients.SE(p2)));
    set(handles.quadLogSimStdET,'String',num2str(mdl.Coefficients.SE(p3)));
    set(handles.dif1LogSimStdET,'String',num2str(mdl.Coefficients.SE(p4)));
    
    set(handles.interceptTstatET,'String',num2str(mdl.Coefficients.tStat(p1)));
    set(handles.linrLogSimTstatET,'String',num2str(mdl.Coefficients.tStat(p2)));
    set(handles.quadLogSimTstatET,'String',num2str(mdl.Coefficients.tStat(p3)));
    set(handles.dif1LogSimTstatET,'String',num2str(mdl.Coefficients.tStat(p4)));
    
    set(handles.interceptPvalET,'String',num2str(mdl.Coefficients.pValue(p1)));
    set(handles.linrLogSimPvalET,'String',num2str(mdl.Coefficients.pValue(p2)));
    set(handles.quadLogSimPvalET,'String',num2str(mdl.Coefficients.pValue(p3)));
    set(handles.dif1LogSimPvalET,'String',num2str(mdl.Coefficients.pValue(p4)));
    
    set(handles.adjR2StaticModelST,'String',num2str(mdl.Rsquared.Adjusted));
    set(handles.rmseStaticModelST,'String',num2str(mdl.RMSE));
    % Change background color of push button to plot static estimates
    set(handles.plotSttCorUnitFlowsPB,'BackgroundColor',[0.831, 0.816, 0.784]);
    %
elseif  linrParm==1 && quadParm==1 && dif1Parm==0 
    fprintf(1,'A quadratic model will be used as the error model.\n');
    % Develop a quadratic regression model
    mdl = fitlm(tbl,'logSimErr ~ logSimFlow + logSimFlow^2', 'RobustOpts',rb);
    disp(mdl);
    X       = [tbl.logSimFlow,tbl.logSimFlow.^2];
    ypred   = predict(mdl,X);
    % Find explanatory variable positions in regression
    p1 = find(strcmp(mdl.CoefficientNames,'(Intercept)')==1);
    p2 = find(strcmp(mdl.CoefficientNames,'logSimFlow')==1);
    p3 = find(strcmp(mdl.CoefficientNames,'logSimFlow^2')==1);
    % Populate table of parameters
    set(handles.interceptMagET,'String',num2str(mdl.Coefficients.Estimate(p1)));
    set(handles.linrLogSimMagET,'String',num2str(mdl.Coefficients.Estimate(p2)));
    set(handles.quadLogSimMagET,'String',num2str(mdl.Coefficients.Estimate(p3)));
    set(handles.dif1LogSimMagET,'String','NaN');
    
    set(handles.interceptStdET,'String',num2str(mdl.Coefficients.SE(p1)));
    set(handles.linrLogSimStdET,'String',num2str(mdl.Coefficients.SE(p2)));
    set(handles.quadLogSimStdET,'String',num2str(mdl.Coefficients.SE(p3)));
    set(handles.dif1LogSimStdET,'String','NaN');
    
    set(handles.interceptTstatET,'String',num2str(mdl.Coefficients.tStat(p1)));
    set(handles.linrLogSimTstatET,'String',num2str(mdl.Coefficients.tStat(p2)));
    set(handles.quadLogSimTstatET,'String',num2str(mdl.Coefficients.tStat(p3)));
    set(handles.dif1LogSimTstatET,'String','NaN');
    
    set(handles.interceptPvalET,'String',num2str(mdl.Coefficients.pValue(p1)));
    set(handles.linrLogSimPvalET,'String',num2str(mdl.Coefficients.pValue(p2)));
    set(handles.quadLogSimPvalET,'String',num2str(mdl.Coefficients.pValue(p3)));
    set(handles.dif1LogSimPvalET,'String','NaN');
    
    set(handles.adjR2StaticModelST,'String',num2str(mdl.Rsquared.Adjusted));
    set(handles.rmseStaticModelST,'String',num2str(mdl.RMSE));
    % Change background color of push button to plot static estimates
    set(handles.plotSttCorUnitFlowsPB,'BackgroundColor',[0.831, 0.816, 0.784]);
    
elseif   linrParm==1 && quadParm==0 && dif1Parm==0 
    fprintf(1,'A linear model will be used as the error model.\n');
    % Develop a linear regression model
    mdl = fitlm(tbl,'logSimErr ~ logSimFlow', 'RobustOpts',rb);
    % mdl = fitlm(tbl,'linear','logSimErr','logSimFlow', 'RobustOpts',rb);
    disp(mdl);
    X       = [tbl.logSimFlow];
    ypred   = feval(mdl,X);
    % This form of predict doesn't work
    % ypred   = predict(mdl,X);
    % Find explanatory variable positions in regression
    p1 = find(strcmp(mdl.CoefficientNames,'(Intercept)')==1);
    p2 = find(strcmp(mdl.CoefficientNames,'logSimFlow')==1);
    % Populate table of parameters
    set(handles.interceptMagET,'String',num2str(mdl.Coefficients.Estimate(p1)));
    set(handles.linrLogSimMagET,'String',num2str(mdl.Coefficients.Estimate(p2)));
    set(handles.quadLogSimMagET,'String','NaN');
    set(handles.dif1LogSimMagET,'String','NaN');
    
    set(handles.interceptStdET,'String',num2str(mdl.Coefficients.SE(p1)));
    set(handles.linrLogSimStdET,'String',num2str(mdl.Coefficients.SE(p2)));
    set(handles.quadLogSimStdET,'String','NaN');
    set(handles.dif1LogSimStdET,'String','NaN');
    
    set(handles.interceptTstatET,'String',num2str(mdl.Coefficients.tStat(p1)));
    set(handles.linrLogSimTstatET,'String',num2str(mdl.Coefficients.tStat(p2)));
    set(handles.quadLogSimTstatET,'String','NaN');
    set(handles.dif1LogSimTstatET,'String','NaN');
    
    set(handles.interceptPvalET,'String',num2str(mdl.Coefficients.pValue(p1)));
    set(handles.linrLogSimPvalET,'String',num2str(mdl.Coefficients.pValue(p2)));
    set(handles.quadLogSimPvalET,'String','NaN');
    set(handles.dif1LogSimPvalET,'String','NaN');
    
    set(handles.adjR2StaticModelST,'String',num2str(mdl.Rsquared.Adjusted));
    set(handles.rmseStaticModelST,'String',num2str(mdl.RMSE));
    % Change background color of push button to plot static estimates
    set(handles.plotSttCorUnitFlowsPB,'BackgroundColor',[0.831, 0.816, 0.784]);
    
elseif linrParm==0 && quadParm==0 && dif1Parm==0
    fprintf(1,'A constant model will be used to describe the error\n');
    % Develop a constant regression model
    mdl = fitlm(log10(simFlow(ndxNaZ)), errFlow(ndxNaZ),'constant','RobustOpts',rb);
    disp(mdl);
    ypred   = predict(mdl);
    % Populate table of parameters
    set(handles.interceptMagET,'String',num2str(mdl.Coefficients.Estimate(1)));
    set(handles.linrLogSimMagET,'String','NaN');
    set(handles.quadLogSimMagET,'String','NaN');
    set(handles.dif1LogSimMagET,'String','NaN');
    
    set(handles.interceptStdET,'String',num2str(mdl.Coefficients.SE(1)));
    set(handles.linrLogSimStdET,'String','NaN');
    set(handles.quadLogSimStdET,'String','NaN');
    set(handles.dif1LogSimStdET,'String','NaN');
    
    set(handles.interceptTstatET,'String',num2str(mdl.Coefficients.tStat(1)));
    set(handles.linrLogSimTstatET,'String','NaN');
    set(handles.quadLogSimTstatET,'String','NaN');
    set(handles.dif1LogSimTstatET,'String','NaN');
    
    set(handles.interceptPvalET,'String',num2str(mdl.Coefficients.pValue(1)));
    set(handles.linrLogSimPvalET,'String','NaN');
    set(handles.quadLogSimPvalET,'String','NaN');
    set(handles.dif1LogSimPvalET,'String','NaN');
    
    set(handles.adjR2StaticModelST,'String','NaN');
    set(handles.rmseStaticModelST,'String',num2str(mdl.RMSE));
    % Change background color of push button to plot static estimates
    set(handles.plotSttCorUnitFlowsPB,'BackgroundColor',[0.831, 0.816, 0.784]);
elseif linrParm==1 && quadParm==1 && dif1Parm==1 
    fprintf(1,'A constant model will be used to describe the error\n');
    % Develop a constant regression model
    mdl = fitlm(tbl,...
        'logSimErr ~ 1 + logSimFlow + logSimFlow^2 + dif1LogSimFlow ',...
        'RobustOpt',rb);
    disp(mdl);
    ypred   = predict(mdl);
    % Populate table of parameters
    set(handles.interceptMagET,'String', num2str(mdl.Coefficients.Estimate(1)));
    set(handles.linrLogSimMagET,'String',num2str(mdl.Coefficients.Estimate(2)));
    set(handles.quadLogSimMagET,'String',num2str(mdl.Coefficients.Estimate(3)));
    set(handles.dif1LogSimMagET,'String',num2str(mdl.Coefficients.Estimate(4)));
    
    set(handles.interceptStdET,'String', num2str(mdl.Coefficients.SE(1)));
    set(handles.linrLogSimStdET,'String',num2str(mdl.Coefficients.SE(2)));
    set(handles.quadLogSimStdET,'String',num2str(mdl.Coefficients.SE(3)));
    set(handles.dif1LogSimStdET,'String',num2str(mdl.Coefficients.SE(4)));
    
    set(handles.interceptTstatET,'String', num2str(mdl.Coefficients.tStat(1)));
    set(handles.linrLogSimTstatET,'String',num2str(mdl.Coefficients.tStat(2)));
    set(handles.quadLogSimTstatET,'String',num2str(mdl.Coefficients.tStat(3)));
    set(handles.dif1LogSimTstatET,'String',num2str(mdl.Coefficients.tStat(4)));
    
    set(handles.interceptPvalET,'String', num2str(mdl.Coefficients.pValue(1)));
    set(handles.linrLogSimPvalET,'String',num2str(mdl.Coefficients.pValue(2)));
    set(handles.quadLogSimPvalET,'String',num2str(mdl.Coefficients.pValue(3)));
    set(handles.dif1LogSimPvalET,'String',num2str(mdl.Coefficients.pValue(4)));
    
    set(handles.adjR2StaticModelST,'String',num2str(mdl.Rsquared.Adjusted));
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
% ypred              = predict(mdl,log10(simFlow(ndxNaZ)));
sttTimeVec         = simTimeVec;
ndxStt             = ndxSim;
% Initialize static flow vector
sttFlowVec         = NaN(size(simFlowVec));
% Use Smearing bias adjustment to correct flows
mse                = mdl.RMSE^2;
%
sttFlow            = NaN(size(simFlow));
sttFlow(ndxNaZ)    = 10.^(log10( simFlow(ndxNaZ))+ ypred ) .* 10^(mse/2);
sttFlowVec(ndxStt(tDelay15:end)) = sttFlow;
%
% figure(4); clf(4);
% plot(simTimeVec(ndxSim(1:end-dynParm5+1)),simFlowVec(ndxSim(dynParm5:end)),'r-');
% datetick('x');
% hold on
% plot(sttTimeVec(ndxStt(1:end-dynParm5+1)),sttFlowVec(ndxStt(dynParm5:end)),'g-');
% plot(meaTimeVec(ndxMea),meaFlowVec(ndxMea),'b-');
%
% Simulated flows comparable with contemporaneous measured flows
simFlowCmp  = simFlowVec(ndxSim(tDelay15:end));
% These indices omit zeros from simulated values
ndxCmp      = find(simFlowCmp > 0);
simFlowCmp  = simFlowCmp(ndxCmp);
% Measured flows comparable with contemporaneous simulated flows
meaFlowCmp  = meaFlowVec(ndxMea(1:end-tDelay15+1));
meaFlowCmp  = meaFlowCmp(ndxCmp);
% Differences between log simulated and measured flows
simDifMea   = log10(simFlowCmp(ndxCmp)) - log10(meaFlowCmp(ndxCmp));
fprintf(1,'Std of log10 simDifMea is %f\n',std(simDifMea));
% Statically corrected flows comparable with contermporaneous measured flows
sttFlowCmp  = sttFlowVec(ndxStt(tDelay15:end));
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
setappdata(hUFinchGUI,'tbl',tbl);
plotSttCorUnitFlowsPB_Callback(handles.plotSttCorUnitFlowsPB, eventdata, handles);
plotEcdfPB_Callback(handles.plotEcdfPB, eventdata, handles);


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
trgtGageNumber   = getappdata(hUFinchGUI,'trgtGageNumber');
trgtGageName     = getappdata(hUFinchGUI,'trgtGageName'); 

%
% Clear hydrograph (The statement below cleared the figure)
cla(handles.hydrographPlot,'reset');
% Plot hydrograph of measured data
semilogy(meaTimeVec(ndxMea(1:end-tDelay15+1)),...
    meaFlowVec(ndxMea(1:end-tDelay15+1)),'b-',...
    'parent',handles.hydrographPlot);
%
datetick(handles.hydrographPlot,'x');
[yearVec,~,~,~,~,~] = datevec(meaTimeVec(ndxMea(1:end-tDelay15+1)));
xlabel(handles.hydrographPlot,[num2str(min(yearVec)),' - ',...
    num2str(max(yearVec))]);
ylabel(handles.hydrographPlot,'Flow, in cubic feet per second');
ylabel(handles.hydrographPlot,'Log_{10} Unit Flows, in ft^3/s');
title(handles.hydrographPlot,['Hydrograph for ',...
    trgtGageNumber,' ',trgtGageName]);
legend(handles.hydrographPlot,'Measured','Location','Best');
%

% --- Executes on button press in plotSimulatedUnitFlowsPB.
function plotSimulatedUnitFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotSimulatedUnitFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Connect function with GUI workspace
hUFinchGUI   = getappdata(0,'hUFinchGUI');
handleMain   = getappdata(hUFinchGUI,'handles');
% Target ComID

% Get date time vector.
simTimeVec   = getappdata(hUFinchGUI,'vYrMoDaHrMn');
ndxSim       = getappdata(hUFinchGUI,'ndxSim');
% Get simulated flow matrix
qndxIDtDelay = getappdata(hUFinchGUI,'qndxIDtDelay');
% Identify and select the vector of simulated flows
ComID       = getappdata(hUFinchGUI,'ComID');
trgtComID    = str2double(get(handleMain.GageComIdST,'String'));
ndxComID     = find(ComID == trgtComID);
tDelay15     = getappdata(hUFinchGUI,'tDelay15');
% Find the index of the target ComID in the sorted ComID vector
fprintf(1,'The index for the target ComID %u is %u.\n',trgtComID,ndxComID);
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
% set(handles.interceptMagET,'String',num2str(biasB0));
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
% Get handle to ModelErrorGUIv0_2 memory space
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


function linrLogSimMagET_Callback(hObject, eventdata, handles)
% hObject    handle to linrLogSimMagET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linrLogSimMagET as text
%        str2double(get(hObject,'String')) returns contents of linrLogSimMagET as a double

% --- Executes during object creation, after setting all properties.
function linrLogSimMagET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linrLogSimMagET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interceptMagET_Callback(hObject, eventdata, handles)
% hObject    handle to interceptMagET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interceptMagET as text
%        str2double(get(hObject,'String')) returns contents of interceptMagET as a double
%
% get string from text box and update slider position
biasB0 = get(hObject,'String');
if strcmpi(biasB0,'NaN')
    set(handles.constantTrendSlider,'Value',0);
else
    set(handles.constantTrendSlider,'Value',str2double(biasB0));
end

% --- Executes during object creation, after setting all properties.
function interceptMagET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interceptMagET (see GCBO)
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
ndxSim     = getappdata(hUFinchGUI,'ndxSim');
tDelay15   = getappdata(hUFinchGUI,'tDelay15');
ndxMea     = getappdata(hUFinchGUI,'ndxMea');
%
% Retrieve target gageNumber and gageName
% trgtComID      = get(handles.GageComIdST,'String');
trgtGageNumber = getappdata(hUFinchGUI,'trgtGageNumber');
trgtGageName   = getappdata(hUFinchGUI,'trgtGageName'); 
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
title(handles.hydrographPlot,['Hydrograph at ',...
    trgtGageNumber,' ',trgtGageName]);
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
trgtComID   = get(handleMain.GageComIdST,'String');
% Get vector of all ComIDs
ComID      = getappdata(hUFinchGUI,'ComID');
% Find index of trgtComID in ComID vector
ndxComID   = find(ComID == str2double(trgtComID));
% Retrieve simulated dateTime and Flows
simFlowVec = qSimMatrix(ndxComID,:)';
adjFlowVec = getappdata(hUFinchGUI,'adjFlowVec')';
% simTimeVec = getappdata(hUFinchGUI,'simTimeVec');
% Retrieve measured dateTime and Flows
% meaTimeVec = getappdata(hUFinchGUI,'meaTimeVec');
meaFlowVec = getappdata(hUFinchGUI,'meaFlowVec');
% Retrieve gageNum and gageName
trgtGageNumber = getappdata(hUFinchGUI,'trgtGageNumber');
trgtGageName   = getappdata(hUFinchGUI,'trgtGageName');
%
% Retrieve time parameters
ndxSim     = getappdata(hUFinchGUI,'ndxSim');
ndxMea     = getappdata(hUFinchGUI,'ndxMea');
tDelay15   = getappdata(hUFinchGUI,'tDelay15');
%
% Clear scatter plot
cla(handles.scatterPlot,'reset');
labelQselQerrPB = get(handles.scatterQselQerrPB,'String');
estimator       = labelQselQerrPB(1:4);
switch estimator
    case 'Simu'
    % Simulated Flow
    colorPnt = 'r';
    % differences between log10 simulated flows and log10 measured
    % flows at contemporaneous times
    simDifMea  = getappdata(hUFinchGUI,'simDifMea');
    % Simulated flows that are non-zero
    simFlowCmp = getappdata(hUFinchGUI,'simFlowCmp');
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
    fprintf(1,'Mean simulated error, in log_{10}CFS: %f\n',meanErr);
    fprintf(1,'Std  static errorr, in log_{10}CFS: %f\n',sqrt(varErr));    
    %
    % Statically Corrected Flow
    case 'Stat'
    colorPnt = 'k';
    % differences between log10 simulated flows and log10 measured
    % flows at contemporaneous times
    sttDifMea  = getappdata(hUFinchGUI,'sttDifMea');
    % Simulated flows that are non-zero
    sttFlowCmp = getappdata(hUFinchGUI,'sttFlowCmp');
    semilogx(sttFlowCmp,sttDifMea,'Color',colorPnt,'Marker','.',...
        'MarkerSize',1,'parent',handles.scatterPlot);
    hold(handles.scatterPlot,'on');
    semilogx([0.7*nanmin(sttFlowCmp),...
        1.3*nanmax(sttFlowCmp)],[0,0],...
        'Color',[0.5 0.5 0.5],'LineStyle','--',...
        'parent',handles.scatterPlot);
    xlabel(handles.scatterPlot,'Statically Corrected Flow, in cfs');
    ylabel(handles.scatterPlot,'log_{10}Measured - log_{10}Statically Corrected Flows, in cfs');
    meanErr = mean(sttDifMea);
    varErr  = var( sttDifMea);
    fprintf(1,'Mean static errorr, in log_{10}CFS: %f\n',meanErr);
    fprintf(1,'Std  static errorr, in log_{10}CFS: %f\n',sqrt(varErr));
  
%     [nrowAdj,ncol] = size(adjFlowVec);
%     fprintf(1,'adjFlowVec: nrows = %u, ncols = %u\n',nrowAdj,ncol);
%     if (nrowMea - nrowAdj) == 1
%         last = 0;
%     else
%         last = 1;
%     end
%     [nrow,ncol] = size(meaFlowVec(ndxMea(1:end-dynParm(3) + last)));
%     fprintf(1,'meaFlowVec(ndxMea(1:end-dynParm(5) + last )): nrows = %u, ncols = %u\n',nrow,ncol);
%     fprintf(1,'dynParm(3): %u\n',dynParm(3));
%     errFlowVec = log10(meaFlowVec(ndxMea(1:end-dynParm(3) + last))) - log10(adjFlowVec);
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
title(handles.scatterPlot,['Error Scatter for ',trgtGageNumber,' ',trgtGageName]);


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



function quadLogSimMagET_Callback(hObject, eventdata, handles)
% hObject    handle to quadLogSimMagET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quadLogSimMagET as text
%        str2double(get(hObject,'String')) returns contents of quadLogSimMagET as a double


% --- Executes during object creation, after setting all properties.
function quadLogSimMagET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadLogSimMagET (see GCBO)
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



function linrLogSimStdET_Callback(hObject, eventdata, handles)
% hObject    handle to linrLogSimStdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linrLogSimStdET as text
%        str2double(get(hObject,'String')) returns contents of linrLogSimStdET as a double


% --- Executes during object creation, after setting all properties.
function linrLogSimStdET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linrLogSimStdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function quadLogSimStdET_Callback(hObject, eventdata, handles)
% hObject    handle to quadLogSimStdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quadLogSimStdET as text
%        str2double(get(hObject,'String')) returns contents of quadLogSimStdET as a double


% --- Executes during object creation, after setting all properties.
function quadLogSimStdET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadLogSimStdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interceptStdET_Callback(hObject, eventdata, handles)
% hObject    handle to interceptStdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interceptStdET as text
%        str2double(get(hObject,'String')) returns contents of interceptStdET as a double


% --- Executes during object creation, after setting all properties.
function interceptStdET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interceptStdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function linrLogSimPvalET_Callback(hObject, eventdata, handles)
% hObject    handle to linrLogSimPvalET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linrLogSimPvalET as text
%        str2double(get(hObject,'String')) returns contents of linrLogSimPvalET as a double


% --- Executes during object creation, after setting all properties.
function linrLogSimPvalET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linrLogSimPvalET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function quadLogSimPvalET_Callback(hObject, eventdata, handles)
% hObject    handle to quadLogSimPvalET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quadLogSimPvalET as text
%        str2double(get(hObject,'String')) returns contents of quadLogSimPvalET as a double


% --- Executes during object creation, after setting all properties.
function quadLogSimPvalET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadLogSimPvalET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interceptPvalET_Callback(hObject, eventdata, handles)
% hObject    handle to interceptPvalET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interceptPvalET as text
%        str2double(get(hObject,'String')) returns contents of interceptPvalET as a double


% --- Executes during object creation, after setting all properties.
function interceptPvalET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interceptPvalET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function linrLogSimTstatET_Callback(hObject, eventdata, handles)
% hObject    handle to linrLogSimTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linrLogSimTstatET as text
%        str2double(get(hObject,'String')) returns contents of linrLogSimTstatET as a double


% --- Executes during object creation, after setting all properties.
function linrLogSimTstatET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linrLogSimTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function quadLogSimTstatET_Callback(hObject, eventdata, handles)
% hObject    handle to quadLogSimTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quadLogSimTstatET as text
%        str2double(get(hObject,'String')) returns contents of quadLogSimTstatET as a double


% --- Executes during object creation, after setting all properties.
function quadLogSimTstatET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadLogSimTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interceptTstatET_Callback(hObject, eventdata, handles)
% hObject    handle to interceptTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interceptTstatET as text
%        str2double(get(hObject,'String')) returns contents of interceptTstatET as a double


% --- Executes during object creation, after setting all properties.
function interceptTstatET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interceptTstatET (see GCBO)
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
tDelay15   = getappdata(hUFinchGUI,'tDelay15');
trgtGageNumber = getappdata(hUFinchGUI,'trgtGageNumber');
trgtGageName   = getappdata(hUFinchGUI,'trgtGageName');
% dynParm5   = str2double(get(handles.parmDifLagET,'String'));
%
% Clear hydrograph (The statement below cleared just the hydrograph)
cla(handles.hydrographPlot,'reset');
% Plot hydrograph of measured flows
semilogy(meaTimeVec(ndxMea(1:end-tDelay15+1)),...
    meaFlowVec(ndxMea(1:end-tDelay15+1)),'b-','LineWidth',0.25,...
    'parent',handles.hydrographPlot);
datetick(handles.hydrographPlot,'x');
[yearVec,~,~,~,~,~] = datevec(meaTimeVec(ndxMea(1:end-tDelay15+1)));
xlabel(handles.hydrographPlot,[num2str(min(yearVec)),' - ',...
    num2str(max(yearVec))]);
ylabel(handles.hydrographPlot,'Flow, in cubic feet per second');
title(handles.hydrographPlot,['Hydrograph for ',trgtGageNumber,' ',trgtGageName]);
hold(handles.hydrographPlot,'on');
%
semilogy(simTimeVec(ndxSim(1:end-tDelay15+1)),...
    simFlowVec(ndxSim(tDelay15:end)),'r-','LineWidth',0.25,...
    'parent',handles.hydrographPlot);
%
semilogy(sttTimeVec(ndxStt(1:end-tDelay15+1)),...
    sttFlowVec(ndxStt(tDelay15:end)),'k-','LineWidth',1.25,...
    'parent',handles.hydrographPlot);

legend(handles.hydrographPlot,'Measured','Simulated','Static Correction',...
    'Location','Best');
hold(handles.hydrographPlot,'off');

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



function dif1LogSimMagET_Callback(hObject, eventdata, handles)
% hObject    handle to dif1LogSimMagET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dif1LogSimMagET as text
%        str2double(get(hObject,'String')) returns contents of dif1LogSimMagET as a double


% --- Executes during object creation, after setting all properties.
function dif1LogSimMagET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dif1LogSimMagET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dif1LogSimStdET_Callback(hObject, eventdata, handles)
% hObject    handle to dif1LogSimStdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dif1LogSimStdET as text
%        str2double(get(hObject,'String')) returns contents of dif1LogSimStdET as a double


% --- Executes during object creation, after setting all properties.
function dif1LogSimStdET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dif1LogSimStdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dif1LogSimPvalET_Callback(hObject, eventdata, handles)
% hObject    handle to dif1LogSimPvalET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dif1LogSimPvalET as text
%        str2double(get(hObject,'String')) returns contents of dif1LogSimPvalET as a double


% --- Executes during object creation, after setting all properties.
function dif1LogSimPvalET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dif1LogSimPvalET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dif1LogSimTstatET_Callback(hObject, eventdata, handles)
% hObject    handle to dif1LogSimTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dif1LogSimTstatET as text
%        str2double(get(hObject,'String')) returns contents of dif1LogSimTstatET as a double


% --- Executes during object creation, after setting all properties.
function dif1LogSimTstatET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dif1LogSimTstatET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotEcdfPB.
function plotEcdfPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotEcdfPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get the meaured, simulated, and corrected estimate
hUFinchGUI       = getappdata(0,'hUFinchGUI');
% Get memory variables
meaFlowVec       = getappdata(hUFinchGUI,'meaFlowVec');
tDelay15         = getappdata(hUFinchGUI,'tDelay15');
ndxMea           = getappdata(hUFinchGUI,'ndxMea');
ndxSim           = getappdata(hUFinchGUI,'ndxSim');
%
% Retrieve handles of hUFinchGUI
handleMain       = getappdata(hUFinchGUI,'handles');
% Target ComID
trgtComID        = get(handleMain.GageComIdST,'String');
% Target Gage Number
trgtGageNumber   = get(handleMain.GageNumberST,'String');
% Target Gage Name
trgtGageName     = get(handleMain.GageNameST,'String'); 
% Clear scatterPlot
cla(handles.scatterPlot,'reset');
%
% Compute frequencies and quantiles of measured flow
[freqMeaFlow, qntlMeaFlow] = ecdf(meaFlowVec(ndxMea(1:end-tDelay15+1)));

semilogx(qntlMeaFlow, freqMeaFlow, 'b-','LineWidth',1.5,...
    'parent',handles.scatterPlot);
title(handles.scatterPlot,{'Empirical Cumulative Distribution of Flows at ',...
    [trgtGageNumber,' ',trgtGageName]});
xlabel(handles.scatterPlot,'Flow, in cubic feet per second');
hold(handles.scatterPlot,'on');

% Retrieve simulated flow matrix (nComID x nSim)
qSimMatrix = getappdata(hUFinchGUI,'qndxIDtDelay');

% Get vector of all ComIDs
ComID      = getappdata(hUFinchGUI,'ComID');
% Find index of trgtComID in ComID vector
ndxComID   = find(ComID == str2double(trgtComID));
% Retrieve simulated dateTime and Flows
simFlowVec = qSimMatrix(ndxComID,:)';
%
[freqSimFlow, qntlSimFlow] = ecdf(simFlowVec(ndxSim(tDelay15:end)));
% 
% Exclude zero flows in measured flows (not always appropriate)
meaFlow            = meaFlowVec(ndxMea(1:end-tDelay15+1));
% Find indices greater than 0
ndxGT0             = find(meaFlow>0);
[meaFreq, meaQntl] = ecdf(log10(meaFlow(ndxGT0)));
 meaQntlK          = interp1(meaFreq,meaQntl,linspace(0,1,1000)); 
% Exclude zero flows in simulated flows (not always appropriate)
simFlow            = simFlowVec(ndxSim(tDelay15:end));
% Find indices greater than 0
ndxGT0             = find(simFlow>0);
[simFreq, simQntl] = ecdf(log10(simFlow(ndxGT0)));
 simQntlK          = interp1(simFreq,simQntl,linspace(0,1,1000)); 
% Compute differences between simulated and measured log flows
sim_meaQntlK       = simQntlK - meaQntlK;
% Integrate area between curves in log space
intAreaSim_Mea     = trapz(linspace(0,1,1000),sim_meaQntlK);
fprintf(1,'Area between Measured and Simulated ECDF (log space): %f\n',...
    intAreaSim_Mea);

semilogx(qntlSimFlow,freqSimFlow,'r-','LineWidth',1.5,...
    'parent',handles.scatterPlot);
%
sampFreqMeaFlow    = linspace(nanmin(freqSimFlow),nanmax(freqMeaFlow),500);
sampQntlLogMeaFlow = interp1(freqMeaFlow, log10(qntlMeaFlow), sampFreqMeaFlow);
sampQntlLogSimFlow = interp1(freqSimFlow, log10(qntlSimFlow), sampFreqMeaFlow);
%
% Characterize the discrepancy between simulated and measured flows
% relative to the mean measured flow
ndxIsF      = isfinite(sampQntlLogSimFlow);
areaSim2Mea = sum(abs(sampQntlLogSimFlow(ndxIsF) - sampQntlLogMeaFlow(ndxIsF)))/...
    sum(abs(sampQntlLogMeaFlow - mean(sampQntlLogMeaFlow)));

fprintf(1,'sum(abs(sampQntlLogMeaFlow - mean(sampQntlLogMeaFlow))): %f\n',...
    sum(abs(sampQntlLogMeaFlow - mean(sampQntlLogMeaFlow))));

fprintf(1,'Relative Area between Quantiles of Simulated and Measured flow: %f\n',...
    areaSim2Mea);
% Statically Adjusted Flows
sttFlowVec = getappdata(hUFinchGUI,'sttFlowVec')';
ndxStt     = getappdata(hUFinchGUI,'ndxStt');
if ~isempty(sttFlowVec)
    [freqSttFlow, qntlSttFlow] = ecdf(sttFlowVec(ndxStt(tDelay15:end)));
    semilogx(qntlSttFlow,freqSttFlow,'k-','LineWidth',1.5,...
        'parent',handles.scatterPlot);
    sampQntlLogSttFlow = interp1(freqSttFlow, log10(qntlSttFlow), sampFreqMeaFlow);
    ndxIsF = isfinite(sampQntlLogSttFlow);
    areaStt2Mea = sum(abs(sampQntlLogSttFlow(ndxIsF) - sampQntlLogMeaFlow(ndxIsF)))/...
        sum(abs(sampQntlLogMeaFlow - mean(sampQntlLogMeaFlow)));
    fprintf(1,'Relative Area between Quantiles of Statically Corrected and Measured flow: %f\n',...
        areaStt2Mea);
    %
    % Exclude zero flows in corrected flows (not always appropriate)
    sttFlow           = sttFlowVec(ndxStt(tDelay15:end));
    % Find indices greater than 0
    ndxGT0             = find(sttFlow>0);
    [sttFreq, sttQntl] = ecdf(log10(sttFlow(ndxGT0)));
    sttQntlK           = interp1(sttFreq,sttQntl,linspace(0,1,1000));
    % Compute differences between statically corrected and measuured flows
    stt_meaQntlK       = sttQntlK - meaQntlK;
    % Integrate area between curves in log space
    intAreaStt_Mea  = trapz(linspace(0,1,1000),stt_meaQntlK);
    fprintf(1,'Area between Measured and Statically Corrected Flows ECDF (log space): %f\n',...
        intAreaStt_Mea);
    legend('Measured (Area Between Curves)',...
        ['Simulated (',num2str(intAreaSim_Mea,4),')'],...
        ['Static Correction (',num2str(intAreaStt_Mea,4),')'],...
        'Location','SouthEast');
    %
else
    legend('Measured (Area Between Curves)',['Simulated (',num2str(intAreaSim_Mea,4),')'],...
        'Location','SouthEast');
end

% --- Executes on button press in clearExitPB.
function clearExitPB_Callback(hObject, eventdata, handles)
% hObject    handle to clearExitPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI = getappdata(0,'hUFinchGUI');
cla(handles.scatterPlot,'reset');
cla(handles.hydrographPlot,'reset');
if isappdata(hUFinchGUI,'sttFlowVec')
    rmappdata(hUFinchGUI,'sttFlowVec'); 
end
close(gcf());


% --- Executes on button press in writeFlowsPB.
function writeFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to writeFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Launch GUI to get path and (root) file name for save flows and meta
hUFinchGUI       = getappdata(0,'hUFinchGUI');
% Get memory variables
% simTimeVec = getappdata(hUFinchGUI,'simTimeVec');
% ndxSim     = getappdata(hUFinchGUI,'ndxSim');
% simFlowVec = getappdata(hUFinchGUI,'simFlowVec');
% % Retrieve measured dateTime and Flows
% meaTimeVec = getappdata(hUFinchGUI,'meaTimeVec');
% ndxMea     = getappdata(hUFinchGUI,'ndxMea');
% meaFlowVec = getappdata(hUFinchGUI,'meaFlowVec');
%
tDelay15   = getappdata(hUFinchGUI,'tDelay15');
% Static model
mdl              = getappdata(hUFinchGUI,'mdl');
% The time and index vectors for sim and stt are shared
selTimeVec       = getappdata(hUFinchGUI,'simTimeVec');
ndxSel           = getappdata(hUFinchGUI,'ndxSim');
selFlowVec       = getappdata(hUFinchGUI,'selFlowVec');
selFlow          = getappdata(hUFinchGUI,'selFlow');
%
% Retrieve handles of hUFinchGUI
handleMain       = getappdata(hUFinchGUI,'handles');
% Target ComID
trgtComID        = get(handleMain.GageComIdST,'String');
% Target Gage Number
trgtGageNumber   = get(handleMain.GageNumberST,'String');
% Target Gage Name
trgtGageName     = get(handleMain.GageNameST,'String'); 
% Target Gage Drainage Area
trgtGageArea     = get(handleMain.daMiSqST,'String');
% Base gageNumber
gageNumber       = getappdata(hUFinchGUI,'gageNumber');
% Base gageName
gageName         = getappdata(hUFinchGUI,'gageName');
% All ComID
ComID            = getappdata(hUFinchGUI,'ComID');
% Index of base gage in StreamGageEvents
gageNdx          = getappdata(hUFinchGUI,'gageNdx');
% 
StreamGageEvent  = getappdata(hUFinchGUI,'StreamGageEvent');
baseGageArea     = StreamGageEvent(str2double(gageNdx)).DA_SQ_MILE;
baseGageComID    = StreamGageEvent(str2double(gageNdx)).ComID;
disp({['..\',handleMain.HR,'\FlowData\Simulated\']});
[fName,pName] = uiputfile({['..\',handleMain.HR,'\FlowData\Simulated\']},...
    'Save Simulated or Statically Corrected Unit Flows and Meta data',...
    [trgtGageNumber,'.ufloSim']);

% mdlOutput = evalc('disp(mdl)');
fid = fopen(fullfile(pName,fName),'wt');

% Initiate comment section 'CommentStyle',{'/*', '*/'}
fprintf(fid,'%s\n','/*');
% Write gage number and name
fprintf(fid,'Target gage: %s %s at ComID %s.\n',trgtGageNumber,trgtGageName,num2str(trgtComID,'%u'));
fprintf(fid,'   Drainage area of target gage is %6.1f mi^2.\n',str2double(trgtGageArea));
fprintf(fid,'Base gage for simulation: %s %s at ComID %u\n',...
    gageNumber,gageName,baseGageComID);
fprintf(fid,'   Drainage area of the base gage is %6.1f mi^2\n',baseGageArea);
fprintf(fid,'Date and time of analysis: %s \n',datestr(now(),'yyyy-mmm-dd HH:MM'));
% Switch output flow series based on selection
switch selFlow
    case 'simFlowVec'
        fprintf(fid,'Simulated flow used without static correction.\n');
    case 'sttFlowVec'
        fprintf(fid,'Model used in Static Correction:\n');
        fprintf(fid,'%s',evalc('disp(mdl)'));
end
%
% Terminate comment section 
fprintf(fid,'%s\n','*/');
% Create matrix of time info
[yr,mo,da,hr,mn,~] = datevec(selTimeVec(ndxSel(1:end-tDelay15+1)));
selFlowVec         =         selFlowVec(ndxSel(tDelay15:end));
% semilogy(simTimeVec(ndxSim(1:end-tDelay15+1)),...
%     simFlowVec(ndxSim(tDelay15:end)),...

% Write out date time and unit flow
for i = 1:length(selTimeVec(ndxSel(1:end-tDelay15+1))),
    flowStr = num2str(selFlowVec(i),5);
    fprintf(fid,'%u,%u,%u,%u,%u,%5s\n',yr(i),mo(i),da(i),hr(i),mn(i),...
        flowStr);
end
fclose(fid);


% --- Executes when selected object is changed in selOutputFlowsBP.
function selOutputFlowsBP_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in selOutputFlowsBP 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
hUFinchGUI = getappdata(0,'hUFinchGUI');
simFlowVec = getappdata(hUFinchGUI,'simFlowVec');
ndxSim     = getappdata(hUFinchGUI,'ndxSim');
sttFlowVec = getappdata(hUFinchGUI,'sttFlowVec');
ndxStt     = getappdata(hUFinchGUI,'ndxStt');
% Define selected flow information based on radio button selection
switch get(eventdata.NewValue,'Tag')
    case 'selSimuFlowsRB'
        display('Simulated flow.');
        selFlow    = 'simFlowVec';
        selFlowVec =  simFlowVec;
        ndxSel     =  ndxSim;
    case 'selStatCorrFlowsRB'
        display('Statically Corrected Flow.');
        selFlow    = 'sttFlowVec';
        selFlowVec =  sttFlowVec;
        ndxSel     =  ndxStt;
    otherwise
        fprintf(1,'Case of correction not found.\n');
end
setappdata(hUFinchGUI,'selFlowVec',selFlowVec);
setappdata(hUFinchGUI,'selFlow',selFlow);
setappdata(hUFinchGUI,'ndxSel', ndxSel);
guidata(hObject,handles);
