% Develop and test new algorithm for computing travel times 
% Prompt for nhd joined file data fields: Flowline/NHDPlusVAA/
[fname, pname]  = uigetfile('..\HR02\GIS\Streamgage\*.nhd','Open Geometry for Streamgage');
% fid = fopen([pname fname],'rt');
%% Read in network geometry
% Use dialog box to get input NHDPlus geometry file containing fields
% Read in the nhd geometry data
clearvars -except fname pname
headerlinesIn = 1; delimiterIn = ',';
nhdStruct     = importdata([pname,fname],delimiterIn,headerlinesIn);
% Identify column contents by header
ndxComID = find(strncmpi(nhdStruct.colheaders,'ComID',     length('ComID')));
ndxLenKm = find(strncmpi(nhdStruct.colheaders,'LengthKm',  length('LengthKm')));
ndxFNode = find(strncmpi(nhdStruct.colheaders,'FromNode',  length('FromNode')));
ndxTNode = find(strncmpi(nhdStruct.colheaders,'ToNode',    length('ToNode')));
ndxHSequ = find(strncmpi(nhdStruct.colheaders,'HydroSeq',  length('HydroSeq')));
ndxLPath = find(strncmpi(nhdStruct.colheaders,'LevelPathI',length('LevelPathI')));
ndxAreaM = find(strncmpi(nhdStruct.colheaders,'AreaSqKm',  length('AreaSqKm')));
ndxV001C = find(strncmpi(nhdStruct.colheaders,'V0001C',    length('V0001C')));
ndxV001E = find(strncmpi(nhdStruct.colheaders,'V0001E',    length('V0001E')));
% Replace data structure with data.
nhdMatrix           = nhdStruct.data;
% Sort rows of A by HydroSeq in decreasing (-) order.
% A          = cell2mat(A);
nhdMatrix  = sortrows(nhdMatrix,[ndxLPath,ndxHSequ]);
ComID      = nhdMatrix(:, ndxComID);
LengthKm   = nhdMatrix(:, ndxLenKm);
AreaSqKm   = nhdMatrix(:, ndxAreaM);
fprintf('%8.1f\n',min(AreaSqKm));
fprintf('%8.1f\n',max(AreaSqKm));
V0001C     = nhdMatrix(:, ndxV001C);
V0001E     = nhdMatrix(:, ndxV001E);
% MaVelU is the mean velocity metric selected 
MaVelU     = nhdMatrix(:, ndxV001C);
% 
FromNode   = nhdMatrix(:, ndxFNode);
ToNode     = nhdMatrix(:, ndxTNode);
HydroSeq   = nhdMatrix(:, ndxHSequ);
LevelPathI = nhdMatrix(:, ndxLPath);
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
velAdj = 2.0217;
for i = 1:nFlowlines,
    % The constant 2.18723 converts 1*km/(1*fps * 5/3) into 15-min units
    % Experimentin with high (*2) velocity
    ttFlowline(i) = max(1,floor(LengthKm(i) / (V0001C(i)*velAdj) * 2.18723));
    fprintf(1,' %3u  %12u  %10u  %7.3f  %8.4f  %9.4f \n',...
        i,LevelPathI(i),ComID(i),LengthKm(i),V0001C(i),ttFlowline(i));
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
        % max(1,ttFlowline(j)) is intended to take care of short reaches
%         if ttFlowline(j)<1
%             fprintf(1,'%u %8.4f \n',j,ttFlowline(j));
%         end
%         ttBranch(j)   =  max(floor(ttBranch(j-1) + ttFlowline(j)),...
%                              floor(ttBranch(j-1) + 1));        
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
% sorted travel time in network vector
sttNetwork = sort(ttNetwork);
%
%% Generate equations: 
sBranchIDTable = sortrows(branchIDTable,'HydroSeq','descend');
for i = 1:nFlowlines,
    % This statement takes care of one or more (convergent) flowlines with
    % no divergent flowlines 
    
%     ndx = find(sBranchIDTable.FromNode(i) == sBranchIDTable.ToNode) & ...
%         length(find(sBranchIDTable.FromNode(i) == sBranchIDTable.FromNode) == 1);
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
%% Write equations as matrix components and travel times
for i = 1:nFlowlines,
    % Identify convergent (length(ndxCon)>1) and connected flowlines
    ndxCon = find(sBranchIDTable.FromNode(i) == sBranchIDTable.ToNode)  ;
    % Identifies divergent branches (length(ndxDiv>1)) 
    ndxDiv = find(sBranchIDTable.FromNode(i) == sBranchIDTable.FromNode);
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
%             if length(ndxCon)>1
%                 fprintf(1,'HEY! More than one convergent line here!\n');
%             end
            % Uncomment next line to get full output
            fprintf(1,'%8u(%s) ',ndxCon(j),num2str(sBranchIDTable.ttNetwork(ndxCon(j)),'%04u'));
            usFlowlines = [usFlowlines,' + C',num2str(sBranchIDTable.ComID(ndxCon(j))),...
                '(t - ',num2str(sBranchIDTable.ttNetwork(ndxCon(j)),'%04u'),')'];
        end
        % Uncomment next line to get full output
       fprintf(1,'\n');
    elseif ~isempty(ndxCon) && length(ndxDiv) > 1 
        for j = 1:length(ndxCon)
%             fprintf(1,'%s',['C',num2str(sBranchIDTable.ComID(i)),...
%          '(t - ',num2str(sBranchIDTable.ttNetwork(i),'%04u'),') <- ']);
%             fprintf(1,'C%u(%04u)/%u. || ',sBranchIDTable.ComID(ndxCon(j)),...
%                 sBranchIDTable.ttNetwork(ndxCon(j)),length(ndxDiv));
                
%             fprintf(1,'%6u %6u C%s(t - %s) / %s. \n',i,ndxCon(j),...
%                 num2str(sBranchIDTable.ComID(ndxCon(j)),'%04u'),...
%                 num2str(sBranchIDTable.ttNetwork(ndxCon(j)),'%04u'),...
%                 num2str(length(ndxDiv),'%u'));
            fprintf(1,'%8u(%04u) %8u(%04u)/%u.\n',i,sBranchIDTable.ttNetwork(i),...
                 ndxCon(j),sBranchIDTable.ttNetwork(ndxCon(j)),length(ndxDiv));
%             usFlowlines = [usFlowlines,' + C',num2str(sBranchIDTable.ComID(ndxCon(j))),...
%                 '(t - ',num2str(sBranchIDTable.ttNetwork(ndxCon(j)),'%04u'),')' , ...
%                 ' * 1/',num2str(length(ndxDiv),'%u')];
        end        
    end
    % This statement takes care of two or more divergent flowlines
    
%     fprintf(1,'%s \n',['C',num2str(sBranchIDTable.ComID(i)),...
%         '(t - ',num2str(sBranchIDTable.ttNetwork(i),'%04u'),') = Ylds',...
%         '(t - ',num2str(sBranchIDTable.ttNetwork(i),'%04u'),') * ',...
%         num2str(sBranchIDTable.AreaSqKm(i),'%9.4f'),...
%         usFlowlines,';']);
end


            
        




