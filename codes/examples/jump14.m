% �ú�����Ҫ�������� celljump14.m
n = 5;
connect = [
    0, 0.3, 0.2, 0.6, 0;
    0.3, 0, 0.5, 0.7, 0; 
    0.4, 0.3, 0, 0, 0.7; 
    0.2, 0.2, 0.3, 0, 0.3;
    0.5, 0.8, 0.5, 0, 0
    ];
% ��һ�μ���������ϸ������״̬
runtime01 = 2;
inact = zeros(n,1);
input = zeros(n,runtime01);
input(1,1) = 1;
input(3,1) = 1;
input(4,1) = 1;
jacell = celljump14(n, connect, input, inact, runtime01)

% �ڵ�һ�η��ŵĻ����ϲ����ڶ��ε�ϸ������
inact = jacell(:, runtime01);
runtime02 = 2;
input = zeros(n,runtime02);
jacell = celljump14(n,connect,input,inact,runtime02)