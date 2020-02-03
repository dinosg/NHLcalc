% load iv4goaliestrueandteams %this version counts team #'s
% load ivnov2519_goalies;   %goalies & restvec
% load ivnov2519_nogoalies;  %no goalies or restvec
 %var list for PUCKLINE
% load ('old_nhldata/nhl_iv_dec5_19_pl','iv4');
load('old_nhldata/ivdec10_goalies','iv4')
%%% settings for ML:
ivthresh=0.02; %.012
numtrees=375;
minls=100;
do_wins=-1;
%settings for PUCKLINE:
numtrees=375;
minls=100;
% ivthresh=.02;
% load iv4_short
% load iv_nhl_tginclgoalsjan16  %counts GOALS as a varaible
% load('nhl_iv_manyfactors3.mat')
% ivthresh=0.015; %.012
ivars1=find(iv4 > ivthresh);
cfilter=0;
% load('nhl_iv_manyfactors3.mat')
additional_training=100;
ivars1=find(iv4 > ivthresh); %.034
multi_reps=5;
num_additionalyrs=2;  %add in 2 PRIOR years' data. legit values are 0 (no extra yrs) 1 and 2.
open_close=0; %0 = open, 1 = close total odds
% archive_data_predictmulti_=cell(multi_reps, cfilter+1);
admulti_=cell(multi_reps,size(sportmat0_,1)-num_additionalyrs,cfilter+1);
% archive_data_predict_ = cell(cfilter+1,1);
date_string=lower([datestr(now,'mmmdd')]);
new_date_string=input(['use ', date_string, ' or enter new date: '],'s');
% new_date_string=[];

if cfilter > 0
    conf_ = {'eastern', 'western'};
else
    conf_ = {'eastern'};
end
if ~isempty(new_date_string)   %a date other than today's date is entered. setup date_limit so no training is done for that date (or after)
    molist=[{'jan'},{'feb'},{'mar'},{'apr'},{'may'},{'jun'},{'jul'},{'aug'},{'sep'},{'oct'},{'nov'},{'dec'}];
    date_string=['_', lower(new_date_string)];
    curryr = datevec(now);
    curryr = curryr(1); %obtain year
    mostring=new_date_string(1:3);
    dystring = new_date_string(4:5);
    monum = find(strcmp(molist, mostring));
    dynum = str2num(dystring);
    date_limit=datenum(curryr, monum, dynum);
    
else   %input of custom date string earlier than today
    date_string=['_' , date_string];
    
    date_limit = 999999;
end
fprintf('date_string = %s\n', date_string);
% additional_training = 100; %add-on to prior years training

%


for yrind=size(sportmat0_,1):-1:1+num_additionalyrs
% for yrind=1+num_additionalyrs:size(sportmat0_,1)
    yr1=datelist0_{yrind,1}(1,3);
    fprintf('year: %d \n', yr1);
    dearchive_dataloop_parallel;   %extracted stored file read-in
    if num_additionalyrs > 0
        dearchive_dataloop_parallel_2x;   %extracted stored file read-in for PRIOR YEAR
    end
    if num_additionalyrs > 1
        dearchive_dataloop_parallel_3x
    end
   
    for cind=1:cfilter+1
        for mi = 1:multi_reps
            fixup_offsets0;
            if num_additionalyrs > 0
                fixup_offsets0_2;  %same for PRIOR YR DATA
            end
            if num_additionalyrs > 1
                fixup_offsets0_3;  %same for year before that...
            end
            conference = char(conf_(cind));
            
            if cfilter >0
                [sportmat_o, teamno,sportodds, datelist, restvec, goaliesavemat]  = conference_filter_nhlr(sportmat_o0, sportodds0, ...
                    datelist0, conference, teamno0, restvec0, goaliesavemat0);
                %             actual_conffilter;  %check to see if this is the most recent
                %             yr, if so get actual stat averages
                if num_additionalyrs > 0
                    [sportmat_o2, teamno,sportodds2, datelist2, restvec2, goaliesavemat2]  = conference_filter_nhlr(sportmat_o02, sportodds02, ...
                        datelist02, conference, teamno0, restvec02, goaliesavemat02);
                end
                if num_additionalyrs > 1
                    [sportmat_o3, teamno,sportodds3, datelist3, restvec3, goaliesavemat3]  = conference_filter_nhlr(sportmat_o03, sportodds03, ...
                        datelist03, conference, teamno0, restvec03, goaliesavemat03);
                end
%                 if yrind >= numel(sportmat0_)
%                     sportmat_o_actual = actual_conffilter_fn(yrind, sportmat0_, sportmat_o_actual0, sportodds0, ...
%                         datelist0, conference, teamno0);
%                 end
            else
%                 if yrind >= numel(sportmat0_)
%                     sportmat_o_actual = sportmat_o_actual0;
%                 end
                sportmat_o=sportmat_o0;
                sportoddspl_{yrind,cind}=sportoddspl;
                sportodds=sportodds0;
                datelist=datelist0;
                teamno=teamno0;
                goaliesavemat=goaliesavemat0;
                restvec=restvec0;
            end
            sportodds_{yrind,cind}=sportodds;
%             sportoddspl_{yrind,cind}=sportoddspl;
            sportmat_o_{yrind,cind}=sportmat_o;
            datelist_{yrind,cind}=datelist;
            teamno_{yrind,cind}=teamno;
            goaliesavemat_{yrind,cind}=goaliesavemat;
            
            
            %        create EXTENDED TRAINING DATA w/ multiple years HERE:
                if num_additionalyrs == 2
                
                numpts2 = size(sportmat_o2,1) +size(sportmat_o3,1)  ;
                training_min1=numpts2  +additional_training;
                sportmat_o=vertcat(sportmat_o3, sportmat_o2,sportmat_o);
                sportoddspl=vertcat(sportoddspl3, sportoddspl2,sportoddspl);
                sportodds=vertcat(sportodds3, sportodds2,sportodds);
                sportoddsou=vertcat(sportoddsou3, sportoddsou2,sportoddsou);
                restvec= vertcat(restvec3, restvec2, restvec);
                goaliesavemat = vertcat(goaliesavemat3,goaliesavemat2,goaliesavemat);
                datelist=vertcat(datelist3, datelist2, datelist);
                
                
            elseif num_additionalyrs == 1
                numpts2 = size(sportmat_o2,1);
                training_min1=numpts2 +additional_training;
                sportmat_o=vertcat(sportmat_o2,sportmat_o);
                sportoddspl=vertcat(sportoddspl2,sportoddspl);
                sportodds=vertcat(sportodds2,sportodds);
                sportoddsou=vertcat(sportoddsou2,sportoddsou);
                restvec= vertcat(restvec2, restvec);
                goaliesavemat = vertcat(goaliesavemat2,goaliesavemat);
                datelist=vertcat(datelist2, datelist);
                
                
            else
                if additional_training > 0
                    training_min1 = additional_training; %if no additional years added you HAVE to have some training data from current year
                else
                    training_min1 = additional_training; % a good default value if you forgot to put in for 'additional training'
                end
            end
            %%  put right bcalc function and SOS_= odds here
%             bcalcnhlxf_qr_tg;  % goalie & restvec version
%             bcalcnhlxf_qr_t;  % NO goalie & NO restvec version
            bcalcnhlxf_qr_tg  %using the adaptation from puckline data
            
            %%%%% make sure to modify below for different odds types
            sportoddsshort=sportoddsshort;
            %OFFLOAD data prediction payload here:
            archive_dataloop_p;
            
%             sos_{yrind,cind}=sportoddsplshort;   %done in
%             archive_dataloop_p
%             p_(yrind,cind)=p;
%             %         rmse(yrind,cind)=rmse1;
%             %         rmsea(yrind,cind)=rmse2;
%             %         rmseb(yrind,cind)=rmse3;
%             wv_{yrind,cind}=winvec2;
%             np_{yrind,cind}=numpts;
%             ad_{yrind,cind}=archive_data;
            
            
            admulti_{mi,yrind,cind}=ad_{yrind,cind};
        end
        %average over iterations here:::
        %create regular matrix arrays of cell arrays so we can do
        %averaging....
        admp_ = [];
        
        adm_=zeros(multi_reps,size(ad_{yrind,cind},1), size(ad_{yrind,cind},2));
        for fi=1:multi_reps
            
            adm_(fi,:,:)=admulti_{fi,yrind,cind};
            
        end
        
        ad_{yrind,cind} = ssqueeze(mean(adm_,1)); %ditto
        
    end
end
for nulltime = 1:num_additionalyrs
    null_data_2; %get rid of meaningless set of data for yrind=1 case
end  %d