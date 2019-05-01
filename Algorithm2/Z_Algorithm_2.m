function [R, h, S] = Z_Algorithm_2(R0, h0, B, dis)
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
    a(j) = B(1,j) / abs(W(j, R(1), h(1), dis));
    c(j) = B(1,j+3) * omega(j)*10^(-6) - angle(W(j, R(1), h(1), dis));
end

for m = 1:(u-1)
    for j = 1:3

        %проверка перехода фазы через начало отсчета, в случае прохождения
        %обеспечивается неразрывность путем прибавления 2Пи либо -2Пи
        if m>1
        if abs(angle(W(j, R(m), h(m), dis)) -angle(W(j, R(m-1), h(m-1), dis))) > abs(angle(W(j, R(m), h(m), dis)) -angle(W(j, R(m-1), h(m-1), dis)) +2*pi)
            AAA(j) = AAA(j)+1;
        elseif abs(angle(W(j, R(m), h(m), dis)) -angle(W(j, R(m-1), h(m-1), dis))) > abs(angle(W(j, R(m), h(m), dis)) -angle(W(j, R(m-1), h(m-1), dis)) -2*pi)
            AAA(j) = AAA(j)-1;
        end
        end
        
        v(j) = modWR(j, R(m), h(m), dis) / abs(W(j, R(m), h(m), dis));
        vv(j) = modWh(j, R(m), h(m), dis) / abs(W(j, R(m), h(m), dis));
        SE(j) = abs(a(j) * abs(W(j, R(m), h(m), dis)) - B(m, j))^2 / abs(B(1, j))^2;
        Sphi(j) = abs(c(j) + angle(W(j, R(m), h(m), dis)) + AAA(j)*2*pi - B(m, j+3) * omega(j)*10^(-6))^2 / ...
            ((B(1, j+3) - B(u, j+3)) * omega(j)*10^(-6))^2;
        s(j) = SE(j) + Sphi(j);
        V(j) = argWR(j, R(m), h(m), dis);
        VV(j) = argWh(j, R(m), h(m), dis);
    end
    
    A = [v(1) vv(1); v(2) vv(2); v(3) vv(3); V(1) VV(1); V(2) VV(2); V(3) VV(3)];

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

    b = [(B(m+1,1)-B(m,1))/B(m+1,1); (B(m+1,2)-B(m,2))/B(m+1,2); (B(m+1,3)-B(m,3))/B(m+1,3);...
        (B(m+1,4)-B(m,4))*omega(1)*10^(-6); (B(m+1,5)-B(m,5))*omega(2)*10^(-6); (B(m+1,6)-B(m,6))*omega(3)*10^(-6)];
    
    Weight_A(1:3,1) = abs(A(1:3,1))./max(abs(A(1:3,1)));
    Weight_A(1:3,2) = abs(A(1:3,2))./max(abs(A(1:3,2)));
    Weight_A(4:6,1) = abs(A(4:6,1))./max(abs(A(4:6,1)));
    Weight_A(4:6,2) = abs(A(4:6,2))./max(abs(A(4:6,2)));
    
    Weight1 = eye(6).*Weight_A(:,1);
    Weight2 = eye(6).*Weight_A(:,2);
    Weight = Weight1*Weight2;
    
    A = Weight*A;
    b = Weight*b;
    
    Z = inv(A'*A)*A'*b;
    DeltaR = Z(1);
    Deltah = Z(2);
    R(m+1) = R(m) + DeltaR;
    h(m+1) = h(m) + Deltah;
    
end

for j =1:3
    
    SE(j) = abs(a(j) * abs(W(j, R(u), h(u), dis)) - B(u, j))^2 / abs(B(1, j))^2;
    Sphi(j) = abs(c(j) + angle(W(j, R(u), h(u), dis)) + AAA(j)*2*pi - B(u, j+3) * omega(j)*10^(-6))^2 / ...
        ((B(1, j+3) - B(u, j+3)) * omega(j)*10^(-6))^2;
    s(j) = SE(j) + Sphi(j);
end

S(u) = S(u-1) + s(1) + s(2) + s(3);
%S11(u) = S11(u-1) + s(1);
%S22(u) = S22(u-1) + s(2);
%S33(u) = S33(u-1) + s(3);

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

function argWh =argWh(n, R, h, dis)

dh =0.5;

%на тот случай, когда точка разрыва оказывается в отрезке, для которого
%считается частная производная, производится проверка непрерывности
%дополнительно
A(1:3)=0;

A(1) =angle( W(n, R, h +dh, dis)) -angle( W(n, R, h -dh, dis) );
A(2) =angle( W(n, R, h +dh, dis)) -angle( W(n, R, h -dh, dis) ) +2*pi;
A(3) =angle( W(n, R, h +dh, dis)) -angle( W(n, R, h -dh, dis) ) -2*pi ;

[~, i] =min( abs(A(:)));

argWh =A(i) /(2*dh);

end

function argWR =argWR(n, R, h, dis)

dR =0.05;

A(1:3)=0;

A(1) =angle(W(n, R +dR, h, dis)) -angle(W(n, R -dR, h, dis));
A(2) =angle(W(n, R +dR, h, dis)) -angle(W(n, R -dR, h, dis)) +2*pi;
A(3) =angle(W(n, R +dR, h, dis)) -angle(W(n, R -dR, h, dis)) -2*pi;

[~, i] =min( abs(A(:)));

argWR =A(i) /(2*dR);

end
