function [Aff,idxF]=lqRFM(X,Y,scores,t1,t2)

p=0.2; % LQ ������ָ������ p
mu=0.0003; % ��ʼ�ͷ����� mu
alpha=1.65; % mu �Ķ�̬��������
Nmax=50; % ���������
Nmin=10; % ��С������
iter=30; % ����������
max_mu=1e6; % mu �����ֵ
stop=1e-8; % ��ֹ��ֵ

[Xn, Yn, ~]=norm2(X,Y); % ����������й�һ������
nsample=max(min(size(Xn,1)*0.3,Nmax),Nmin); % ����������
[vals,indx] = sort(scores); % �Ե÷ֽ����������򣩣�indx�������Ķ�Ӧԭ����/���������
xsample=Xn(indx(1:nsample),:)'; % ѡ��÷ָߵ�������
ysample=Yn(indx(1:nsample),:)';
Xsample=X(indx(1:nsample),:)';
Ysample=Y(indx(1:nsample),:)';

% ���� lqEstimation �������Ƴ�ʼ�任
[x1_,ite]=lqEstimation(ysample,xsample,p,mu,iter,max_mu,alpha,stop);
err=sum((x1_-xsample).^2); % ����������
inliers=err<t1*t1; % �ж���Щ�����ڵ�
[~,idx]=find(inliers==1);
X1=Xsample(:,idx); % ��ȡ�ڵ��������
X2=Ysample(:,idx);

% ͨ������ģ�����¹���ȫ�ֱ任
[Xe,Aff]=estimateH(X2,X1);
vv=(Xe-X1);
m0 = sqrt(sum(vv(1,:).^2+vv(2,:).^2)/(size(vv,2)));
if m0>0.5&m0<5 % ������������ֵ
    tt=3*m0;
else
    tt=t2;
end

% Ӧ�ñ任���������
X_ = homo2cart(Aff*cart2homo(Y'));
E=X_-X';
dstE = sqrt(E(1,:).^2+E(2,:).^2);
inliersF=dstE<tt; % �ж��ڵ�
[~,idxF]=find(inliersF==1);

% ���¹��Ʒ���任
X1=X(idxF,:)';
X2=Y(idxF,:)';
[~,Aff]=estimateH(X2,X1);

% ���ձ任Ӧ��
X_ = homo2cart(Aff*cart2homo(Y'));
E=X_-X';
dstE = sqrt(E(1,:).^2+E(2,:).^2);
inliersF=dstE<t2; % �����ڵ��ж�
[~,idxF]=find(inliersF==1);  