function out = search(in,start)
%����� ������� � �������� ������� (��� ������� 1 -> 0)
%��� ������� 0 -> 1 ��������� ~in
%start - ��������� ���������
n = start;
while in(n) && n<length(in)
    n=n+1;
end
out = n;
end

