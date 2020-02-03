
%tree version
%bp0 is loaded in from matlab workspace, has best fitting parms
mloddcol = 5;

%
eoffset = 0 ; %or whatever8
eoffseta =0;

ad=[];

opt1=0;

nn = num_newdataelements;
bet_summary = [];
datesummary=[];
% Compute optimal neural network parameters here incorporating most recent
% data all in 1 shot




[traindat1, targetdat1] = mktraintarget20_t(sportmat_o, sportodds, teamno, nn, datelist(1:size(sportodds,1),:));
ntargets = size(targetdat1,1);
traindat1 =[traindat1 ; restvec(1:size(sportodds,1),:)'];
ivars=1:size(traindat1, 1);
isCategorical=zeros(length(ivars),1);
isCategorical(end-1:end)=1;
isCategorical(1:2)=1;
% traindat1 =[traindat1 ; restvec(1:size(sportodds,1))];

[~,~,minInp, maxInp, minT, maxT] = norm_data(traindat1,targetdat1); %compute *single* normalizations to apply to all further data

dayno = datelist(:,2);
if exist('date_string')  %don't use any dates equal or later than the scraped in odds date
    lastdayno = datenum(date_string(2:end));
    dayno = dayno(dayno < lastdayno);
end
dp=zeros(1,length(dayno));
for jj = 2:length(dayno)
    if dayno(jj) ~= dayno(jj-1)
        dp(jj)=1;
    end
end

fp = find(dp ~= 0); %find indices of new dates
d1=find(fp > training_min1,1, 'first'); %find the first day index with enough prior history to train
numptsarchive = size(sportmat_o,1)-fp(d1)+1;
archive_data=[];
tic;
% fprintf('%d   %d\n', nind, length(fp));
opts_tree=statset('UseParallel',true);
parfor dayind = d1:length(fp)
    % now you're ready to create the training & targ\et data
    dateseg=datelist(1:fp(dayind)-1,:);
    if dayind < length(fp)
        sL1=fp(dayind+1)-1;
        oddstest1 = sportodds(1:fp(dayind+1)-1,:);
        dateodds1=datenum(datelist(fp(dayind+1)-1,3),datelist(fp(dayind+1)-1,1),datelist(fp(dayind+1)-1,2));
        dateseg1=datelist(1:fp(dayind+1)-1,:);
    else
        sL1 = length(dayno);
        oddstest1=sportodds(1:sL1,:);
        dateodds1=datenum(datelist(sL1,3),datelist(sL1,1),datelist(sL1,2));
        dateseg1=datelist(1:sL1,:);
    end
    stest_o = sportmat_o(1:fp(dayind)-1,: );
    oddstest= sportodds(1:fp(dayind)-1,:);
    [traindat1, targetdat1] = mktraintarget20_t(stest_o, oddstest, teamno, nn, datelist(1:size(stest_o,1),:));
%     traindat1 =[traindat1 ; restvec(1:size(stest_o,1),:)'];
%     %multi-dimensional restvec!!... but restvec is USELESS
%     traindat1 =[traindat1 ; restvec(1:size(stest_o,1))];
    traindat1=traindat1';
    targetdat1=targetdat1';
    
    
    
    
    %***** IMPORTANT ***** bestw1  must be set by prior validation run
    %*****  determining optimal betting strategy
    %
    %         display(dayind);
    
    %%%%%
    %%%%%%
    datelinseg=dateseg(end-training_min1 +1:end,:);
    
    if do_wins < 1
       
      
       b = TreeBagger(numtrees,traindat1(:,ivars1),targetdat1(:,4+do_wins),'Method','R',...
     'OOBPred','On',  ...
    'MinLeafSize',minls);%3 100 %125
    else
         b = TreeBagger(375,traindat1(:,ivars1),targetdat1(:,4+do_wins),'Method','C',...
    'CategoricalPredictors',find(isCategorical(ivars1) == 1), 'OOBPred','On',  ...
    'MinLeafSize',100);%100 %125
    end
    
    % n2='dataminer_fake.xlsx';  %for validation only
    % [stest1, oddstest1, dateodds] = sportfeedin_addltrain_scrape(stest, oddstest, n2, mloddcol); %append new data to existing stest odds file
    s1 = fp(dayind)-1;
    sdiff2 = sL1 - s1; %# of additional matchups
    oddstest_predict1 = oddstest1(end-sdiff2+1:end,:);
    stest_o1 = sportmat_o(1: sL1,:);
    %
    %add on the records et
    % now you're ready to create the training & target data
    [traindat11, targetdat11] = mktraintarget20_t(stest_o1,oddstest1, teamno, nn, datelist(1:size(stest_o1,1),:));
%      traindat11 =[traindat11 ; restvec(1:size(stest_o1,1),:)'];
    traindat11=traindat11';
    targetdat11=targetdat11';
    
%     traindat11 =[traindat11 ; restvec(1:size(stest_o1,1))];
    %%%%
    %%%%
    
    
    
   archive_data1 = futureproject_tree(b, traindat11, targetdat11, sdiff2, ivars1, do_wins); %predict w
    %%%%%%%
    
   
    %for games not yet played only
   
    %
    
    archive_data=[archive_data ; archive_data1];
    
    
    %     fcode=postoutputbets(bet_onlive, totbet_live,mlcritlist, oddstest_predict1,stest1, teamsu,outputfname, dateodds);  %post output
end
% targetarchive = archive_data(:,2:ntargets+1);
% targetarchive_o = invnorm_T(targetarchive,minT, maxT);
% archive_data(:,2:ntargets+1) = targetarchive_o;
numpts = numptsarchive - eoffset;
j1 = archive_data(:,5+do_wins);
% j2 = archive_data(:,5 +do_wins + ntargets);
j2 = archive_data(:,5 +1 + ntargets); %correlate with actual wins
p = corrcoef(j1,j2);
p=p(1,2);
fprintf('prediction quality corr coeff = %d \n', p);
maxbet= 100;
datelistshort = datelist(end-eoffset-numpts+1:end-eoffset,:);
sportmatshort_o = sportmat_o(end-eoffset-numpts+1:end-eoffset,:);
sportoddsshort = sportodds(end-eoffset-numpts+1:end-eoffset,:); %only calculate payouts based on predicted odds & scores
archive_short=archive_data(end-eoffset-numpts+1:end-eoffset,6);
ntargetvars = (size(archive_data,2)-2 - 10)/2;
winvecshort = archive_data(end-eoffset-numpts+1:end-eoffset,1+5+5+ntargetvars);
winvec2 = zeros(numel(winvecshort),2);
winvec2(:,1)= winvecshort > .5;
winvec2(:,2) = winvecshort < .5;



