%tie the box score team names and dates together w/ odds

o_plcol1 = 12; %puckline odds col for 2014/2019 and LATER (depending on VERSION of odds data.... 2014 for NEW version 11/14/19)
% PLcoloffset=0; %=1  for odds years 2014 (2019) and LATER - format of odds data CHANGED to give TWO cols to puckline!!!! more readable
if yrs(yri) > 2013   %changed file format for 2014!!!!!
    PLcoloffset = 1;
else
    PLcoloffset = 0;
end
nind=find(strcmp(teamnames_nhl1(:,3),char(bxteams(jind))));  %find the long name of the visiting team
nind_h=find(strcmp(teamnames_nhl1(:,3),char(bxhteams(jind))));  %find the long name of the home team



oteams_oddsformat =char(teamnames_nhl1{nind,10});
oteams_oddsformat_h =char(teamnames_nhl1{nind_h,10});

oindexv = find(((abs(odate - bxdate(jind)) < 2) & circshift(strcmp(oteams, oteams_oddsformat_h),-1) & strcmp(oteams, oteams_oddsformat)));
if ~isempty(oindexv)
    oindexh=oindexv+1; %the home teams just 1 row below the visitor teams in the odds data
    if numel(oindexv) > 1  %wuh-oh, looks like there are 2 games that could be it... annoying, gotta fix. which is it>
        
        %from scraped in spider file (box score data),  vgf_incsowon   is the 'goals for' including the effect of any
        % shoot-out wins
        
        %vga is goals against
        scorets2v=oddsgoals(oindexv);
        scorets2h=oddsgoals(oindexh);
        
        if (scorets2v(1) ==  ceil(sportmat(jind,3))) & (  scorets2h(1) ==  ceil(sportmat(jind,4))  )
            oindexv=oindexv(1);
            oindexh=oindexh(1);
        elseif (scorets2v(2) ==  ceil(sportmat(jind,3))) & (  scorets2h(2) ==  ceil(sportmat(jind,4))  )
            
            oindexv=oindexv(2);
            oindexh=oindexh(2);
        else
            fprintf('wuh-oh on yr %d  jind %d\n', yri, jind);
        end
    end
    
    %                                  find the row in the odds data matching the box score data
    %                                      screen by goal for, goals
    %                                      against match, date matches
    %                                      (within 1 day), team names
    %                                      match
    
    sportodds(jind,1) = t1(oindexv,o_mlocol); %visitor ML open
    sportodds(jind,2) = t1(oindexh,o_mlocol); %home ML open
    sportodds(jind,3) = t1(oindexv,o_mlccol); %visitor ML close
    sportodds(jind,4) = t1(oindexh,o_mlccol); %home ML close
    
    sportou(jind,1) = t1(oindexv,o_ouopencol1+oddscoloffset+ PLcoloffset); %visitor OU open
    sportou(jind,2) = t1(oindexv,o_ouopencol2+oddscoloffset+ PLcoloffset); %
    sportou(jind,3) = t1(oindexv,o_ouclosecol1+oddscoloffset+ PLcoloffset); %
    sportou(jind,4) = t1(oindexv,o_ouclosecol2+oddscoloffset+ PLcoloffset); %
    
    sportou(jind,5) = t1(oindexh,o_ouopencol1+oddscoloffset+ PLcoloffset); %
    sportou(jind,6) = t1(oindexh,o_ouopencol2+oddscoloffset+ PLcoloffset); %
    sportou(jind,7) = t1(oindexh,o_ouclosecol1+oddscoloffset+ PLcoloffset); %
    sportou(jind,8) = t1(oindexh,o_ouclosecol2+oddscoloffset+ PLcoloffset); %
    
    if oddscoloffset>0   %if there are pucklines, read them in here
        if PLcoloffset == 1   %read in pucklines the EZ way with new format
            sportpl(jind,1)= t1(oindexv,o_plcol);  %first do open odds the same as close odds (only available)
            sportpl(jind,2)=t1(oindexv,o_plcol1);
            sportpl(jind,3)= t1(oindexh,o_plcol);
            sportpl(jind,4)= t1(oindexh,o_plcol1);
            
            sportpl(jind,5)= t1(oindexv,o_plcol);   %close puckline odds (what's available)
            sportpl(jind,6)=t1(oindexv,o_plcol1);
            sportpl(jind,7)= t1(oindexh,o_plcol);
            sportpl(jind,8)= t1(oindexh,o_plcol1);
            
            %now infer opening puckline odds from prob diff in ML odds
            %visitor first:
            
            probv1 = ML2PL(ml2prob( sportodds(jind,3)),sportpl(jind,5)); %road close
            probv2 = ML2PL(ml2prob( sportodds(jind,1)),sportpl(jind,5)); %road open
            roaddelta = probv2 - probv1;  %obtain delta
            sportpl(jind,2) = prob2ml( ml2prob(sportpl(jind,6)) + roaddelta);
            
            %home:
            
            probh1 = ML2PL(ml2prob( sportodds(jind,4)),sportpl(jind,7)); %home close
            probh2 = ML2PL(ml2prob( sportodds(jind,2)),sportpl(jind,7)); %home open
            homedelta = probh2 - probh1;  %obtain delta
            sportpl(jind,2) = prob2ml( ml2prob(sportpl(jind,8)) + homedelta);
            
            
            
            
        else   %do this for 2014 - 2018
            pl_string=v1(oindexv, o_plcol);
            pl_string=strrep(pl_string, '(', ' ');
            pl_string=strrep(pl_string, ')', ' ');
            [o1, ~]=sscanf(char(pl_string), '%f   %f');
            sportpl(jind,1)= o1(1);
            sportpl(jind,2)= o1(2);
            
            pl_string=v1(oindexh, o_plcol);
            pl_string=strrep(pl_string, '(', ' ');
            pl_string=strrep(pl_string, ')', ' ');
            [o1, ~]=sscanf(char(pl_string), '%f   %f');
            
            sportpl(jind,3)= o1(1);
            sportpl(jind,4)= o1(2);
            
            
        end
    end
    else
        sportodds(jind,1:4) = NaN;
        sportou(jind,1:8) = NaN;
        sportpl(jind,1:4) = NaN;
        
    end
    dateinfov=datevec(bxdate(jind));
    
    datelist(jind,1) = dateinfov(2);
    datelist(jind,2) =  dateinfov(3);
    datelist(jind,3)=dateinfov(1);