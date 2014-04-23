% ACF is the Auto Correlation Function for process X up to 
%     lag k.  Expected input is one vector length and a scalar k.  
%     Output is the auto correlation. 
%     The algorithm for computing the acf is based on Box, G.E., 
%     and Jenkins, G.M., 1976, Time Series Analysis: Forecasting
%     and Control: Holden-Day, Oakland, Calif., p. 32-.
%
function autok = acf(x,k)
%
x = checkrc(x);
N      = length(x);
xbar   = mean(x);
stdx2  = std(x,1)^2;
for i  = 1:k,
    clear x1 x2
        x1 = x(1  :N-i);
        x2 = x(1+i:N);
    sum2xx        = (x1-xbar)'*(x2-xbar);
    autok(i) = (sum2xx/N)/stdx2;
end
figure;
bar(0:k,[1 autok],.5,'r');
hold on
axis([0 k -1 1]);
title('Autocorrelation function');
xlabel('k');
ylabel('AUTOCORRELATION COEFFICIENT');plot([0,k],[0 0],'k');
plot([0,k],[-1.96/sqrt(N),-1.96/sqrt(N)],'b-');
plot([0,k],[+1.96/sqrt(N),+1.96/sqrt(N)],'b-');
text(k/2,-1.96/sqrt(N)-0.05,'95% CI');
hold off
%;
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
    error('The input series is not a vector.  Respecify.');
end
