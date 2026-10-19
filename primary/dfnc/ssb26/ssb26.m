clc

ps=4;ts=3;
load('severity_scores.mat')
load('ci_dfnc_post_process.mat');
states=squeeze(clusterInfo.states);
SC_AU = [5:6, 56:57, 106:107, 155:156, 203:204]; % 1
SC_SM = [7:15, 58:66, 108:116, 157:165, 205:213]; % 2
SC_VI = [16:24, 67:75, 117:125, 166:174, 214:222]; % 3
SC_CC = [25:41, 76:92, 126:142, 175:191, 223:239]; % 4
SC_DM = [42:48, 93:99, 143:149, 192:198, 240:246]; % 5
SC_CB = [49:52, 100:103, 150:153, 199:202, 247:250]; % 6
AU_SM = [252:260, 298:306]; % 7
AU_VI = [261:269, 307:315]; % 8
AU_CC = [270:286, 316:332]; % 9
AU_DM = [287:293, 333:339]; % 10
AU_CB = [294:297, 340:343]; % 11
SM_VI = [352:360, 396:404, 439:447, 481:489, 522:530, 562:570, 601:609, 639:647, 676:684]; % 12
SM_CC = [361:377, 405:421, 448:464, 490:506, 531:547, 571:587, 610:626, 648:664, 685:701]; % 13
SM_DM = [378:384, 422:428, 465:471, 507:513, 548:554, 588:594, 627:633, 665:671, 702:708]; % 14
SM_CB = [385:388, 429:432, 472:475, 514:517, 555:558, 595:598, 634:637, 672:675, 709:712]; % 15
VI_CC = [721:737, 756:772, 790:806, 823:839, 855:871, 886:902, 916:932, 945:961, 973:989]; % 16
VI_DM = [738:744, 773:779, 807:813, 840:846, 872:878, 903:909, 933:939, 962:968, 990:996]; % 17
VI_CB = [745:748, 780:783, 814:817, 847:850, 879:882, 910:913, 940:943, 969:972, 997:1000]; % 18
CC_DM = [1017:1023, 1043:1049, 1068:1074, 1092:1098, 1115:1121, 1137:1143, 1158:1164, 1178:1184, 1197:1203, 1215:1221, 1232:1238, 1248:1254, 1263:1269, 1277:1283, 1290:1296, 1302:1308, 1313:1319]; % 19
CC_CB = [1024:1027, 1050:1053, 1075:1078, 1099:1102, 1122:1125, 1144:1147, 1165:1168, 1185:1188, 1204:1207, 1222:1225, 1239:1242, 1255:1258, 1270:1273, 1284:1287, 1297:1300, 1309:1312, 1320:1323]; % 20
DM_CB = [1330:1333, 1339:1342, 1347:1350, 1354:1357, 1360:1363, 1365:1368, 1369:1372]; % 21

ps_mn=nan(83,1378);
ts_mn=nan(83,1378);
diff=abs(clusterInfo.Call(ps,:)-clusterInfo.Call(ts,:));
[l,m]=sort(diff,"descend");
for i=1:83
    idx_ps=states(i,:)==ps;
    idx_ts=states(i,:)==ts;
    load(sprintf('ci_dfnc_sub_%03d_sess_001_results.mat',i+89));
    ps_states=FNCdyn(idx_ps,:);
    ts_states=FNCdyn(idx_ts,:);
    ps_mn(i,:)=median(ps_states(:,m(1:1378)),1);
    ts_mn(i,:)=median(ts_states(:,m(1:1378)),1);
end

valid_ps = ~all(isnan(ps_mn),2);
valid_ts = ~all(isnan(ts_mn),2);

phb=severity_scores(valid_ps,1);
pdel=severity_scores(valid_ps,2);
putc=severity_scores(valid_ps,3);
psp=severity_scores(valid_ps,4);

thb=severity_scores(valid_ts,1);
tdel=severity_scores(valid_ts,2);
tutc=severity_scores(valid_ts,3);
tsp=severity_scores(valid_ts,4);

[prho1,pp1]=corr(ps_mn(valid_ps,:),phb,'Type','Spearman','Tail','both');
[prho2,pp2]=corr(ps_mn(valid_ps,:),pdel,'Type','Spearman','Tail','both');
[prho3,pp3]=corr(ps_mn(valid_ps,:),putc,'Type','Spearman','Tail','both');
[prho4,pp4]=corr(ps_mn(valid_ps,:),psp,'Type','Spearman','Tail','both');
fdr1=mafdr(pp1,'BHFDR',true);
fdr2=mafdr(pp2,'BHFDR',true);
fdr3=mafdr(pp3,'BHFDR',true);
fdr4=mafdr(pp4,'BHFDR',true);
mask1=fdr1<0.1;
mask2=fdr2<0.1;
mask3=fdr3<0.1;
mask4=fdr4<0.1;
s1=find(mask1==1);
s2=find(mask2==1);
s3=find(mask3==1);
s4=find(mask4==1);
sig_p={m(s1) m(s2) m(s3) m(s4)};
rp={prho1(s1) prho2(s2) prho3(s3) prho4(s4)};
pfdr_p={fdr1(s1) fdr2(s2) fdr3(s3) fdr4(s4)};
clear fdr1 fdr2 fdr3 fdr4 mask1 mask2 mask3 mask4 s1 s2 s3 s4
[trho1,tp1]=corr(ts_mn(valid_ts,:),thb,'Type','Spearman','Tail','both');
[trho2,tp2]=corr(ts_mn(valid_ts,:),tdel,'Type','Spearman','Tail','both');
[trho3,tp3]=corr(ts_mn(valid_ts,:),tutc,'Type','Spearman','Tail','both');
[trho4,tp4]=corr(ts_mn(valid_ts,:),tsp,'Type','Spearman','Tail','both');
fdr1=mafdr(tp1,'BHFDR',true);
fdr2=mafdr(tp2,'BHFDR',true);
fdr3=mafdr(tp3,'BHFDR',true);
fdr4=mafdr(tp4,'BHFDR',true);
mask1=fdr1<0.1;
mask2=fdr2<0.1;
mask3=fdr3<0.1;
mask4=fdr4<0.1;
s1=find(mask1==1);
s2=find(mask2==1);
s3=find(mask3==1);
s4=find(mask4==1);
sig_t={m(s1) m(s2) m(s3) m(s4)};
rt={trho1(s1) trho2(s2) trho3(s3) trho4(s4)};
pfdr_t={fdr1(s1) fdr2(s2) fdr3(s3) fdr4(s4)};

prss=[rp;sig_p;pfdr_p];
trns=[rt;sig_t;pfdr_t];

u1=sum(isnan(ps_mn(valid_ps,:)),'all');
u2=sum(isnan(ts_mn(valid_ts,:)),'all');
u3=sum(sum(isnan(ps_mn(valid_ps,:)),1));
u4=sum(sum(isnan(ts_mn(valid_ts,:)),1));
u=[u1 u2 u3 u4];

%% permutation 

n_perm = 40000;
n_ps=numel(phb);
n_ts=numel(thb);

per_seeds = 1:n_perm;

parfor i = 1:n_perm

    rng(per_seeds(i),'twister');
    permp_idx = randperm(n_ps);
    permt_idx = randperm(n_ts);
       
    hb = phb(permp_idx );
    del = pdel(permp_idx );
    utc = putc(permp_idx );
    sp  = psp(permp_idx );

    [pr1(:,i),~] = corr(ps_mn(valid_ps,:),hb, ...
        'Type','Spearman','Tail','both');

    [pr2(:,i),~] = corr(ps_mn(valid_ps,:),del, ...
        'Type','Spearman','Tail','both');

    [pr3(:,i),~] = corr(ps_mn(valid_ps,:),utc, ...
        'Type','Spearman','Tail','both');

    [pr4(:,i),~] = corr(ps_mn(valid_ps,:),sp, ...
        'Type','Spearman','Tail','both');

    hb = thb(permt_idx);
    del = tdel(permt_idx);
    utc = tutc(permt_idx);
    sp  = tsp(permt_idx);


    [tr1(:,i),~] = corr(ts_mn(valid_ts,:),hb, ...
        'Type','Spearman','Tail','both');

    [tr2(:,i),~] = corr(ts_mn(valid_ts,:),del, ...
        'Type','Spearman','Tail','both');

    [tr3(:,i),~] = corr(ts_mn(valid_ts,:),utc, ...
        'Type','Spearman','Tail','both');

    [tr4(:,i),~] = corr(ts_mn(valid_ts,:),sp, ...
        'Type','Spearman','Tail','both');

    disp(['perm iter: ',num2str(i)]);
end

for i = 1:1378

    pe_hb(i)  = (1 + sum(abs(pr1(i,:)) >= abs(prho1(i)))) / (n_perm + 1);
    pe_del(i) = (1 + sum(abs(pr2(i,:)) >= abs(prho2(i)))) / (n_perm + 1);
    pe_utc(i) = (1 + sum(abs(pr3(i,:)) >= abs(prho3(i)))) / (n_perm + 1);
    pe_sp(i)  = (1 + sum(abs(pr4(i,:)) >= abs(prho4(i)))) / (n_perm + 1);

    tpe_hb(i)  = (1 + sum(abs(tr1(i,:)) >= abs(trho1(i)))) / (n_perm + 1);
    tpe_del(i) = (1 + sum(abs(tr2(i,:)) >= abs(trho2(i)))) / (n_perm + 1);
    tpe_utc(i) = (1 + sum(abs(tr3(i,:)) >= abs(trho3(i)))) / (n_perm + 1);
    tpe_sp(i)  = (1 + sum(abs(tr4(i,:)) >= abs(trho4(i)))) / (n_perm + 1);

end

pv1=mafdr(pe_hb,'BHFDR',true);
o1=sum(pv1<0.05);
pv2=mafdr(pe_del,'BHFDR',true);
o2=sum(pv2<0.05);
pv3=mafdr(pe_utc,'BHFDR',true);
o3=sum(pv3<0.05);
pv4=mafdr(pe_sp,'BHFDR',true);
o4=sum(pv4<0.05);

pv5=mafdr(tpe_hb,'BHFDR',true);
o5=sum(pv5<0.05);
pv6=mafdr(tpe_del,'BHFDR',true);
o6=sum(pv6<0.05);
pv7=mafdr(tpe_utc,'BHFDR',true);
o7=sum(pv7<0.05);
pv8=mafdr(tpe_sp,'BHFDR',true);
o8=sum(pv8<0.05);

o=[o1 o2 o3 o4 o5 o6 o7 o8];
pv=[pv1 ;pv2 ;pv3 ;pv4 ;pv5 ;pv6 ;pv6 ;pv7 ;pv8];

idx_p_hb=find(pe_hb<0.05);
table_pv1=[prho1(idx_p_hb)'; pp1(idx_p_hb)'; pe_hb(idx_p_hb); pv1(idx_p_hb)];

idx_p_del=find(pe_del<0.05);
table_pv2=[prho2(idx_p_del)'; pp2(idx_p_del)'; pe_del(idx_p_del); pv2(idx_p_del)];

idx_p_utc=find(pe_utc<0.05);
table_pv3=[prho3(idx_p_utc)'; pp3(idx_p_utc)'; pe_utc(idx_p_utc); pv3(idx_p_utc)];

idx_p_sp=find(pe_sp<0.05);
table_pv4=[prho4(idx_p_sp)'; pp4(idx_p_sp)'; pe_sp(idx_p_sp); pv4(idx_p_sp)];

idx_t_hb=find(tpe_hb<0.05);
table_pv5=[trho1(idx_t_hb)'; tp1(idx_t_hb)'; tpe_hb(idx_t_hb); pv5(idx_t_hb)];

idx_t_del=find(tpe_del<0.05);
table_pv6=[trho2(idx_t_del)'; tp2(idx_t_del)'; tpe_del(idx_t_del); pv6(idx_t_del)];

idx_t_utc=find(tpe_utc<0.05);
table_pv7=[trho3(idx_t_utc)'; tp3(idx_t_utc)'; tpe_utc(idx_t_utc); pv7(idx_t_utc)];

idx_t_sp=find(tpe_sp<0.05);
table_pv8=[trho4(idx_t_sp)'; tp4(idx_t_sp)'; tpe_sp(idx_t_sp); pv8(idx_t_sp)];

save('ssb26.mat', ...
    'table_pv1','table_pv2','table_pv3','table_pv4', ...
    'table_pv5','table_pv6','table_pv7','table_pv8', ...
    'idx_p_del','idx_p_hb','idx_p_sp','idx_p_utc', ...
    'idx_t_del','idx_t_hb','idx_t_sp','idx_t_utc','pv','o','m','prss','trns')

