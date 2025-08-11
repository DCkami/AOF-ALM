function [Aff,idxF]=lqRFM(X,Y,scores,t1,t2)

p=0.2; % LQ 范数的指数参数 p
mu=0.0003; % 初始惩罚参数 mu
alpha=1.65; % mu 的动态调整因子
Nmax=50; % 最大样本数
Nmin=10; % 最小样本数
iter=30; % 最大迭代次数
max_mu=1e6; % mu 的最大值
stop=1e-8; % 终止阈值

[Xn, Yn, ~]=norm2(X,Y); % 对特征点进行归一化处理
nsample=max(min(size(Xn,1)*0.3,Nmax),Nmin); % 计算样本数
[vals,indx] = sort(scores); % 对得分进行排序（升序），indx是排序后的对应原矩阵/向量的序号
xsample=Xn(indx(1:nsample),:)'; % 选择得分高的样本点
ysample=Yn(indx(1:nsample),:)';
Xsample=X(indx(1:nsample),:)';
Ysample=Y(indx(1:nsample),:)';

% 调用 lqEstimation 函数估计初始变换
[x1_,ite]=lqEstimation(ysample,xsample,p,mu,iter,max_mu,alpha,stop);
err=sum((x1_-xsample).^2); % 计算估计误差
inliers=err<t1*t1; % 判断哪些点是内点
[~,idx]=find(inliers==1);
X1=Xsample(:,idx); % 提取内点的特征点
X2=Ysample(:,idx);

% 通过仿射模型重新估计全局变换
[Xe,Aff]=estimateH(X2,X1);
vv=(Xe-X1);
m0 = sqrt(sum(vv(1,:).^2+vv(2,:).^2)/(size(vv,2)));
if m0>0.5&m0<5 % 根据误差调整阈值
    tt=3*m0;
else
    tt=t2;
end

% 应用变换并计算误差
X_ = homo2cart(Aff*cart2homo(Y'));
E=X_-X';
dstE = sqrt(E(1,:).^2+E(2,:).^2);
inliersF=dstE<tt; % 判断内点
[~,idxF]=find(inliersF==1);

% 重新估计仿射变换
X1=X(idxF,:)';
X2=Y(idxF,:)';
[~,Aff]=estimateH(X2,X1);

% 最终变换应用
X_ = homo2cart(Aff*cart2homo(Y'));
E=X_-X';
dstE = sqrt(E(1,:).^2+E(2,:).^2);
inliersF=dstE<t2; % 最终内点判断
[~,idxF]=find(inliersF==1);  