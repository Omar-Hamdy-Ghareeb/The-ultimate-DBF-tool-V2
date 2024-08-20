function s_wet_value = s_wet(S,t,c)
s_wet_value = S.*(1 +0.2.*(t./c));
end