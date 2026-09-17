x = 0:0.02:2*pi;
y1 = -5 * sin(3*x);
y2 = 4 * cos(5*x);

figure;
plot(x, y1, 'r--', x, y2, 'g-.', 'LineWidth', 1.2);
xlabel('Domain X (Radian)');
ylabel('Sumbu Y');
title('Plot Multi-Kurva Sinusoidal dan Kosinusoidal');
legend('y1 = -5*sin(3x)', 'y2 = 4*cos(5x)');
grid on;
