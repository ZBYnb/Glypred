close all;
clear;
clc;
format compact;
index=readmatrix("index.csv");
pos=readmatrix('POS.csv');
pos=pos(:,index);
neg=readmatrix('NEG.csv');
neg=neg(:,index);

pos_labels=1*ones(size(pos,1),1);
neg_labels=2*ones(size(neg,1),1);

Kfoldxapp=[pos;neg];
Kfoldyapp=[pos_labels;neg_labels];


yappTrain=Kfoldyapp;
xappTrain=Kfoldxapp;





P_train = xappTrain';
T_train = yappTrain';
M = size(P_train, 2);
t_train = categorical(T_train)';



%% 数据平铺
P_train =  double(reshape(P_train, 434, 1, 1, M));

%%  数据格式转换
p_train={};
for i = 1 : M
    p_train{i, 1} = P_train(:, :, 1, i);
end

%%  网络设置
layers = [
    sequenceInputLayer(434,'Name','INPUT')
    bilstmLayer(64,'OutputMode','last')
    dropoutLayer(0.2,'Name','drop1')
    reluLayer
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(2) %进行分类
    softmaxLayer
    classificationLayer
    ];
%%  参数设置
options = trainingOptions('adam', ...       % Adam 梯度下降算法
    'MaxEpochs', 50, ...                    % 最大迭代次数
    'InitialLearnRate', 0.01, ...
    'LearnRateSchedule', 'piecewise', ...   % 学习率下
    'MiniBatchSize',64,...
    'LearnRateDropFactor', 0.1, ...         % 学习率下降因子
    'LearnRateDropPeriod', 50, ...          % 经过25次训练后 学习率为 0.001 * 0.1    
    'Shuffle', 'every-epoch', ...           % 每轮是否打乱16
    'Plots', 'training-progress', ...       % 画出曲线
    'Verbose', false ...
    );


%%  训练模型

net = trainNetwork(p_train, t_train, layers, options);
Net=net;%记录每一个模型


analyzeNetwork(net);%展示模型结构
save('BiLSTM.mat','Net')%保存每一个模型
exportONNXNetwork(net,"model.onnx")
