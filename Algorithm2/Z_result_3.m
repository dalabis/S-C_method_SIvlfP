function [R, h, S] = Z_result_3(R0, h0, B, dis)
%Вычисление временных зависимостей эффективной высоты и модуля коэффициента
%отражения по заданным вариациям амплитуд и фаз и начальным значениям
%искомых R(t) и h(t) (детальное описание подпрограммы Z(R0, h0) приведено 
%в разделе 5 описания "ММетод_пособ_end")

    u = size(B, 1);

    R(1:u,1:3) = 0;
    h(1:u,1:3) = 0;

    R(1,:) = [R0,R0,R0];
    h(1,:) = [h0,h0,h0];

    S(1:u,1:3) = 0;

    a(1:3) = 0;
    c(1:3) = 0;
    v(1:3) = 0;
    vv(1:3) = 0;
    SE(1:3) = 0;
    Sphi(1:3) = 0;
    s(1:3) = 0;
    V(1:3) = 0;
    VV(1:3) = 0;
    C(1:3, 1:3) = 0;
    AAA(1:3) = 0;

    % initial normal values (common for the every solution)
    for j = 1:3
        a(j) = B(1,j) / abs(W(j, R0, h0, dis));
        c(j) = B(1,j+3) * omega(j)*10^(-6) - angle(W(j, R0, h0, dis));
    end

    for n = 1:3
        for m = 1:(u-1)
            for j = 1:3
                %проверка перехода фазы через начало отсчета, в случае прохождения
                %обеспечивается неразрывность путем прибавления 2Пи либо -2Пи
                if m > 1
                    if abs(angle(W(j, R(m,n), h(m,n), dis)) - angle(W(j, R(m-1,n), h(m-1,n), dis))) ...
                            > abs(angle(W(j, R(m,n), h(m,n), dis)) - angle(W(j, R(m-1,n), h(m-1,n), dis)) + 2*pi)
                        AAA(j) = AAA(j)+1;
                    elseif abs(angle(W(j, R(m,n), h(m,n), dis)) -angle(W(j, R(m-1,n), h(m-1,n), dis))) ...
                            > abs(angle(W(j, R(m,n), h(m,n), dis)) -angle(W(j, R(m-1,n), h(m-1,n), dis)) - 2*pi)
                        AAA(j) = AAA(j)-1;
                    end
                end

                v(j) = modWR(j, R(m,n), h(m,n), dis) / abs(W(j, R(m,n), h(m,n), dis));
                vv(j) = modWh(j, R(m,n), h(m,n), dis) / abs(W(j, R(m,n), h(m,n), dis));
                SE(j) = abs(a(j) * abs(W(j, R(m,n), h(m,n), dis)) - B(m, j))^2 / abs(B(1, j))^2;
                Sphi(j) = abs(c(j) + angle(W(j, R(m,n), h(m,n), dis)) + AAA(j)*2*pi - B(m, j+3) * omega(j)*10^(-6))^2 / ...
                    ((B(1, j+3) - B(u, j+3)) * omega(j)*10^(-6))^2;
                s(j) = SE(j) + Sphi(j);
                for k = 1:3
                    V(k) = argWR(k, R(m,n), h(m,n), dis);
                    VV(k) = argWh(k, R(m,n), h(m,n), dis);
                    A = [v(j), vv(j); V(k), VV(k)];
                    C(j, k) = abs(det(A));
                end
            end

            % finding first maximal determinant for n = 1
            % second maximal determinant for n = 2
            % third maximal determinant for n = 3
            switch n
                case 1
                    [row, col] = find(C == max(C(:)));
                case 2
                    [row, col] = find(C == max(C(:)));
                    C(row,col) = 0;
                    [row, col] = find(C == max(C(:)));
                case 3
                    [row, col] = find(C == max(C(:)));
                    C(row,col) = 0;
                    [row, col] = find(C == max(C(:)));
                    C(row,col) = 0;
                    [row, col] = find(C == max(C(:)));
            end

            if m == 1
                S(m,n) = s(1) + s(2) + s(3);
            else
                S(m,n) = S(m - 1,n) + s(1) + s(2) + s(3);
            end

            AA = [v(row), vv(row); V(col), VV(col)];
            b = [(B(m+1, row) - B(m, row)) / B(m+1, row); (B(m+1, col+3) - B(m, col+3))*omega(col)*10^(-6)];
            Z = AA \ b;
            DeltaR = Z(1);
            Deltah = Z(2);
            R(m+1,n) = R(m,n) + DeltaR;
            h(m+1,n) = h(m,n) + Deltah;
        end

        for j =1:3
            SE(j) = abs(a(j) * abs(W(j, R(u,n), h(u,n), dis)) - B(u, j))^2 / abs(B(1, j))^2;
            Sphi(j) = abs(c(j) + angle(W(j, R(u,n), h(u,n), dis)) + AAA(j)*2*pi - B(u, j+3) * omega(j)*10^(-6))^2 / ...
                ((B(1, j+3) - B(u, j+3)) * omega(j)*10^(-6))^2;
            s(j) = SE(j) + Sphi(j);
        end
    end

    S(u,n) = S(u-1,n) + s(1) + s(2) + s(3);
end

%Вычисление частных производных модуля и аргумента функции ослабления
function modWh = modWh(n, R, h, dis)
dh = 0.5;
modWh =(abs(W(n, R, h + dh, dis)) - abs(W(n, R, h - dh, dis))) / (2 * dh);
end

function modWR = modWR(n, R, h, dis)
dR = 0.05;
modWR =(abs(W(n, R + dR, h, dis)) - abs(W(n, R - dR, h, dis))) / (2 * dR);
end

function argWh = argWh(n, R, h, dis)

dh = 0.5;

%на тот случай, когда точка разрыва оказывается в отрезке, для которого
%считается частная производная, производится проверка непрерывности
%дополнительно
A(1:3) = 0;

A(1) = angle( W(n, R, h +dh, dis)) - angle( W(n, R, h -dh, dis) );
A(2) = angle( W(n, R, h +dh, dis)) - angle( W(n, R, h -dh, dis) ) + 2*pi;
A(3) = angle( W(n, R, h +dh, dis)) - angle( W(n, R, h -dh, dis) ) - 2*pi ;

[~, i] = min( abs(A(:)));

argWh =A(i) / (2*dh);

end

function argWR = argWR(n, R, h, dis)

dR =0.05;

A(1:3)=0;

A(1) =angle(W(n, R + dR, h, dis)) - angle(W(n, R - dR, h, dis));
A(2) =angle(W(n, R + dR, h, dis)) - angle(W(n, R - dR, h, dis)) + 2*pi;
A(3) =angle(W(n, R + dR, h, dis)) - angle(W(n, R - dR, h, dis)) - 2*pi;

[~, i] = min(abs(A(:)));

argWR =A(i) / (2*dR);

end