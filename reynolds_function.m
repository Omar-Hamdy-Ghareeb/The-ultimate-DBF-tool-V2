
function re = reynolds_function(v,chord)
    load("constants.mat","rho","dynamic_viscosity");
    re = rho.*v.*chord./dynamic_viscosity;
end