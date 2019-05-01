function [A, P] = CorrectFun(A, P, C)

B = [A', P'];

    for j = 1:6
        B_1 = B(1, j);
        B_36 = B(36, j);
        for k = 0:35
            X_lin_cor = ( C(2, j) - C(1, j) ) / 35 * k + C(1, j);
            X_lin_nonecor = ( B_36 - B_1 ) / 35 * k + B_1;
            B(1+k, j) = B(1+k, j) + ( X_lin_cor - X_lin_nonecor );
        end
    end

A = B(:,1:3)';
P = B(:,4:6)';
