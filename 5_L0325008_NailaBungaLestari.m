clc; clear;

% =====================================================================
% DEFINISI MATRIKS A DAN VEKTOR b
% =====================================================================
A = [ 2.0, 1.0, -1.0;
      4.0, 3.0,  1.0;
     -2.0, 1.0,  2.0];

b = [3.0; 9.0; 4.0];

fprintf('=======================================================\n');
fprintf('MATRIKS AWAL A DAN VEKTOR b\n');
fprintf('=======================================================\n');
disp('Matriks A =');
disp(A);
disp('Vektor b =');
disp(b);


% =====================================================================
% a) ELIMINASI GAUSS
% =====================================================================
fprintf('\n=======================================================\n');
fprintf('a) ELIMINASI GAUSS \n');
fprintf('=======================================================\n');

n = length(b);
Ab = [A, b];

fprintf('\n[1] Matriks Augmented [A|b] Awal:\n');
disp(Ab);

fprintf('[2] Proses Forward Elimination:\n');
for i = 1:n
    fprintf('--- Pivot Kolom %d (Elemen Diagonal = %.2f) ---\n', i, Ab(i,i));
    for j = i+1:n
        factor = Ab(j, i) / Ab(i, i);
        fprintf('  Baris %d dikurangi (%.2f) * Baris %d\n', j, factor, i);
        Ab(j, i:end) = Ab(j, i:end) - factor * Ab(i, i:end);
        disp(Ab);
    end
end

fprintf('[3] Proses Backward Substitution:\n');
x_gauss = zeros(n, 1);
for i = n:-1:1
    sum_val = Ab(i, i+1:n) * x_gauss(i+1:n);
    x_gauss(i) = (Ab(i, end) - sum_val) / Ab(i, i);
    fprintf('  x%d = (%.2f - %.2f) / %.2f = %.2f\n', i, Ab(i, end), sum_val, Ab(i,i), x_gauss(i));
end

fprintf('\nHasil Akhir Eliminasi Gauss:\n');
fprintf('  x1 = %.2f, x2 = %.2f, x3 = %.2f\n', x_gauss(1), x_gauss(2), x_gauss(3));


% =====================================================================
% b) ELIMINASI GAUSS-JORDAN
% =====================================================================
fprintf('\n=======================================================\n');
fprintf('b) ELIMINASI GAUSS-JORDAN \n');
fprintf('=======================================================\n');

Ab_jordan = [A, b];

for i = 1:n
    fprintf('--- Langkah %d: Normalisasi Baris %d ---\n', i, i);
    pivot = Ab_jordan(i, i);
    Ab_jordan(i, :) = Ab_jordan(i, :) / pivot;
    fprintf('  Baris %d dibagi %.2f:\n', i, pivot);
    disp(Ab_jordan);

    fprintf('  Eliminasi Kolom %d pada Baris Lain:\n', i);
    for j = 1:n
        if i ~= j
            factor = Ab_jordan(j, i);
            if factor ~= 0
                fprintf('    Baris %d dikurangi (%.2f) * Baris %d\n', j, factor, i);
                Ab_jordan(j, :) = Ab_jordan(j, :) - factor * Ab_jordan(i, :);
            end
        end
    end
    disp(Ab_jordan);
end

x_jordan = Ab_jordan(:, end);
fprintf('Hasil Akhir Gauss-Jordan:\n');
fprintf('  x1 = %.2f, x2 = %.2f, x3 = %.2f\n', x_jordan(1), x_jordan(2), x_jordan(3));


% =====================================================================
% c) DEKOMPOSISI LU
% =====================================================================
fprintf('\n=======================================================\n');
fprintf('c) DEKOMPOSISI LU \n');
fprintf('=======================================================\n');

L = eye(n);
U = A;

fprintf('[1] Pembentukan Matriks L dan U:\n');
for i = 1:n
    for j = i+1:n
        factor = U(j, i) / U(i, i);
        L(j, i) = factor;
        fprintf('  Pengali m_%d%d = %.2f\n', j, i, factor);
        U(j, i:end) = U(j, i:end) - factor * U(i, i:end);
    end
end

fprintf('\nMatriks L (Segitiga Bawah):\n');
disp(L);
fprintf('Matriks U (Segitiga Atas):\n');
disp(U);

fprintf('[2] Pembuktian A = L * U:\n');
disp(L * U);

fprintf('[3] TAHAP 1: Forward Substitution (L * y = b)\n');
y = zeros(n, 1);
for i = 1:n
    y(i) = b(i) - L(i, 1:i-1) * y(1:i-1);
    fprintf('  y%d = %.2f\n', i, y(i));
end

fprintf('\n[4] TAHAP 2: Backward Substitution (U * x = y)\n');
x_lu = zeros(n, 1);
for i = n:-1:1
    x_lu(i) = (y(i) - U(i, i+1:n) * x_lu(i+1:n)) / U(i, i);
    fprintf('  x%d = %.2f\n', i, x_lu(i));
end

fprintf('\nHasil Akhir Dekomposisi LU:\n');
fprintf('  x1 = %.2f, x2 = %.2f, x3 = %.2f\n', x_lu(1), x_lu(2), x_lu(3));


% =====================================================================
% KESIMPULAN
% =====================================================================
fprintf('\n=======================================================\n');
fprintf('KESIMPULAN AKHIR\n');
fprintf('=======================================================\n');
fprintf('Ketiga metode menghasilkan solusi yang SAMA PERSIS:\n');
fprintf('  x1 = %.2f  (atau -2/5)\n', x_lu(1));
fprintf('  x2 = %.2f   (atau 18/5)\n', x_lu(2));
fprintf('  x3 = %.2f  (atau -1/5)\n', x_lu(3));
fprintf('=======================================================\n');
