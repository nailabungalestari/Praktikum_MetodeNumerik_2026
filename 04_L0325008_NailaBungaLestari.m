clc;
clear;

%% =========================================================================
% SOAL 1: Deret Taylor e^(0.3) dengan n = {0, 1, 2, 3, 4}
% =========================================================================
fprintf('=================== SOAL 1: Deret Taylor e^(0.3) ===================\n');
x1 = 0.3;
eksak1 = exp(x1);
n_set1 = [0, 1, 2, 3, 4];

% Loop 1 (Luar): Iterasi untuk setiap nilai n
for idx = 1:length(n_set1)
    n = n_set1(idx);
    hampiran = 0;

    % Loop 2 (Dalam): Penjumlahan suku i = 0 sampai n
    for i = 0:n
        % Hitung faktorial i! secara manual
        faktorial = 1;
        for j = 1:i
            faktorial = faktorial * j;
        end

        suku = (x1^i) / faktorial;
        hampiran = hampiran + suku;
    end

    galat = abs(eksak1 - hampiran);
    fprintf('n = %d | Hampiran = %.7f | Galat = %.7f\n', n, hampiran, galat);
end


%% =========================================================================
% SOAL 2: Deret Harmonik (1/1 + 1/2 + 1/3 + ... + 1/20)
% =========================================================================
fprintf('\n=================== SOAL 2: Deret Harmonik ===================\n');

% a. Perhitungan secara eksak
eksak2 = 0;
for i = 1:20
    eksak2 = eksak2 + (1 / i);
end

% b. Masing-masing pembagian dibulatkan (misal: 3 desimal) menggunakan 2 loop
hampiran_dibulatkan = 0;
for i = 1:20               % Loop 1: Iterasi suku 1 sampai 20
    for dummy = 1:1        % Loop 2: Simulasi perulangan ke-2
        pembagian = round((1 / i) * 1000) / 1000; % Pembulatan 3 angka desimal
        hampiran_dibulatkan = hampiran_dibulatkan + pembagian;
    end
end
galat2_b = abs(eksak2 - hampiran_dibulatkan);

% c. Tanpa looping (menggunakan fungsi sum dan array/vektor)
vektor_suku = 1 ./ (1:20);
hampiran_sum = sum(vektor_suku);

fprintf('a. Perhitungan secara eksak           : %.7f\n', eksak2);
fprintf('b. Masing-masing dibulatkan (3 des)   : %.7f | Galat = %.7f\n', hampiran_dibulatkan, galat2_b);
fprintf('c. Tanpa looping (menggunakan sum)    : %.7f\n', hampiran_sum);


%% =========================================================================
% SOAL 3: Deret Taylor sin(x) dengan x = 1 dan N = {1, 2, 3, 4, 5}
% =========================================================================
fprintf('\n=================== SOAL 3: Deret Taylor sin(1) ===================\n');
x3 = 1.0;
eksak3 = sin(x3);
N_set3 = [1, 2, 3, 4, 5];

% Loop 1 (Luar): Iterasi untuk setiap nilai N
for idx = 1:length(N_set3)
    N = N_set3(idx);
    hampiran = 0;

    % Loop 2 (Dalam): Penjumlahan suku n = 0 sampai N
    for n = 0:N
        pangkat = 2 * n + 1;

        % Hitung faktorial (2n + 1)! secara manual
        faktorial = 1;
        for k = 1:pangkat
            faktorial = faktorial * k;
        end

        suku = ((-1)^n) * (x3^pangkat) / faktorial;
        hampiran = hampiran + suku;
    end

    galat = abs(eksak3 - hampiran);
    fprintf('N = %d | Hampiran = %.8f | Galat = %.8f\n', N, hampiran, galat);
end
