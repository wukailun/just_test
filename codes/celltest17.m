clear; clc;
%% Step 1: ������������ʼ��������Ԫ���������Ӿ���
% ��������chunk֮�����Ӿ���Ĳ���
inter_param = struct();
inter_param.n = 30;
inter_param.n_forward = 3;
inter_param.p_adj = 0.62;
inter_param.p_pro = 0.06;
inter_param.p_pre = 0.08;
inter_param.wpath = 5;
inter_param.out_thresh = 0.001;
inter_param.in_thresh = 0.001;

% ��ʾ��Ԫchunk֮�����Ӿ�������ɸ���
p_inter = 0.03; 

% ��������chunk�ڲ����Ӿ���Ĳ���
chunk_param = struct();
chunk_param.n = 200;
chunk_param.n_forward = 20;
chunk_param.p_pre = 0.03;
chunk_param.p_adj = 0.13;
chunk_param.p_pro = 0.04;
chunk_param.wpath = 2.5;

% ����������Ԫ���������Ӿ���
connect = whole_conn(inter_param, p_inter, chunk_param);

% ��������
load('input01.mat');
load('wdint17.mat')
%% 
n = chunk_param.n; % ÿһ����Ԫ������
p_inhib = 0.05; %��������Ԫ�����Ƹ���
% ncj = chunk_param.n_forward;
num_neuron = inter_param.n * n; % ��������Ԫ���ܸ���
num_chunk = inter_param.n; % ������ chunk �ĸ���
runtime = 400;

inht = zeros(num_chunk, runtime + 20);

nkr1 = round(rand(1) * 90 + 1);
nkr2 = round(rand(1) * 90 + 1);

% ztt������¼����ʱ��ÿ��chunk���ڷ���״̬����Ԫ������ÿ��Ϊһ��ʱ��
ztt = zeros(runtime, num_chunk + 1);

dint1 = zeros(num_chunk, 1) + 0.5;
dint2 = zeros(num_chunk, 1) + 5;

trace = zeros(num_neuron, 1); % ��¼��Ԫ�ķ��Ŵ���
nacell = zeros(1, num_chunk);

inact = zeros(num_neuron, 1); % ��¼ǰһ��ʱ�̵ķ���״̬
njacell = zeros(num_neuron, runtime); % �����洢����ʱ������Ԫ��״̬

%%
tic;
for tt = 1:runtime
    tt
%     nkr1 = round(rand(1) * 90 + 1);
%     nkr2 = round(rand(1) * 90 + 1);
%     nkr3 = round(rand(1) * 90 + 1);
%     nkr4 = round(rand(1) * 90 + 1);
    nkr1 = 16;
    nkr2 = 16;
    nkr3 = 50;
    nkr4 = 50;
%     if tt > 100
%         %zk = 3;
%     end
    rt = 1;
    input = zeros(num_neuron, 1);
    winput = 1;
    
    % Step 1: ������һ����Ԫ�ļ����� input(1: n) �ĳ�ʼֵ
    % ����ĸ�����ͬ���룬����ͨ������ mod(tt, k) �е� k ���ƶ�����������˳��
    switch mod(tt, 2)
        case 1
            input(1: n) = winput * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr1);
        case 2
            input(1: n) = winput * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr2);
        case 3
            input(1: n) = winput * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr3);
        case 0
            input(1: n) = winput * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr2);
    end
            
    % Step 2: ������ 7 (hp + 1)�ŵļ�����ʼֵ����input(6 * n + 1: 7 * n)
    hp = 6;
    whp = 0;
    nkr1 = 54;
    nkr2 = 21;
    nkr3 = 21;
    nkr4 = 21;
    nkr5 = 21;
    nkr6 = 21;
    nkr7 = 21;
    nkr8 = 21;
    zk2 = mod(tt,8);
    switch mod(tt, 8)
        case 1
            input(hp * n + 1: (hp + 1) * n) = whp * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr1);
        case 2
            input(hp * n + 1: (hp + 1) * n) = whp * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr2);
        case 3
            input(hp * n + 1: (hp + 1) * n) = whp * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr3);
        case 4
            input(hp * n + 1: (hp + 1) * n) = whp * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr4);
        case 5
            input(hp * n + 1: (hp + 1) * n) = whp * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr5);
        case 6
            input(hp * n + 1: (hp + 1) * n) = whp * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr6);
        case 7
            input(hp * n + 1: (hp + 1) * n) = whp * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr7);
        case 0
            input(hp * n + 1: (hp + 1) * n) = whp * (0.9 + 0.39 * rand(n, 1)) .* input01(1: n, nkr8);
    end

    % Step 3:  inht(r, tt)��ʾʱ��tt��chunk ���Ϊ r ��������Ԫ��input ��Ҫ���ӵ���
    inht_expand = repmat(inht(:, tt), 1, n)';
    input = input + (rand(length(input), 1) > p_inhib) .* inht_expand(:);
    
    % Step 4: ����һ����ת��״̬����¼
    % �õ�һ�ε�ǰʱ���������Ԫ״̬
    jacell = celljump14(num_neuron, connect, input, inact, 1);
    % ����ǰ״̬�洢������״̬��¼������
    njacell(:, tt) = jacell;
    % ��¼ÿ����Ԫ��ȫ��ʱ���еķ��Ŵ���
    trace = trace + (jacell == 1) * 1;
    % ����ǰ��Ԫ״̬��Ϊ�´η��ŵĳ�ʼ״̬
    inact = jacell;
    % �����ʱÿ�� chunk �д��ڷ���״̬����Ԫ����, num_chunk * 1 vector
    nacell = sum(reshape(jacell, n, num_chunk) == 1, 1)';
    
    % ztt��ÿ�м�¼��chunk��Ԫ���ڷ���״̬������
    ztt(tt,1) = tt;
    ztt(tt, 2: end) = nacell';

    % Step 5: ������������Ԫ������
    % ��ĳ�������ڷ���״̬����Ԫ��������һ��ֵ������������Ԫ��������������ǿ
    inht(:, tt + 1: tt + 8) = inht(:, tt + 1: tt + 8) - ...  % ��һ����������Ԫ
        repmat((nacell > 20), 1, 8) .* (wdint1(1: num_chunk, 1: 8) .* repmat(dint1, 1, 8));
    inht(:, tt + 1: tt + 6) = inht(:, tt + 1: tt + 6) - ...  % �ڶ�����������Ԫ
        repmat((nacell > 50), 1, 6) .* (wdint1(1: num_chunk, 1: 6) .* repmat(dint2, 1, 6));
end
toc;

%%
ztt1 = ztt(:, 2: end); % ÿ�б�ʾһ��ʱ������ chunk �ķ���״̬��Ԫ����
sztt = sum(ztt1, 2); % ÿ��Ԫ�ر�ʾһ��ʱ������ chunk �ķ���״̬��Ԫ����

figure;imagesc(ztt1)
noten = 1;
njacellex4(:,:,noten) = njacell;
traceex4(:,:,noten) = trace;
