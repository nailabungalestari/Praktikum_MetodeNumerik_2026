syms x
f_asli = sym('sin(3*x) - 2*x^3')
f_integral = int(f_asli, 'x')

f_asli2 = sym('4*x^3 + cos(2*x)')
f_integral2 = int(f_asli2, 'x')
