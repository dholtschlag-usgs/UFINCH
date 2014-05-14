%% Check constant yields and compare with stream drainage area in sqkm
% Select matlab ouput file of simulated UFINCH flows 
[fname, pname]  = uigetfile({['..\..\..\Data\UFinch\HR02\FlowData\Model\','.mat']},...
    'Open Matlab File of Unit Flows from UFINCH simulation');
% Load the data file
load([pname,fname]);
% Select in GageNetworkInfo.txt
[fname, pname]  = uigetfile({['..\..\..\Analysis\UFinch\HR02\GIS\Streamgage\01636500\',...
    'GageNetworkInfo.txt']},...
    'Open Text File containing GAGEID, STATION_NM, DA_SQ_MILE, ComID');
GageNetworkInfo = readtable([pname,fname],'Format','%s %s %f %u');
% Omit undefined drainage areas (-999999.00)
ndx  =  find(GageNetworkInfo.DA_SQ_MILE > 0);
GageNetworkInfo                 = GageNetworkInfo(ndx,:); 
GageNetworkInfo.DA_SQ_KM        = GageNetworkInfo.DA_SQ_MILE * 2.59;
%
% Allocate a vector to contain flows from 1-yields (DA_SQ_KM);
FlowYield1  = nan(height(GageNetworkInfo),1);
% Index of UFINCH simulated flows for comparison 
ndxTarget   = 5000;
% loop through streamgage network
for i = 1:height(GageNetworkInfo)
    FlowYield1(i) = eval(['C',num2str(GageNetworkInfo.ComID(i)),'(ndxTarget)']);
end
%
figure(1); clf(1);
loglog([GageNetworkInfo.DA_SQ_KM],FlowYield1,'bx');
hold on
loglog([2 9000],[2 9000],'r-');
xlabel('NWIS Drainage Areas at Streamgages, in square kilometers');
ylabel('UFINCH Yield-Equivalent Drainage Areas at Streamgages , in square kilometers');
title({'Relation between NWIS Drainage Areas and Yield-Equavalent Drainage Areas',...
    'at Streamgages Upstream from 01636500 Shenandoah River at Millville, VA'});

legend('Data pairs','Line of Agreement','Location','NorthWest');
%
figure(2); clf(2);
ecdf(log10(GageNetworkInfo.DA_SQ_MILE))
xlabel('log_{10} Drainage Area, in Square Miles');
ylabel('Empirical Cumulative Probability');
title({'Distribution Function of log_{10} Drainage Areas at Streamgages',...
    'Upstream from 01636500 Shenandoah River at Millville, WV'});




