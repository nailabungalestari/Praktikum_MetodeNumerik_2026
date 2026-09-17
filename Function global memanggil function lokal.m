function sapa2(param)
    fprintf('Nama saya %s!\n', param)
    cekAwalan(param)
end

function cekAwalan(param)
    fprintf('Kata "%s" diawali dengan huruf %c.\n', param, param(1))
end
