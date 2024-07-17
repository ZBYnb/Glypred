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



%% ����ƽ��
P_train =  double(reshape(P_train, 434, 1, 1, M));

%%  ���ݸ�ʽת��
p_train={};
for i = 1 : M
    p_train{i, 1} = P_train(:, :, 1, i);
end

%%  ��������
layers = [
    sequenceInputLayer(434,'Name','INPUT')
    bilstmLayer(64,'OutputMode','last')
    dropoutLayer(0.2,'Name','drop1')
    reluLayer
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(2) %���з���
    softmaxLayer
    classificationLayer
    ];
%%  ��������
options = trainingOptions('adam', ...       % Adam �ݶ��½��㷨
    'MaxEpochs', 50, ...                    % ����������
    'InitialLearnRate', 0.01, ...
    'LearnRateSchedule', 'piecewise', ...   % ѧϰ����
    'MiniBatchSize',64,...
    'LearnRateDropFactor', 0.1, ...         % ѧϰ���½�����
    'LearnRateDropPeriod', 50, ...          % ����25��ѵ���� ѧϰ��Ϊ 0.001 * 0.1    
    'Shuffle', 'every-epoch', ...           % ÿ���Ƿ����16
    'Plots', 'training-progress', ...       % ��������
    'Verbose', false ...
    );


%%  ѵ��ģ��

net = trainNetwork(p_train, t_train, layers, options);
Net=net;%��¼ÿһ��ģ��


analyzeNetwork(net);%չʾģ�ͽṹ
save('BiLSTM.mat','Net')%����ÿһ��ģ��
exportONNXNetwork(net,"model.onnx")
