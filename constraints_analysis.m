clc
clear
close all

load("Constants.mat","rho");

%%%%%%%%%%%%%%%%%%%%%%%%%  figure   %%%%%%%%%%%%%%%%%%%%%

figure;
xlabel("W/S","Interpreter","latex");
ylabel("W/P","Interpreter","latex");
grid on
hold on
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

%%%%%%%%%%%%%%% V_stall constraint %%%%%%%%%%%%%%%%%
                

                CL_max = 1;                 % Estimation (Most likely to change)
                v_stall_constraint = 5;     % Extreme case

w_S_const = 0.5 .* v_stall_constraint .* CL_max;
xline(w_S_const,"r");

%%%%%%%%%%%%%%%%%% max speed %%%%%%%%%%%%%%%%%%%%%%%
                
                np = 0.8;                   % Estimation (Most likely to change)
                ef = 0.8;                   % Mission dependant (Probably subject to change)
                CD_0 = 0.003;               % Estimation (Most likely to change)
                v_max_constraint = 23;      % Extreme case
                AR = 5;                     % Mission dependant (Probably subject to change)

k = 1/pi*ef*AR;          
w_S_curve = linspace(0,10,50000);
np_w_p_constraint = (((0.5*rho*(v_max_constraint.^3).*CD_0)./w_S_curve)+((2.*k.*w_S_curve)./(rho.*v_max_constraint)));
w_p_constraint = np ./ np_w_p_constraint;

plot(w_S_curve,w_p_constraint);
legend('w_S_const','w_p');


%%%%%%%%%%%%%%%%%%%%%%%%%   Hold off and save variables    %%%%%%%%%%%%%%%%%%%%%

hold off
save("constraints_analysis_variables.mat"); 
