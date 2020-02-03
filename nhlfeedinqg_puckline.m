function [sportmatc, sportoddsc, datelistc, teamsuc, teamnoc, num_newdataelementsc, restvecc, sportouc, sportplc, ...
    goaliesavematc, goaliefinalsavepcstats, goalienames, goalieLnames] = nhlfeedinqg_puckline(yrlist, lastdate, winexp)
%read in NHL data from latest box score scraper including advanced features
% function [sportmatc, sportoddsc, datelistc, teamsuc, teamnoc, num_newdataelementsc, restvecc, sportouc, sportplc] = nhlfeedinq()
%read in NHL data from latest box score scraper including advanced features

%includes selected goalie stats (save %, shoot-out save %)
if ~exist('lastdate')  %allow all dates to be looked at
    lastdate = datenum(date) +1;
end
if ~exist('winexp')
    winexp=0;
end

load teamnames_nhl2
so_goalequivalent =0.5; %for shootouts, in puckline winner is +1.5 guy no matter what; %0.01;
base_oddspath='nhl_odds/nhl odds ';
yrs = yrlist;  %available data for these years only
% yrs(yrs == 2012) = []; %get rid of lockout season
yrno=numel(yrs);
sportmatc=cell(yrno,1);
sportoddsc = sportmatc;
goaliesavematc = sportmatc;
sportouc=sportoddsc;  %overunderodds
sportplc=sportoddsc;   %puckline
datelistc=sportmatc;
teamsuc = sportmatc;
teamnoc = sportmatc;
restvecc=sportmatc;
num_newdataelementsc = sportmatc;
%       columns for ODDS data
o_datecol = 1;
o_teamcol = 4; % team name (NOT abbreviation)

o_mlocol = 9; %ML open,     "
o_mlccol = 10; %ML close,    "
o_scorecol=8;

o_ouopencol1=11; %overunder open - score value (usually 5.5 or 5)
o_ouopencol2=12; %overunder open - ML value
o_ouclosecol1=13; %overunder close - score value (usually 5.5 or 5)
o_ouclosecol2=14; %overunder close - ML value

o_plcol=11;  %puckline col... for 2014-15 and after only
%
%   columns for upwork data scraping file
%

spmd(12)
    switch labindex
        case 1
            
            %             [as1, ~, s1]=xlsread('s1.xlsx');
            ts1=readtable('s1.csv','Delimiter', ',');
            %             ts1=cell2table(s1(2:end,:),'VariableNames',s1(1,:));
            gd1=ts1.gameDate;
            [~,gd1]=fixthetimestring(gd1);
            ts1.gameDate=gd1;
            ts1=sortrows(ts1,'gameDate');
            
        case 2
            %             [as2, ~, s2]=xlsread('s2.xlsx');
            ts2=readtable('s2.csv','Delimiter', ',');
            %             ts2=cell2table(s2(2:end,:),'VariableNames',s2(1,:));
            gd2=ts2.gameDate;
            [~,gd2]=fixthetimestring(gd2);
            ts2.gameDate=gd2;
            
            ts2=sortrows(ts2,'gameDate');
            
            
        case 3
            %             [as5, ~, s5]=xlsread('s5.xlsx');
            ts5=readtable('s5.csv','Delimiter', ',');
            %             ts5=cell2table(s5(2:end,:),'VariableNames',s5(1,:));
            gd5=ts5.gameDate;
            [~,gd5]=fixthetimestring(gd5);
            ts5.gameDate=gd5;
            ts5=sortrows(ts5,'gameDate');
            
        case 4
            
            %             [as6, ~, s6]=xlsread('s6.xlsx');
            ts6=readtable('s6.csv','Delimiter', ',');
            %             ts6=cell2table(s6(2:end,:),'VariableNames',s6(1,:));
            gd6=ts6.gameDate;
            gd6=ts6.gameDate;
            [~,gd6]=fixthetimestring(gd6);
            ts6.gameDate=gd6;
            ts6=sortrows(ts6,'gameDate');
            
        case 5
            
            %             [as7, ~, s7]=xlsread('s7.xlsx');
            ts7=readtable('s7.csv','Delimiter', ',');
            %             ts7=cell2table(s7(2:end,:),'VariableNames',s7(1,:));
            gd7=ts7.gameDate;
            [~,gd7]=fixthetimestring(gd7);
            ts7.gameDate=gd7;
            ts7=sortrows(ts7,'gameDate');
            
        case 6
            
            %             [as8, ~, s8]=xlsread('s8.xlsx');
            ts8=readtable('s8.csv','Delimiter', ',');
            %             ts8=cell2table(s8(2:end,:),'VariableNames',s8(1,:));
            gd8=ts8.gameDate;
            [~,gd8]=fixthetimestring(gd8);
            ts8.gameDate=gd8;
            ts8=sortrows(ts8,'gameDate');
            
        case 7
            %             [as9, ~, s9]=xlsread('s9.xlsx');
            ts9=readtable('s9.csv','Delimiter', ',');
            %             ts9=cell2table(s9(2:end,:),'VariableNames',s9(1,:));
            gd9=ts9.gameDate;
            [~,gd9]=fixthetimestring(gd9);
            ts9.gameDate=gd9;
            ts9=sortrows(ts9,'gameDate');
            
            
        case 8
            %             [as10, ~, s10]=xlsread('s10.xlsx');
            ts10=readtable('s10.csv','Delimiter', ',');
            %             ts10=cell2table(s10(2:end,:),'VariableNames',s10(1,:));
            gd=ts10.gameDate;
            [gd10, gt10]=split(gd,'T');
            gdates=datenum(gd10(:,1));
            ts10.gameDate=gdates;
            ts10=sortrows(ts10,'gameDate');
            
        case 9
            %             [as11, ~, s11]=xlsread('s11.xlsx');
            ts11=readtable('s11.csv','Delimiter', ',');
            %             ts11=cell2table(s11(2:end,:),'VariableNames',s11(1,:));
            gd11=ts11.gameDate;
            [~,gd11]=fixthetimestring(gd11);
            ts11.gameDate=gd11;
            ts11=sortrows(ts11,'gameDate');
            
        case 10
            %             [as12, ~, s12]=xlsread('s12.xlsx');
            ts12=readtable('s12.csv','Delimiter', ',');
            %             ts12=cell2table(s12(2:end,:),'VariableNames',s12(1,:));
            gd12=ts12.gameDate;
            [~,gd12]=fixthetimestring(gd12);
            ts12.gameDate=gd12;
            ts12=sortrows(ts12,'gameDate');
            
        case 11
            
            %             [as13, ~, s13]=xlsread('s13.xlsx');
            ts13=readtable('s13.csv','Delimiter', ',');
            %             ts13=cell2table(s13(2:end,:),'VariableNames',s13(1,:));
            goaliedates13=ts13.gameDate;
            [~,goaliedates13]=fixthetimestring(goaliedates13);
            ts13.gameDate=goaliedates13;
            ts13=sortrows(ts13,'gameDate');
            
            
        case 12
            
            %             [as14, ~, s14]=xlsread('s14.xlsx');
            ts14=readtable('s14.csv','Delimiter', ',');
            %             ts14=cell2table(s14(2:end,:),'VariableNames',s14(1,:));
            gd14=ts14.gameDate;
            [~,goaliedates]=fixthetimestring(gd14);
            ts14.gameDate=goaliedates;
            ts14=sortrows(ts14,'gameDate');
            
    end
end
%convert composites to regular tables... note you skipped ts3&4
ts1=ts1{1};
ts2=ts2{2};
ts5=ts5{3};
ts6=ts6{4};
ts7=ts7{5};
ts8=ts8{6};
ts9=ts9{7};
ts10=ts10{8};
ts11=ts11{9};
ts12=ts12{10};
ts13=ts13{11};
ts14=ts14{12};

%add fields for YTD goalie data
jz=zeros(length(ts14.gameId),1);
ts14.ytdshots = jz;
ts14.ytdsaves = jz;
ts14.ytdsavepc = jz;
ts14.ytdsoshots=jz;
ts14.ytdsosaves=jz;
ts14.ytdsosavepc=jz; %accumulate shootout stats here too
jz=zeros(length(ts13.gameId),1);
ts13.ytdsoshots = jz;
ts13.ytdsosaves = jz;
ts13.ytdsosavepc = jz;

bxteamsu = teamnames_nhl1(:,3);


ytdgoaliestats_compile;  %have to do this out of parfor loop

for yri=1:length(yrs)
    
    if yrs(yri) > 2008
        numvars = (33-8 + 1);
    else
        numvars = 18 - 8 + 1;
    end
    
    
    oddscoloffset=yrs(yri)> 2013;
    namelong=[base_oddspath, num2str(yrs(yri)), '-',  num2str(yrs(yri)+1-2000),'.xlsx'];
    if exist(namelong, 'file') >0
        [t1,u1,v1]=xlsread(namelong); %odds datafile ( by year)
    else
        namelong=strrep(namelong,'-20','-');
        [t1,u1,v1]=xlsread(namelong); %odds datafile ( by year)
    end
    
    v1=v1(2:end,:);
    
    L1 = datenum(yrs(yri), 8,31); %date bounds on the season starting in yr(yrs)
    L2 = datenum(yrs(yri)+1,7,1);
    
    %%%%%  regular box score & odds stats done here:
    odate1 = t1(:,o_datecol);
    odate1dys = odate1 - floor(odate1/100)*100;  %get # of days in day
    odate1mo = floor(odate1/100); % the months
    yr_actual = (odate1mo < 7) + yrs(yri); %the actual years
    odate = datenum(yr_actual,odate1mo, odate1dys);
    bgoodind = find((ts5.gameDate > L1) & (ts5.gameDate < L2) & (ts5.gameDate < lastdate));  %box score index!!!!  index of stuff in box scores in the year you're looking @
    
    bxdate=ts5.gameDate(bgoodind);
    bxteams = ts5.teamAbbrev(bgoodind);
    bxhteams = ts5.opponentTeamAbbrev(bgoodind);
    oteams = strtrim(v1(:,o_teamcol));
    oddsgoals=t1(:,o_scorecol);  %goals from odds data
    
    st = size(bxteams,1);
%     teamno = numel(unique(bxteams));
teamno=31; %set as maximum including Las Vegas
    sportmat = zeros(st,2+5+2*numvars);
    sportodds = zeros(st,4);
    sportou=sportodds;
    sportpl=sportodds;
    datelist = zeros(st,3);
    
    
    goaliesavemat=zeros(st,4);
    
    
    for jind = 1:st
        jind5 = jind + bgoodind(1)- 1;
        thegameId = ts5.gameId(jind5);
        %    jind00 = jind+bgoodind(1)-1;
        jind00  = find(ts11.gameId == thegameId);
        
        vt = find(strcmp(bxteams(jind), bxteamsu));
        ht = find( strcmp(bxhteams(jind), bxteamsu));
        
        gindexv=find((ts14.gameId == thegameId) &  (strcmp(ts14.teamAbbrev, ts11.teamAbbrev(jind00)))); %index of visiting goalies that match gameId
        gindexh=find((ts14.gameId == thegameId) &  (strcmp(ts14.teamAbbrev , ts11.opponentTeamAbbrev(jind00))));
        %now get info for starting goalie...
        gindexvs = find((ts14.gameId == thegameId )&  (strcmp(ts14.teamAbbrev, ts11.teamAbbrev(jind00)) )& (ts14.gamesStarted == 1));
        gindexhs = find((ts14.gameId == thegameId )&  (strcmp(ts14.teamAbbrev, ts11.opponentTeamAbbrev(jind00)) )& (ts14.gamesStarted == 1));
        
        timeonice = max(sum(ts14.timeOnIce(gindexv)), sum(ts14.timeOnIce(gindexh)))/3600; %ratio of actual time on ice to regulation 60 min
        timeonice1=1; %just set = 1 for total data stats... but not for puckline or other sets
        sportmat(jind,1) = teamnames_nhl1{vt,5};
        sportmat(jind,2)=teamnames_nhl1{ht,5};
        
        %scores & score diff, etc.... the basic 5 components
        sportmat(jind,3)= ts11.goalsFor(jind00) +so_goalequivalent*ts11.shootoutGamesWon(jind00);
        sportmat(jind,4)= ts11.goalsAgainst(jind00) + so_goalequivalent*ts11.shootoutGamesLost(jind00);
        % %         winningscore=max(sportmat(jind,3), sportmat(jind,4));
        %         losingscore = min(sportmat(jind,3), sportmat(jind,4));
        %         scoremultiplier=winningscore/max(losingscore, .5);
        
        sportmat(jind,5) = ((sportmat(jind,3) - sportmat(jind,4))/(sportmat(jind,3)+sportmat(jind,4)));
        sportmat(jind,6) = (sportmat(jind,3)- sportmat(jind,4));
        %fancy stuff here to capture impact of shootout game wins/ losses
        %         sportmat(jind,7) = sign(vgf - vga) + 0.6*sign(vsowon - vsolost);
        sportmat(jind,7) = sign(sportmat(jind,3)- sportmat(jind,4));
        %         %         sportmat(jind,5)=sportmat(jind,7)*scoremultiplier;
        %   sportmat(jind,5) = scoremultiplier.^winexp * sportmat(jind,7);
        %   sportmat(jind,6) = sign((sportmat(jind,3) - sportmat(jind,4)))*exp(abs((sportmat(jind,3) - sportmat(jind,4))/(sportmat(jind,3)+sportmat(jind,4))).^winexp);
        %         sportmat(jind,7)=sign(sportmat(jind,5));
        
        
        sportmat(jind,8) = ts11.shotsFor(jind00)/timeonice1; %effective shots for
        sportmat(jind,9) = ts11.shotsAgainst(jind00)/timeonice1; %effective shots against
        sportmat(jind,10) = ts11.shNumTimes(jind00)/timeonice1; %times short
        sportmat(jind,11) = ts11.ppPctg(jind00); %power play %
        sportmat(jind,12) = ts11.penaltyKillPctg(jind00); %penalty kill %
        sportmat(jind,13) = ts11.faceoffWinPctg(jind00); %faceoff %
        
        
        
        jind1=find(ts1.gameId == thegameId);  %tie the tables together....
        sportmat(jind,14) = ts1.enGoalsFor(jind1); %empty net goals for;
        sportmat(jind,15) = ts1.evGoalsFor(jind1); %even strength goals for;
        sportmat(jind,16) = ts1.penaltyShotGoals(jind1); %penalty shot goals
        
        %         sportmat(jind,17) = ts14.ytdsavepc(gindexvs); %ytd save pc for STARTING visitor goalie
        %         sportmat(jind,18) = ts14.ytdsosavepc(gindexvs);%ytd SO save pc for STARTING visitor goalie
        goaliesavemat(jind,1)=ts14.ytdsavepc(gindexvs);   %road goalie YTD save pc.... these are YTD AVERAGES
        goaliesavemat(jind,2)=ts14.ytdsosavepc(gindexvs);  %road goalie YTD SO save pc
        
        goaliesavemat(jind,5)=ts14.ytdsavepc_actual(gindexvs);   %road goalie YTD save pc.... these are YTD AVERAGES INCLUDING current game
        goaliesavemat(jind,6)=ts14.ytdsosavepc_actual(gindexvs);  %road goalie YTD SO save pc
        
        
        sportmat(jind,17) = sportmat(jind,3); %goals for
        sportmat(jind,18) = sportmat(jind,4); %goals against
        
        
        
        if yrs(yri) > 2008
            
            jind9=find(ts9.gameId == thegameId);  %tie the tables together...
            sportmat(jind,19) = ts9.giveaways(jind9)/timeonice1; %
            sportmat(jind,20) = ts9.takeaways(jind9)/timeonice1; %
            sportmat(jind,21) = ts9.hits(jind9)/timeonice1; %
            
            jind5=find(ts5.gameId == thegameId);  %tie the tables together...
            
            sportmat(jind,22) = ts5.shotAttemptsPctgClose(jind5); %
            sportmat(jind,23) = ts5.unblockedShotAttemptsPctgClose(jind5); %
            sportmat(jind,24) = ts5.offensiveZoneFaceoffs(jind5)/timeonice1; %
            sportmat(jind,25) = ts5.defensiveZoneFaceoffs(jind5)/timeonice1; %
            sportmat(jind,26) = ts5.unblockedShotAttemptsPctgTied(jind5); %
            sportmat(jind,27) = ts5.shotAttemptsPctgTied(jind5); %
            
            sportmat(jind,28) = ts5.fiveOnFiveSavePctg(jind5); %
            sportmat(jind,29) = ts5.fiveOnFiveShootingPctg(jind5); %
            
            sportmat(jind,30) = ts5.zoneStartPctg(jind5); %
            
            jind7=find(ts7.gameId == thegameId);  %tie the tables together...
            sportmat(jind,31) = ts7.shotsDeflected(jind7)/ts11.shotsFor(jind00); %
            sportmat(jind,32) = ts7.shotsSlap(jind7)/ts11.shotsFor(jind00); %
            sportmat(jind,33) = ts7.shotsTipped(jind7)/ts11.shotsFor(jind00); %
            
            
        end
        
        
        
        jind0 = find(ts12.gameId == thegameId);
        
        sportmat(jind,8+numvars) = ts12.shotsFor(jind0)/timeonice1; %shots for
        sportmat(jind,9+numvars) = ts12.shotsAgainst(jind0)/timeonice1; %shots against
        sportmat(jind,10+numvars) = ts12.shNumTimes(jind0)/timeonice1; %times short
        sportmat(jind,11+numvars) = ts12.ppPctg(jind0); %power play %
        sportmat(jind,12+numvars) = ts12.penaltyKillPctg(jind0); %penalty kill %
        sportmat(jind,13+numvars) = ts12.faceoffWinPctg(jind0); %faceoff %
        
        
        
        jind2=find(ts2.gameId == thegameId);  %tie the tables together....
        sportmat(jind,14+numvars) = ts2.enGoalsFor(jind2); %empty net goals for;
        sportmat(jind,15+numvars) = ts2.evGoalsFor(jind2); %even strength goals for;
        sportmat(jind,16+numvars) = ts2.penaltyShotGoals(jind2); %penalty shot goals
        
        %         sportmat(jind,17+numvars) = ts14.ytdsavepc(gindexhs); %ytd save pc for STARTING home goalie
        %         sportmat(jind,18+numvars) = ts14.ytdsosavepc(gindexhs);%ytd SO save pc for STARTING home goalie
        goaliesavemat(jind,3)=ts14.ytdsavepc(gindexhs);   %home goalie YTD save pc.... these are YTD AVERAGES NINC current game
        goaliesavemat(jind,4)=ts14.ytdsosavepc(gindexhs);  %home goalie YTD SO save pc
        
        goaliesavemat(jind,7)=ts14.ytdsavepc_actual(gindexhs);   %home goalie YTD save pc.... these are YTD AVERAGES
        goaliesavemat(jind,8)=ts14.ytdsosavepc_actual(gindexhs);  %home goalie YTD SO save pc
        
        
        sportmat(jind,17+numvars) = sportmat(jind,4); %goals for
        sportmat(jind,18+numvars) = sportmat(jind,3); %goals against
        
        if yrs(yri) > 2008
            
            jind10=find(ts10.gameId == thegameId);  %tie the tables together...
            sportmat(jind,19+numvars) = ts10.giveaways(jind10)/timeonice1; %
            sportmat(jind,20+numvars) = ts10.takeaways(jind10)/timeonice1; %
            sportmat(jind,21+numvars) = ts10.hits(jind10)/timeonice1; %
            
            
            jind6=find(ts6.gameId == thegameId);  %tie the tables together...
            
            
            sportmat(jind,22+numvars) = ts6.shotAttemptsPctgClose(jind6); %
            sportmat(jind,23+numvars) = ts6.unblockedShotAttemptsPctgClose(jind6); %
            sportmat(jind,24+numvars) = ts6.offensiveZoneFaceoffs(jind6)/timeonice1; %
            sportmat(jind,25+numvars) = ts6.defensiveZoneFaceoffs(jind6)/timeonice1; %
            sportmat(jind,26+numvars) = ts6.unblockedShotAttemptsPctgTied(jind6); %
            sportmat(jind,27+numvars) = ts6.shotAttemptsPctgTied(jind6); %
            sportmat(jind,28+numvars) = ts6.fiveOnFiveSavePctg(jind6); %
            sportmat(jind,29+numvars) = ts6.fiveOnFiveShootingPctg(jind6); %
            
            sportmat(jind,30+numvars) = ts6.zoneStartPctg(jind6); %
            
            jind8=find(ts8.gameId == thegameId);  %tie the tables together...
            sportmat(jind,13+numvars) = ts8.shotsDeflected(jind8)/ts12.shotsFor(jind0); %
            sportmat(jind,32+numvars) = ts8.shotsSlap(jind8)/ts12.shotsFor(jind0); %
            sportmat(jind,33+numvars) = ts8.shotsTipped(jind8)/ts12.shotsFor(jind0); %
        end
        
        nhlodds_tiein;   %set up NHL odds
        
    end
        num_newdataelementsc{yri,1} = numvars;
        sportmatc(yri,1)={sportmatformatconvert(sportmat,num_newdataelementsc{yri,1},  teamno)};
        rv=findrestvec(sportmatc{yri,1},bxdate, teamno);
        restvecc(yri,1)={rv};
        sportoddsc(yri,1)={sportodds};
        sportouc(yri,1)={sportou};
        if oddscoloffset
            sportplc(yri,1)={sportpl};
        end
        datelistc(yri,1)={datelist};
        teamsuc(yri,1)={bxteamsu};
        teamnoc(yri,1) = {teamno};
        goaliesavematc(yri,1)={goaliesavemat};
        
    end
    
end
