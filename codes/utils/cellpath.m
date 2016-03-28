function connect = cellpath(n_row, n_col, p, wpath)
% ������������Ԫchunk֮������ӣ����� n_col ��Ӧ����Ԫ������ n_row ��Ӧ����Ԫ
%
% Inputs:
%     n_row   : �������������õ���Ԫ������   
%     n_col   : ����������������������Ԫ������
%     p       : �໥�������Ӿ���Ĳ�������
%     wpath   : ����Ȩֵ��scaleϵ��
%
% Outputs��
%     connect : n_row x n_col ���󣬼����������Ӿ���

%% Step 1: ��ʼ�����Ӿ���
row_index = repmat((1: n_row)', 1, n_col);
col_index = repmat(1: n_col, n_row, 1);
% ����ʽ�ӵ�һ���ֱ�ʾ�����ڵ�row�е�col�е����ӣ�������ĸ���Ϊ��
% 2 * (col - row + n_row) / (n_row + n_col) * p
% Ҳ����˵�� n_col ��Ӧ����Ԫ���� n_row ��Ӧ����Ԫ���ø���һЩ
%           n_row ��Ӧ����Ԫ���� n_col ��Ӧ����Ԫ���ø�СһЩ
connect = (rand(n_row, n_col) < ...
    (2 * (col_index - row_index + n_row) / (n_row + n_col) * p))...
    .* reshape(weight(rand(n_row * n_col, 1)), n_row, n_col);

%% Step 2: �й�һ�����󣬲�̫ȷ�������Ƿ�����й�һ�������й�һ����������ڣ�
EPS = 0.0001;
connect = connect ./ (repmat(sum(connect, 2), 1, n_col) + EPS) * wpath;
end