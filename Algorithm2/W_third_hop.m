function W_function = W_third_hop(n, modR, h)

switch n
    case 1
        omega = 10.2 * 10^3 * (2*pi);
    case 2
        omega = 12.1 * 10^3 * (2*pi);
    case 3
        omega = 13.6 * 10^3 * (2*pi);
end

% contants
R = 6370;
d = 885;
theta = d / R;
epsilon_m = 10;
epsilon_0 = 8.85 * 10^(-12);
sigma = 10^(-3);
c = 2.997992 * 10^5;

% difractional wave hop
W_0 = 0.65 * exp(1i);

% first hop
a_1 = 2 * R * sin(theta/2);
b_1 = R * cos(theta/2);
c_1 = R * tan(theta/2);
d_1 = c_1 * sin(theta/2);
e_1 = (R + h) - (d_1 + b_1);
tau_1 = 2 * sqrt(a_1^2/4 + (e_1 + d_1)^2);
I_1 = pi/2 - acos((tau_1^2/4 + c_1^2 - e_1^2) / (tau_1 * c_1));
psi_1 = acos((tau_1^2/4 + e_1^2 - c_1^2) / (e_1 * tau_1));
alpha_1 = sqrt((2 * sin(theta/2)) / sin(theta)) * sqrt((cos(psi_1) / cos(I_1)));
delta_g = 1 / sqrt(epsilon_m + (1i * sigma) / (omega * epsilon_0));
R_g = (cos(I_1) - delta_g) / (cos(I_1) + delta_g);
switch n
    case 1
        argR = pi + 0.35 * ((pi/2 - psi_1) / (pi/2 - psi_1));
    case 2
        argR = pi;
    case 3
        argR = pi - 0.35 * ((pi/2 - psi_1) / (pi/2 - psi_1));
end
tau_real_1 = omega/c * (tau_1 - d);

W_1 = alpha_1/2 * sin(I_1)^2 * (1 + R_g)^2 * modR * exp(1i * (tau_real_1 + argR));

% second hop
a_2 = 2 * R * sin(theta/4);
b_2 = R * cos(theta/4);
c_2 = R * tan(theta/4);
d_2 = c_2 * sin(theta/4);
e_2 = (R + h) - (d_2 + b_2);
tau_2 = 2 * sqrt(a_2^2/4 + (e_2 + d_2)^2);
I_2 = pi/2 - acos((tau_2^2/4 + c_2^2 - e_2^2) / (tau_2 * c_2));
psi_2 = acos((tau_2^2/4 + e_2^2 - c_2^2) / (e_2 * tau_2));
alpha_2 = sqrt((4 * sin(theta/4)) / sin(theta)) * sqrt((cos(psi_2) / cos(I_2)));
delta_g = 1 / sqrt(epsilon_m + (1i * sigma) / (omega * epsilon_0));
R_g = (cos(I_2) - delta_g) / (cos(I_2) + delta_g);
switch n
    case 1
        argR = pi + 0.35 * ((pi/2 - psi_2) / (pi/2 - psi_2));
    case 2
        argR = pi;
    case 3
        argR = pi - 0.35 * ((pi/2 - psi_2) / (pi/2 - psi_2));
end
tau_real_2 = omega/c * (2*tau_2 - d);

R_2 = modR + (1 - modR) * (psi_2 - psi_1) / (pi/2 - psi_1);
if R_2 < 0 
    R_2 = 0;
end

W_2 = alpha_2/2 * sin(I_2)^2 * (1 + R_g)^2 * R_2^2 * R_g * exp(1i * (tau_real_2 + 2*argR));

% third hop
a_3 = 2 * R * sin(theta/6);
b_3 = R * cos(theta/6);
c_3 = R * tan(theta/6);
d_3 = c_3 * sin(theta/6);
e_3 = (R + h) - (d_3 + b_3);
tau_3 = 2 * sqrt(a_3^2/4 + (e_3 + d_3)^2);
I_3 = pi/2 - acos((tau_3^2/4 + c_3^2 - e_3^2) / (tau_3 * c_3));
psi_3 = acos((tau_3^2/4 + e_3^2 - c_3^2) / (e_3 * tau_3));
alpha_3 = sqrt((6 * sin(theta/6)) / sin(theta)) * sqrt((cos(psi_3) / cos(I_3)));
delta_g = 1 / sqrt(epsilon_m + (1i * sigma) / (omega * epsilon_0));
R_g = (cos(I_3) - delta_g) / (cos(I_3) + delta_g);
switch n
    case 1
        argR = pi + 0.35 * ((pi/2 - psi_2) / (pi/2 - psi_2));
    case 2
        argR = pi;
    case 3
        argR = pi - 0.35 * ((pi/2 - psi_2) / (pi/2 - psi_2));
end
tau_real_3 = omega/c * (3*tau_3 - d);

R_3 = modR + (1 - modR) * (psi_3 - psi_1) / (pi/2 - psi_1);
if R_3 < 0 
    R_3 = 0;
end

W_3 = alpha_3/2 * sin(I_3)^2 * (1 + R_g)^2 * R_3^3 * R_g^2 * exp(1i * (tau_real_3 + 2*argR));

W_function = W_0 + W_1 + W_2 + W_3;