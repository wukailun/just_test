function jacell = celljump14(n, connect, input, inact, runtime)
%��ʱ��ֱ���ģ�ͣ�2msһ֡��¼��
% ���δ����е����⣺����״̬�ĵ�λֵ��û���õģ���Ϊ��Ԫһ�����žͻ���벻Ӧ��

% act ״̬    ��δ����0      ������1     ��Ӧ��2
% ״̬��λֵ  ��   0           2          -1.3

jacell = zeros(n,runtime); % ��¼ÿ��ϸ����act״̬���Ƿ���actcell��ͬ
pcell = zeros(n,1); % -2~1��ʾ��ǰ��λ������1��Ϊ2�����ţ�������һʱ�̽�Ϊ-1.3������һʱ�̻ص�0
actcell = inact; % δ���ż�Ϊ0�������м�Ϊ1����Ӧ�ڼ�Ϊ2
for t = 1:runtime
    % ��һʱ��Ϊ����״̬��1�������ʱ����������
    % 1. ͨ���ڲ�ͻ�������̼�����ϸ��
    % 2. �����λ��Ϊ -1.3 ������ ��Բ�Ӧ�ڣ�2��
    newactcell = zeros(n,1);
    pcell(actcell == 1) = -1.3;
    newactcell(actcell == 1) = 2; % ��Ԫ�ڷ��ź������λ���̽��� -1.3 
    
    % ��Դ���� �� �ڲ�ͻ������
    % ��һʱ��Ϊ δ����״̬��0������Բ�Ӧ�ڣ�2������Ԫ�������������
    pcell = pcell + input(:, t) + connect * (1 - abs(actcell - 1));
    
    % �ڲ�ͻ�������󣬸ı�״̬
    newactcell(pcell >= 1) = 1; % ��λ >= 1, ��Ϊ������״̬(1)����λֵΪ 2
    pcell(pcell >= 1) = 2;
    newactcell((pcell < 1) & (actcell == 2)) = 0; % ��λ < 1, ��ǰһ״̬Ϊ��Ӧ�� (2)����λֵΪ 2
    pcell(pcell < 1) = 0;                         % ���Ϊ������״̬��0������λΪ0
    
    actcell = newactcell;
    % ��¼ʱ��t������Ԫ״̬
    jacell(:, t) = actcell;
end
end
