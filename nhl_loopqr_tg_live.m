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
    sportmat_o0_{yrind,1} = sportmat_o0;
%     actual_teamfilter;
%     if nind == numel(sportmat0_)
%         fillteststats; %add in scraped data on TEST matchups.... and fill in stats from MOST RECENT KNOWN
%         %but only do it FOR LATEST YEAR.... creates new set of variables
%         %all_sportmat_o0
%         %all_sportodds0
%         %all_datelist0
%         %all_restvec0
%     end
%     
%     for cind=1:numel(conf_)
%         conference = char(conf_(cind));
%         
%         if cfilter >0
%             [sportmat_o, teamno, sportodds, datelist, restvec, goaliesavemat]  = conference_filter_nhlr(sportmat_o0, sportodds0, ...
%                 datelist0, conference, teamno0, restvec0, goaliesavemat0);
%             %             actual_conffilter;  %check to see if this is the most recent yr, if so get ACTUAL stat averages
%             
%             %THIS IS OPTIONAL SINCE sportmat_o_actual0 WAS ALREADY USED
%             if nind >= numel(sportmat0_)
%                 sportmat_o_actual = actual_conffilter_fn(nind, sportmatc, sportmat_o_actual0,  sportodds0, ...
%                     datelist0, conference, teamno0);
%             end
%         else
%             if nind >= numel(sportmat0_)    %% THIS IS OPTIONAL
%                 sportmat_o_actual = sportmat_o_actual0;
%             end
%             sportmat_o=sportmat_o0;
%             sportodds_{nind,cind}=sportodds;
%             datelist=datelist0;
%             teamno=teamno0;
%             goaliesavemat=goaliesavemat0;
%             restvec=restvec0;
%         end
%         sportodds_{nind,cind}=sportodds;
%         sportmat_o_{nind,cind}=sportmat_o;
%         datelist_{nind,cind}=datelist;
%         teamno_{nind,cind}=teamno;
%         goaliesavemat_{nind,cind}=goaliesavemat;
%         
%         if nind >= numel(sportmat0_)
%             if cfilter == 1
%                 
%                 [sportmat_test_o, teamno, sportodds_test, datelist_test, restvec_test,...
%                     goaliesavemat_test, gamenotes]  = conference_filter_nhlr(sportmat_test_o0, sportodds_live0, ...
%                     gdatelistlive0, conference, teamno0, restvec_test0, goaliesavemat_test0, gamenotes0);
%                 %do offshore odds here
%                 [sportmat_testOS_o, ~, sportoddsOS_test]  = conference_filter_nhlr(sportmat_test_o0, sportoddsOS_live0, ...
%                     gdatelistlive0, conference, teamno0, restvec_test0, goaliesavemat_test0, gamenotes0);
%                 
%                 %now do all the other odds so we don't have to mess w/
%                 %changing code in all the different versions
%                 [~, ~, sportou_test]  = conference_filter_nhlr(sportmat_test_o0, sportou_live0, ...
%                     gdatelistlive0, conference, teamno0, restvec_test0, goaliesavemat_test0, gamenotes0);
%                 
%                 [~, ~, sportouOS_test]  = conference_filter_nhlr(sportmat_test_o0, sportouOS_live0, ...
%                     gdatelistlive0, conference, teamno0, restvec_test0, goaliesavemat_test0, gamenotes0);
%                 
%                 [sportmat_testpl_o, ~, sportoddpl_test]  = conference_filter_nhlr(sportmat_test_o0, sportoddpl_live0, ...
%                     gdatelistlive0, conference, teamno0, restvec_test0, goaliesavemat_test0, gamenotes0);
%                 
%                 [sportmat_testplOS_o, ~, sportoddplOS_test]  = conference_filter_nhlr(sportmat_test_o0, sportoddplOS_live0, ...
%                     gdatelistlive0, conference, teamno0, restvec_test0, goaliesavemat_test0, gamenotes0);
%                 
%             else
%                 
%                 sportmat_test_o=sportmat_test_o0;
%                 teamno=teamno0;
%                 sportodds_test=sportodds_live0;
%                 sportoddsOS_test=sportodds_OS_live0;
%                 %
%                 %extra odds here
%                 sportou_test=sportou_live0;
%                 sportouOS_test=sportouOS_live0;
%                 sportoddpl_test=sportoddpl_live0;
%                 sportoddplOS_test=sportoddplOS_live0;
%                 
%                 datelist_test= gdatelistlive0;
%                 gamenotes=gamenotes0;
%                 restvec_test=restvec_test0;
%                 goaliesavemat_test = goaliesavemat_test0;
%             end
%             
%         end
%         %        stop
%         bcalcnhlxf_qr_tg;  %parfor loop in here
%         
%         sos_{nind,cind}=sportoddsshort;
%         p_(nind,cind)=p;
%         
%         wv_{nind,cind}=winvec2;
%         np_{nind,cind}=numpts;
%         ad_{nind,cind}=archive_data;
%         
%         if (nind >= numel(sportmat0_) ) & ~isempty(sportmat_test_o)
%             bcalcnhlxf_qr_tg_live; %execute script for calculating predictions on LIVE data
%             %archive live odds
%             
%             sportodds_test_{cind,1}=sportodds_test;
%             sportoddsOS_test_{cind,1}=sportoddsOS_test;
%             sportou_test_{cind,1}=sportou_test;
%             sportouOS_test_{cind,1}=sportouOS_test;
%             sportoddpl_test_{cind,1}=sportoddpl_test;
%             sportoddplOS_test_{cind,1}=sportoddplOS_test;
%             datelist_test_{cind,1}=datelist_test;
%             %%%
%             theodds=sportodds_test;  %% set this to ON-SHORE odds for specific bet,
%             %%     = sportou_test_;  %for over/under bets
%             %%     = sportoddpl_test_; %for puckline bets
%             consensusodds_no=2;
%             %%%
%             consensusodds_test = theodds(:,1+(consensusodds_no-1)*book_periodicity:consensusodds_no*book_periodicity);
%             consensusodds_test_{cind,1}=consensusodds_test;
%             sportmat_test_o_{cind,1}=sportmat_test_o;
%             %produces archive_data_predict and oddstest_predict (cell
%             %matrix w/ predicted strengths and live odds)s
%         end
%     end
end





