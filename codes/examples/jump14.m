% 该函数主要用来测试 celljump14.m
n = 5;
connect = [
    0, 0.3, 0.2, 0.6, 0;
    0.3, 0, 0.5, 0.7, 0; 
    0.4, 0.3, 0, 0, 0.7; 
    0.2, 0.2, 0.3, 0, 0.3;
    0.5, 0.8, 0.5, 0, 0
    ];
% 第一次激励产生的细胞发放状态
runtime01 = 2;
inact = zeros(n,1);
input = zeros(n,runtime01);
input(1,1) = 1;
input(3,1) = 1;
input(4,1) = 1;
jacell = celljump14(n, connect, input, inact, runtime01)

% 在第一次发放的基础上产生第二次的细胞发放
inact = jacell(:, runtime01);
runtime02 = 2;
input = zeros(n,runtime02);
jacell = celljump14(n,connect,input,inact,runtime02)