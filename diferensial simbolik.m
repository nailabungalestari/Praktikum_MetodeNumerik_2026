syms x
f_asli = sym('x^2 + 5*x + 7')
f_turunan = diff(f_asli, 'x')

f_asli2 = sym('3*x^4 - 2*x^2 + 6*x')
f_turunan2 = diff(f_asli2, 'x')
