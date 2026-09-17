clc;
clear;
close all;

x = linspace(-2*pi, 2*pi, 50);
y = linspace(-2*pi, 2*pi, 50);

[X,Y] = meshgrid(x,y);

Z = sin(X).*cos(Y);

figure;
contour(X,Y,Z,20);

grid on;
title('Grafik Contour: Z = sin(X) cos(Y)');
xlabel('X');
ylabel('Y');
