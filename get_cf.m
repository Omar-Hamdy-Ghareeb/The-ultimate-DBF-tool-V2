function [Cf_laminar,Cf_turblent] = get_cf(Re)

 Cf_laminar = 1.328./sqrt(Re);
 Cf_turblent= 0.455./(log10(Re).^2.58);

end