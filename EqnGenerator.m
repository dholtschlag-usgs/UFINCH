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
FlowEqnBld = FlowEqn{1,2};
for k = 1:14
    ndx0 = find(strcmp(tarFromNode,ToNodeSet{k}(1:end))==1);
    if ~isempty(ndx0)
        fprintf(1,'ToNode in cell %d, element %d matches FromNode %s\n',k,ndx0,tarFromNode);
        FlowEqnBld = [FlowEqnBld,' + ',FlowEqn{k,ndx0}(1:cell2mat(strfind(FlowEqn(k,ndx0),'='))-1)];
    end
end
FlowEqn(1,2) = cellstr(FlowEqnBld);
%





% j indexes the "column" in the cell array Experiment with matching ToNode and FromNode
j = 2;
for i = 1:length(ndxLong)
    ndxFromNode = find(strcmp(tarFromNode,{LevelPathSet(i).FromNode{:}}) == 1);

% target from node
tarFromNode = LevelPathSet(1).FromNode(j); 
% 
FlowEqn{1,1}(1:cell2mat(strfind(FlowEqn(1,1),'='))-1)



