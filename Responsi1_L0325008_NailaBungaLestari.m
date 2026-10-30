function responsi1_metode_numerik(pilihan)
% =====================================================================
%  RESPONSI 1 PRAKTIKUM METODE NUMERIK  (Galat, SPL, SPNL)
%  Satu file berisi seluruh program (kompatibel MATLAB dan GNU Octave).
%
%  Cara menjalankan:
%      responsi1_metode_numerik        % menjalankan Kasus 1, 2, dan 3 berurutan
%      responsi1_metode_numerik(1)     % hanya Kasus 1 (Galat)
%      responsi1_metode_numerik(2)     % hanya Kasus 2 (SPL)
%      responsi1_metode_numerik(3)     % hanya Kasus 3 (Persamaan Non Linier)
%
%  Grafik akan muncul di layar DAN disimpan otomatis ke folder "hasil".
% =====================================================================
    if nargin < 1, pilihan = 0; end
    close all;
    if pilihan == 0 || pilihan == 1
        disp('--------------- KASUS 1 : GALAT -----------------');
        kasus1_galat();
    end
    if pilihan == 0 || pilihan == 2
        disp(' '); disp('---------------- KASUS 2 : SPL ------------------');
        kasus2_spl();
    end
    if pilihan == 0 || pilihan == 3
        disp(' '); disp('------------------ KASUS 3 : PERSAMAAN NON LINIER ------------------');
        kasus3_nonlinear();
    end
end

%% ===================== KASUS 1 : GALAT =====================
function kasus1_galat()
%% =====================================================================
%  KASUS 1 : Galat (Error Pemotongan) - Visualisasi Gelombang Air Laut
%  h = h0 * ( cos(t*v/lambda) + e^x )
%  Pendekatan: deret Maclaurin cos(x) dan e^x dengan n = 23, 24, 25
%% =====================================================================
folder = fileparts(mfilename('fullpath'));
if isempty(folder), folder = pwd; end
folder_hasil = fullfile(folder, 'hasil');
if ~exist(folder_hasil, 'dir'), mkdir(folder_hasil); end

%% 1. Parameter dan data masukan
lambda = 12;  v = 36;  x = 10;  h0 = 5;
n_list = [23 24 25];                   % batas iterasi
t      = 0:0.01:5;                     % 0 <= t <= 5, langkah 0,01 (501 titik)
z      = t * v / lambda;               % argumen cosinus = t*v/lambda

%% 2. Hitung nilai eksak
h_eksak = h0 * (cos(z) + exp(x));

%% 3. Hitung nilai pendekatan, galat mutlak, dan galat relatif
jumlah_n = numel(n_list);
h_pend   = zeros(jumlah_n, numel(t));
gal_mut  = zeros(jumlah_n, numel(t));
gal_rel  = zeros(jumlah_n, numel(t));
for i = 1:jumlah_n
    n = n_list(i);
    h_pend(i, :) = h0 * (taylor_cos(z, n) + taylor_exp(x, n));
    gal_mut(i, :) = abs(h_eksak - h_pend(i, :));          % |eksak - pendekatan|
    gal_rel(i, :) = gal_mut(i, :) ./ abs(h_eksak) * 100;  % dalam persen
end

%% 4. Tampilkan hasil
batas_toleransi = 1;   % persen
fprintf('Nilai e^x eksak            = %.6f\n', exp(x));
for i = 1:jumlah_n
    fprintf('e^x pendekatan (n = %d)    = %.6f\n', n_list(i), taylor_exp(x, n_list(i)));
end
fprintf('\n%-4s | %-22s | %-22s | %-22s | %s\n', 'n', ...
        'Rerata galat mutlak', 'Rerata galat relatif (%)', 'Galat relatif maks (%)', 'Layak (<1%)?');
fprintf('%s\n', repmat('-', 1, 105));
for i = 1:jumlah_n
    rerata_mut = mean(gal_mut(i, :));
    rerata_rel = mean(gal_rel(i, :));
    maks_rel   = max(gal_rel(i, :));
    if rerata_rel < batas_toleransi, ket = 'Ya'; else, ket = 'Tidak'; end
    fprintf('%-4d | %-22.6f | %-24.8f | %-22.8f | %s\n', ...
            n_list(i), rerata_mut, rerata_rel, maks_rel, ket);
end

%% 5. Grafik 1: perbandingan keempat fungsi dalam satu plot ('visible', 'on')
warna = {'r--', 'g-.', 'b:'};
fig1 = figure('visible', 'on', 'position', [100 100 900 520]);
plot(t, h_eksak, 'k-', 'LineWidth', 2.5); hold on;
for i = 1:jumlah_n
    plot(t, h_pend(i, :), warna{i}, 'LineWidth', 1.8);
end
grid on;
xlabel('t'); ylabel('h(t)');
title('Perbandingan h(t): Eksak vs Pendekatan Deret Maclaurin');
legend('f_{eksak}', 'f_{n=23}', 'f_{n=24}', 'f_{n=25}', 'location', 'east');
print(fig1, fullfile(folder_hasil, 'kasus1_grafik_perbandingan.png'), '-dpng', '-r130');

%% 6. Grafik 2: tampilan skala penuh ('visible', 'on')
fig2 = figure('visible', 'on', 'position', [150 150 900 520]);
plot(t, h_eksak, 'k-', 'LineWidth', 2.5); hold on;
for i = 1:jumlah_n
    plot(t, h_pend(i, :), warna{i}, 'LineWidth', 1.8);
end
grid on;
ylim([0, 1.3 * h0 * exp(x)]);
xlabel('t'); ylabel('h(t)');
title('Tampilan skala penuh: keempat kurva praktis berimpit');
legend('f_{eksak}', 'f_{n=23}', 'f_{n=24}', 'f_{n=25}', 'location', 'northeast');
print(fig2, fullfile(folder_hasil, 'kasus1_grafik_skala_penuh.png'), '-dpng', '-r130');

%% 7. Grafik 3: galat mutlak terhadap t ('visible', 'on')
fig3 = figure('visible', 'on', 'position', [200 200 900 520]);
semilogy(t, max(gal_mut(1, :), 1e-12), 'r-', 'LineWidth', 1.8); hold on;
semilogy(t, max(gal_mut(2, :), 1e-12), 'g-', 'LineWidth', 1.8);
semilogy(t, max(gal_mut(3, :), 1e-12), 'b-', 'LineWidth', 1.8);
grid on;
xlabel('t'); ylabel('Galat mutlak (skala log)');
title('Galat mutlak pendekatan terhadap nilai eksak');
legend('n = 23', 'n = 24', 'n = 25', 'location', 'east');
print(fig3, fullfile(folder_hasil, 'kasus1_grafik_galat.png'), '-dpng', '-r130');
end

function s = taylor_cos(z, n)
    suku = ones(size(z));
    s    = suku;
    for k = 1:n
        suku = suku .* (-z.^2) ./ ((2*k - 1) * (2*k));
        s    = s + suku;
    end
end

function s = taylor_exp(x, n)
    suku = ones(size(x));
    s    = suku;
    for k = 1:n
        suku = suku .* x ./ k;
        s    = s + suku;
    end
end

%% ===================== KASUS 2 : SPL =====================
function kasus2_spl()
%% =====================================================================
%  KASUS 2 : SPL (Gauss-Seidel & Gauss) - Harga Bahan Makanan per Kilogram
%% =====================================================================
data = [ 2.5   1500    5     500;
         40    0.75    1000   2;
         2000  15      50     6000;
         1     4250    20     9 ];
pembagi = [ 1    1000  1     1000;
            10   1     1000  1;
            1000 10    100   1000;
            1    1000  10    10 ];
total = [161000; 149000; 251500; 173000];

A = data ./ pembagi;
b = total;
disp('Matriks koefisien A (dalam kg):'); disp(A);
disp('Vektor konstanta b (Rp):');        disp(b);

diag_abs   = abs(diag(A));
sisa_baris = sum(abs(A), 2) - diag_abs;
fprintf('\n[Uji dominan diagonal - urutan baris asli]\n');
for i = 1:4
    fprintf('Baris %d : |a_ii| = %.4f  vs  jumlah |a_ij| (j!=i) = %.4f  -> %s\n', ...
            i, diag_abs(i), sisa_baris(i), ternary(diag_abs(i) > sisa_baris(i), 'dominan', 'TIDAK dominan'));
end

rho_asli = jari_spektral_gs(A);
fprintf('\nJari-jari spektral Gauss-Seidel (urutan asli) = %.4f -> %s\n', ...
        rho_asli, ternary(rho_asli < 1, 'konvergen', 'TIDAK konvergen'));

[~, ~, riw] = gauss_seidel(A, b, zeros(4, 1), 1e-6, 10);
fprintf('\n[Gauss-Seidel urutan asli, tebakan awal nol -> terlihat DIVERGEN]\n');
fprintf('%-4s | %-16s %-16s %-16s %-16s\n', 'Iter', 'x1', 'x2', 'x3', 'x4');
for i = 1:size(riw, 1)
    fprintf('%-4d | %-16.4g %-16.4g %-16.4g %-16.4g\n', riw(i, 1:5));
end

P = perms(1:4);
urutan = [];
for k = 1:size(P, 1)
    Ap = A(P(k, :), :);
    if all(abs(diag(Ap)) > sum(abs(Ap), 2) - abs(diag(Ap)))
        urutan = P(k, :);
        break;
    end
end
nama_orang = {'Adel', 'Briza', 'Caca', 'Dinda'};
fprintf('\nUrutan baris yang dominan diagonal: %s\n', mat2str(urutan));
fprintf('Artinya: %s\n', strjoin(nama_orang(urutan), ' -> '));

A2 = A(urutan, :);  b2 = b(urutan);
disp('Matriks A setelah baris disusun ulang:'); disp(A2);
disp('Vektor b setelah baris disusun ulang:');    disp(b2);
for i = 1:4
    fprintf('Baris %d : |a_ii| = %.4f  >  jumlah |a_ij| (j!=i) = %.4f\n', ...
            i, abs(A2(i, i)), sum(abs(A2(i, :))) - abs(A2(i, i)));
end
rho_baru = jari_spektral_gs(A2);
fprintf('Jari-jari spektral Gauss-Seidel (urutan baru) = %.4f -> konvergen\n', rho_baru);

tol = 1e-6;  maxit = 100;
[xgs, iter, riw2] = gauss_seidel(A2, b2, zeros(4, 1), tol, maxit);
fprintf('\n===== GAUSS-SEIDEL (tebakan awal 0, toleransi %.0e) =====\n', tol);
fprintf('%-4s | %-14s %-14s %-14s %-14s | %s\n', 'Iter', 'x1 (beras)', 'x2 (telur)', 'x3 (tepung)', 'x4 (ayam)', 'Galat maks');
for i = 1:size(riw2, 1)
    fprintf('%-4d | %-14.4f %-14.4f %-14.4f %-14.4f | %.4e\n', riw2(i, :));
end
fprintf('Konvergen setelah %d iterasi\n', iter);

xg = gauss_elim(A, b, false);
fprintf('\n[Verifikasi]\n');
fprintf('Determinan A                 = %.6f (tidak nol -> solusi tunggal)\n', det(A));
fprintf('Residu max |A*x_gs - b|      = %.3e\n', max(abs(A * xgs - b)));
fprintf('Selisih max |x_gs - x_gauss| = %.3e\n', max(abs(xgs - xg)));
fprintf('Eliminasi Gauss              = %s\n', mat2str(xg', 8));

fprintf('\n===== HASIL AKHIR =====\n');
nama = {'Beras', 'Telur', 'Tepung', 'Ayam'};
for i = 1:4
    fprintf('Harga %-7s = Rp %10.2f per kg\n', nama{i}, xgs(i));
end
end

function [x, iter, riwayat] = gauss_seidel(A, b, x0, tol, maxit)
    n = length(b);
    x = x0(:);
    riwayat = [];
    for iter = 1:maxit
        xlama = x;
        for i = 1:n
            jumlah = A(i, [1:i-1, i+1:n]) * x([1:i-1, i+1:n]);
            x(i)   = (b(i) - jumlah) / A(i, i);
        end
        galat   = max(abs(x - xlama));
        riwayat = [riwayat; iter, x', galat];
        if galat < tol, return; end
    end
end

function rho = jari_spektral_gs(A)
    D = diag(diag(A));  L = tril(A, -1);  U = triu(A, 1);
    T = -((D + L) \ U);
    rho = max(abs(eig(T)));
end

function [x, Aug] = gauss_elim(A, b, tampil)
    if nargin < 3, tampil = false; end
    n   = length(b);
    Aug = [A, b(:)];
    if tampil, disp('Matriks augmented awal [A | b]:'); disp(Aug); end

    for k = 1:n-1
        [~, idx] = max(abs(Aug(k:n, k)));
        p = idx + k - 1;
        if abs(Aug(p, k)) < 1e-12
            error('Matriks singular, SPL tidak punya solusi tunggal.');
        end
        if p ~= k
            Aug([k p], :) = Aug([p k], :);
            if tampil, fprintf('Tukar baris %d <-> %d\n', k, p); end
        end
        for i = k+1:n
            m = Aug(i, k) / Aug(k, k);
            Aug(i, :) = Aug(i, :) - m * Aug(k, :);
        end
    end

    x = zeros(n, 1);
    x(n) = Aug(n, n+1) / Aug(n, n);
    for i = n-1:-1:1
        x(i) = (Aug(i, n+1) - Aug(i, i+1:n) * x(i+1:n)) / Aug(i, i);
    end
end

function out = ternary(kondisi, a, b)
    if kondisi, out = a; else, out = b; end
end

%% ===================== KASUS 3 : PERSAMAAN NON LINIER =====================
function kasus3_nonlinear()
%% =====================================================================
%  KASUS 3 : Persamaan Non Linier - Volume Tabung di Luar Bola (Biseksi)
%% =====================================================================
folder = fileparts(mfilename('fullpath'));
if isempty(folder), folder = pwd; end
folder_hasil = fullfile(folder, 'hasil');
if ~exist(folder_hasil, 'dir'), mkdir(folder_hasil); end

V_bola = 300;
f = @(r) (4/3) * pi * r.^3 - V_bola;

r = 2:0.02:6;
fig = figure('visible', 'on', 'position', [100 100 900 520]); % Diubah menjadi 'on'
plot(r, f(r), 'b-', 'LineWidth', 2); hold on;
plot([2 6], [0 0], 'k-', 'LineWidth', 1);
plot([4 5], f([4 5]), 'ro', 'MarkerFaceColor', 'r');
grid on;
xlabel('r (cm)'); ylabel('f(r)');
title('Grafik f(r) = (4/3) \pi r^3 - 300');
legend('f(r)', 'f(r) = 0', 'Titik awal a = 4 dan b = 5', 'location', 'northwest');
print(fig, fullfile(folder_hasil, 'kasus3_grafik.png'), '-dpng', '-r130');

a = 4;  b = 5;
fprintf('f(%g) = %.4f\n', a, f(a));
fprintf('f(%g) = %.4f\n', b, f(b));
fprintf('f(a)*f(b) = %.4f (< 0 -> ada akar di [%g, %g])\n\n', f(a) * f(b), a, b);

tol = 1e-6;  maxit = 100;
[akar, iter, tabel] = bisection(f, a, b, tol, maxit);
fprintf('%-4s %-10s %-10s %-10s %-11s %-11s %-11s %-10s\n', ...
        'Iter', 'a', 'b', 'c', 'f(a)', 'f(b)', 'f(c)', 'b-a');
for i = 1:size(tabel, 1)
    fprintf('%-4d %-10.6f %-10.6f %-10.6f %-11.5f %-11.5f %-11.5f %-10.6f\n', tabel(i, :));
end

r_bola = akar;
t_tabung = 2 * r_bola;
V_bola_cek = (4/3) * pi * r_bola^3;
V_tabung   = pi * r_bola^2 * t_tabung;
V_luar     = V_tabung - V_bola_cek;
V_rumus    = (2/3) * pi * r_bola^3;

fprintf('\n===== HASIL =====\n');
fprintf('Jumlah iterasi                 = %d\n', iter);
fprintf('Jari-jari bola = tabung (r)    = %.6f cm\n', r_bola);
fprintf('Tinggi tabung (t = 2r)         = %.6f cm\n', t_tabung);
fprintf('Volume bola (cek)              = %.6f cm^3\n', V_bola_cek);
fprintf('Volume tabung                  = %.6f cm^3\n', V_tabung);
fprintf('Volume tabung di luar bola     = %.6f cm^3\n', V_luar);
fprintf('Cek dengan V = (2/3)*pi*r^3    = %.6f cm^3\n', V_rumus);

r_analitik = (225 / pi)^(1/3);
fprintf('\nr analitik = (225/pi)^(1/3)    = %.6f cm\n', r_analitik);
fprintf('Selisih |r_biseksi - r_analitik| = %.3e\n', abs(r_bola - r_analitik));
end

function [r, iter, tabel] = bisection(f, a, b, tol, maxit)
    if f(a) * f(b) > 0
        error('f(a) dan f(b) harus berlawanan tanda.');
    end
    tabel = [];
    for iter = 1:maxit
        c = (a + b) / 2;
        tabel = [tabel; iter, a, b, c, f(a), f(b), f(c), b - a];
        if abs(f(c)) == 0 || (b - a) / 2 < tol
            break;
        end
        if f(a) * f(c) < 0
            b = c;
        else
            a = c;
        end
    end
    r = c;
end
