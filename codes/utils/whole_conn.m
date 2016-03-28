function connect = whole_conn(inter_param, p_inter, chunk_param)
% 该函数用来生成所有神经元的整体连接矩阵
% 
% Inputs:
%     inter_param : struct, chunk间连接矩阵的参数 
%     p_inter     : chunk间连接矩阵的产生概率
%     chunk_param : struct, chunk内连接矩阵的参数 
%
% Outputs:
%     connect     : N x N 矩阵，整体连接矩阵
%
% % 用来生成chunk之间连接矩阵的参数
% inter_param = struct();
% inter_param.n = 30;
% inter_param.n_forward = 3;
% inter_param.p_adj = 0.62;
% inter_param.p_pro = 0.06;
% inter_param.p_pre = 0.08;
% inter_param.wpath = 5;
% inter_param.out_thresh = 0.001;
% inter_param.in_thresh = 0.001;
% 
% % 表示神经元chunk之间连接矩阵的生成概率
% p_inter = 0.03; 
% 
% % 用来生成chunk内部连接矩阵的参数
% chunk_param = struct();
% chunk_param.n = 200;
% chunk_param.n_forward = 20;
% chunk_param.p_pre = 0.03;
% chunk_param.p_adj = 0.13;
% chunk_param.p_pro = 0.04;
% chunk_param.wpath = 2.5;

%% Step 1: 产生神经元 chunk 之间的连接权重
conn_inter = makeconn(inter_param.n, inter_param.n_forward, ...
    inter_param.p_adj, inter_param.p_pro, inter_param.p_pre, ...
    inter_param.wpath, inter_param.out_thresh, inter_param.in_thresh);
chunk_num = size(conn_inter, 1); % 即产生的 chunk 个数
n = chunk_param.n
%% Step 2: 生成单个chunk中的连接矩阵
connect = zeros(chunk_num * n, chunk_num * n);
for k = 1:chunk_num
    % 产生单个chunk中神经元的连接矩阵
    connect((k - 1) * n + 1: k * n, (k - 1) * n + 1: k * n) = ...
        cellchunk(chunk_param.n, chunk_param.n_forward, ...
        chunk_param.p_pre, chunk_param.p_adj, chunk_param.p_pro, ...
        chunk_param.wpath);
end

%% Step 3: 将已经生成的chunk间连接矩阵扩充到整个 connect 当中
for row_index = 1: chunk_num
    for col_index = 1: chunk_num
        if conn_inter(row_index,col_index) > 0
            % 表示神经元chunk r 作用于神经元 chunk k
            connect((row_index - 1) * n + 1: row_index * n, (col_index - 1) * n + 1: col_index * n) = ...
                cellpath(n, n, p_inter, conn_inter(row_index, col_index));
        end
    end
end