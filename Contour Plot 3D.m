x = -3:0.2:3;
y = -3:0.2:3;
[X, Y] = meshgrid(x, y);

Z = X .* exp(-X.^2 - Y.^2);

figure;
contour3(X, Y, Z, 20); % 20 level kontur
xlabel('Sumbu X');
ylabel('Sumbu Y');
zlabel('Sumbu Z');
title('Contour Plot 3D Level Ketinggian');
grid on;
