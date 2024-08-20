function constraints_array = constraints_analysis(CL_max,v_stall_constraint,np,ef,CD_0,v_max_constraint,AR)
load("constants.mat","rho");


%%%%%%%%%%%%%%% V_stall constraint %%%%%%%%%%%%%%%%%
                

%                 CL_max = 1;                 % Estimation (Most likely to change)
%                 v_stall_constraint = 5;     % Extreme case
w_S_const = NaN(1,50000).';
w_S_const(1) = 0.5 .* v_stall_constraint .* CL_max;

%%%%%%%%%%%%%%%%%% max speed %%%%%%%%%%%%%%%%%%%%%%%
                
%                 np = 0.8;                   % Estimation (Most likely to change)
%                 ef = 0.8;                   % Mission dependant (Probably subject to change)
%                 CD_0 = 0.003;               % Estimation (Most likely to change)
%                 v_max_constraint = 23;      % Extreme case
%                 AR = 5;                     % Mission dependant (Probably subject to change)

k = 1/pi*ef*AR;          
w_S_curve = (linspace(0,10,50000)).';
np_w_p_constraint = (((0.5*rho*(v_max_constraint.^3).*CD_0)./w_S_curve)+((2.*k.*w_S_curve)./(rho.*v_max_constraint)));
w_p_constraint = np ./ np_w_p_constraint;



%%%%%%%%%%%%%%%%%%%%%%%%%  save variables    %%%%%%%%%%%%%%%%%%%%%


save("constraints_analysis_variables.mat");
constraints_array = [w_S_const(:),w_S_curve(:),w_p_constraint(:)];
end
