function connect = cellpath(n_row, n_col, p, wpath)
% 本函数产生神经元chunk之间的连接，其中 n_col 对应的神经元作用于 n_row 对应的神经元
%
% Inputs:
%     n_row   : 行数，代表被作用的神经元的数量   
%     n_col   : 列数，代表作用于其他神经元的数量
%     p       : 相互作用连接矩阵的产生概率
%     wpath   : 矩阵权值的scale系数
%
% Outputs；
%     connect : n_row x n_col 矩阵，即产生的连接矩阵

%% Step 1: 初始化连接矩阵
row_index = repmat((1: n_row)', 1, n_col);
col_index = repmat(1: n_col, n_row, 1);
% 下面式子第一部分表示，对于第row行第col列的连接，其产生的概率为：
% 2 * (col - row + n_row) / (n_row + n_col) * p
% 也就是说， n_col 对应的神经元，对 n_row 对应的神经元作用更大一些
%           n_row 对应的神经元，对 n_col 对应的神经元作用更小一些
connect = (rand(n_row, n_col) < ...
    (2 * (col_index - row_index + n_row) / (n_row + n_col) * p))...
    .* reshape(weight(rand(n_row * n_col, 1)), n_row, n_col);

%% Step 2: 行归一化矩阵，不太确定这样是否合理？行归一化还是列归一化？道理何在？
EPS = 0.0001;
connect = connect ./ (repmat(sum(connect, 2), 1, n_col) + EPS) * wpath;
end