clc

w=28;
m=147-w+1;
windowFD=nan(83,m);
for i=1:83
    rp = load(sprintf('sz/%d.txt',i));
   
    d = [zeros(1,6); diff(rp(4:150,:))];
    
    FD(:,i) = sum(abs(d(:,1:3)),2) + ...
        50*sum(abs(d(:,4:6)),2);
    
    start = 1:m;
    stop  = start + (w-1);
    fd=FD(:,i);
    for j=1:m
        idx=start(j):stop(j);
        windowFD(i,j) = mean(fd(idx));
    end
end

mean(FD)
mfd=mean(FD)';
sum(mfd>0.5)
ix28=find(mfd>0.5);