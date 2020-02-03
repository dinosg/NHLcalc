%this version parses goalie stats from goaliefinalsavepcstats based on
%goalienames scraped in from Rotogrinders - in gamenotes_new
%b/c determining probable goalie starter has become unreliable
%reset to avoid carryover from previous run of this loop
load ('teamnames_nhl2','teamnames_nhl1');



ht_roto = find(gamenotes_new.Home_Teamno == tm2);  %row with same home team jind'th row in sportmat_oddsonly_live0
vt_roto = find(gamenotes_new.Away_Teamno == tm1);   % " for visiting team

h_goalie = gamenotes_new.Home_Player(ht_roto);  %ID the goalies
v_goalie = gamenotes_new.Away_Player(vt_roto);

h_goalieln = gamenotes_new.Home_PlayerLN(ht_roto);  %get last names just in case
v_goalieln = gamenotes_new.Away_PlayerLN(vt_roto);

goalieparse_h=contains(goalienames0_,h_goalie);   %now matchup w/
goalieparse_v=contains(goalienames0_,v_goalie);

if all(~goalieparse_h)   %just do last names if full name matching turns up empty
    goalieparse_h = contains(goalieLnames0_,h_goalieln);
end
if all(~goalieparse_v)    % " for road teams
    goalieparse_v = contains(goalieLnames0_,v_goalieln);
end

%  changed from goaliefinalsavepcstats0    12/23/19
goalieteststats1=goaliefinalsavepcstats0_(goalieparse_v,:);  %road goalie stats
goalieteststats2=goaliefinalsavepcstats0_(goalieparse_h,:);   %home goalie stats
