% CCF is the Cross Correlation Function for two process X,Y up to 
%     plus or minus lag k.  Expected input are two vectors of equal 
%     length and a scalar k.  Output is the cross correlation. 
%     The algorithm for computing the ccf is based on Box, G.E., 
%     and Jenkins, G.M., 1976, Time Series Analysis: Forecasting
%     and Control: Holden-Day, Oakland, Calif., p. 371-376.
%     Coded by D.J. Holtschlag on Feb. 14, 2002. 
%
function crossk = ccf(x,y,k)
if nargin ~= 3
     error('Wrong number of input arguments')
end
if length(x)~=length(y)
    n = min(length(x),length(y));
    x = x(1:n); y=y(1:n);
    disp('X or Y series truncated to match minimum series length.');
end
%
x = checkrc(x);
y = checkrc(y);
%
N      = length(x);
%
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
autocx = acf(x,k); autocx = [fliplr(autocx) 1 autocx];
autocy = acf(y,k); autocy = [fliplr(autocy) 1 autocy];
varccf = 0;
for i=-k:k,
    varccf = varccf + (autocx(k+1+i)*autocy(k+1+i) );
end
varccf = varccf ./ (N-abs(-k:k));
figure(10)
bar(-k:k,crossk,.5,'r');
hold on
plot([-k:k],-1.96*sqrt(varccf),'b-');
plot([-k:k],+1.96*sqrt(varccf),'b-');
plot([-k,k],[0 0],'k-','LineWidth',2);
plot([ 0 0],[get(gca,'YLim')],'k:','LineWidth',1);
title('Cross Correlation Function');
xlabel('k');
ylabel('CROSS CORRELATION COEFFICIENT');
hold off
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
