function sportmat_o_actual = actual_conffilter_fn(nind, sportmat0_, sportmat_o_actual0, sportodds0, ...
        datelist0, conference, teamno0)
    
%filters out the sportmat_o_actual0 by conference    
if nind >= numel(sportmat0_)
    [sportmat_o_actual]  = conference_filter_nhlr(sportmat_o_actual0, sportodds0, ...
        datelist0, conference, teamno0);
else
    sportmat_o_actual = [];
end