%% Test 1: freq = 12.1 kHz, R = 0.7, h = 70 km
%expected = 1.313785060243455 + 1.607461215439455i;
expected = 1.31 + 1.61i;

W_function = W(2, 0.7, 70, 0);
actual = round(W_function, 2);

assert(expected == actual)