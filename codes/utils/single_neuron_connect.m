function y = single_neuron_connect(n, k, n_forward, p_pre, p_adj, p_pro)
% 本函数产生第 k 个神经元对其他所有神经元作用的连接权值，即产生列向量
% 这样在迭代乘法过程中 A*x，第 k 列表示神经元 k 对其他神经元的作用
%
% Inputs:
%     n         : 神经元总个数
%     k         : 当前神经元编号
%     n_forward : 前向连接个数
%     p_pre     : 后向连接概率
%     p_adj     : 邻近前向概率
%     p_pro     : 远端前向概率
%
% Outputs:
%     y         : n x 1 vector, 生成的第 k 个神经元对其他神经元的作用矩阵

p_pre_array = ones(k - 1, 1) * p_pre;
if k + n_forward <= n  % 说明当前神经元还不在较后位置，可以有前向连接
    p_adj_array = ones(n_forward, 1) * p_adj;
    % 若神经元足够靠前，可以有更远的前向连接
    p_pro_array = ones(n - k - n_forward, 1) * p_pro;
else
    p_adj_array = ones(n - k, 1) * p_adj; % 此时表示不再有前向连接
    % 此时不再有更远的前向连接
    p_pro_array = [];
end
p_array = [p_pre_array; 0; p_adj_array; p_pro_array]; 
p_weight = rand(n, 1) .* (rand(n, 1) < p_array);
y = weight(p_weight);
end