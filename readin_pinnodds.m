if isfile(pinnacle_filename)
    pinn2019 = readtable(pinnacle_filename);
    ispinn =1;
    pinn2019.mo = month_convert(pinn2019.MM);
   
    pinn2019.H = strrep(pinn2019.TeamsID,'WIN','WPG');
    pinn2019.A = strrep(pinn2019.Var14,'WIN','WPG');
    
    for ki = 1:size(pinn2019.H,1)
        pinn2019.zdate(ki) = datenum(pinn2019.YY(ki), pinn2019.mo(ki), pinn2019.DD(ki), 24*pinn2019.Kick_off(ki),0,0);  %this is in ztime
        pinn2019.pstdate(ki) = pinn2019.zdate(ki) - 0.33334;
        
        h_ind = find(strcmp(teamnames_nhl1(:,3), pinn2019.H(ki)));
        if ~isempty(h_ind)
            pinn2019.h(ki) = cell2mat(teamnames_nhl1(h_ind,5));
        else
            pinn2019.h(ki) = NaN;
        end
        a_ind = find(strcmp(teamnames_nhl1(:,3), pinn2019.A(ki)));
        if ~isempty(a_ind)
            pinn2019.a(ki) = cell2mat(teamnames_nhl1(a_ind,5));
            
        else
            pinn2019.a(ki) = NaN;
         
        end
    end
    
else
    ispinn = 0;
end