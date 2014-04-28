% The equation generator is code used to revise the algorithm for
% developing equations used in UFinch simulations. 
% Dave Holtschlag, Apr. 23, 2014
%
% Extract data from hUFinchGUI workspace following UFINCH run.
hUFinchGUI    = getappdata(0,'hUFinchGUI');
info          = getappdata(hUFinchGUI);
LevelPathSet  = info.LevelPathSet; 
% aCatch, tDelay, seqComID are consistent nEqn x 1 vectors
aCatch        = info.aCatch;
tDelay        = info.tDelay;
seqComID      = info.seqComID;
Ylds          = info.Ylds;
nSim          = info.nSim;
maxTTime      = info.maxTTime;
% nEqn          = info.nEqn;
% Compute the length (number of branches) of the LevelPathSet
lenLevelPathSet = length(LevelPathSet);
% Allocate a vector containing the number of flowlines in each branch
vecLevelPathSet = nan(lenLevelPathSet,1);
% Populate with the number of flowlines per branch
for i = 1:lenLevelPathSet
    vecLevelPathSet(i) = length(LevelPathSet(i).ComID);
end
%
%% Algorithm for generating flow equations
%
% Determine the number of branches in LPS
numBrLPS = length(LevelPathSet);
% Allocate numFlowLineBr to contain the number of flowlines in each branch
numFlowLineBr   = nan(numBrLPS,1);
% Determine the number of flowlines in each branch
for i = 1:numBrLPS    
    numFlowLineBr(i) = length(LevelPathSet(i).FromNode);
end
% Compute the cumulative sum of flowlines in the branches
cumFlowLineBr        = cumsum(numFlowLineBr); 
% Create a structure array to hold equations
field1    = 'FloEqn'; value1 = cell(cumFlowLineBr(end),1); 
field2    = 'CumTT';  value2 =  nan(cumFlowLineBr(end),1);
strFloEqn = struct(field1,value1,field2,value2);
celFloEqn =   cell(cumFlowLineBr(end),2);
%
% Initialize counter for equations 
nEqn = 0;
% Generate the equations for all flowlines
for i = 1:numBrLPS
    % Print the branch number and headwater ComID
%     fprintf(1,'%d %d \n',i,LevelPathSet(i).ComID(1));
    % Starting with the second flowline in the branch, find all the
    %  ComIDs in which their ToNode matches the current flowlines FromNode
    % Compute yield equations for all flowlines 
    FlowBldEqn = ['C',num2str(LevelPathSet(i).ComID(1)),...
            '(t-',num2str(LevelPathSet(i).CumTT(1),'%03d'),') = Ylds(t-',...
            num2str(LevelPathSet(i).CumTT(1),'%03d'),') * ',...
            num2str(LevelPathSet(i).AreaSqKm(1),'%8.3f')];
            nEqn = nEqn + 1;        
            fprintf(1,'nEqn = %03d:  ',nEqn);
            strFloEqn(nEqn).FloEqn = FlowBldEqn;
            strFloEqn(nEqn).CumTT  = LevelPathSet(i).CumTT(1);
            celFloEqn{nEqn,1}      = FlowBldEqn;
            celFloEqn{nEqn,2}      = LevelPathSet(i).CumTT(1);
            fprintf(1,'%s \n',[FlowBldEqn,';']);
    % Add info on any upstream flowlines
    for j = 2:numFlowLineBr(i)
        % Set current FromNode to targetToNode
        targetToNode = LevelPathSet(i).FromNode(j);
        targetComID  = LevelPathSet(i).ComID(j);
        % Find the vector of indices of targetToNode in LSP
        ndxToNode = find(ismember([LevelPathSet.ToNode],targetToNode)==1);
        % Loop over vecToNode to find branch numBr and flowline numFL
        FlowBldEqn = ['C',num2str(LevelPathSet(i).ComID(j)),...
            '(t-',num2str(LevelPathSet(i).CumTT(j),'%03d'),') = Ylds(t-',...
            num2str(LevelPathSet(i).CumTT(j),'%03d'),') * ',...
            num2str(LevelPathSet(i).AreaSqKm(j),'%8.3f')];
        for k = 1:length(ndxToNode)
            % Branch with matching ToNode
            numBr = find(ndxToNode(k) <= cumFlowLineBr,1,'first');
            % Flowline in Branch with matching ToNode
            if ndxToNode(k) > numFlowLineBr(1)
                numFL = ndxToNode(k) - cumFlowLineBr(numBr-1);
            else
                numFL = ndxToNode(k);
            end
%             fprintf(1,'%3d %3d %3d %3d %3d %d %d \n',i,j,k,numBr,numFL,...
%                 LevelPathSet(numBr).ComID(numFL),targetComID);
            FlowBldEqn = horzcat(FlowBldEqn, ...
                [' + C',num2str(LevelPathSet(numBr).ComID(numFL)),...
                '(t-',num2str(LevelPathSet(numBr).CumTT(numFL),'%03d'),...
                ')']);
        end
        nEqn = nEqn + 1;
        fprintf(1,'nEqn = %03d:  ',nEqn);
        fprintf(1,'%s \n',[FlowBldEqn,';']);
        strFloEqn(nEqn).FloEqn = FlowBldEqn;
        strFloEqn(nEqn).CumTT  = LevelPathSet(numBr).CumTT(numFL);
        celFloEqn{nEqn,1}      = FlowBldEqn;
        celFloEqn{nEqn,2}      = LevelPathSet(numBr).CumTT(numFL);
    end
end
% Put cumTT in numeric vector for sorting
cumTTvec        = nan(nEqn,1);
ndxParan        = nan(nEqn,1);
cumComID        = nan(nEqn,1);
% Run through all flowlines
for i = 1:nEqn
    cumTTvec(i) = str2num(celFloEqn{i,1}(12:14));
    vecMatch    = strfind(celFloEqn{i,1},'(');
    % Find the first close paraenthesis around 
    ndxParan(i) = vecMatch(1);
    cumComID(i) = str2num(celFloEqn{i,1}(2:ndxParan(i)-1));
end
% Sort cumTTvec 
[~,srtEqn] = sort(cumTTvec,'descend');
celComID   = nan(nEqn,1);
% Print the equations in the appropriate order to the terminal
for i = 1:nEqn
    vecMatch    = strfind(celFloEqn{srtEqn(i),1},'(');
    % Find the first close paraenthesis around 
    ndxParan(i) = vecMatch(1);
    celComID(i) = str2num(celFloEqn{srtEqn(i),1}(2: ndxParan(1)-1));
    fprintf(1,'%s \n',celFloEqn{srtEqn(i),1});
end
% ib is the index sequence that match seqComID, aCatch, and tDelay to
% ordered equations needed to compute flow
[c, ia, ib] = intersect(celComID,seqComID,'stable');
% seqComID(ib)
% This substitutes equation numbers for ComID
%
%% Compute local inflows
for i = 1:nEqn
    fprintf(1,'%s \n',['R',num2str(seqComID(ib(i))),'(t-',...
        num2str(tDelay(ib(i)),'%03d'),') = Ylds(t-',...
        num2str(tDelay(ib(i)),'%03d'),') * ',...
        num2str(aCatch(ib(i)),'%7.3f'),' ']);
end
%
%% Initialize variables to contain flow
for i = 1:nEqn
    eval(['C',num2str(seqComID(ib(i))),' = zeros(nSim,1)']);
end
% Ylds = 0.1*ones(500,1);
% Print the equations in the appropriate order to the terminal
for t = 1+maxTTime:nSim,
    for i = 1:nEqn,
        vecMatch    = strfind(celFloEqn{srtEqn(i),1},'(');
        % Find the first close paraenthesis around
        ndxParan(i) = vecMatch(1);
        celComID(i) = str2num(celFloEqn{srtEqn(i),1}(2: ndxParan(1)-1));
        % fprintf(1,'%s \n',celFloEqn{srtEqn(i),1});
        eval(celFloEqn{srtEqn(i),1});
    end
end





