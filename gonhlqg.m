%read in data, the sportoddsreview excel files are wired into this
%alternative data -feed in to check vs. nhlfeedinx. Let's see if results
%are similar


[sportmat0_, sportodds0_, datelist0_, teamsu0_, teamno0_, num_newdataelements0_, restvec0_, sportoddsou0_, sportoddspl0_, ...
   goaliesavemat0_,       goaliefinalsavepcstats0_, goalienames0_, goalieLnames0_] =  nhlfeedinqg(yrlist);