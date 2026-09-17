x = -5:0.25:5;
y = -5:0.25:5;
[X, Y] = meshgrid(x, y);

R = sqrt(X.^2 + Y.^2) + eps; % eps mencegah pembagian dengan nol
Z = sin(R) ./ R;

figure;
mesh(X, Y, Z);
xlabel('Sumbu X');
ylabel('Sumbu Y');
zlabel('Sumbu Z');
title('Surface Mesh Plot Sinc 2D');
colorbar;
