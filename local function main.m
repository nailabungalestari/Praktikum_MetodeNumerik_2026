function main_function(nama)
    fprintf('Pengguna terdaftar: %s!\n', nama);
    cetak_inisiator(nama);
end

function cetak_inisiator(nama)
    fprintf('Huruf pertama dari nama "%s" adalah %c.\n', nama, nama(1));
end
