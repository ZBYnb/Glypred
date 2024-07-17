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

n=size(Kfoldxapp,1);
indices = crossvalind('Kfold', n, 10); 


for k=1:10
 test = (indices==k); 
 train = ~test;

 yappTrain=[Kfoldyapp(train,:)];
 xappTrain=[Kfoldxapp(train,:)];

 testXOrg=Kfoldxapp(test,:);
 testYOrg=Kfoldyapp(test,:);



%% ����ѵ�����Ͳ��Լ�
P_train = xappTrain';
T_train = yappTrain';
M = size(P_train, 2);

P_test = testXOrg';
T_test = testYOrg';
N = size(P_test, 2);

t_train = categorical(T_train)';
t_test  = categorical(T_test )';


%% ����ƽ��
P_train =  double(reshape(P_train, 434, 1, 1, M));
P_test  =  double(reshape(P_test,434, 1, 1, N));
p_test={};
p_train={};
%%  ���ݸ�ʽת��
for i = 1 : M
    p_train{i, 1} = P_train(:, :, 1, i);
end

for i = 1 : N
    p_test{i, 1} = P_test( :, :, 1, i);
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
    'LearnRateSchedule', 'piecewise', ...   % ѧϰ���½�
    'LearnRateDropFactor', 0.1, ...         % ѧϰ���½�����
    'LearnRateDropPeriod', 25, ...          % ����25��ѵ���� ѧϰ��Ϊ 0.001 * 0.1    
    'Shuffle', 'every-epoch', ...           % ÿ���Ƿ����16
    'Plots', 'training-progress', ...       % ��������
    'Verbose', false ...
    );


%%  ѵ��ģ��

net = trainNetwork(p_train, t_train, layers, options);
Net=net;


%%  ��֤Ԥ��
YPred = predict(net, p_test ); 
pt=numel(find(T_test==1));
nt=numel(find(T_test==2));
TP=0;TN=0;
for j=1:pt
    if YPred(j,1)>=0.5
        TP=TP+1;
    end
end
for j=pt+1:pt+nt
    if YPred(j,1)<0.5
        TN=TN+1;
    end
end

%��������
t=size(T_test,2);
FP=nt-TN;FN=pt-TP;
Sn(k)=TP/(TP+FN);
Sp(k)=TN/(TN+FP);
acc(k)=(TP+TN)/(TP+TN+FP+FN);
mcc(k)=(TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
[auc(k), curve]=ROC(YPred(:,1), T_test,1,2);
Number=[FN,FP,TN,TP];
end
%%  ʮ�۽�����֤ƽ�����
save('BiLSTM.mat','Net')%����ÿһ��ģ��
SN=mean(Sn);
SP=mean(Sp);
ACC=mean(acc);
MCC=mean(mcc);
AUC=mean(auc);
result = [SN,SP,ACC,MCC,AUC]
