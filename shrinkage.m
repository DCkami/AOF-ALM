function s=shrinkage(mu,n,p,s)
% ͨ����������Ȩ�� s
for i=1:3 % ���� 3 ��
    s=1-(p./mu).*(n.^(p-2)).*(s.^(p-1)); % ����Ȩ�� s
end
end