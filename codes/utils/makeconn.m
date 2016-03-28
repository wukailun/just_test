function conn = makeconn(n, n_forward, p_adj, p_pro, p_pre, wpath, out_thresh, in_thresh)
% �ú������ݸ�������ֵ��������Ԫ�����ĳ�ʼȨֵ��
% �ó�ʼȨֵ��������Ԫchunk֮�������ϵ��
%
% Inputs:
%     n          : ���������Ӿ����Ӧ����Ԫ����
%     n_forward  : �ڽ�ǰ����������
%     p_pre      : �������Ӹ���
%     p_adj      : �ڽ�ǰ�����Ӹ���
%     p_pro      : Զ��ǰ�����Ӹ���
%     wpath      : Ȩ�ص�scale����
%     out_thresh : ���ȣ�����k����Ԫ���з�����Ȩ�أ���sum(conn(:, k))
%     in_thresh  : ��ȣ������н����k����Ԫ��Ȩ�أ���sum(conn(k, :))
%
% Outputs:
%     conn       : n x n ���󣬱�ʾ���ɵ����Ӿ���

%%% Step1 �����в�����ע�⣬weight.m���в�����δ�������� %%%
% n = 30; % ��Ԫ�ܸ���
% p_pre = 0.08; % �������Ӹ���
% p_adj = 0.62; % �ڽ�ǰ�����Ӹ���
% p_pro = 0.06; % Զ��ǰ�����Ӹ���
% n_forward = 3; % �ڽ�ǰ����������
conn = zeros(n,n); % ��ʼ�����Ӿ���
%%% Step1 �����в��� %%%

%%% Step2 �����в��� %%%
EPS = 0.0001; % Ϊ�˵ڶ������Ӿ����һ���ĳ����Ϸ���
% wpath = 5; % Ȩ�ص�scale����
%%% Step2 �����в��� %%%

%%% Step3 �����в��� %%%
% out_thresh = 0.001; % ���ȣ�����k����Ԫ���з�����Ȩ�أ���sum(conn(:, k))
% in_thresh = 0.001;  % ��ȣ������н����k����Ԫ��Ȩ�أ���sum(conn(k, :))
%%% Step3 �����в��� %%%

p = 0.076;  % Ŀǰ��ʱûʲô�õĲ���


%% Step 1: ���ݾ����ڽ��������(p1, p2, p3)
%           �Լ�Ȩ�ظ��ʷֲ�(�μ�����weight.m)
%           ����Ȩֵ���Ӿ���ĳ�ʼֵ

% conn(r, k) ��ʾ��Ԫ r �ܵ�������Ԫ k ������
% conn ����ĵ� k �б�ʾ��Ԫ k ��������Ԫ������
for k = 1:n
    % ���γ�ʼ��ÿһ�У���ʾ��ʼ��ÿһ����Ԫ����������Ԫ������Ȩֵ
    conn(:, k) = conn(:, k) + single_neuron_connect(n, k, n_forward, p_pre, p_adj, p_pro);
end

%% Step 2: ��һ��Ȩֵ���Ӿ������й�һ��(����ÿһ����Ԫ������Ȩ�ؽ���)
conn = conn ./ (repmat(sum(conn, 1), n, 1) + EPS) * wpath;

%% Step 3: ɾȥ������Ⱥ��ٵ���Ԫ
weights_out = sum(conn, 1); % ������Ԫ�ĳ��ȣ�����, 1 x n
weights_in = sum(conn, 2); % ������Ԫ����ȣ�����, n x 1

% �ҳ��������ӽ�������Ԫ
weak_neuron = (weights_out < out_thresh)' .* (weights_in < in_thresh); % ����, n x 1

% ɾȥ�������ӽ�������Ԫ
conn(logical(weak_neuron), :) = [];
conn(:, logical(weak_neuron)) = [];


%% Step 4: �ٴ�ɾ������ȶ���С����Ԫ
weights_out = sum(conn, 1); % ������Ԫ�ĳ��ȣ�����, 1 x n
weights_in = sum(conn, 2); % ������Ԫ����ȣ�����, n x 1

% �ҳ��������ӽ�������Ԫ
weak_neuron = (weights_out < out_thresh)' .* (weights_in < in_thresh); % ����, n x 1

% ɾȥ�������ӽ�������Ԫ
conn(logical(weak_neuron), :) = [];
conn(:, logical(weak_neuron)) = [];

%% Step 5: �С��й�һ��Ȩֵ���Ӿ����������й�һ��
conn = conn ./ (repmat(sum(conn, 1), n, 1) + EPS) * wpath; % �й�һ��
conn = conn ./ (repmat(sum(conn, 2), 1, n) + EPS) * wpath; % �й�һ��

%% Step 6: �������ɵ����Ӿ���
% showconn = [cumsum(ones(size(conn, 1) + 1, 1)) - 1, [cumsum(ones(size(conn, 1), 1))'; conn]];

% conn12 = conn;
% zns2 = size(conn12, 1);
% figure;imagesc(conn12)
end