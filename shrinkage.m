function s=shrinkage(mu,n,p,s)
% 通过迭代计算权重 s
for i=1:3 % 迭代 3 次
    s=1-(p./mu).*(n.^(p-2)).*(s.^(p-1)); % 更新权重 s
end
end