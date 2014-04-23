function [outhuclist]=UFSelectHUC(hucshapefile)
%Script to select individual HUCs
%for AFINCH regression.  Displays map of HUCs and
%small window with instructions on selecting.
%Generates list of HUCs.  Gets streamgages within
%the selected HUCs using reachcodes in the
%streamgage event table.
%
%H.W. Reeves, USGS Michigan Water Science Center
%March 1, 2011
%
%set up parameters of Albers Projection, need to change
%these to correspond to project used for application
albers=defaultm('eqaconicstd');
albers.falseeasting=0.0;
albers.falsenorthing=0.0;
albers.mapparallels=[29.5 45.0];
%albers.origin=[-96.0 23.0 0.0];

%read shapefile of HUCS and show on map, show a second window
%with selection instructions
HUC=shaperead(hucshapefile);
scrsz=get(0,'ScreenSize');
mainfig=figure('Position',[20 100 scrsz(3)*0.75 scrsz(4)*0.75],'Name',...
    'Select Hydrologic Subregion');
messx=scrsz(3)-scrsz(3)*0.2;
messy=scrsz(4)-scrsz(4)*0.2;
messagefig=figure('OuterPosition',...
    [messx messy scrsz(3)*0.2 scrsz(4)*0.2],'Color','y','MenuBar','none');
messax=axes('Position',[0 0 1 1],'Visible','off');
str(1)={'ZOOM TO AREA OF INTEREST'};
str(2)={'Dialog below to start'};
str(3)={''};
str(4)={'Left-click to select HUC'};
str(5)={'Shift-Left-click to deselect HUC'};
str(6)={'Right-click to end list of HUCs'};
set(gcf,'CurrentAxes',messax);
text(0.015,0.6,str,'FontSize',12);
figure(mainfig);
ax=axesm(albers);
hUFinchGUI = getappdata(0,'hUFinchGUI');
HRname     = getappdata(hUFinchGUI,'HRname');
maphandle=mapshow(ax,HUC,...
    'DisplayType','polygon',...
    'FaceColor','none',...
    'EdgeColor','k');
title(HRname);
%entry=input('Enter y/Y to pick HUCS\n','s');
%if isempty(entry)
%    entry='Y';
%end
zoomin=msgbox('Zoom to location of interest, click OK to start',...
    'START');
zx=scrsz(3)*0.60;
zy=scrsz(4)*0.50;
set(zoomin,'Position',[zx,zy,176.25,51.75],'Color','y');
uiwait(zoomin);
entry='YES';
% set up hashes (MATLAB map) for selected HUCs and 
% map-object handles of the HUCs
huclist=containers.Map;
py=containers.Map;
% arrays for HUC labels
centerx=zeros(length(HUC),1);
centery=zeros(length(HUC),1);
%if entry=='Y'|| entry=='y'   %user requests to select HUCs
if strcmp(entry,'YES') || strcmp(entry,'Yes');
    for i=1:length(HUC)  %label HUCs
        sumx=0.;
        sumy=0.;
        countx=0;
        county=0;
        goodvals=isfinite(HUC(i).X);
        for j=1:length(goodvals)
            if goodvals(j)==1
                sumx=sumx+HUC(i).X(j);
                countx=countx+1;
                sumy=sumy+HUC(i).Y(j);
                county=county+1;
            end
        end
        centerx(i,1)=sumx/countx;
        centery(i,1)=sumy/county;
        hucname=strtrim(HUC(i).HUC_4);
        hucName=strtrim(HUC(i).HUC_Name);
        text(centerx(i,1),centery(i,1),hucname,...
            'HorizontalAlignment','center','Clipping','on');
    end
    done=false;
    while done==false;
        [xpt,ypt,button]=ginput(1);
        if button==1;  %left click
            add=true;
        elseif button==2;  %middle button or shift-left click
            add=false;
        elseif button==3;  % right click
            done=true;
            break;
        else  %any other input on keyboard
            done=true;
            break;   
        end
        for testhuc=1:length(HUC);
            IN=inpolygon(xpt(1),ypt(1),HUC(testhuc).X,HUC(testhuc).Y);
            if IN==1; 
                hucname=strtrim(HUC(testhuc).HUC_4);
                %fprintf('%12.2f %12.2f %2d %s %s %d\n',xpt(1), ypt(1),...
                %IN, HUC(testhuc).NAME, hucname, add);
                if add==true;
                    huclist(hucname)=1;
                    han=mapshow(ax,HUC(testhuc),...
                        'DisplayType','polygon',...
                        'FaceColor','cyan',...
                        'EdgeColor','none');
                    py(hucname)=han;
                    text(centerx(testhuc,1),centery(testhuc,1),hucname,...
                        'HorizontalAlignment','center');
                elseif add==false;
                    if isKey(huclist,hucname);
                        remove(huclist,hucname);
                        if isKey(py,hucname);
                            delete(py(hucname));
                            remove(py,hucname);
                        end
                    end
                end
            end
        end
    end
    outhuclist=keys(huclist);
else
    fprintf('no HUCS selected\n');
end
close(mainfig);
close(messagefig);


    
  








