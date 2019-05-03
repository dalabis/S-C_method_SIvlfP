function [R, h, S] = Z_third_hop(R0, h0, B)
%Вычисление временных зависимостей эффективной высоты и модуля коэффициента
%отражения по заданным вариациям амплитуд и фаз и начальным значениям
%искомых R(t) и h(t) (детальное описание подпрограммы Z(R0, h0) приведено 
%в разделе 5 описания "ММетод_пособ_end")
%!Работа осуществляется с файлом "Данные 28.09-6.10.1989 г..xlsx"!

u = size(B, 1);

R(1:u) = 0;
h(1:u) = 0;

R(1) = R0;
h(1) = h0;

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
S(1:u) = 0;
AAA(1:3) = 0;

for j = 1:3
    a(j) = B(1,j) / abs(W_third_hop(j, R(1), h(1)));
    c(j) = B(1,j+3) * omega(j)*10^(-6) - angle(W_third_hop(j, R(1), h(1)));
end

for m = 1:(u-1)
    for j = 1:3

        %проверка перехода фазы через начало отсчета, в случае прохождения
        %обеспечивается неразрывность путем прибавления 2Пи либо -2Пи
        if m>1
        if abs(angle(W_third_hop(j, R(m), h(m))) -angle(W_third_hop(j, R(m-1), h(m-1)))) > abs(angle(W_third_hop(j, R(m), h(m))) -angle(W_third_hop(j, R(m-1), h(m-1))) +2*pi)
            AAA(j) = AAA(j)+1;
        elseif abs(angle(W_third_hop(j, R(m), h(m))) -angle(W_third_hop(j, R(m-1), h(m-1)))) > abs(angle(W_third_hop(j, R(m), h(m))) -angle(W_third_hop(j, R(m-1), h(m-1))) -2*pi)
            AAA(j) = AAA(j)-1;
        end
        end
        
        v(j) = modWR(j, R(m), h(m)) / abs(W_third_hop(j, R(m), h(m)));
        vv(j) = modWh(j, R(m), h(m)) / abs(W_third_hop(j, R(m), h(m)));
        SE(j) = abs(a(j) * abs(W_third_hop(j, R(m), h(m))) - B(m, j))^2 / abs(B(1, j))^2;
        Sphi(j) = abs(c(j) + angle(W_third_hop(j, R(m), h(m))) + AAA(j)*2*pi - B(m, j+3) * omega(j)*10^(-6))^2 / ...
            ((B(1, j+3) - B(u, j+3)) * omega(j)*10^(-6))^2;
        s(j) = SE(j) + Sphi(j);
        for k = 1:3
            V(k) = argWR(k, R(m), h(m));
            VV(k) = argWh(k, R(m), h(m));
            A = [v(j), vv(j); V(k), VV(k)];
            C(j, k) = abs(det(A));
        end
    end
    
    %этот кусок находит положение максимального элемента матрицы C
    [~, i] = max(C(:));
    col = fix((i - 1) / 3) + 1;
    row = i - (col - 1) * 3;

    if m == 1
        S(m) = s(1) + s(2) + s(3);
        %S11(m) = s(1);
        %S22(m) = s(2);
        %S33(m) = s(3);
    else
        S(m) = S(m - 1) + s(1) + s(2) + s(3);
        %S11(m) = S11(m-1) + s(1);
        %S22(m) = S22(m-1) + s(2);
        %S33(m) = S33(m-1) + s(3);
    end

    AA = [v(row), vv(row); V(col), VV(col)];
    b = [(B(m+1, row) - B(m, row)) / B(m+1, row); (B(m+1, col+3) - B(m, col+3))*omega(col)*10^(-6)];
    Z = AA \ b;
    DeltaR = Z(1);
    Deltah = Z(2);
    R(m+1) = R(m) + DeltaR;
    h(m+1) = h(m) + Deltah;
    
end

for j =1:3
    
    SE(j) = abs(a(j) * abs(W_third_hop(j, R(u), h(u))) - B(u, j))^2 / abs(B(1, j))^2;
    Sphi(j) = abs(c(j) + angle(W_third_hop(j, R(u), h(u))) + AAA(j)*2*pi - B(u, j+3) * omega(j)*10^(-6))^2 / ...
        ((B(1, j+3) - B(u, j+3)) * omega(j)*10^(-6))^2;
    s(j) = SE(j) + Sphi(j);
end

S(u) = S(u-1) + s(1) + s(2) + s(3);
%S11(u) = S11(u-1) + s(1);
%S22(u) = S22(u-1) + s(2);
%S33(u) = S33(u-1) + s(3);

end

%Вычисление частных производных модуля и аргумента функции ослабления
function modWh = modWh(n, R, h)
dh = 0.5;
modWh =(abs(W_third_hop(n, R, h + dh)) - abs(W_third_hop(n, R, h - dh))) / (2 * dh);
end

function modWR = modWR(n, R, h)
dR = 0.05;
modWR =(abs(W_third_hop(n, R + dR, h)) - abs(W_third_hop(n, R - dR, h))) / (2 * dR);
end

function argWh =argWh(n, R, h)

dh =0.5;

%на тот случай, когда точка разрыва оказывается в отрезке, для которого
%считается частная производная, производится проверка непрерывности
%дополнительно
A(1:3)=0;

A(1) =angle( W_third_hop(n, R, h +dh)) -angle( W_third_hop(n, R, h -dh) );
A(2) =angle( W_third_hop(n, R, h +dh)) -angle( W_third_hop(n, R, h -dh) ) +2*pi;
A(3) =angle( W_third_hop(n, R, h +dh)) -angle( W_third_hop(n, R, h -dh) ) -2*pi ;

[~, i] =min( abs(A(:)));

argWh =A(i) /(2*dh);

end

function argWR =argWR(n, R, h)

dR =0.05;

A(1:3)=0;

A(1) =angle(W_third_hop(n, R +dR, h)) -angle(W_third_hop(n, R -dR, h));
A(2) =angle(W_third_hop(n, R +dR, h)) -angle(W_third_hop(n, R -dR, h)) +2*pi;
A(3) =angle(W_third_hop(n, R +dR, h)) -angle(W_third_hop(n, R -dR, h)) -2*pi;

[~, i] =min( abs(A(:)));

argWR =A(i) /(2*dR);

end
