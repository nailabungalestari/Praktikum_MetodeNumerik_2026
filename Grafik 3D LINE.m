t = linspace(0,6*pi,200);

x = cos(t);
y = sin(t);
z = t;

plot3(x,y,z);
grid on;
title('Grafik Garis 3D Spiral');
xlabel('X');
ylabel('Y');
zlabel('Z');
