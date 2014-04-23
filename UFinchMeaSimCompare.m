% UFinchMeaSimCompare compares simulated and measured flows from UFINCH
% Dave Holtschlag, April 9, 2014
%
% Option for clearing workspace and console
clearWS = input('Clear workspace and console? (y/N): ','s');
if(upper(clearWS)=='Y')
    clear; clc;
end
% Get UFinch path and file name for retrieval
[fName,pName] = uigetfile('..\..\..\Data\UFinch\*.mat',...
    'Open UFinch Output file');
% Construct full file path name
filePath = fullfile(pName,fName); 
% Load data file
load(filePath);
gageName   = 'Shenandoah River at Millville, VA';
% New figue
figure(1); clf(1);
% Plot the simulated and measured flow for the time series
semilogy(timeVec(tbeg:tend-maxTTime),flowVec(tbeg:tend-maxTTime),'r-');
datetick('x');
ylabel('Flow, in cubic feet per second');
% gageNumber = getappdata(hUFinchGUI,'gageNumber');
title(['Unit flows at ',gageNumber,' ',gageName]);
%
hold on
% plot(timeVec(tbeg:tend-maxTTime-96),...
%       floOut(maxTTime+96+1:nSim,end),'b:','MarkerSize',2);

semilogy(timeVec(tbeg:tend-maxTTime),...
      floOut(maxTTime-1:nSim-2,end),'b:','MarkerSize',2);
xlabel(['Water Year ',datestr(timeVec(tend),'yyyy')]);
legend('Measured','Simulated');
hold off
%
% Take logs of measured and simulated flows
 lFlowMea = log10(flowVec(tbeg:tend-maxTTime));
dlFlowMea = diff(lFlowMea,1);
 lFlowSim = log10(floOut(maxTTime-1:nSim-2,end));
dlFlowSim = diff(lFlowSim,1);
%
figure(2); clf(2);
% Plot log, differenced flow series
plot(timeVec(tbeg:(tend - maxTTime - 1)),dlFlowMea,'r-');
datetick('x','mmm-YY');
hold on
plot(timeVec(tbeg:(tend - maxTTime - 1)),dlFlowSim,'b:');
plot([timeVec(tbeg),timeVec(tend - maxTTime -1)],[0,0],...
    'k--');
legend('Measured','Simulated','Zero Reference','Location','Best');
ylabel('Lag_1 Differenced, Log_{10} Flows, in cubic feet per second');
hold off
%
% Cross-correlation analysis
accf(dlFlowMea,dlFlowSim,65);
title('Cross correlation of lag_1 Differenced, Log_{10} Flows');

figure(3); clf(3);
plot3(lFlowMea,lFlowSim,timeVec(tbeg:(tend - maxTTime)),'b-');
datetick('z');
xlabel('log_{10} Measured Flow, in cubic feet per second');
xlim([2.5,2.8]);
ylabel('log_{10} Simulated Flow, in cubic feet per second');
ylim([2.5,2.8])
zlabel(['Water Year ',datestr(timeVec(tend),'yyyy')]);
title(['Unit flows at ',gageNumber,' ',gageName]);

figure(4); clf(4);
plot(timeVec(tbeg:(tend - maxTTime)),lFlowMea,'b-');
datetick('x')
title(['Discretized daily mean flows on 01636500 Shenandoah River at Millville, VA in water year ',datestr(timeVec(tend),'yyyy')]); 
ylabel('Log_{10} Measured flow, in cubic feet per second');

figure(5); clf(5);
plot(timeVec(tbeg:(tend - maxTTime)),lFlowMea - lFlowSim,'b-');
datetick('x');
ylabel('Log_{10}Measured - Log_{10}Simulated Flows, in cubic feet per second');
xlabel(['Water Year ',datestr(timeVec(tend),'yyyy')]);
hold on
plot([timeVec(tbeg),timeVec(tend - maxTTime)],[0,0],'k:');

figure(6); clf(6);
plot(timeVec(tbeg:(tend - maxTTime-1)),dlFlowMea,'b-');
datetick('x')
title(['Discretized daily mean flows on 01636500 Shenandoah River at Millville, VA in water year ',datestr(timeVec(tend),'yyyy')]); 
ylabel('Log_{10} Measured flow, in cubic feet per second');

figure(7); clf(7);
plot(dlFlowMea,lFlowMea(2:end) - lFlowSim(2:end),'b.');
datetick('x')
title(['Discretized daily mean flows on 01636500 Shenandoah River at Millville, VA in water year ',datestr(timeVec(tend),'yyyy')]); 
ylabel('Log_{10} Measured flow, in cubic feet per second');

ndxZeroSim = find( abs(dlFlowSim) < 1.65e-5);
ndxZeroMea = find( abs(dlFlowMea) == 0);
%
figure(10); clf(10);
plot(lFlowMea(ndxSetDif),lFlowSim(ndxSetDif),'go','MarkerSize',2);
hold on
plot(lFlowMea(ndxZeroSim),lFlowSim(ndxZeroSim),'b.','MarkerSize',5)
plot(lFlowMea(ndxZeroMea),lFlowSim(ndxZeroMea),'ro','MarkerSize',3);
%
% Plot lFlowMea with lFlowSim flows that are not ndxZero
% First, create intersection of ndxZeroMea and ndxZeroSim
[ndxInter, iMea, iSim] = intersect(ndxZeroMea,ndxZeroSim);
 ndxSetDif = setdiff(1:length(lFlowMea),ndxInter);
% Plot reference 1:1 reference line
plot([2.62,4.50],[2.62,4.50],'k--');





figure( 9);clf( 9);ecdf(abs(dlFlowMea));
figure(10);clf(10);ecdf(abs(dlFlowSim));


