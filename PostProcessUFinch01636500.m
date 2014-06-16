%% Retrieve unit flow from simulation
[fname, pname]  = uigetfile({['..\..\..\Data\UFinch\HR02\FlowData\Model\','.mat']},...
    'Load Matlab File of Unit Flows from UFinch Simulation');
% Load the data file
load([pname,fname]);
%
%% Select computed daily mean flows from 
% 01636500 Shenandoah River at Millville, WV
selGageNo   = 01636500;
selGageName = 'Shenandoah River at Millville, WV';
selComID    = 8445070;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',...
    ['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(1); clf(1); 
travTime15 = 130;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2006,6,1),150,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% Plot quantiles
% figure(2); clf(2); 
% qqplot(log10(tStreamgage.flow),log10(uQUfinch(1+travTime:end)));
% % Get and Set properties of lines 
% h = get(gca,'Children'); set(h(1),'MarkerSize',2); set(h(1),'MarkerEdgeColor','b')
% xlabel('Quantiles of log_{10}Computed Daily Mean Flows at Streamgage');
% ylabel('Quantiles of log_{10}Simulated Unit Flows by UFINCH');
% title(['Quantile-Quantile Plot of Measured Daily with UFINCH Unit Flows at',num2str(selGageNo),' ',selGageName]); 
%% Plot Relation Between Measurd and UFINCH flow series
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); clf(6);
plot([0.5,4.9],[0.5,4.9],'k-');
hold on 
plot(log10(tStreamgage.flow),log10(dQUfinch),'r+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01636500 (DArea 3041 mi^2)'});
pause()
set(h1,'visible','off'); delete(h1);
%
%% Select computed daily mean flows from 
selGageNo   = 01631000;
selGageName = 'S F SHENANDOAH RIVER AT FRONT ROYAL, VA';
selComID    = 5907079;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(3); clf(3); 
travTime15 = 130;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2006,6,1),150,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% Plot relation between flows
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'b+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01636500 (DArea 3041 mi^2)',...
    '01631000 (DArea 1634 mi^2)'});
pause()
set(h1,'visible','off'); delete(h1);
%
%%
selGageNo   = 01634000;
selGageName = 'N F SHENANDOAH RIVER NEAR STRASBURG, VA';
selComID    = 8441253;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(4); clf(4); 
travTime15 = 130;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2006,6,1),20,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% Plot Relation Between Flows
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'g+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01636500 (DArea 3041 mi^2)',...
    '01631000 (DArea 1634 mi^2)','01634000 (DArea 770 mi^2)'});
pause()
set(h1,'visible','off'); delete(h1);
%
%% 
selGageNo   = 01622000;
selGageName = 'NORTH RIVER NEAR BURKETOWN, VA';
selComID    = 5908733;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(5); clf(5); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2006,6,1),20,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% Plot relation between flows
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'c+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01636500 (DArea 3041 mi^2)',...
    '01631000 (DArea 1634 mi^2)','01634000 (DArea 770 mi^2)',...
    '01622000 (DArea 376 mi^2)'});
pause()
set(h1,'visible','off'); delete(h1);
%
%%
selGageNo   = 01632000;
selGageName = 'N F SHENANDOAH RIVER AT COOTES STORE, VA';
selComID    = 8441037;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(5); clf(5); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2006,6,1),0.2,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% QQ plot 
figure(10); clf(10);
qqplot(log10(tStreamgage.flow),log10(uQUfinch));
hold on
plot([-0.5 3.9],[-0.5, 3.9],'k-');
legend('Line Extrapolating Line Through the Upper and Lower Quantiles',...
    'Line Connecting the Upper and Lower Quantiles','Quantile Pairs',...
    'Line of Agreement','Location','NorthWest');

%% Plot Relation between Flow Series
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'m+','MarkerSize',1.5);
plot([0.5,4],[0.5,4],'k-');
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01636500 (DArea 3041 mi^2)',...
    '01631000 (DArea 1634 mi^2)','01634000 (DArea 770 mi^2)',...
    '01622000 (DArea 376 mi^2)','01632000 (DArea 210 mi^2)'});
pause()
% set(h1,'visible','off'); delete(h1);

%% Fit residuals to a function
figure(6); hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'m+','MarkerSize',1.5);
plot([0.5,4],[0.5,4],'k-');
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01636500 (DArea 3041 mi^2)',...
    '01631000 (DArea 1634 mi^2)','01634000 (DArea 770 mi^2)',...
    '01622000 (DArea 376 mi^2)','01632000 (DArea 210 mi^2)'});
%
% Compute residuals
residQUfinch = log10(dQUfinch) - log10(tStreamgage.flow);
% plot relation
figure(7); clf(7);
plot(log10(tStreamgage.flow),residQUfinch,'b+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Streamflow Bias, in log_{10} cubic feet per second');%
hold on;
% Specify equation form
% g = inline('b(1) .* exp(-(b(2) .* x)) + b(3) .* x .* exp(-(b(4) .* x))','b','x');
g = inline('b(1) .* exp(-(b(2) .* x)) + b(3) .* x ','b','x');
x = log10(tStreamgage.flow);
% Specify initial parameter estimate vector
beta = [2 .5 0.2];
beta = nlinfit(x,residQUfinch,g,beta);
[beta,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(x,residQUfinch,g,beta);
% Parameter confidence interval computed first way
ci1 = nlparci(beta,R,'covar',CovB);
disp(ci1);
% Parameter confidence interval computed second way
ci2 = nlparci(beta,R,'jacobian',J);
disp(ci2);
%
hold on
y    = g(beta,sort(x));
plot(sort(x), y,'r-','LineWidth',2);
legend('Bias Data Pairs','Estimated Relation','Location','NorthEast');
text(-0.85,-0.32,'g(b,x) = b_1 .* exp(-(b_2 * x)) + b_3 * x ',...
    'FontName','FixedWidth');
text(-0.75,-0.45,['bhat  = ',num2str(beta)],'FontName','FixedWidth');
text(-0.75,-0.58,[' 2.5% = ',num2str(ci1(:,1)')],'FontName','FixedWidth');
text(-0.75,-0.71,['97.5% = ',num2str(ci1(:,2)')],'FontName','FixedWidth');
title('Bias in UFINCH Flow Estimate at 01632000 NF Shenandoah River at Cootes Store, VA');
%% Bias Adjusted UFINCH flows
figure(8); clf(8); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 

yhat     = g(beta,log10(tStreamgage.flow));

semilogy(tStreamgage.Date,...
    10.^(log10(dQUfinch)-yhat),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2006,1,1),0.2,{'Computed Daily Mean Flows Plotted at Noon.',...
    'Bias Adjusted UFINCH Noon Flows from 15-min Values.'});

%% 
figure(9); clf(9);
plot([-0.5,4],[-0.5,4],'k-');
hold on
plot(log10(tStreamgage.flow),log10(dQUfinch),'m+','MarkerSize',1.5);
plot(log10(tStreamgage.flow),(log10(dQUfinch)-yhat),'rx','MarkerSize',4);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('Bias-Adjusted UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01632000 (DArea 210 mi^2)',...
    'Bias Adjusted 01632000'});
% pause()
% set(h1,'visible','off'); delete(h1);

%% 01625000 Middle River nr Grottoes, VA 
selGageNo   = 01625000;
selGageName = 'Middle River nr Grottoes, VA';
selComID    = 5908355;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(5); clf(5); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2006,6,1),20,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% Plot relation between flows
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); clf(6);
plot([1.1 3.9],[1.1,3.9],'k-');
hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'g+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01625000 (DArea 373 mi^2)'});
pause()
set(h1,'visible','off'); delete(h1);
%
%% 01627500 South River at Harriston, VA 
selGageNo   = 01627500;
selGageName = 'South River at Harriston, VA';
selComID    = 5908375;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(5); clf(5); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2006,6,1),20,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% Plot relation between flows
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); clf(6);
plot([1.1 3.9],[1.1,3.9],'k-');
hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'g+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01627500 (DArea 212 mi^2)'});
pause()
set(h1,'visible','off'); delete(h1);
%
%% 01635090 Cedar Creek above HWY 11 nr Middletown, VA 
selGageNo   = 01635090;
selGageName = 'Cedar Creek above HWY 11 nr Middletown, VA (Drainage Area 154 mi^2)';
selComID    = 8440399;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(5); clf(5); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2007,1,1),10,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% Plot relation between flows
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); clf(6);
plot([1.1 3.9],[1.1,3.9],'k-');
hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'g+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01635090 (DArea 154 mi^2)'});
title(['Relation Between Measured and UFINCH Flows at ',num2str(selGageNo),' ',selGageName]); 
%% Fit residuals to a function
% Compute residuals
residQUfinch = log10(dQUfinch) - log10(tStreamgage.flow);
% plot relation
figure(7); clf(7);
plot(log10(tStreamgage.flow),residQUfinch,'b+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Streamflow Bias, in log_{10} cubic feet per second');%
hold on;
% Specify equation form
% g = inline('b(1) .* exp(-(b(2) .* x)) + b(3) .* x .* exp(-(b(4) .* x))','b','x');
g = inline('b(1) .* exp(-(b(2) .* x)) + b(3) .* x ','b','x');
x = log10(tStreamgage.flow);
% Specify initial parameter estimate vector
beta = [2 .5 0.2];
beta = nlinfit(x,residQUfinch,g,beta);
[beta,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(x,residQUfinch,g,beta);
% Parameter confidence interval computed first way
ci1 = nlparci(beta,R,'covar',CovB);
disp(ci1);
% Parameter confidence interval computed second way
ci2 = nlparci(beta,R,'jacobian',J);
disp(ci2);
%
% Estimate linear equation instead
mdl = fitlm(x,residQUfinch);

hold on
% y    = g(beta,sort(x));
y      = mdl.Fitted;
plot(x, y,'r-','LineWidth',2);
legend('Bias Data Pairs','Estimated Relation','Location','NorthEast');
text(-0.85,-0.32,'g(b,x) = b_1 .* exp(-(b_2 * x)) + b_3 * x ',...
    'FontName','FixedWidth');
text(-0.75,-0.45,['bhat  = ',num2str(beta)],'FontName','FixedWidth');
text(-0.75,-0.58,[' 2.5% = ',num2str(ci1(:,1)')],'FontName','FixedWidth');
text(-0.75,-0.71,['97.5% = ',num2str(ci1(:,2)')],'FontName','FixedWidth');
title('Bias in UFINCH Flow Estimate at 01632000 NF Shenandoah River at Cootes Store, VA');
%% Bias Adjusted UFINCH flows
figure(8); clf(8); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 

% yhat     = g(beta,log10(tStreamgage.flow));
yhat     = mdl.Fitted;
semilogy(tStreamgage.Date,...
    10.^(log10(dQUfinch)-yhat),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2005,6,1),2,{'Computed Daily Mean Flows Plotted at Noon.',...
    'Bias Adjusted UFINCH Noon Flows from 15-min Values.'});
%
%% 01629500 SF Shenandoah River near Luray, VA 
selGageNo   = 01629500;
selGageName = 'SF Shenandoah River near Luray, VA (Drainage Area 1372 mi^2)';
selComID    = 5907167;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(5); clf(5); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2007,1,1),10,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% Plot relation between flows
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); clf(6);
plot([1.1 3.9],[1.1,3.9],'k-');
hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'g+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement','01635090 (DArea 154 mi^2)'});
title(['Relation Between Measured and UFINCH Flows at ',num2str(selGageNo),' ',selGageName]); 
%% Fit residuals to a function
% Compute residuals
residQUfinch = log10(dQUfinch) - log10(tStreamgage.flow);
% plot relation
figure(7); clf(7);
plot(log10(tStreamgage.flow),residQUfinch,'b+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Streamflow Bias, in log_{10} cubic feet per second');%
hold on;
% Specify equation form
% g = inline('b(1) .* exp(-(b(2) .* x)) + b(3) .* x .* exp(-(b(4) .* x))','b','x');
% g = inline('b(1) .* exp(-(b(2) .* x)) + b(3) .* x ','b','x');
x = log10(tStreamgage.flow);
% % Specify initial parameter estimate vector
% beta = [2 .5 0.2];
% beta = nlinfit(x,residQUfinch,g,beta);
% [beta,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(x,residQUfinch,g,beta);
% % Parameter confidence interval computed first way
% ci1 = nlparci(beta,R,'covar',CovB);
% disp(ci1);
% % Parameter confidence interval computed second way
% ci2 = nlparci(beta,R,'jacobian',J);
% disp(ci2);
%
% Estimate linear equation instead
mdlR = fitlm(x,residQUfinch,'residQUfinch ~ x + x^2','ResponseVar',...
    'residQUfinch','PredictorVars','x','RobustOpts','on');

hold on
% y    = g(beta,sort(x));
yR      = mdlR.Fitted;
[x_sort,ndx] = sort(x); 
plot(x_sort, yR(ndx),'k-','LineWidth',2);
legend('Bias Data Pairs','OLS Relation','Robust Relation',...
    'Location','NorthEast');
text(-0.85,-0.32,'g(b,x) = b_1 .* exp(-(b_2 * x)) + b_3 * x ',...
    'FontName','FixedWidth');
text(-0.75,-0.45,['bhat  = ',num2str(beta)],'FontName','FixedWidth');
text(-0.75,-0.58,[' 2.5% = ',num2str(ci1(:,1)')],'FontName','FixedWidth');
text(-0.75,-0.71,['97.5% = ',num2str(ci1(:,2)')],'FontName','FixedWidth');
title(['Bias in UFINCH Flow Estimate at ',num2str(selGageNo),' ',selGageName]);
%% Bias Adjusted UFINCH flows
figure(8); clf(8); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 

% yhat     = g(beta,log10(tStreamgage.flow));
yhat     = mdlR.Fitted;
semilogy(tStreamgage.Date,...
    10.^(log10(dQUfinch)-yhat),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2005,6,1),2,{'Computed Daily Mean Flows Plotted at Noon.',...
    'Bias Adjusted UFINCH Noon Flows from 15-min Values.'});
%% 01628500 SF Shenandoah River at Lynwood, VA 
selGageNo   = 01628500;
selGageName = 'SF Shenandoah River at Lynwood, VA (Drainage Area 1079 mi^2)';
selComID    = 5908723;
%
% Get daily flows from NWIS retrieval 
[fname1, pname1]  = uigetfile({['..\HR02\FlowData\',['dQ',num2str(selGageNo,'%08u'),'.txt']]},...
    'Open ASCII File of Daily Flows for Selected Streamgage');
% Store daily flows in table
tStreamgage      = readtable([pname1,fname1],'Delimiter','\t');
% Standardize names
tStreamgage.Properties.VariableNames = {'Agency','site_no','datetimeStr',...
    'flow','flow_qualifier'};
% Summarize table of data
summary(tStreamgage);
% Convert string to datetime
tStreamgage.Date = datenum(tStreamgage.datetimeStr,'yyyy-mm-dd');
%
%% Plot the UFINCH flow at a selected ComID
% Find travel time associated with ComID 5907079
% Streamgage 01631000 is on ComID 5907079.  target ComID is targComID
uQUfinch    = eval(['C',num2str(selComID)]);
ndxComID    = find(ComID == selComID); 
%
% ttNetwork is a vector of network travel times computed in UFINCH
%   travTime15 is the number of 15-minute travel time intervals from the base
travTime15   = ttNetwork(ndxComID);
fprintf(1,'For %u %s at ComID %u, the travel time is %u 15-min intervals.\n',...
    selGageNo, selGageName, selComID, travTime15); 
% Form timedate vector for UFINCH flows
vYrMoDaHrMn  = sYrMoDaHrMn:1/96:eYrMoDaHrMn;
%% Plot times series
figure(5); clf(5); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 
semilogy(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2007,1,1),30,{'Computed Daily Mean Flows Plotted at Noon.',...
    'UFINCH Noon Flows Plotted from 15-min Values.'});
%
%% Plot relation between flows
dQUfinch      = interp1(vYrMoDaHrMn(1:end-travTime),uQUfinch(1+travTime:end),...
                  tStreamgage.Date+0.5,'pchip');
ndx           = find(dQUfinch <= 0);
dQUfinch(ndx) = nan();
%
figure(6); clf(6);
plot([1.8 4.6],[1.8,4.6],'k-');
hold on;
plot(log10(tStreamgage.flow),log10(dQUfinch),'g+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Noon Streamflow, in log_{10} cubic feet per second');
h1 = legend('Location','NorthWest',{'Line of Agreement',[num2str(selGageNo),' Drainage Area 1079']});
title(['Relation Between Measured and UFINCH Flows at ',num2str(selGageNo),' ',selGageName]); 
%% Fit residuals to a function
% Compute residuals
residQUfinch = log10(dQUfinch) - log10(tStreamgage.flow);
ldQUfinch    = log10(dQUfinch);
ldQMeasure   = log10(tStreamgage.flow);
% plot relation
figure(7); clf(7);
plot(log10(tStreamgage.flow),residQUfinch,'b+','MarkerSize',1.5);
xlabel('Computed Daily Mean Streamflow, in log_{10} cubic feet per second');
ylabel('UFINCH Streamflow Bias, in log_{10} cubic feet per second');%
hold on;
% Specify equation form
% g = inline('b(1) .* exp(-(b(2) .* x)) + b(3) .* x .* exp(-(b(4) .* x))','b','x');
% g = inline('b(1) .* exp(-(b(2) .* x)) + b(3) .* x ','b','x');
x = log10(tStreamgage.flow);
% % Specify initial parameter estimate vector
% beta = [2 .5 0.2];
% beta = nlinfit(x,residQUfinch,g,beta);
% [beta,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(x,residQUfinch,g,beta);
% % Parameter confidence interval computed first way
% ci1 = nlparci(beta,R,'covar',CovB);
% disp(ci1);
% % Parameter confidence interval computed second way
% ci2 = nlparci(beta,R,'jacobian',J);
% disp(ci2);
%
% Estimate linear equation instead
mdlR = fitlm(x,residQUfinch,'residQUfinch ~ x + x^2','ResponseVar',...
    'residQUfinch','PredictorVars','x','RobustOpts','on');

hold on
% y    = g(beta,sort(x));
yR      = mdlR.Fitted;
[x_sort,ndx] = sort(x); 
plot(x_sort, yR(ndx),'k-','LineWidth',2);
legend('Bias Data Pairs','OLS Relation','Robust Relation',...
    'Location','NorthEast');
text(-0.85,-0.32,'g(b,x) = b_1 .* exp(-(b_2 * x)) + b_3 * x ',...
    'FontName','FixedWidth');
text(-0.75,-0.45,['bhat  = ',num2str(beta)],'FontName','FixedWidth');
text(-0.75,-0.58,[' 2.5% = ',num2str(ci1(:,1)')],'FontName','FixedWidth');
text(-0.75,-0.71,['97.5% = ',num2str(ci1(:,2)')],'FontName','FixedWidth');
title(['Bias in UFINCH Flow Estimate at ',num2str(selGageNo),' ',selGageName]);
%% Bias Adjusted UFINCH flows
figure(8); clf(8); 
travTime15 = 110;                    % ADJUST travTime15 TO MATCH 
travTime = round(11/3*travTime15); 

% yhat     = g(beta,log10(tStreamgage.flow));
yhat     = mdlR.Fitted;
semilogy(tStreamgage.Date,...
    10.^(log10(dQUfinch)-yhat),'r-');
datetick('x');
hold on
title(['Flows at ',num2str(selGageNo),' ',selGageName]); 
% Add 0.5 to tStreamgage.Date to put average at noon
semilogy(tStreamgage.Date+0.5,tStreamgage.flow,'b-');
ylabel('Streamflow, in cubic feet per second');
xlabel('Water Year');
legend('UFINCH','Measured');
text(datenum(2005,6,1),2,{'Computed Daily Mean Flows Plotted at Noon.',...
    'Bias Adjusted UFINCH Noon Flows from 15-min Values.'});

%
predlogY  = sim(arx440,ldQUfinch);
figure(11); clf(11);
plot(predlogY,'b-');
hold on 
plot(log10(tStreamgage.flow),'r-');
plot(log10(dQUfinch),'g-');

figure(11); clf(11);
h1 = ecdf(log10(tStreamgage.flow));
hold on
ecdf(log10(dQUfinch));

qqplot(log10(tStreamgage.flow),log10(dQUfinch))
xlabel('Quantiles of Measured Daily Log_{10} Streamflow');
ylabel('Quantiles of UFINCH Estimated Log_{10} Streamflow');

slogMeasured = sort(log10(tStreamgage.flow));
slogUFinch   = sort(log10(dQUfinch));

figure(12); clf(12);
plot(slogMeasured,slogUFinch,'r+');
hold on
plot([1.8, 4.8],[1.8, 4.8],'k-');

