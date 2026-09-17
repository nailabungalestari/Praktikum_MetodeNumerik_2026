x = linspace(-2*pi,2*pi,50);
y = linspace(-2*pi,2*pi,50);

[X,Y] = meshgrid(x,y);
Z = sin(X).*cos(Y);

mesh(X,Y,Z);
grid on;
title('Grafik MESH 3D');
xlabel('X');
ylabel('Y');
zlabel('Z');
