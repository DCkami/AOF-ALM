function Q_cart = homo2cart(Q_homo)
% 将齐次坐标转换为笛卡尔坐标。
% Q_cart = homo2cart(Q_homo)
%
% DESC:
% converts from cartesian coordinates to homegeneous ones
%
% VERSION:
% 1.0.0
% 
% INPUT:
% Q_homo		= homogeneous coordinates of the points
%
% OUTPUT:
% Q_cart		= cartesian coordinates of the points


% AUTHOR:
% Marco Zuliani, email: marco.zuliani@gmail.com
% Copyright (C) 2008 by Marco Zuliani 
% 
% LICENSE:
% This toolbox is distributed under the terms of the GNU LGPL.
% Please refer to the files COPYING and COPYING.LESSER for more information.



% HISTORY
% 1.0.0         - ??/??/01 - Initial version

l = size(Q_homo, 1);

% 检查最后一个元素是否为0，如果为0则设为1（避免除零错误）。
% 将前 l-1 行元素分别除以最后一行，得到笛卡尔坐标。
if Q_homo(l) == 0
   Q_homo(l) = 1;
end;

Q_cart = Q_homo(1:l - 1, :)./repmat(Q_homo(l, :), [l-1, 1]);

return;