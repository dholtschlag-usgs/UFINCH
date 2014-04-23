% Script to plot unit and daily values of flow and compute 15-min interval
% estimates of flow
%% From Excel, transfer:
% XLdatetimeUnit  and flowUnit
% XLdateDaily     and flowDaily
%
gageNum  = '04112500';
gageName = 'Red Cedar River at East Lansing, MI';
%% Plot unit and daily flow data from 04118000
datetimeUnit = XLdatetimeUnit + datenum('Dec-30-1899');
dateDaily    = XLdateDaily    + datenum('Dec-30-1899');
%
figure(1); clf(1);
% Plot daily values
semilogy(dateDaily+0.5,flowDaily,'b-');
datetick('x');
hold on
% Add smoothed interpolated values with interp1-pchip
begUnitDate  = dateDaily(1)+0.5;
last         = length(dateDaily);
endUnitDate  = dateDaily(end)+0.5;
time15min    = linspace(begUnitDate,endUnitDate,4*24*(endUnitDate-begUnitDate)+1);
flow15min    = interp1(dateDaily+.5,flowDaily,time15min,'pchip');
% Plot interpolated 15-min values
semilogy(time15min,flow15min,'k-');
% Plot unit (30-min) values
semilogy(datetimeUnit,flowUnit,'r-');
hold off
xlabel('Date'); ylabel('Streamflow, in cubic feet per second');
title([gageNum,' ',gageName]);
%
%% Write out data set
[yr,mo,da,hr,mn,~] = datevec(time15min-0.5);
[fname,pname] = uiputfile('*.uFlo','Save time series of flow data.',...
    [gageNum,'.uFlo']);
fid = fopen([pname,fname],'wt');
fprintf(fid,'%4u,%2u,%2u,%2u,%2u,%8.2f\n',[yr;mo;da;hr;mn;flow15min]);
fclose(fid);
%
