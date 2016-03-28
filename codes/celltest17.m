clear; clc;
%% Step 1: 给出参数并初始化所有神经元的整体连接矩阵
% 用来生成chunk之间连接矩阵的参数
inter_param = struct();
inter_param.n = 30;
inter_param.n_forward = 3;
inter_param.p_adj = 0.62;
inter_param.p_pro = 0.06;
inter_param.p_pre = 0.08;
inter_param.wpath = 5;
inter_param.out_thresh = 0.001;
inter_param.in_thresh = 0.001;

% 表示神经元chunk之间连接矩阵的生成概率
p_inter = 0.03; 

% 用来生成chunk内部连接矩阵的参数
chunk_param = struct();
chunk_param.n = 200;
chunk_param.n_forward = 20;
chunk_param.p_pre = 0.03;
chunk_param.p_adj = 0.13;
chunk_param.p_pro = 0.04;
chunk_param.wpath = 2.5;

% 生成所有神经元的总体连接矩阵
connect = whole_conn(inter_param, p_inter, chunk_param);

% 加载输入
load('input01.mat');
load('wdint17.mat')
%% 
n = chunk_param.n; % 每一团神经元的数量
p_inhib = 0.05; %抑制性神经元的抑制概率
% ncj = chunk_param.n_forward;
num_neuron = inter_param.n * n; % 网络中神经元的总个数
num_chunk = inter_param.n; % 网络中 chunk 的个数
runtime = 400;

inht = zeros(num_chunk, runtime + 20);

nkr1 = round(rand(1) * 90 + 1);
nkr2 = round(rand(1) * 90 + 1);

% ztt用来记录所有时刻每个chunk处于发放状态的神经元数量，每行为一个时刻
ztt = zeros(runtime, num_chunk + 1);

dint1 = zeros(num_chunk, 1) + 0.5;
dint2 = zeros(num_chunk, 1) + 5;

trace = zeros(num_neuron, 1); % 记录神经元的发放次数
nacell = zeros(1, num_chunk);

inact = zeros(num_neuron, 1); % 记录前一个时刻的发放状态
njacell = zeros(num_neuron, runtime); % 用来存储所有时间点各神经元的状态

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
    
    % Step 1: 给出第一团神经元的激励即 input(1: n) 的初始值
    % 交错的给出不同输入，可以通过调整 mod(tt, k) 中的 k 来制定给出激励的顺序
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
            
    % Step 2: 给出第 7 (hp + 1)团的激励初始值，即input(6 * n + 1: 7 * n)
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

    % Step 3:  inht(r, tt)表示时刻tt，chunk 序号为 r 的所有神经元上input 需要叠加的量
    inht_expand = repmat(inht(:, tt), 1, n)';
    input = input + (rand(length(input), 1) > p_inhib) .* inht_expand(:);
    
    % Step 4: 计算一步跳转的状态并记录
    % 得到一次当前时间点所有神经元状态
    jacell = celljump14(num_neuron, connect, input, inact, 1);
    % 将当前状态存储在整个状态记录矩阵中
    njacell(:, tt) = jacell;
    % 记录每个神经元在全部时间中的发放次数
    trace = trace + (jacell == 1) * 1;
    % 将当前神经元状态作为下次发放的初始状态
    inact = jacell;
    % 计算此时每个 chunk 中处于发放状态的神经元数量, num_chunk * 1 vector
    nacell = sum(reshape(jacell, n, num_chunk) == 1, 1)';
    
    % ztt的每行记录各chunk神经元处于发放状态的数量
    ztt(tt,1) = tt;
    ztt(tt, 2: end) = nacell';

    % Step 5: 考虑抑制性神经元的作用
    % 若某个区域处于发放状态的神经元数量多于一定值，则抑制性神经元对其抑制作用增强
    inht(:, tt + 1: tt + 8) = inht(:, tt + 1: tt + 8) - ...  % 第一种抑制性神经元
        repmat((nacell > 20), 1, 8) .* (wdint1(1: num_chunk, 1: 8) .* repmat(dint1, 1, 8));
    inht(:, tt + 1: tt + 6) = inht(:, tt + 1: tt + 6) - ...  % 第二种抑制性神经元
        repmat((nacell > 50), 1, 6) .* (wdint1(1: num_chunk, 1: 6) .* repmat(dint2, 1, 6));
end
toc;

%%
ztt1 = ztt(:, 2: end); % 每行表示一个时刻所有 chunk 的发放状态神经元数量
sztt = sum(ztt1, 2); % 每个元素表示一个时刻所有 chunk 的发放状态神经元总数

figure;imagesc(ztt1)
noten = 1;
njacellex4(:,:,noten) = njacell;
traceex4(:,:,noten) = trace;
