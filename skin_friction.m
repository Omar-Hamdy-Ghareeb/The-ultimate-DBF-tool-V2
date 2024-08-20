function skin_friction()
Re_wing_vector = linspace(0,100000000,100);
Cf_vector_laminar = get_cf(0,Re_wing_vector);
Cf_vector_turbulent = get_cf(1,Re_wing_vector);
figure('Name', 'Cf vs Re','NumberTitle','off');
cf_re_tiles = tiledlayout(1,2);
title(cf_re_tiles,"Coefficient of skin friction");
 nexttile;
loglog(Re_wing_vector,Cf_vector_laminar);
hold on
loglog(Re_wing_vector,Cf_vector_turbulent);
xlabel("Re","Interpreter","latex");
ylabel("Cf","Interpreter","latex");
legend("Laminar","turbulent");
grid on
hold off
nexttile;
plot_2(Re_wing_vector,Cf_vector_laminar,"Re","Cf");
hold on
plot_2(Re_wing_vector,Cf_vector_turbulent,"Re","Cf");
legend("Laminar","turbulent");
hold off;
end