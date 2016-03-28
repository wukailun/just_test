function connect = cellchunk(n, n_forward, p_pre, p_adj, p_pro, wpath)
% 本函数根据参数生成一个chunk内所有神经元的连接矩阵
%
% Inputs:
%     n          : 待生成连接矩阵对应的神经元数量
%     n_forward  : 邻近前向连接数量
%     p_pre      : 后向连接概率
%     p_adj      : 邻近前向连接概率
%     p_pro      : 远端前向连接概率
%     wpath      : 权重的scale参数
%
% Outputs:
%     connect    : n x n 矩阵，表示生成的连接矩阵

%% Step 1: 根据距离邻近距离概率(p_pre, p_adj, p_pro)
%           以及权重概率分布(参见函数weight.m)
%           产生权值连接矩阵的初始值
connect = zeros(n, n);
for k = 1:n
    connect(:, k) = single_neuron_connect(n, k, n_forward, p_pre, p_adj, p_pro);
end

%% Step 2: 归一化权值连接矩阵，逐列归一化(即对每一个神经元发出的权重进行)
EPS = 0.0001;
connect = connect ./ (repmat(sum(connect, 1), n, 1) + EPS) * wpath;
end

