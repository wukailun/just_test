function jacell = celljump14(n, connect, input, inact, runtime)
%低时间分辨率模型（2ms一帧记录）
% 本段代码中的问题：发放状态的电位值是没有用的，因为神经元一旦发放就会进入不应期

% act 状态    ：未发放0      发放中1     不应期2
% 状态电位值  ：   0           2          -1.3

jacell = zeros(n,runtime); % 记录每个细胞的act状态，记法与actcell相同
pcell = zeros(n,1); % -2~1表示当前电位，超过1记为2即发放，发放下一时刻降为-1.3，再下一时刻回到0
actcell = inact; % 未发放记为0，发放中记为1，不应期记为2
for t = 1:runtime
    % 上一时刻为发放状态（1），则此时有两个动作
    % 1. 通过内部突触激励刺激其他细胞
    % 2. 自身电位降为 -1.3 并进入 相对不应期（2）
    newactcell = zeros(n,1);
    pcell(actcell == 1) = -1.3;
    newactcell(actcell == 1) = 2; % 神经元在发放后自身电位立刻降至 -1.3 
    
    % 外源输入 与 内部突触激励
    % 上一时刻为 未发放状态（0）和相对不应期（2）的神经元均对外界无作用
    pcell = pcell + input(:, t) + connect * (1 - abs(actcell - 1));
    
    % 内部突触激励后，改变状态
    newactcell(pcell >= 1) = 1; % 电位 >= 1, 则为发放中状态(1)，电位值为 2
    pcell(pcell >= 1) = 2;
    newactcell((pcell < 1) & (actcell == 2)) = 0; % 电位 < 1, 且前一状态为不应期 (2)，电位值为 2
    pcell(pcell < 1) = 0;                         % 则变为不发放状态（0），电位为0
    
    actcell = newactcell;
    % 记录时刻t所有神经元状态
    jacell(:, t) = actcell;
end
end
