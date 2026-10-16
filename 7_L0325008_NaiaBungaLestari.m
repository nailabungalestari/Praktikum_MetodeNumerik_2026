% =====================================================================
%  PENCARIAN AKAR PERSAMAAN NON LINEAR
%  1) Metode grafik tunggal & grafik ganda
%  2) Metode Biseksi & Regula-Falsi (maks iterasi 20, toleransi 0.0001)
%
%  Persamaan:
%   (1) y = 3x^3 - 5x^2 + 4x - 7      , dengan y = 1
%   (2) y = e^x - x^2                 , dengan y = 0
%   (3) y = log(x+2) + 2x - 3         , dengan y = 0   (log basis 10)
%
%  Cara pakai: jalankan  >> akar_persamaan
% =====================================================================
1;  % penanda bahwa ini file script (bukan file function)

% ---------------------------------------------------------------------
%  FUNGSI METODE BISEKSI
% ---------------------------------------------------------------------
function [akar, tabel] = biseksi(f, a, b, tol, maxit)
  if f(a) * f(b) > 0
    error('Interval [%g, %g] tidak mengapit akar (f(a)*f(b) > 0)', a, b);
  end
  fa = f(a);
  tabel = [];
  xr_lama = a;
  for i = 1:maxit
    xr  = (a + b) / 2;
    fxr = f(xr);
    if i == 1
      ea = NaN;
    else
      ea = abs(xr - xr_lama);
    end
    tabel(end+1, :) = [i, a, b, xr, fxr, ea];
    if fxr == 0 || (i > 1 && ea < tol)
      break;
    end
    if fa * fxr < 0
      b = xr;
    else
      a = xr;
      fa = fxr;
    end
    xr_lama = xr;
  end
  akar = xr;
end

% ---------------------------------------------------------------------
%  FUNGSI METODE REGULA-FALSI
% ---------------------------------------------------------------------
function [akar, tabel] = regulafalsi(f, a, b, tol, maxit)
  if f(a) * f(b) > 0
    error('Interval [%g, %g] tidak mengapit akar (f(a)*f(b) > 0)', a, b);
  end
  fa = f(a);
  fb = f(b);
  tabel = [];
  xr_lama = a;
  for i = 1:maxit
    xr  = (a * fb - b * fa) / (fb - fa);
    fxr = f(xr);
    if i == 1
      ea = NaN;
    else
      ea = abs(xr - xr_lama);
    end
    tabel(end+1, :) = [i, a, b, xr, fxr, ea];
    if fxr == 0 || (i > 1 && ea < tol)
      break;
    end
    if fa * fxr < 0
      b = xr;  fb = fxr;
    else
      a = xr;  fa = fxr;
    end
    xr_lama = xr;
  end
  akar = xr;
end

% ---------------------------------------------------------------------
%  FUNGSI MENCETAK TABEL ITERASI
% ---------------------------------------------------------------------
function cetak_tabel(judul, tabel)
  printf('\n%s\n', judul);
  printf('%-5s %-12s %-12s %-12s %-14s %-12s\n', ...
         'Iter', 'a', 'b', 'xr', 'f(xr)', 'Error');
  printf('%s\n', repmat('-', 1, 72));
  for k = 1:rows(tabel)
    if isnan(tabel(k,6))
      err_str = '-';
    else
      err_str = sprintf('%.6f', tabel(k,6));
    end
    printf('%-5d %-12.6f %-12.6f %-12.6f %-14.6f %-12s\n', ...
           tabel(k,1), tabel(k,2), tabel(k,3), tabel(k,4), tabel(k,5), err_str);
  end
end

% =====================================================================
%  PROGRAM UTAMA
% =====================================================================
tol   = 0.0001;   % batas error toleransi
maxit = 20;       % maksimal iterasi

% Pilihan basis logaritma untuk persamaan (3):
%   false -> log natural (ln), bawaan Octave  : log(x)
%   true  -> log basis 10                     : log10(x)
pakai_log10 = true;      % sesuai hitungan tulis tangan (log basis 10)
if pakai_log10
  lg = @(x) log10(x);
else
  lg = @(x) log(x);
end

% ---------------------------------------------------------------------
%  DEFINISI PERSAMAAN
%   f  : f(x) = 0                     (untuk grafik tunggal & numerik)
%   ya : sisi kiri  (grafik ganda)
%   yb : sisi kanan (grafik ganda)
% ---------------------------------------------------------------------
nama = {'Persamaan 1: 3x^3 - 5x^2 + 4x - 7 = 1', ...
        'Persamaan 2: e^x - x^2 = 0', ...
        'Persamaan 3: log(x+2) + 2x - 3 = 0'};

% (1) 3x^3 - 5x^2 + 4x - 7 = 1  ->  3x^3 - 5x^2 + 4x - 8 = 0
f{1}  = @(x) 3*x.^3 - 5*x.^2 + 4*x - 7 - 1;
ya{1} = @(x) 3*x.^3 - 5*x.^2 + 4*x - 7;
yb{1} = @(x) ones(size(x)) * 1;
lbl_a{1} = 'y_1 = 3x^3 - 5x^2 + 4x - 7';   lbl_b{1} = 'y_2 = 1';
rentang{1} = [0 3];       % rentang gambar grafik
interval{1} = [1 2];      % interval awal akar

% (2) e^x - x^2 = 0  ->  e^x = x^2
f{2}  = @(x) exp(x) - x.^2;
ya{2} = @(x) exp(x);
yb{2} = @(x) x.^2;
lbl_a{2} = 'y_1 = e^x';   lbl_b{2} = 'y_2 = x^2';
rentang{2} = [-2 2];
interval{2} = [-1 0];

% (3) log(x+2) + 2x - 3 = 0  ->  log(x+2) = 3 - 2x
f{3}  = @(x) lg(x + 2) + 2*x - 3;
ya{3} = @(x) lg(x + 2);
yb{3} = @(x) 3 - 2*x;
lbl_a{3} = 'y_1 = log(x+2)';   lbl_b{3} = 'y_2 = 3 - 2x';
rentang{3} = [-1.9 3];
interval{3} = [1 2];

% ---------------------------------------------------------------------
%  PROSES UNTUK SETIAP PERSAMAAN
% ---------------------------------------------------------------------
for n = 1:3
  printf('\n%s\n', repmat('=', 1, 70));
  printf('%s\n', nama{n});
  printf('%s\n', repmat('=', 1, 70));

  a = interval{n}(1);
  b = interval{n}(2);
  printf('Interval awal: [%g, %g]   f(a) = %.4f,  f(b) = %.4f\n', ...
         a, b, f{n}(a), f{n}(b));

  % ---- Metode numerik ----
  [akar_bis, tab_bis] = biseksi(f{n}, a, b, tol, maxit);
  [akar_rf,  tab_rf]  = regulafalsi(f{n}, a, b, tol, maxit);

  cetak_tabel('--- METODE BISEKSI ---', tab_bis);
  printf('Akar (biseksi)       = %.6f  (iterasi: %d, f(akar) = %.2e)\n', ...
         akar_bis, rows(tab_bis), f{n}(akar_bis));

  cetak_tabel('--- METODE REGULA-FALSI ---', tab_rf);
  printf('Akar (regula-falsi) = %.6f  (iterasi: %d, f(akar) = %.2e)\n', ...
         akar_rf, rows(tab_rf), f{n}(akar_rf));

  % ---- Grafik ----
  x = linspace(rentang{n}(1), rentang{n}(2), 500);

  figure(n);
  set(gcf, 'name', nama{n});

  % (a) Grafik tunggal: f(x) memotong sumbu-x
  subplot(1, 2, 1);
  plot(x, f{n}(x), 'b-', 'linewidth', 2); hold on;
  plot(x, zeros(size(x)), 'k-');                        % sumbu x
  plot(akar_bis, 0, 'ro', 'markersize', 9, 'linewidth', 2);
  grid on;
  xlabel('x'); ylabel('f(x)');
  title(['Grafik Tunggal - ', nama{n}]);
  legend('f(x)', 'y = 0', sprintf('akar \\approx %.4f', akar_bis), ...
         'location', 'northeast');
  hold off;

  % (b) Grafik ganda: perpotongan dua kurva
  subplot(1, 2, 2);
  plot(x, ya{n}(x), 'b-', 'linewidth', 2); hold on;
  plot(x, yb{n}(x), 'r-', 'linewidth', 2);
  plot(akar_bis, ya{n}(akar_bis), 'ko', 'markersize', 9, 'linewidth', 2);
  grid on;
  xlabel('x'); ylabel('y');
  title(['Grafik Ganda - ', nama{n}]);
  legend(lbl_a{n}, lbl_b{n}, ...
         sprintf('titik potong x \\approx %.4f', akar_bis), 'location', 'northeast');
  hold off;
end

% ---------------------------------------------------------------------
%  RINGKASAN
% ---------------------------------------------------------------------
printf('\n=================== RINGKASAN HASIL AKAR ===================\n');
printf('%-12s %-12s %-12s\n', 'Persamaan', 'Biseksi', 'Regula-Falsi');
for n = 1:3
  [rb, tb] = biseksi(f{n}, interval{n}(1), interval{n}(2), tol, maxit);
  [rr, tr] = regulafalsi(f{n}, interval{n}(1), interval{n}(2), tol, maxit);
  printf('%-12d %-9.6f (%2d it) %-9.6f (%2d it)\n', n, rb, rows(tb), rr, rows(tr));
end
