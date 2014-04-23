% ACCF computes the auto and cross-correlation function for two series to 
%     lag k.  Expected input is two vectors x and y, and a scalar k.  
%     Output is the two acfs and the ccf. 
%     The algorithm for computing the acf is based on Box, G.E., 
%     and Jenkins, G.M., 1976, Time Series Analysis: Forecasting
%     and Control: Holden-Day, Oakland, Calif., p. 32-.
%
function [autoxk,autoyk,crossk] = accf(x,y,k)
%
if nargin ~= 3
     error('Wrong number of input arguments')
end
if length(x)~=length(y)
    n = min(length(x),length(y));
    x = x(1:n); y=y(1:n);
    disp('X or Y series truncated to match minimum series length.');
end
% Check/convert series to vectors if possible. 
name1 = input('Name of first series:  ','s');
name2 = input('Name of second series: ','s');
x = checkrc(x);
y = checkrc(y);
%
% Compute autocorrelation of first series
N      = length(x);
xbar   = mean(x);
varx  = var(x,1);
for i  = 1:k,
    clear x1 x2
        x1 = x(1  :N-i);
        x2 = x(1+i:N);
    sum2xx        = (x1-xbar)'*(x2-xbar);
    autoxk(i) = (sum2xx/N)/varx;
end
%
% Plot ACF of first series
figure;
subplot(3,1,1)
bar(1:k,[autoxk],.5,'r');
hold on
% axis([0 k -1 1]);
title(strcat({'Autocorrelation function of ',},name1,{' series'}));
xlabel('LAG k');
ylabel('AUTOCORRELATION COEFFICIENT');plot([0,k],[0 0],'k');
plot([0,k],[-1.96/sqrt(N),-1.96/sqrt(N)],'b-');
plot([0,k],[+1.96/sqrt(N),+1.96/sqrt(N)],'b-');
text(.8*k,-1.96/sqrt(N)-0.025,'95% CI');
fprintf(1,'Lag   Est. ACF \n');
for i=1:k,
    fprintf(1,' %8.0f %12.4f  \n',i,autoxk(i));
end
%;
% Compute autocorrelation of second series
ybar   = mean(y);
vary  = var(y,1);
for i  = 1:k,
    clear y1 y2
        y1 = y(1  :N-i);
        y2 = y(1+i:N);
    sum2yy        = (y1-xbar)'*(y2-xbar);
    autoyk(i) = (sum2yy/N)/vary;
end
% Plot ACF of second series
subplot(3,1,2)
bar(1:k,[autoyk],.5,'r');
hold on
% axis([0 k -1 1]);
title(strcat({'Autocorrelation function of ',},name2,{' series'}));
xlabel('LAG k');
ylabel('AUTOCORRELATION COEFFICIENT');plot([0,k],[0 0],'k');
plot([0,k],[-1.96/sqrt(N),-1.96/sqrt(N)],'b-');
plot([0,k],[+1.96/sqrt(N),+1.96/sqrt(N)],'b-');
text(.8*k,-1.96/sqrt(N)-0.025,'95% CI');
%
% Compute CCF of x and y
xbar   = mean(x);
ybar   = mean(y);
stdx   = std(x,1);
stdy   = std(y,1);
stdxy  = stdx * stdy;
for i  = -k:k,
    clear x1 y1
    if i <= 0
        x1 = x(1-i:N); y1 = y(1:N+i);
    else
        x1 = x(1:N-i); y1 = y(1+i:N);
    end
    sum2xy        = (x1-xbar)'*(y1-ybar);
    crossk(k+1+i) = (sum2xy/N)/stdxy;
end
%;
autoxk = [fliplr(autoxk) 1 autoxk];
autoyk = [fliplr(autoyk) 1 autoyk];
varccf = 0;
for i=-k:k,
    varccf = varccf + (autoxk(k+1+i)*autoyk(k+1+i) );
end
varccf = varccf ./ (N-abs(-k:k));
% Plot CCF of x and y
subplot(3,1,3)
bar(-k:k,crossk,.5,'r');
hold on
plot([-k:k],-1.96*sqrt(varccf),'b-');
plot([-k:k],+1.96*sqrt(varccf),'b-');
text(k/2,-1.96*sqrt(varccf(k))-.025,'95% CI');
plot([-k,k],[0 0],'k-','LineWidth',2);
plot([ 0 0],[get(gca,'YLim')],'k:','LineWidth',1);
title(strcat({'Cross correlation function of ',},name1,{'and '},name2));
xlabel('LAG k');
ylabel('CROSS CORRELATION COEFFICIENT');
return
%
function cvec = checkrc(vec)
[row,col] = size(vec);
% fprintf(1,'Row: %10.0f  Col: %10.0f \n',row,col);
if xor(row==1,col==1)==1
    if row == 1
        cvec = vec';
    else
        cvec = vec;
    end
else
    error('At least one of the input series is not a vector.  Respecify.');
end

return
%
