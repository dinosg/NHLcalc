%fill in X data from known matchups and historical stats for games to be
%predicted
%but first, filter test data for conferences AFTER doing this.create same
%etiquette of matrixzzz0  ---> matrixzzz by conference filtering AFTER
%doing this

sportmat_test_o0=zeros(size(sportmat_oddsonly_live0,1), size(sportmat_o0,2));
sportmat_test_o0(:,1:teamno0)=sportmat_oddsonly_live0;
nn=num_newdataelements;  %teamno0 is already set
goaliesavemat_test0=zeros(size(sportmat_oddsonly_live0,1),8);
teamno=size(sportmat_oddsonly_live0,2);
readin_rotogoalies;    %get the scheduled goalie info in
for jind=1:size(sportmat_oddsonly_live0,1)
    tm1=find(sportmat_oddsonly_live0(jind,1:teamno)==1);% road team
    tm2=find(sportmat_oddsonly_live0(jind,1:teamno)==-1); %home team
    
    lastind1=find(sportmat_o_actual0(:,tm1) ~= 0, 1, 'last');% LAST game played by road team
    lastind2=find(sportmat_o_actual0(:,tm2) ~= 0, 1, 'last');% LAST game played by hone team
    
    %offset for team W/L averages
    avginddiff1 = 3*(sportmat_o_actual0(lastind1,tm1) == -1); %offset of 3 if was home
    avginddiff2 = 3*(sportmat_o_actual0(lastind2,tm2) == -1);
    
    
    %offset for team box score stats
    statinddiff1 = nn*(sportmat_o_actual0(lastind1,tm1) == -1); %offset of nn if was home
    statinddiff2 = nn*(sportmat_o_actual0(lastind2,tm2) == -1); %offset of nn if was home
    
    %offset for goaliesavemat
    goaliesavematoffset1 = 2*(sportmat_o_actual0(lastind1,tm1) == -1); %offset of 2 if was home
    goaliesavematoffset2 = 2*(sportmat_o_actual0(lastind2,tm2) == -1);
    
    
    %fill test data w/ actual prior avg data
    sportmat_test_o0(jind,5+teamno0 + 2*nn +1) = sportmat_o_actual0(lastind1,5+teamno0 + 2*nn +1+avginddiff1);
    sportmat_test_o0(jind,5+teamno0 + 2*nn +4) = sportmat_o_actual0(lastind2,5+teamno0 + 2*nn +1+avginddiff2);
    %fill test data w/ actual prior stat data
    sportmat_test_o0(jind,teamno0 + 5 +6+2*nn+1: teamno0 + 5 +6+3*nn) = ...
        sportmat_o_actual0(lastind1,teamno0 + 5 +6+2*nn+1+statinddiff1: teamno0 + 5 +6+3*nn+statinddiff1);
    sportmat_test_o0(jind,teamno0 + 5 +6+3*nn+1: teamno0 + 5 +6+4*nn) = ...
        sportmat_o_actual0(lastind2,teamno0 + 5 +6+2*nn+1+statinddiff2: teamno0 + 5 +6+3*nn+statinddiff2);
    
    %fill goalie save mat w/ new info
    goaliesavemat_test0(jind,1:2) = goaliesavemat0(lastind1,5+goaliesavematoffset1:6+goaliesavematoffset1); %copy the ACTUAL data into test
    goaliesavemat_test0(jind,3:4) = goaliesavemat0(lastind2,5+goaliesavematoffset2:6+goaliesavematoffset2);
    %note that goaliesavemat_test(5:8) are all unset (zeros) b/c there's no
    %info about how goalies did after test games
    %
    
    
    goalienameparse_roto;       %extract goalie names and statuses USING ROTO GRINDERS GOALIE STAT SCRAPING
    %             goalienameparse;       %extract goalie names and statuses
    %update goalie stats with ACTUAL info about best record on goalie
    %who is PROBABLE for game tonite
    if ~isempty(goalieteststats1)  %road goalie stats
        if goalieteststats1(1) == 0 | goalieteststats1(1) == 1   %screen out garbage data
            goalieteststats1(1) = NaN;
        end
        if goalieteststats1(2) == 0 | goalieteststats1(2) == 1
            goalieteststats1(2) = NaN;
        end
        
        goaliesavemat_test0(jind,1:2) = goalieteststats1;
        
    else
        goaliesavemat_test0(jind,1:2) = [NaN  NaN];
    end
    if ~isempty(goalieteststats2) %home goalie stats
        
        if goalieteststats2(1) == 0 | goalieteststats2(1) == 1   %screen out garbage data
            goalieteststats2(1) = NaN;
        end
        if goalieteststats2(2) == 0 | goalieteststats2(2) == 1
            goalieteststats2(2) = NaN;
        end
        
        goaliesavemat_test0(jind,3:4) = goalieteststats2;
    else
        goaliesavemat_test0(jind,3:4) = [NaN NaN];
    end
    
    
    %stuff sportmat_test here with last historical results. ind1 & ind2
    %show where to find it. depending on whether they played home or away
    %it's different.
    
    %figure out restvec too (ugh)
    
    %find where stuff is from here:
    % avgdiff=  stest_o(:,(5+teamno0 + 2*nn +1 )) - stest_o(:,(5+teamno0 + 2*nn +4) );
    % statdiff = stest_o(:, teamno0 + 5 +6+2*nn+1: teamno0 + 5 +6+3*nn) - stest_o(:, teamno0 + 5 +6 +3*nn+1:teamno0 + 5 +6+4*nn);
    %
    
end
gdatelistlive0 = datevec(datelist_live0);
gdatelistlive0=gdatelistlive0(:,1:3);
gdatelistlive0=circshift(gdatelistlive0,[0 -1]);


all_sportmat_o0=vertcat(sportmat_o0, sportmat_test_o0);
all_goaliesavemat0 = vertcat(goaliesavemat0, goaliesavemat_test0);  %ALL the goalie save mat info
all_datelist0=vertcat(datelist0, gdatelistlive0);
all_restvec0 = findrestvec(all_sportmat_o0, all_datelist0, teamno0);
restvec_test0=all_restvec0(end-size(sportmat_oddsonly_live0,1)+1:end,:);
% all_sportodds0=vertcat(sportodds0, sportodds_live0);
% all_sportoddOS0=vertcat(sportodds0, sportoddsOS_live0);  %get the offshore odds in somewhere
%only conference filter after ALL the data has been constructed,as to get
%valid restvec, etc.
% all_sportoddsou0=vertcat(sportoddsou0, sportodds_liveou0);
% all_sportoddouOS0=vertcat(sportoddsou0, sportoddsouOS_live0);  %get the offshore odds in somewhere
% all_sportoddspl0=vertcat(sportoddspl0, sportoddspl_live0);
% all_sportoddplOS0=vertcat(sportoddspl0, sportoddsplOS_live0);  %get the offshore odds in somewhere
%


