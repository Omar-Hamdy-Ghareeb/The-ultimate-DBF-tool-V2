function ff = wing_and_tail_ff(xc,t_c)
ff = (1+0.6.*t_c./(xc)+100.*t_c.^4);
end