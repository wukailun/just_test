function connect = whole_conn(inter_param, p_inter, chunk_param)
% �ú�����������������Ԫ���������Ӿ���
% 
% Inputs:
%     inter_param : struct, chunk�����Ӿ���Ĳ��� 
%     p_inter     : chunk�����Ӿ���Ĳ�������
%     chunk_param : struct, chunk�����Ӿ���Ĳ��� 
%
% Outputs:
%     connect     : N x N �����������Ӿ���
%
% % ��������chunk֮�����Ӿ���Ĳ���
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
% % ��ʾ��Ԫchunk֮�����Ӿ�������ɸ���
% p_inter = 0.03; 
% 
% % ��������chunk�ڲ����Ӿ���Ĳ���
% chunk_param = struct();
% chunk_param.n = 200;
% chunk_param.n_forward = 20;
% chunk_param.p_pre = 0.03;
% chunk_param.p_adj = 0.13;
% chunk_param.p_pro = 0.04;
% chunk_param.wpath = 2.5;

%% Step 1: ������Ԫ chunk ֮�������Ȩ��
conn_inter = makeconn(inter_param.n, inter_param.n_forward, ...
    inter_param.p_adj, inter_param.p_pro, inter_param.p_pre, ...
    inter_param.wpath, inter_param.out_thresh, inter_param.in_thresh);
chunk_num = size(conn_inter, 1); % �������� chunk ����
n = chunk_param.n
%% Step 2: ���ɵ���chunk�е����Ӿ���
connect = zeros(chunk_num * n, chunk_num * n);
for k = 1:chunk_num
    % ��������chunk����Ԫ�����Ӿ���
    connect((k - 1) * n + 1: k * n, (k - 1) * n + 1: k * n) = ...
        cellchunk(chunk_param.n, chunk_param.n_forward, ...
        chunk_param.p_pre, chunk_param.p_adj, chunk_param.p_pro, ...
        chunk_param.wpath);
end

%% Step 3: ���Ѿ����ɵ�chunk�����Ӿ������䵽���� connect ����
for row_index = 1: chunk_num
    for col_index = 1: chunk_num
        if conn_inter(row_index,col_index) > 0
            % ��ʾ��Ԫchunk r ��������Ԫ chunk k
            connect((row_index - 1) * n + 1: row_index * n, (col_index - 1) * n + 1: col_index * n) = ...
                cellpath(n, n, p_inter, conn_inter(row_index, col_index));
        end
    end
end