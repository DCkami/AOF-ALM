function Z=shrink(Z,u,p)
Aa=(2./u.*(1-p)).^(1/(2-p)); % 计算调整因子 Aa
ha=Aa+p./u.*(Aa.^(p-1)); % 计算阈值 ha
for i=1:size(Z,2)
    n=norm(Z(:,i)); % 计算当前列的范数
%?n = norm(v) 返回向量 v 的欧几里德范数。此范数也称为 2-范数、向量模或欧几里德长度
    w=0; % 初始化权重 w 为 0
    if n>ha % 如果范数大于阈值
        w = shrinkage(u, n, p, (Aa/n + 1.0)/2.0); % 计算权重 w
    end
    Z(:,i)=Z(:,i)*w; % 对当前列进行软阈值处理
end
end