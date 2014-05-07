% Develop and test new algorithm for computing travel times 
% Prompt for 
[fname, pname]  = uigetfile('..\HR02\GIS\nhdFlowline\*.nhd','Open Geometry for Streamgage');
% fid = fopen([pname fname],'rt');
%% Read in network geometry
% Use dialog box to get input NHDPlus geometry file containing fields
%   "COMID","LENGTHKM","AREASQKM","MAVELU","STREAMLEVE","FROMNODE",
%   "TONODE","HYDROSEQ","LEVELPATHI","STARTFLAG"
% Read in the nhd geometry data
headerlinesIn = 1; delimiterIn = ',';
nhdMatrix = importdata([pname,fname],delimiterIn,headerlinesIn);
% Identify column contents by header
ndxComID = find(strncmpi(nhdMatrix.colheaders,'ComID',     length('ComID')));
ndxLenKm = find(strncmpi(nhdMatrix.colheaders,'LengthKm',  length('LengthKm')));
ndxSorde = find(strncmpi(nhdMatrix.colheaders,'StreamOrde',length('StreamOrde')));
ndxFNode = find(strncmpi(nhdMatrix.colheaders,'FromNode',  length('FromNode')));
ndxTNode = find(strncmpi(nhdMatrix.colheaders,'ToNode',    length('ToNode')));
ndxHSequ = find(strncmpi(nhdMatrix.colheaders,'HydroSeq',  length('HydroSeq')));
ndxLPath = find(strncmpi(nhdMatrix.colheaders,'LevelPathI',length('LevelPathI')));
ndxAreaM = find(strncmpi(nhdMatrix.colheaders,'AreaSqKm',  length('AreaSqKm')));
ndxV001C = find(strncmpi(nhdMatrix.colheaders,'V0001C',    length('V0001C')));
ndxV001E = find(strncmpi(nhdMatrix.colheaders,'V0001E',    length('V0001E')));
% Replace data structure with data.
nhdMatrix           = nhdMatrix.data;
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
MaVelU      = nhdMatrix(:, ndxV001C);
% 
StreamOrde = nhdMatrix(:, ndxSorde);
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
for i = 1:nFlowlines,
    % The constant 2.18723 converts 1*km/(1*fps * 5/3) into 15-min units
    ttFlowline(i) = round(LengthKm(i) / V0001C(i) * 2.18723);
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
ttBranch(j)   =  max(1,round(ttFlowline(j)));
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
        if ttFlowline(j)<1
            fprintf(1,'%u %8.4f \n',j,ttFlowline(j));
        end
        ttBranch(j)   =  max(round(ttBranch(j-1) + ttFlowline(j)),...
                             round(ttBranch(j-1) + 1));        
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
        ttNetwork(ndxAdd) = round(ttNetwork(ndxFromNode) + ttBranch(ndxAdd));
    end
end
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
% Just account for travel time in the flowline
% Inital set of equations
for i = 1:nFlowlines
    fprintf(1,'%s \n',['C',num2str(ComID(i),'%03u'),'(t - ',...
        num2str(ttNetwork(i),'%03u'),') = Ylds(',...
        num2str(ttNetwork(i),'%03u'),') * ',...
        num2str(AreaSqKm(i),5),' ;']);
end
%
% 
% Initiate branch computations
for i = 1:nBranch,
    ndx = find(branchID(:,1) == i);
    % fprintf(1,'The %u branch has %u flowlines.\n',i,length(ndx));
    branchComID = [];
    for j = 1: length(ndx)
        branchComID = [branchComID,' C',num2str(branchID(ndx(j),5))];
    end
    fprintf(1,'%u %s \n',i,branchComID);
end
%
            
        

