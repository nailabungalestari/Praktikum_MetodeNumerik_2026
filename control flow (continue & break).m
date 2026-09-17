fprintf('--- Demonstrasi Continue ---\n');
for i = 1:5
    if (i == 3)
        continue; % Melewati iterasi saat i = 3
    end
    fprintf('Nilai i = %d, i^2 = %d\n', i, i^2);
end

fprintf('\n--- Demonstrasi Break ---\n');
for i = 1:5
    if (i == 4)
        break; % Menghentikan loop secara paksa saat i = 4
    end
    fprintf('Nilai i = %d, i^2 = %d\n', i, i^2);
end
