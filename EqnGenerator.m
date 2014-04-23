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
% Build a character string for each first order stream
j = 1;
for i = 1:lenLevelPathSet
    fprintf(1,'%s\n',['C',num2str(LevelPathSet(i).ComID(j)),'(t-',...
        num2str(LevelPathSet(i).CumTT(j),'%03d'),') = Ylds(t-',...
        num2str(LevelPathSet(i).CumTT(j),'%03d'),') * ',...
        num2str(LevelPathSet(i).AreaSqKm(j),'%7.2f')] );
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
for k = 1:length(ndxLong)
    fprintf(1,'%d %d %d \n',k,ndxLong(k),find(strcmp(tarFromNode,ToNodeSet{k}(1:end))==1));
end




% j indexes the "column" in the cell array Experiment with matching ToNode and FromNode
j = 2;
for i = 1:length(ndxLong)
    ndxFromNode = find(strcmp(tarFromNode,{LevelPathSet(i).FromNode{:}}) == 1);

% target from node
tarFromNode = LevelPathSet(1).FromNode(j); 
% 




