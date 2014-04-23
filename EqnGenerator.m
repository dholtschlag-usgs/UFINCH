% The equation generator is code used to revise the algorithm for
% developing equations used in UFinch simulations. 
% Dave Holtschlag, Apr. 23, 2014


% Compute the length (number of branches) of the LevelPathSet
lenLevelPathSet = length(LevelPathSet);
% Allocate a vector containing the number of flowlines in each branch
vecLevelPathSet = nan(lenLevelPathSet,1);
% Populate with the number of flowlines per branch
for i = 1:lenLevelPathSet
    vecLevelPathSet(i) = length(LevelPathSet(i).ComID);
end
%
% Build a character string for each first order stream
j = 1;
for i = 1:lenLevelPathSet
    fprintf(1,'%s\n',['C',num2str(LevelPathSet(i).ComID(j)),'(t-',...
        num2str(LevelPathSet(i).CumTT(j),'%03d'),') = Ylds(t-',...
        num2str(LevelPathSet(i).CumTT(j),'%03d'),') * ',...
        num2str(LevelPathSet(i).AreaSqKm(j),'%7.2f')] );
end
% 
ndxLong = find(vecLevelPathSet >= 2);
% j indexes the "column" in the cell array Experiment with matching ToNode and FromNode
j = 2;
for i = 1:length(ndxLong)
    ndxFromNode = find(strcmp(tarFromNode,{LevelPathSet(i).FromNode{:}}) == 1);

% target from node
tarFromNode = LevelPathSet(1).FromNode(j); 
% 

% Find the target node in all ToNode
ToNodeSet = {LevelPathSet.ToNode};
% Find the target node in all ToNode
strcmp(tarFromNode,{horzcat(LevelPathSet.ToNode)})



