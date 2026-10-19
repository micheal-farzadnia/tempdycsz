clc
clear
for i=1:89
    rp = load(sprintf('hc/%d.txt',i));
   
    d = [zeros(1,6); diff(rp(4:150,:))];
    
    FD(:,i) = sum(abs(d(:,1:3)),2) + ...
        50*sum(abs(d(:,4:6)),2);
    
end

mean(FD)
mfd=mean(FD)';
sum(mfd>0.5)
hcc=find(mfd>0.5);