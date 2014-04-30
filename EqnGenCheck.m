% The equation generator is code used to revise the algorithm for
% developing equations used in UFinch simulations. 
% Dave Holtschlag, Apr. 23, 2014
%
% Extract data from hUFinchGUI workspace following UFINCH run.
hUFinchGUI    = getappdata(0,'hUFinchGUI');
% Stored properties
info          = getappdata(hUFinchGUI);
LevelPathSet  = info.LevelPathSet; 
% aCatch, tDelay, seqComID are consistent nEqn x 1 vectors
aCatch        = info.aCatch;
tDelay        = info.tDelay;
seqComID      = info.seqComID;
Ylds          = info.Ylds;
nSim          = info.nSim;
maxTTime      = info.maxTTime;
%
%%
flowVec      = info.flowVec';
timeVec      = info.timeVec';
%
LevelPathSet   = getappdata(hUFinchGUI,'LevelPathSet');
sYrMoDaHrMn    = info.sYrMoDaHrMn;
eYrMoDaHrMn    = info.eYrMoDaHrMn;
tbeg           = find(timeVec == sYrMoDaHrMn);
tend           = find(timeVec == eYrMoDaHrMn);
%
fprintf(1,'Simulations start at timeVec(%u) = %s.\n',tbeg,...
    datestr(timeVec(tbeg),'yyyy-mmm-dd HH:MM'));
fprintf(1,'Simulations end   at timeVec(%u) = %s.\n',tend,...
    datestr(timeVec(tend),'yyyy-mmm-dd HH:MM'));

nSim = tend - tbeg + 1;
fprintf(1,'The number of 15-min time intervals simulated will be %u.\n',nSim);

ComID      = getappdata(hUFinchGUI,'ComID');
AreaSqKm   = getappdata(hUFinchGUI,'AreaSqKm');
FromNode   = getappdata(hUFinchGUI,'FromNode');
ToNode     = getappdata(hUFinchGUI,'ToNode');
LevelPathI = getappdata(hUFinchGUI,'LevelPathI');
HydroSeq   = getappdata(hUFinchGUI,'HydroSeq');
StreamLeve = getappdata(hUFinchGUI,'StreamLeve');

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

%% Computed properties
StreamLevelMax = max([LevelPathSet.StreamLeve]);
StreamLevelMin = min([LevelPathSet.StreamLeve]);
%
% Indices of StreamLevelMax
StreamLevelNdx1  = find([LevelPathSet.StreamLeve]==StreamLevelMax);
% nSteamLevelMaxNdx = length(SteamLevelMaxNdx);
% Generate code for the highest order stream levels
for i = 1:length(StreamLevelNdx1)
    j = 1;
    ndxEqn = ndxEqn + 1;
    nFlowline = length(LevelPathSet(StreamLevelNdx1(i)).ComID);
    EqnName   = ['C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j))];
    seqComID(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).ComID(j);
    EqnForm   = ['C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j)),...
            '(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j),'%03u'),...
            ') = Ylds(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j),'%03u'),...
            ') * ',num2str(LevelPathSet(StreamLevelNdx1(i)).AreaSqKm(j),'%6.3f')];
    % flowDesign(ndxEqn,ndxComID) = 1;
    tDelay(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).CumTT(j);
    aCatch(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).AreaSqKm(j);
    strLevel(ndxEqn) = StreamLevelMax;
    eval([EqnName ' = EqnForm;']);
    fprintf(1,'i=%d, j=%d\n\n%s\n',i,j,[eval(EqnName),';']);
    for j = 2:nFlowline
%         EqnName = ['C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j))];
%         EqnForm = ['C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j)),...
%             '(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j),'%03u'),...
%             ') = Ylds(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j),'%03u'),...
%             ') * ',num2str(LevelPathSet(StreamLevelNdx1(i)).AreaSqKm(j),'%6.3f'),...
%             ' + C',num2str(LevelPathSet(StreamLevelNdx1(i)).ComID(j-1)),...
%             '(t-',num2str(LevelPathSet(StreamLevelNdx1(i)).CumTT(j-1),'%03u'),')'];
        % EvalStr = [eval(EqnName) EqnForm];
        ndxComID = find(LevelPathSet(StreamLevelNdx1(i)).ComID(j-1)==seqComID);
        ndxEqn = ndxEqn + 1;
        seqComID(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).ComID(j);
        flowDesign(ndxEqn,ndxComID) = 1;
        tDelay(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).CumTT(j);
        aCatch(ndxEqn) = LevelPathSet(StreamLevelNdx1(i)).AreaSqKm(j);
        strLevel(ndxEqn) = StreamLevelMax;
        %
        %  eval([EqnName '= EqnForm ;']);
        % fprintf(1,'%s \n',[eval(EqnName),';']);
    end
end
%
