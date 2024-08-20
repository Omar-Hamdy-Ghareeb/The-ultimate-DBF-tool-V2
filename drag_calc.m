
function drag_calc(CL_vs_v,...
    CDi_vs_v,...
    thickness_wing,...
    max_loc_wing,...
    thickness_htail,...
    thickness_vtail,...
    max_loc_htail,...
    max_loc_vtail,...
    IF)


load ("sizing.mat");
load("constants.mat");
%-----------------------Post-analysis phase-----------------------%




%%%%%%%%%%%%%%%%%%%%%%%%%% Lift & Induced Drag %%%%%%%%%%%%%%%%%%%%%%%%%%
% CL_vs_v = readtable("CL.csv");
% CDi_vs_v = readtable("cdi.csv");

v_vector = CDi_vs_v{:,1};
CD_i_vector = CDi_vs_v{:,2};
CL_vector_fixed_lift = CL_vs_v{:,2};

%%%%%%%%%%%%%%%%%%%%%%%%%% Total drag %%%%%%%%%%%%%%%%%%%%%%%%%%

% thickness_wing = 0.12.*MAC_wing; % Analysis placeholder 
% max_loc_wing = 0.2903; % Analysis placeholder
wing_ff = wing_and_tail_ff(max_loc_wing,thickness_wing./MAC_wing);


% thickness_htail = 0.09.*horizontal_chord; %Analysis placeholder
% thickness_vtail = 0.09.*vertical_chord; %Analysis placeholder
% max_loc_htail = 0.2903; %Analysis placeholder
% max_loc_vtail = 0.2903; %Analysis placeholder
htail_ff = wing_and_tail_ff(max_loc_htail,thickness_htail./horizontal_chord);
vtail_ff = wing_and_tail_ff(max_loc_vtail,thickness_vtail./vertical_chord);

% max_fus_area = 0.04; % Design parameter (Probably subject to change)
% fuselage_length = 1; % Design parameter (Probably subject to change)
% fineness_ratio = fuselage_length./(sqrt(4.*max_fus_area./pi));
% fuselage_ff = (1+60./(fineness_ratio.^3)+fineness_ratio./400);
% max_fus_area = 0.04; % Design parameter (Probably subject to change)
% fuselage_length = 1; % Design parameter (Probably subject to change)
% fineness_ratio = fuselage_length./(sqrt(4.*max_fus_area/pi));
% fuselage_ff = (1+60./(fineness_ratio.^3)+fineness_ratio./400);
S_wet_wing = s_wet(S_wing,thickness_wing,MAC_wing);
S_wet_htail = s_wet(SH,thickness_htail,horizontal_chord);
S_wet_vtail = s_wet(S_wing,thickness_vtail,vertical_chord);
% IF = 0.15; % Estimation

CD_0_vector = (1+IF).*(get_cf(reynolds_function(v_vector, MAC_wing)).*S_wet_wing.*wing_ff+...
get_cf(reynolds_function(v_vector,horizontal_chord)).*S_wet_htail.*htail_ff+...
get_cf(reynolds_function(v_vector,vertical_chord)).*S_wet_vtail.*vtail_ff)./S_wing;
CD_vector = CD_0_vector + CD_i_vector;
figure('Name',"CL vs CD");
plot_2(CD_i_vector,CL_vector_fixed_lift,"CDi","CL");
hold on
plot_2(CD_vector,CL_vector_fixed_lift,"CD","CL");
legend("CD_i only","CD");
title(gca,"Coefficient of drag (CD)");
hold off;
save("Temp.mat");
end