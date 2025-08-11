
function [X1,i]=lqEstimation(X,Y,p,mu,iter,max_mu,alpha,stop)
% 初始化变量 Z 用于存储中间变量，C 用于存储乘子变量
Z=zeros(2,size(X,2));
C=zeros(2,size(X,2));
X1=X; % 初始化估计结果 X1 为输入 X

for i=1:iter % 遍历迭代次数
    dual=0; % 初始化对偶变量 dual 为 0
    Z=X-Y+C/mu; % 计算中间变量 Z
    Z=shrink(Z,mu,p); % 对 Z 进行软阈值处理以去除异常值
    U=Y+Z-C/mu; % 更新中间变量 U
    % [X]=rigidMotion(X,U); % （注释：此处为刚性变换，但未实现）
    [X,Aff]=estimateA(X,U); % 通过仿射模型估计全局变换 X 和仿射参数 Aff
    for j=1:size(X,2)
        err0(j)=norm(X1(:,j)-X(:,j)); % 计算估计值与上一迭代的估计值之间的误差
    end
    dual=max(err0); % 计算对偶变量的最大误差
    X1=X; % 更新估计值 X1
    P=X-Y-Z; % 计算中间变量 P
    C=C+mu.*P; % 更新乘子变量 C
    if mu<max_mu % 动态调整惩罚参数 mu
        mu=mu.*alpha;
    end
    for j=1:size(X,2)
        err1(j)=norm(P(:,j)); % 计算 P 的范数作为原始误差
    end
    primal=max(err1); % 计算原始变量的最大误差
    if primal<stop && dual<stop % 满足终止条件则退出循环
        break;
    end
end
end