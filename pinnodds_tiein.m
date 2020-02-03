if ispinn == 1
    pinn_ind = find(pinn2019.a == vt  & floor(pinn2019.pstdate) == bxdate(jind));
    if ~isempty(pinn_ind) 
         if  ~isempty(char(pinn2019.OTTG5_0(pinn_ind)))
            sportouc_pinnacle(jind,[1 3 5 7] ) = 5.0; %the line (always = 5.0 for database we're reading from)
            sportouc_pinnacle(jind,2 ) = prob2ml(1/str2num(cell2mat(pinn2019.OTTG5_0(pinn_ind))));  %over open odds

            sportouc_pinnacle(jind,4 ) = prob2ml(1/str2num(cell2mat(pinn2019.Var58(pinn_ind))));  %over close odds

            sportouc_pinnacle(jind,6 ) = prob2ml(1/str2num(cell2mat(pinn2019.Var57(pinn_ind))));%under open odds
            sportouc_pinnacle(jind,8 ) = prob2ml(1/str2num(cell2mat(pinn2019.Var59(pinn_ind))));%over close odds
        
         else
             sportouc_pinnacle(jind,1:8 ) = NaN;
         end
    else
        sportouc_pinnacle(jind,1:8 ) = NaN;
        
    end
    
end