B = xlsread('DATA_891001_FULL_CORRECT.xlsx', 'B1:G864');
C = xlsread('DATA_891001_FULL_CORRECT.xlsx', 'H1:M49');

for i = 1:24
    B_ind_first = 36 * ( i - 1 ) + 1;
    C_ind_first = 2 * ( i - 1 ) + 1;
    B_ind_last = 36 * ( i - 1 ) + 36;
    C_ind_last = 2 * ( i - 1 ) + 3;
    for j = 1:6
        for k = 0:35
            B1 = ( B(B_ind_first, j) + B(B_ind_first+1, j) ) / 2;
            B2 = ( B(B_ind_last, j) + B(B_ind_last-1, j) ) / 2;
            X_lin_cor = ( C(C_ind_last, j) - C(C_ind_first, j) ) / 36 * k + C(C_ind_first, j);
            X_lin_nonecor = ( B2 - B1 ) / 36 * k + B1;
            B(B_ind_first+k, j) = B(B_ind_first+k, j) + ( X_lin_cor - X_lin_nonecor );
        end
    end
end

xlswrite('DATA_891001_FULL_CORRECT.xlsx', B, 'N1:S864')