function [X1,H]=estimateH(X1,X2)
n=size(X1,2); % ��������
nrows_A=2*n; % ���� M ������
ncols_A=9; % ���� M ������
A=zeros(nrows_A,ncols_A); % ��ʼ������ A
[X1, T1] = normalize_points(X1);
[X2, T2] = normalize_points(X2);
% ���� A ����
row = 1;

    for h = 1:n        
    
        A(row, :)   = [X1(1,h) 0 -X1(1,h)*X2(1,h) X1(2,h) 0 -X1(2,h)*X2(1,h) 1 0 -X2(1,h)];
        A(row+1, :) = [0 X1(1,h) -X1(1,h)*X2(2,h) 0 X1(2,h) -X1(2,h)*X2(2,h) 0 1 -X2(2,h)];
    
        row = row + 2;
    
    end


% ����С��������
[U, S, V] = svd(A); 
h = V(:, 9);
H = reshape(h, 3, 3); 
H = inv(T2)*H*T1;
% Ӧ�÷���任�� X1
X1 = homo2cart(H*cart2homo(X1));
% for i=1:n
%     denom = X1(1,i)*H(3,1) + X1(2,i)*H(3,2) + H(3,3);
%     X1(1,i) = (X1(1,i)*H(1,1) + X1(2,i)*H(1,2) + H(1,3)) / denom;
%     X1(2,i) = (X1(1,i)*H(2,1) + X1(2,i)*H(2,2) + H(2,3)) / denom;
% end
