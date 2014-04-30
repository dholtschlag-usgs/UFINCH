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
    fprintf(1,'%s; \n',celFloEqn{srtEqn(i),1});
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
% Use equantion directly
for t = 1+maxTTime:nSim,
    for i = 1:nEqn,       
        C5909173(t-107) = Ylds(t-107) * 59.469;
        C5909061(t-100) = Ylds(t-100) * 37.143;
        C5909187(t-079) = Ylds(t-079) * 4.939 + C5909173(t-107);
        C5909031(t-078) = Ylds(t-078) * 9.235 + C5909187(t-079);
        C5909029(t-072) = Ylds(t-072) * 12.897 + C5909031(t-078) + C5909061(t-100);
        C5909021(t-058) = Ylds(t-058) * 4.960 + C5909029(t-072) + C5909041(t-022);
        C5909169(t-022) = Ylds(t-022) * 27.018;
        C5909171(t-021) = Ylds(t-021) * 33.247;
        C5909019(t-003) = Ylds(t-003) * 2.884 + C5909171(t-021) + C5909169(t-022);
        C5909017(t-049) = Ylds(t-049) * 9.076 + C5909021(t-058) + C5909019(t-003);
        
        
        C5909023(t-049) = Ylds(t-049) * 27.522;
        C5909007(t-040) = Ylds(t-040) * 5.215 + C5909017(t-049) + C5909009(t-003);
        C5909159(t-039) = Ylds(t-039) * 36.782;
        C5908933(t-035) = Ylds(t-035) * 12.590;
        C5909001(t-034) = Ylds(t-034) * 7.980 + C5909007(t-040) + C5909023(t-049);
        C5909165(t-034) = Ylds(t-034) * 45.535;
        C5908935(t-032) = Ylds(t-032) * 5.804;
        C5909053(t-030) = Ylds(t-030) * 8.457;
        C5909161(t-028) = Ylds(t-028) * 41.284 + C5909001(t-034) + C5909163(t-007);
        C5909167(t-027) = Ylds(t-027) * 17.518;
        C5909157(t-023) = Ylds(t-023) * 42.771 + C5908933(t-035) + C5908935(t-032);
        C5909041(t-022) = Ylds(t-022) * 28.821 + C5909053(t-030);
        C5908999(t-021) = Ylds(t-021) * 21.991;
        C5909015(t-018) = Ylds(t-018) * 10.461;
        C5909003(t-014) = Ylds(t-014) * 8.087;
        C5909005(t-012) = Ylds(t-012) * 11.272 + C5909165(t-034) + C5909167(t-027);
        C5909011(t-008) = Ylds(t-008) * 6.228 + C5909003(t-014);
        C5909185(t-007) = Ylds(t-007) * 1.703 + C5909157(t-023);
        C5909163(t-007) = Ylds(t-007) * 11.255 + C5909159(t-039) + C5908999(t-021);
        C5908983(t-005) = Ylds(t-005) * 2.957 + C5909185(t-007);
        C5909013(t-005) = Ylds(t-005) * 5.458 + C5909161(t-028) + C5909015(t-018);
        C5909009(t-003) = Ylds(t-003) * 3.626 + C5909005(t-012) + C5909011(t-008);
        C5909183(t-002) = Ylds(t-002) * 1.608 + C5908983(t-005);
        C5908981(t-001) = Ylds(t-001) * 0.113 + C5909183(t-002);
    end
end
%
% ComID at 01624300 Middle River near Verona, Va is 5909161



