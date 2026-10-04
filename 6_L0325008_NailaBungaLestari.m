% 1. Definisi Matriks A dan Vektor b
A = [ 5 -1 -1  0  0;
     -1  5 -1 -1  0;
     -1 -1  4 -1 -1;
      0  0  1  4 -2;
      0  1 -1  1  4];

b = [-1; 2; 6; 2; -1];

% Solusi Eksak Analitikal untuk Pembanding Galat
x_eksak = A \ b;

% Parameter Konvergensi Iteratif (Sesuai Petunjuk Soal 1)
max_iter = 20;    % Maksimum iterasi = 20
tol = 0.001;      % Toleransi error = 0.001

fprintf('==========================================================\n');
fprintf('        HASIL PENGUJIAN METODE NUMERIK SPL                \n');
fprintf('==========================================================\n\n');

% ----------------------------------------------------------------
% 1. METODE ELIMINASI GAUSS
% ----------------------------------------------------------------
tic; % Mulai hitung running time
Ab = [A b];
n = length(b);
for i = 1:n-1
    for j = i+1:n
        factor = Ab(j,i) / Ab(i,i);
        Ab(j, i:n+1) = Ab(j, i:n+1) - factor * Ab(i, i:n+1);
    end
end
x_gauss = zeros(n,1);
x_gauss(n) = Ab(n,n+1) / Ab(n,n);
for i = n-1:-1:1
    x_gauss(i) = (Ab(i,n+1) - Ab(i,i+1:n) * x_gauss(i+1:n)) / Ab(i,i);
end
t_gauss = toc; % Selesai hitung running time
err_gauss = max(abs(x_eksak - x_gauss));

% ----------------------------------------------------------------
% 2. METODE GAUSS-JORDAN
% ----------------------------------------------------------------
tic;
Ab_gj = [A b];
for i = 1:n
    Ab_gj(i,:) = Ab_gj(i,:) / Ab_gj(i,i);
    for j = 1:n
        if j ~= i
            factor = Ab_gj(j,i);
            Ab_gj(j,:) = Ab_gj(j,:) - factor * Ab_gj(i,:);
        end
    end
end
x_gj = Ab_gj(:, end);
t_gj = toc;
err_gj = max(abs(x_eksak - x_gj));

% ----------------------------------------------------------------
% 3. METODE DEKOMPOSISI LU
% ----------------------------------------------------------------
tic;
[L, U] = lu(A);
y = L \ b;
x_lu = U \ y;
t_lu = toc;
err_lu = max(abs(x_eksak - x_lu));

% ----------------------------------------------------------------
% 4. METODE JACOBI (Iterasi penuh hingga tol / max_iter)
% ----------------------------------------------------------------
tic;
x_jacobi = zeros(n,1);
iter_j = 0;
for k = 1:max_iter
    x_old = x_jacobi;
    for i = 1:n
        sigma = A(i,:) * x_old - A(i,i) * x_old(i);
        x_jacobi(i) = (b(i) - sigma) / A(i,i);
    end
    iter_j = k;

    % Cek kriteria berhenti (Galat Relatif / Selisih antar iterasi)
    if max(abs(x_jacobi - x_old)) < tol
        break;
    end
end
t_jacobi = toc;
err_jacobi = max(abs(x_eksak - x_jacobi));

% ----------------------------------------------------------------
% 5. METODE GAUSS-SEIDEL (Iterasi penuh hingga tol / max_iter)
% ----------------------------------------------------------------
tic;
x_gs = zeros(n,1);
iter_gs = 0;
for k = 1:max_iter
    x_old = x_gs;
    for i = 1:n
        sigma = A(i,1:i-1) * x_gs(1:i-1) + A(i,i+1:n) * x_old(i+1:n);
        x_gs(i) = (b(i) - sigma) / A(i,i);
    end
    iter_gs = k;

    % Cek kriteria berhenti (Galat Relatif / Selisih antar iterasi)
    if max(abs(x_gs - x_old)) < tol
        break;
    end
end
t_gs = toc;
err_gs = max(abs(x_eksak - x_gs));

% ----------------------------------------------------------------
% MENAMPILKAN HASIL SOLUSI DAN RINGKASAN EVALUASI
% ----------------------------------------------------------------
fprintf('Solusi Vektor x = [p; q; r; s; t]:\n');
fprintf('Eksak        : [%.4f, %.4f, %.4f, %.4f, %.4f]\n', x_eksak);
fprintf('Gauss        : [%.4f, %.4f, %.4f, %.4f, %.4f]\n', x_gauss);
fprintf('Gauss-Jordan : [%.4f, %.4f, %.4f, %.4f, %.4f]\n', x_gj);
fprintf('LU           : [%.4f, %.4f, %.4f, %.4f, %.4f]\n', x_lu);
fprintf('Jacobi       : [%.4f, %.4f, %.4f, %.4f, %.4f] (%d iterasi)\n', x_jacobi, iter_j);
fprintf('Gauss-Seidel : [%.4f, %.4f, %.4f, %.4f, %.4f] (%d iterasi)\n\n', x_gs, iter_gs);

fprintf('----------------------------------------------------------------------\n');
fprintf('Metode                Running Time (s)    Galat Absolut    Jumlah Iterasi\n');
fprintf('----------------------------------------------------------------------\n');
fprintf('Gauss                 %16.6f    %13.6e         -\n', t_gauss, err_gauss);
fprintf('Gauss-Jordan          %16.6f    %13.6e         -\n', t_gj, err_gj);
fprintf('Dekomposisi LU        %16.6f    %13.6e         -\n', t_lu, err_lu);
fprintf('Jacobi                %16.6f    %13.6e         %d\n', t_jacobi, err_jacobi, iter_j);
fprintf('Gauss-Seidel          %16.6f    %13.6e         %d\n', t_gs, err_gs, iter_gs);
fprintf('----------------------------------------------------------------------\n');

% ----------------------------------------------------------------
% 6. TAMPILAN LANGKAH PER TAHAP (opsional, di luar running time)
% ----------------------------------------------------------------
fmt_aug = '%9.4f%9.4f%9.4f%9.4f%9.4f  |%9.4f\n';   % format cetak matriks augmented
fprintf('\n===== LANGKAH ELIMINASI GAUSS =====\n');
fprintf('Matriks augmented awal [A | b]:\n');
Ab_s = [A b];
fprintf(fmt_aug, Ab_s');
for i = 1:n-1
    fprintf('\nEliminasi kolom %d (pivot = %.4f):\n', i, Ab_s(i,i));
    for j = i+1:n
        factor = Ab_s(j,i) / Ab_s(i,i);
        Ab_s(j, i:n+1) = Ab_s(j, i:n+1) - factor * Ab_s(i, i:n+1);
        fprintf('  B%d <- B%d - (%8.4f) x B%d\n', j, j, factor, i);
    end
    fprintf(fmt_aug, Ab_s');
end
fprintf('\nSubstitusi mundur: x = [%.4f, %.4f, %.4f, %.4f, %.4f]\n', x_gauss);

fprintf('\n===== LANGKAH ELIMINASI GAUSS-JORDAN =====\n');
Ab_s = [A b];
for i = 1:n
    Ab_s(i,:) = Ab_s(i,:) / Ab_s(i,i);
    for j = 1:n
        if j ~= i
            factor = Ab_s(j,i);
            Ab_s(j,:) = Ab_s(j,:) - factor * Ab_s(i,:);
        end
    end
    fprintf('Setelah pivot kolom %d:\n', i);
    fprintf(fmt_aug, Ab_s');
    fprintf('\n');
end
fprintf('Solusi (kolom terakhir): x = [%.4f, %.4f, %.4f, %.4f, %.4f]\n', x_gj);

fprintf('\n===== LANGKAH DEKOMPOSISI LU =====\n');
fprintf('Matriks L:\n');
fprintf('%9.4f%9.4f%9.4f%9.4f%9.4f\n', L');
fprintf('\nMatriks U:\n');
fprintf('%9.4f%9.4f%9.4f%9.4f%9.4f\n', U');
fprintf('\nVektor y (L*y = b):\n');
fprintf('  y = [%.4f, %.4f, %.4f, %.4f, %.4f]\n', y);
fprintf('\nSolusi (U*x = y): x = [%.4f, %.4f, %.4f, %.4f, %.4f]\n', x_lu);

fmt_it = 'Iter %d : [%8.5f %8.5f %8.5f %8.5f %8.5f]  selisih = %.5f\n';
fprintf('\n===== LANGKAH METODE JACOBI (2 ITERASI) =====\n');
xj = zeros(n,1);
fprintf('Iter 0 : [%8.5f %8.5f %8.5f %8.5f %8.5f]\n', xj);
for k = 1:2
    xo = xj;
    for i = 1:n
        sigma = A(i,:) * xo - A(i,i) * xo(i);
        xj(i) = (b(i) - sigma) / A(i,i);
    end
    fprintf(fmt_it, k, xj, max(abs(xj - xo)));
end
fprintf('Galat thd. eksak setelah 2 iterasi = %.5f\n', max(abs(x_eksak - xj)));

fprintf('\n===== LANGKAH METODE GAUSS-SEIDEL (2 ITERASI) =====\n');
xg = zeros(n,1);
fprintf('Iter 0 : [%8.5f %8.5f %8.5f %8.5f %8.5f]\n', xg);
for k = 1:2
    xo = xg;
    for i = 1:n
        sigma = A(i,1:i-1) * xg(1:i-1) + A(i,i+1:n) * xo(i+1:n);
        xg(i) = (b(i) - sigma) / A(i,i);
    end
    fprintf(fmt_it, k, xg, max(abs(xg - xo)));
end
fprintf('Galat thd. eksak setelah 2 iterasi = %.5f\n', max(abs(x_eksak - xg)));
