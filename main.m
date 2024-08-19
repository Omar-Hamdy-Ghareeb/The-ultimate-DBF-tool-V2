clc 
clear 
close all
load ("constraints_analysis_variables.mat","AR","CL_max","ef","k","np","rho");
load("Constants.mat");

%%%%%%%%%%%%%%%%%%%%%%% Wing area %%%%%%%%%%%%%%%%%%%%%%%
        
 
        MTOW = 3*g;                             % Estimation (Most likely to change)
        v_stall = 5;                            % Design parameter (Probably subject to change)
        v_cruise = 12.9;                          % Estimation (Most likely to change)

w_S = 0.5*rho.*(v_stall).^2.*CL_max;
S_wing = MTOW ./ w_S;


%%%%%%%%%%%%%%%%% Control surfaces sizing %%%%%%%%%%%%%%%%%

% Control surfaces sizing TBD Here ------------------>

%%%%%%%%%%%%%%%%%%%%%%% Wing sizing %%%%%%%%%%%%%%%%%%%%%%%

        TR = 1;                                 % Design parameter (Probably subject to change)
        sweep = 2;                              % Design parameter (Probably subject to change)

b_wing = sqrt(AR.*S_wing);
root_chord_wing = 2*S_wing./b_wing./(1+TR);
tip_chord_wing = TR.*root_chord_wing;
MAC_wing = (2/3).*root_chord_wing.*((1+TR+(TR).^2)/(1+TR));

%%%%%%%%%%%%%%%%%%%%%%% Tail sizing %%%%%%%%%%%%%%%%%%%%%%%

        v_horizontal = 0.4;                     % Design parameter (Probably subject to change)
        v_vertical = 0.03;                      % Design parameter (Probably subject to change)
        SH_SW = 0.03;                           % Design parameter (Probably subject to change)
        AR_horizontal = 3;                      % Design parameter (Probably subject to change)
        AR_vertical = 3;                        % Design parameter (Probably subject to change)

SH = SH_SW .* S_wing;
arm = v_horizontal.*S_wing.*MAC_wing./SH;
SV = v_vertical.*S_wing.*b_wing./arm;
b_horizontal = sqrt(AR_horizontal.*SH);
b_vertical = sqrt(AR_vertical.*SV);
horizontal_chord = b_horizontal./ AR_horizontal;
vertical_chord = b_vertical./AR_vertical;

%%%%%%%%%%%%%%%%%%%%%%% Airfoil selection %%%%%%%%%%%%%%%%%%%%%%%

Re_wing_to = reynolds_function(v_stall,MAC_wing);
Re_wing_cr = reynolds_function(v_cruise,MAC_wing);



%-----------------------Post-analysis phase-----------------------%




%%%%%%%%%%%%%%%%%%%%%%%%%% Lift & Induced Drag %%%%%%%%%%%%%%%%%%%%%%%%%%
CL_vs_v = readtable("CL.csv");
CDi_vs_v = readtable("cdi.csv");

v_vector = CDi_vs_v{:,1};
CD_i_vector = CDi_vs_v{:,2};
CL_vector_fixed_lift = CL_vs_v{:,2};
%%%%%%%%%%%%%%%%%%%%%%%%%% skin friction Drag vs Re curve %%%%%%%%%%%%%%%%%%%%%%%%%%

Re_wing_vector = linspace(0,100000000,100);
[Cf_vector_laminar,Cf_vector_turblent] = get_cf(Re_wing_vector);
figure('Name', 'Cf vs Re');
cf_re_tiles = tiledlayout(1,2);
title(cf_re_tiles,"Coefficient of skin friction");
 nexttile;
loglog(Re_wing_vector,Cf_vector_laminar);
hold on
loglog(Re_wing_vector,Cf_vector_turblent);
xlabel("Re","Interpreter","latex");
ylabel("Cf","Interpreter","latex");
legend("Laminar","Turblent");
grid on
hold off
nexttile;
plot_2(Re_wing_vector,Cf_vector_laminar,"Re","Cf");
hold on
plot_2(Re_wing_vector,Cf_vector_turblent,"Re","Cf");
legend("Laminar","Turblent");
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%% Total drag %%%%%%%%%%%%%%%%%%%%%%%%%%

thickness_wing = 0.12.*MAC_wing; % Analysis placeholder 
max_loc_wing = 0.2903; % Analysis placeholder
wing_ff = wing_and_tail_ff(max_loc_wing,thickness_wing./MAC_wing);


thickness_htail = 0.09.*horizontal_chord; %Analysis placeholder
thickness_vtail = 0.09.*vertical_chord; %Analysis placeholder
max_loc_htail = 0.2903; %Analysis placeholder
max_loc_vtail = 0.2903; %Analysis placeholder
htail_ff = wing_and_tail_ff(max_loc_htail,thickness_htail./horizontal_chord);
vtail_ff = wing_and_tail_ff(max_loc_vtail,thickness_vtail./vertical_chord);

max_fus_area = 0.04; % Design parameter (Probably subject to change)
fuselage_length = 1; % Design parameter (Probably subject to change)
fineness_ratio = fuselage_length./(sqrt(4.*max_fus_area/pi));
fuselage_ff = (1+60./(fineness_ratio.^3)+fineness_ratio./400);
S_wet_wing = s_wet(S_wing,thickness_wing,MAC_wing);
S_wet_htail = s_wet(SH,thickness_htail,horizontal_chord);
S_wet_vtail = s_wet(S_wing,thickness_vtail,vertical_chord);
IF = 0.15; % Estimation

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