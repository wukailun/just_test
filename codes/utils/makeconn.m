function conn = makeconn(n, n_forward, p_adj, p_pro, p_pre, wpath, out_thresh, in_thresh)
% 该函数根据给定参数值，产生神经元相连的初始权值，
% 该初始权值被用于神经元chunk之间的连接系数
%
% Inputs:
%     n          : 待生成连接矩阵对应的神经元数量
%     n_forward  : 邻近前向连接数量
%     p_pre      : 后向连接概率
%     p_adj      : 邻近前向连接概率
%     p_pro      : 远端前向连接概率
%     wpath      : 权重的scale参数
%     out_thresh : 出度，即第k个神经元所有发出的权重，即sum(conn(:, k))
%     in_thresh  : 入度，即所有进入第k个神经元的权重，即sum(conn(k, :))
%
% Outputs:
%     conn       : n x n 矩阵，表示生成的连接矩阵

%%% Step1 的所有参数，注意，weight.m所有参数并未算入其中 %%%
% n = 30; % 神经元总个数
% p_pre = 0.08; % 后向连接概率
% p_adj = 0.62; % 邻近前向连接概率
% p_pro = 0.06; % 远端前向连接概率
% n_forward = 3; % 邻近前向连接数量
conn = zeros(n,n); % 初始化连接矩阵
%%% Step1 的所有参数 %%%

%%% Step2 的所有参数 %%%
EPS = 0.0001; % 为了第二步连接矩阵归一化的除法合法性
% wpath = 5; % 权重的scale参数
%%% Step2 的所有参数 %%%

%%% Step3 的所有参数 %%%
% out_thresh = 0.001; % 出度，即第k个神经元所有发出的权重，即sum(conn(:, k))
% in_thresh = 0.001;  % 入度，即所有进入第k个神经元的权重，即sum(conn(k, :))
%%% Step3 的所有参数 %%%

p = 0.076;  % 目前暂时没什么用的参数


%% Step 1: 根据距离邻近距离概率(p1, p2, p3)
%           以及权重概率分布(参见函数weight.m)
%           产生权值连接矩阵的初始值

% conn(r, k) 表示神经元 r 受到来自神经元 k 的作用
% conn 矩阵的第 k 列表示神经元 k 对其他神经元的作用
for k = 1:n
    % 依次初始化每一列，表示初始化每一个神经元对于其他神经元的作用权值
    conn(:, k) = conn(:, k) + single_neuron_connect(n, k, n_forward, p_pre, p_adj, p_pro);
end

%% Step 2: 归一化权值连接矩阵，逐列归一化(即对每一个神经元发出的权重进行)
conn = conn ./ (repmat(sum(conn, 1), n, 1) + EPS) * wpath;

%% Step 3: 删去出度入度很少的神经元
weights_out = sum(conn, 1); % 所有神经元的出度：向量, 1 x n
weights_in = sum(conn, 2); % 所有神经元的入度：向量, n x 1

% 找出所有连接较弱的神经元
weak_neuron = (weights_out < out_thresh)' .* (weights_in < in_thresh); % 向量, n x 1

% 删去所有连接较弱的神经元
conn(logical(weak_neuron), :) = [];
conn(:, logical(weak_neuron)) = [];


%% Step 4: 再次删除出入度都很小的神经元
weights_out = sum(conn, 1); % 所有神经元的出度：向量, 1 x n
weights_in = sum(conn, 2); % 所有神经元的入度：向量, n x 1

% 找出所有连接较弱的神经元
weak_neuron = (weights_out < out_thresh)' .* (weights_in < in_thresh); % 向量, n x 1

% 删去所有连接较弱的神经元
conn(logical(weak_neuron), :) = [];
conn(:, logical(weak_neuron)) = [];

%% Step 5: 行、列归一化权值连接矩阵，逐行逐列归一化
conn = conn ./ (repmat(sum(conn, 1), n, 1) + EPS) * wpath; % 列归一化
conn = conn ./ (repmat(sum(conn, 2), 1, n) + EPS) * wpath; % 行归一化

%% Step 6: 画出生成的连接矩阵
% showconn = [cumsum(ones(size(conn, 1) + 1, 1)) - 1, [cumsum(ones(size(conn, 1), 1))'; conn]];

% conn12 = conn;
% zns2 = size(conn12, 1);
% figure;imagesc(conn12)
end