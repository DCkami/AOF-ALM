function [X1,Aff]=estimateA(X1,X2)
n=size(X1,2); % 特征点数
nrows_M=2*n; % 矩阵 M 的行数
ncols_M=6; % 矩阵 M 的列数
M=zeros(nrows_M,ncols_M); % 初始化矩阵 M
B=zeros(nrows_M,1); % 初始化向量 B

% 构建 M 矩阵和 B 向量
for i=1:n
    x1=X2(1,i);
    y1=X2(2,i);
    x2=X1(1,i);
    y2=X1(2,i);
    M_=[x2, y2, 1, 0, 0, 0; % 构建当前方程组
        0, 0, 0, x2, y2, 1];
    b=[x1;y1];
    row_ini=i*2-1;
    row_end=i*2;
    M(row_ini:row_end,:)=M_; % 将当前方程组添加到 M 中
    B(row_ini:row_end,1)=b; % 将当前结果添加到 B 中
end

% 解最小二乘问题
Aff=inv(M'*M)*(M'*B);

% 应用仿射变换到 X1
X1=[Aff(1:2)';Aff(4:5)']*X1+repmat([Aff(3);Aff(6)],1,size(X1,2));
end