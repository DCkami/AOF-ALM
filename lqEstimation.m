
function [X1,i]=lqEstimation(X,Y,p,mu,iter,max_mu,alpha,stop)
% ��ʼ������ Z ���ڴ洢�м������C ���ڴ洢���ӱ���
Z=zeros(2,size(X,2));
C=zeros(2,size(X,2));
X1=X; % ��ʼ�����ƽ�� X1 Ϊ���� X

for i=1:iter % ������������
    dual=0; % ��ʼ����ż���� dual Ϊ 0
    Z=X-Y+C/mu; % �����м���� Z
    Z=shrink(Z,mu,p); % �� Z ��������ֵ������ȥ���쳣ֵ
    U=Y+Z-C/mu; % �����м���� U
    % [X]=rigidMotion(X,U); % ��ע�ͣ��˴�Ϊ���Ա任����δʵ�֣�
    [X,Aff]=estimateA(X,U); % ͨ������ģ�͹���ȫ�ֱ任 X �ͷ������ Aff
    for j=1:size(X,2)
        err0(j)=norm(X1(:,j)-X(:,j)); % �������ֵ����һ�����Ĺ���ֵ֮������
    end
    dual=max(err0); % �����ż������������
    X1=X; % ���¹���ֵ X1
    P=X-Y-Z; % �����м���� P
    C=C+mu.*P; % ���³��ӱ��� C
    if mu<max_mu % ��̬�����ͷ����� mu
        mu=mu.*alpha;
    end
    for j=1:size(X,2)
        err1(j)=norm(P(:,j)); % ���� P �ķ�����Ϊԭʼ���
    end
    primal=max(err1); % ����ԭʼ������������
    if primal<stop && dual<stop % ������ֹ�������˳�ѭ��
        break;
    end
end
end