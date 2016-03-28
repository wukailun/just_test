function connect = cellchunk(n, n_forward, p_pre, p_adj, p_pro, wpath)
% ���������ݲ�������һ��chunk��������Ԫ�����Ӿ���
%
% Inputs:
%     n          : ���������Ӿ����Ӧ����Ԫ����
%     n_forward  : �ڽ�ǰ����������
%     p_pre      : �������Ӹ���
%     p_adj      : �ڽ�ǰ�����Ӹ���
%     p_pro      : Զ��ǰ�����Ӹ���
%     wpath      : Ȩ�ص�scale����
%
% Outputs:
%     connect    : n x n ���󣬱�ʾ���ɵ����Ӿ���

%% Step 1: ���ݾ����ڽ��������(p_pre, p_adj, p_pro)
%           �Լ�Ȩ�ظ��ʷֲ�(�μ�����weight.m)
%           ����Ȩֵ���Ӿ���ĳ�ʼֵ
connect = zeros(n, n);
for k = 1:n
    connect(:, k) = single_neuron_connect(n, k, n_forward, p_pre, p_adj, p_pro);
end

%% Step 2: ��һ��Ȩֵ���Ӿ������й�һ��(����ÿһ����Ԫ������Ȩ�ؽ���)
EPS = 0.0001;
connect = connect ./ (repmat(sum(connect, 1), n, 1) + EPS) * wpath;
end

