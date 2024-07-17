% 清空环境变量
close all;
clear;
clc;
format compact;
index=readmatrix("index.csv");

pos=readmatrix('Test1.csv');
pos=pos(:,index);

neg=readmatrix('Test0.csv');

neg=neg(:,index);
pos_labels=1*ones(size(pos,1),1);
neg_labels=2*ones(size(neg,1),1);


single_test=[pos;neg];
single_test_labels=[pos_labels;neg_labels];

P_test = single_test';
T_test = single_test_labels';

%ps_input=load('cnnps.mat');
%P_test = mapminmax('apply', P_test, ps_input.ps_input);


N = size(P_test, 2);
P_test  =  double(reshape(P_test , 434, 1, 1, N));

p_test={};
net=load('BiLSTM.mat');
for i = 1 : N
    p_test{i, 1} = P_test( :, :, 1, i);
end

for i=1:10
YPred = predict(net.Net(1), p_test ); 

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

%计算数据
FP=nt-TN;FN=pt-TP;
SN(i)=TP/(TP+FN);
SP(i)=TN/(TN+FP);
ACC(i)=(TP+TN)/(TP+TN+FP+FN);
MCC(i)=(TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
[AUC(i), curve]=ROC(YPred(:,1), T_test,1,2);
Number=[FN,FP,TN,TP];
end
SN=mean(SN);
SP=mean(SP);
ACC=mean(ACC);
MCC=mean(MCC);
AUC=mean(AUC);
result = [SN,SP,ACC,MCC,AUC]