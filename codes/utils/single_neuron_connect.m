function y = single_neuron_connect(n, k, n_forward, p_pre, p_adj, p_pro)
% ������������ k ����Ԫ������������Ԫ���õ�����Ȩֵ��������������
% �����ڵ����˷������� A*x���� k �б�ʾ��Ԫ k ��������Ԫ������
%
% Inputs:
%     n         : ��Ԫ�ܸ���
%     k         : ��ǰ��Ԫ���
%     n_forward : ǰ�����Ӹ���
%     p_pre     : �������Ӹ���
%     p_adj     : �ڽ�ǰ�����
%     p_pro     : Զ��ǰ�����
%
% Outputs:
%     y         : n x 1 vector, ���ɵĵ� k ����Ԫ��������Ԫ�����þ���

p_pre_array = ones(k - 1, 1) * p_pre;
if k + n_forward <= n  % ˵����ǰ��Ԫ�����ڽϺ�λ�ã�������ǰ������
    p_adj_array = ones(n_forward, 1) * p_adj;
    % ����Ԫ�㹻��ǰ�������и�Զ��ǰ������
    p_pro_array = ones(n - k - n_forward, 1) * p_pro;
else
    p_adj_array = ones(n - k, 1) * p_adj; % ��ʱ��ʾ������ǰ������
    % ��ʱ�����и�Զ��ǰ������
    p_pro_array = [];
end
p_array = [p_pre_array; 0; p_adj_array; p_pro_array]; 
p_weight = rand(n, 1) .* (rand(n, 1) < p_array);
y = weight(p_weight);
end