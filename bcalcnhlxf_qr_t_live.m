
%tree version
%obtain live data

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



stest_o=sportmat_o(1:length(dayno),:);
goalies_o=goaliesavemat(1:length(dayno),: );
goalies_odiff = goalies_o(:,1:2) - goalies_o(:,3:4);
oddstest= sportodds(1:length(dayno),: );
[traindat1, targetdat1] = mktraintarget20_t(stest_o, oddstest, teamno, nn, datelist(1:size(stest_o,1),:));
% traindat1 =[traindat1 ; restvec'; goalies_odiff'];  %multi-dimensional restvec!!

ntargets = size(targetdat1,1);

ivars=1:size(traindat1, 1);
isCategorical=zeros(length(ivars),1);
% isCategorical(end-3:end-2)=1;
isCategorical(1:2)=1;
% traindat1 =[traindat1 ; restvec(1:size(sportodds,1))];

traindat1=traindat1';
targetdat1=targetdat1';
tic;
% fprintf('%d   %d\n', nind, length(fp));
opts_tree=statset('UseParallel',true);


numptsarchive = size(sportmat_o,1)-fp(d1)+1;
numpts = numptsarchive - eoffset;


%***** IMPORTANT ***** bestw1  must be set by prior validation run
%*****  determining optimal betting strategy
%
%         display(dayind);

%%%%%
%%%%%%
% datelinseg=dateseg(end-training_min1 +1:end,:);

if do_wins < 1
    
    b = TreeBagger(numtrees,traindat1(:,ivars1),targetdat1(:,4+do_wins),'Method','R',...
        'OOBPred','On', 'CategoricalPredictors',find(isCategorical(ivars1) == 1), ...
        'MinLeafSize',minls);%3 100 %125
else
    b = TreeBagger(numtrees,traindat1(:,ivars1),targetdat1(:,4+do_wins),'Method','C',...
        'CategoricalPredictors',find(isCategorical(ivars1) == 1), 'OOBPred','On',  ...
        'MinLeafSize',minls);%100 %125
end

% 
% s1 = size(stest_o,1);
% sL1=size(all_sportmat_o,1);
% sdiff2 = sL1 - s1; %# of additional matchups
sdiff2=size(sportmat_test_o,1);
datetest_predict{cind} = datelist_test;

%put all sport odds here just to keep things scalable
oddstest_predict{cind} = sportodds_test;
% oddstest_predictOS{cind} = sportoddsOS_test;
oddstest_predictou{cind} = sportou_test;
% oddstest_predictouOS{cind} = sportouOS_test;
oddstest_predictpl{cind} = sportoddpl_test;
% oddstest_predictplOS{cind} = sportoddplOS_test;
sportmat_test_o_{cind}=sportmat_test_o;
% sportmat_testOS_o_{cind}=sportmat_testOS_o;
sportmat_testpl_o_{cind}=sportmat_testpl_o;
% sportmat_testplOS_o_{cind}=sportmat_testplOS_o;



%

goalies_diff_test = goaliesavemat_test(:,1:2) - goaliesavemat_test(:,3:4);
%add on the records et
% now you're ready to create the training & target data
[traindat11, targetdat11] = mktraintarget20_t(sportmat_test_o,sportodds_test, teamno, nn, datelist_test);
% traindat11 =[traindat11 ; restvec_test'; goalies_diff_test'];
traindat11=traindat11';
targetdat11=targetdat11';

%     traindat11 =[traindat11 ; restvec(1:size(stest_o1,1))];
%%%%
%%%%



archive_data_predict_{cind,1} = futureproject_tree(b, traindat11, targetdat11, sdiff2, ivars1, do_wins); %predict w

%%%%%%%









