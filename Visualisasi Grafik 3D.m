t = 0:0.1:8*pi;
x = sqrt(t) .* sin(3*t);
y = sqrt(t) .* cos(3*t);
z = 0.2 * t;

figure;
plot3(x, y, z, 'm', 'LineWidth', 1.5);
grid on;
xlabel('Sumbu X');
ylabel('Sumbu Y');
zlabel('Sumbu Z');
title('Plot3D Helix Konis');
