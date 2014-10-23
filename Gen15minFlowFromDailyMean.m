% Script to plot unit and daily values of flow and compute 15-min interval
% estimates of flow
%% From Excel, transfer:
% XLdatetimeUnit  and flowUnit
% XLdateDaily     and flowDaily
%% Read daily flow file
[fName, pName]  = uigetfile({['..\..\..\Data\UFinch\HR02\FlowData\','.dFlo']},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
%
dFloTable   = readtable([pName,fName],'HeaderLines',1,'Delimiter','\t',...
    'Format','%s %s %s %f %s','FileType','text','ReadVariableNames',false);
dFloTable.Properties.VariableNames = {'Agency','gageNumber','yyyy_mm_dd','flow_cfs','flow_code'};
dFloTable.Date = datenum(dFloTable.yyyy_mm_dd,'yyyy-mm-dd') + 0.5;
%
% Define timeseries object from table
dFloTS = timeseries(dFloTable.flow_cfs,dFloTable.Date,'Name','flow');
dFloTS.QualityInfo.Description = vertcat(unique(dFloTable.flow_code),'Unknown');
dFloTS.QualityInfo.Code = vertcat([1:5]',-99);
% Allocate quality vector
dFloTS.Quality = -99 * ones(height(dFloTable),1);
for i = 1:length(dFloTS.QualityInfo.Description)
    switch dFloTS.QualityInfo.Description{i}
        case 'A'
            ndx = find(strcmp(dFloTable.flow_code,'A'));
            dFloTS.Quality(ndx)     = 1;
        case 'A:1'
            ndx = find(strcmp(dFloTable.flow_code,'A:1'));
            dFloTS.Quality(ndx)     = 2;            
        case 'A:e'
            ndx = find(strcmp(dFloTable.flow_code,'A:e'));
            dFloTS.Quality(ndx)     = 3;
        case 'P'
            ndx = find(strcmp(dFloTable.flow_code,'P'));
            dFloTS.Quality(ndx)     = 4;
        case 'P:e'
            ndx = find(strcmp(dFloTable.flow_code,'P:e'));
            dFloTS.Quality(ndx)     = 5;
    end
end
%
% Daily time series
dFloTS.TimeInfo.Units     = 'days';
dFloTS.TimeInfo.Format    = 'yyyy-mm-dd';
dFloTS.TimeInfo.StartDate = datestr(0);
% Daily flow series
dFloTS.DataInfo.Units     = 'cubic feet per second';

uFloTS       = resample(dFloTS,[dFloTS.Time(1):1/96:dFloTS.Time(end)]);
uFloTS.TimeInfo.Format    = 'yyyy-mm-dd HH:MM';
% plot 15-min samples in red
figure(1); clf(1);
plot(dFloTS,'b+','MarkerSize',1);
% Replace need for semilogy
set(gca,'YScale','log');
%
hold on
plot(uFloTS,'rx','MarkerSize',1);



% dFloNdxBeg = find(dDateTime+1/2 == sYrMoDaHrMn);
% dFloNdxEnd = find(dDateTime+1/2 == eYrMoDaHrMn);
% 
% plot(dDateTime(dFloNdxBeg:dFloNdxEnd),dFlow(dFloNdxBeg:dFloNdxEnd),'g-');
% 
% gageNum  = '01632900';
% gageName = 'SMITH CREEK NEAR NEW MARKET, VA';
%% Plot unit and daily flow data from 04118000
% datetimeUnit = XLdatetimeUnit + datenum('Dec-30-1899');
% dateDaily    = XLdateDaily    + datenum('Dec-30-1899');
%
% figure(1); clf(1);
% % Plot daily values
% semilogy(dateDaily+0.5,flowDaily,'b-');
% datetick('x');
% hold on
% % Add smoothed interpolated values with interp1-pchip
% begUnitDate  = dateDaily(1)+0.5;
% last         = length(dateDaily);
% endUnitDate  = dateDaily(end)+0.5;
% time15min    = linspace(begUnitDate,endUnitDate,4*24*(endUnitDate-begUnitDate)+1);
% flow15min    = interp1(dateDaily+.5,flowDaily,time15min,'pchip');
% % Plot interpolated 15-min values
% semilogy(time15min,flow15min,'k-');
% % Plot unit (30-min) values
% % semilogy(datetimeUnit,flowUnit,'r-');
% hold off
% xlabel('Date'); ylabel('Streamflow, in cubic feet per second');
% title([gageNum,' ',gageName]);
%
%% Write out data set
[yr,mo,da,hr,mn,~] = datevec(uFloTS.Time);
% get file name to write unit flow to
[fname,pname] = uiputfile('*.uFlo','Save time series of unit flow data.',...
    [dFloTable.gageNumber{1},'.uFlo']);
fid = fopen([pname,fname],'wt');
% write unit flows
fprintf(fid,'%4u,%2u,%2u,%2u,%2u,%8.2f\n',[yr mo da hr mn uFloTS.Data]');
fclose(fid);
%
