function sizing_vector = sizing(MTOW,v_stall,v_cruise,TR,v_horizontal,v_vertical,SH_SW,AR_horizontal,AR_vertical)
load ("constraints_analysis_variables.mat","AR","CL_max","ef","k","np","rho");
load("constants.mat");


%%%%%%%%%%%%%%%%%%%%%%% Wing area %%%%%%%%%%%%%%%%%%%%%%%
        
 
%         MTOW = 3*g;                             % Estimation (Most likely to change)
%         v_stall = 5;                             % Design parameter (Probably subject to change)
%         v_cruise = 12.9;                          % Estimation (Most likely to change)

w_S = 0.5*rho.*(v_stall).^2.*CL_max;
S_wing = MTOW ./ w_S;



%%%%%%%%%%%%%%%%%%%%%%% Wing sizing %%%%%%%%%%%%%%%%%%%%%%%

%         TR = 1;                                 % Design parameter (Probably subject to change)

b_wing = sqrt(AR.*S_wing);
root_chord_wing = 2*S_wing./b_wing./(1+TR);
tip_chord_wing = TR.*root_chord_wing;
MAC_wing = (2/3).*root_chord_wing.*((1+TR+(TR).^2)/(1+TR));

%%%%%%%%%%%%%%%%%%%%%%% Tail sizing %%%%%%%%%%%%%%%%%%%%%%%

%         v_horizontal = 0.4;                     % Design parameter (Probably subject to change)
%         v_vertical = 0.03;                      % Design parameter (Probably subject to change)
%         SH_SW = 0.03;                           % Design parameter (Probably subject to change)
%         AR_horizontal = 3;                      % Design parameter (Probably subject to change)
%         AR_vertical = 3;                        % Design parameter (Probably subject to change)

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


%%%%%%%%%%%%%%%%% Control surfaces sizing %%%%%%%%%%%%%%%%%

% Control surfaces sizing TBD Here ------------------>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sizing_vector = [w_S,S_wing,b_wing,root_chord_wing,tip_chord_wing,MAC_wing,SH,SV,b_horizontal,b_vertical,horizontal_chord,vertical_chord,arm,Re_wing_to,Re_wing_cr];
save("sizing.mat");
end

