function plot_2(x,y,xlab,ylab)

plot(x,y);
xlabel(xlab,"Interpreter","latex");
ylabel(ylab,"Interpreter","latex");
grid on
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';


end