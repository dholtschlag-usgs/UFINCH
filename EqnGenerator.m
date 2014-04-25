% The equation generator is code used to revise the algorithm for
% developing equations used in UFinch simulations. 
% Dave Holtschlag, Apr. 23, 2014
%
% Extract data from hUFinchGUI workspace following UFINCH run.
hUFinchGUI    = getappdata(0,'hUFinchGUI');
info          = getappdata(hUFinchGUI);
LevelPathSet  = info.LevelPathSet; 

% Compute the length (number of branches) of the LevelPathSet
lenLevelPathSet = length(LevelPathSet);
% Allocate a vector containing the number of flowlines in each branch
vecLevelPathSet = nan(lenLevelPathSet,1);
% Populate with the number of flowlines per branch
for i = 1:lenLevelPathSet
    vecLevelPathSet(i) = length(LevelPathSet(i).ComID);
end
%
% Allocate a cell array to store flows from headwaters of each branch
FlowEqn = cell(lenLevelPathSet,max(vecLevelPathSet));
% Build a character string for each headwater flowline
for i = 1:lenLevelPathSet
    for j = 1:length(LevelPathSet(i).ComID(1:end))
        FlowEqn(i,j) = cellstr( ...
            ['C',num2str(LevelPathSet(i).ComID(j)),'(t-',...
            num2str(LevelPathSet(i).CumTT(j),'%03d'),') = Ylds(t-',...
            num2str(LevelPathSet(i).CumTT(j),'%03d'),') * ',...
            num2str(LevelPathSet(i).AreaSqKm(j),'%7.2f')]) ;
        fprintf(1,'%s \n',FlowEqn{i,j});
    end
end
% 
j = 2;  % Index of minimum number of 
% i is the index of lenLevelPathSet
i = 1;
% Find indices of branches that contain more than one (most upstream) flowline
ndxLong = find(vecLevelPathSet >= 2);
fprintf(1,'%s\n',['There are ',num2str(length(ndxLong)),' branches with ',num2str(j),' or more flowlines.']);
%
fprintf(1,'%s\n',['The index of the first branch is ',num2str(ndxLong(i)),'.']);
tarFromNode = LevelPathSet(ndxLong(i)).FromNode{j};
fprintf(1,'%s\n',['  The corresponding FromNode is ',tarFromNode,'.']);
% 
% 

% Find the index of ToNodes that match the FromNode
% Find the target node in all ToNode
ToNodeSet = horzcat({LevelPathSet.ToNode});
% Find the target node in all ToNode
% j = 2
FlowEqnBld = FlowEqn{1,2};
for k = [find(vecLevelPathSet >= 2)]'
    fprintf(1,'%d \n',k);
    ndx0 = find(strcmp(tarFromNode,ToNodeSet{k}(1:end))==1);
    if ~isempty(ndx0)
        fprintf(1,'ToNode in cell %d, element %d matches FromNode %s\n',k,ndx0,tarFromNode);
        FlowEqnBld = [FlowEqnBld,' + ',FlowEqn{k,ndx0}(1:cell2mat(strfind(FlowEqn(k,ndx0),'='))-1)];
    end
end
FlowEqn(1,2) = cellstr(FlowEqnBld);
%

%% Write code to determine which rows of LevelPathSet have from 2 to
% max(vecLevelPathSet) columns
for i = 2:max(vecLevelPathSet)
    % FlowEqn{i,2}
    ndxLong = find(vecLevelPathSet >= i);
    %ndxTar  = 
    dmat    = repmat('%d ',1,length(ndxLong));
    fprintf(1,strcat(dmat,' \n'),ndxLong);
end


%% Streams with one or more upstream branches
% Create cell array containing all ToNodes 
ToNodeSet = horzcat({LevelPathSet.ToNode});
%
for i = 2:max(vecLevelPathSet)
    %for j = [find(vecLevelPathSet >= i) ]
    for j = 1:lenLevelPathSet
        fprintf(1,'i = %d j = %d \n',i,j);
        FlowEqnBld  = FlowEqn{j,i};
        tarFromNode = LevelPathSet(j).FromNode{i};
        ndx0        = find(strcmp(tarFromNode,ToNodeSet{j}(1:end))==1);
        if ~isempty(ndx0)
            fprintf(1,'ToNode in cell %d, element %d matches FromNode %s\n',j,ndx0,tarFromNode);
            FlowEqnBld = [FlowEqnBld,' + ',FlowEqn{j,ndx0}(1:cell2mat(strfind(FlowEqn(j,ndx0),'='))-1)];
            fprintf(1,'%s \n',FlowEqnBld);
        end       
    end    
    fprintf(1,'%s \n',FlowEqnBld);
end


fprintf(1,'%s\n',['The index of the first branch is ',num2str(ndxLong(i)),'.']);
tarFromNode = LevelPathSet(ndxLong(i)).FromNode{j};
fprintf(1,'%s\n',['  The corresponding FromNode is ',tarFromNode,'.']);

ToNodeSet = horzcat({LevelPathSet.ToNode});
%
for i = 2:max(vecLevelPathSet)
    %for j = [find(vecLevelPathSet >= i) ]
    for j = 1:lenLevelPathSet
        fprintf(1,'i = %d j = %d \n',i,j);
        FlowEqnBld  = FlowEqn{j,i};
        tarFromNode = LevelPathSet(j).FromNode{i};
        ndx0        = find(strcmp(tarFromNode,ToNodeSet{j}(1:end))==1);
        if ~isempty(ndx0)
            fprintf(1,'ToNode in cell %d, element %d matches FromNode %s\n',j,ndx0,tarFromNode);
            FlowEqnBld = [FlowEqnBld,' + ',FlowEqn{j,ndx0}(1:cell2mat(strfind(FlowEqn(j,ndx0),'='))-1)];
            fprintf(1,'%s \n',FlowEqnBld);
        end       
    end    
    fprintf(1,'%s \n',FlowEqnBld);
end


%% Algorithm for generating flow equations
%
% Initally, just loop through the network formed by LevelPathSet (LPS)
%   Rows of LPS are branches, Cols are flowlines in downstream order
%
% Determine the number of branches in LPS
numBrLPS = length(LevelPathSet);
% Allocate numFlowLineBr to contain the number of flowlines in each branch
numFlowLineBr   = nan(numBrLPS,1);
% Float down the branches naming the ComIDs
for i = 1:numBrLPS
    % Determine the number of flowlines in the ith branch
    numFlowLineBr(i) = length(LevelPathSet(i).FromNode);
end
% Compute the cumulative sum of flowlines in branches
cumFlowLineBr        = cumsum(numFlowLineBr); 
    % Print out the branch number and number of flowlines
    % fprintf(1,'\n %u %u \n',i,numFlowLineBr(i));
    % Starting with the second flowline, list the ComID
    %     for j = 2:numFlowLineBr(i)
    %         fprintf(1,'%d %s, ',j,LevelPathSet(i).FromNode{j});
    %     end
for i = 1:numBrLPS
    % Print the branch number and headwater ComID
%     fprintf(1,'%d %d \n',i,LevelPathSet(i).ComID(1));
    % Starting with the second flowline in the branch, find all the
    %  ComIDs in which their ToNode matches the current flowlines FromNode
    % Compute yield equations for all flowlines 
    % if numFlowLineBr(i) == 1
    FlowBldEqn = ['C',num2str(LevelPathSet(i).ComID(1)),...
            '(t-',num2str(LevelPathSet(i).CumTT(1),'%03d'),') = Ylds(t-',...
            num2str(LevelPathSet(i).CumTT(1),'%03d'),') * ',...
            num2str(LevelPathSet(i).AreaSqKm(1),'%8.3f')];
            fprintf(1,'%s \n',[FlowBldEqn,';']);

    % else
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
        fprintf(1,'%s \n',[FlowBldEqn,';']);
    end
        % print the FlowBldEqn (w/o) local water yield
    % end
end





