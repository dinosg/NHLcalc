yrlist=2014:2019;
do_wins=-1;
gonhlqg;

training_min1 = 100;
cfilter = 0;
if cfilter > 0
    conf_ = {'eastern', 'western'};
else
    conf_ = {'eastern'};
end
cmax=numel(conf_);
multi_reps=1;
w_ =cell(numel(sportmat0_),numel(conf_));
po_=zeros(numel(sportmat0_),numel(conf_));
p_=po_;
zn_=w_;
wv_=w_;
np_ = w_;
sos_=w_;
ad_=w_;
sportmat_=cell(numel(sportmat0_),numel(conf_));
sportmat_o_ = sportmat_;

sportodds_=sportmat_;
datelist_ = sportodds_;
teamsu_ = datelist_;
teamno_= datelist_;
num_newdataelements_=teamno_;
goaliesavemat_=sportmat_;
oddstest_predict=cell(numel(conf_),1);
archive_data_predict_=cell(numel(conf_),1);
datelist_test_ = cell(numel(conf_),1);
consensusodds_test_ = cell(numel(conf_),1);
sportodds_test_=cell(numel(conf_),1);
% sportoddsOS_test_=cell(numel(conf_),1);
sportou_test_=cell(numel(conf_),1);
% sportouOS_test_=cell(numel(conf_),1);
sportoddpl_test_=cell(numel(conf_),1);
% sportoddplOS_test_=cell(numel(conf_),1);

consensusodds_test_ = cell(numel(conf_),1);
sportmat_test_o_=cell(numel(conf_),1);
% sportmat_testOS_o_=cell(numel(conf_),1);
sportmat_test_o_=cell(numel(conf_),1);
% sportmat_testplOS_o_=cell(numel(conf_),1);
for nind=1:numel(sportmat0_)
    

    sportmat0 = sportmat0_{nind};
    teamsu0=teamsu0_{nind};
    datelist0 = datelist0_{nind};
    num_newdataelements_{nind,1}=num_newdataelements0_{nind};
    num_newdataelements = num_newdataelements0_{nind};
    teamno0 = teamno0_{nind};
    restvec0 = restvec0_{nind};
    goaliesavemat0=goaliesavemat0_{nind};
    sportmat_o0 = teamfilter_fn4(sportmat0, teamno0, num_newdataelements, size(sportmat0,1), training_min1);
    sportmat_o0_{nind,1} = sportmat_o0;
%    
end





