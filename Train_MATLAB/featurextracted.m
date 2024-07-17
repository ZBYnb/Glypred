  %function [Train_p,Train_n,Test_p,Test_n]=featurextracted()

% 清空环境变量
close all;
clear;
clc;   
format compact

%Kmer
%system('python ./Pse-in-One-2.0/nac.pyc ./1Test.txt Protein Kmer -k 2 -f tab -labels 0 -out PCBmark_pos.txt');
%system('python ./Pse-in-One-2.0/nac.pyc ./0Test.txt Protein Kmer -k 2 -f tab -labels 0 -out PCBmark_neg.txt');
%system('python ./Pse-in-One-2.0/nac.pyc ./pos_3825.txt Protein Kmer -k 1 -f tab -labels 0 -out PCInd_pos.txt');
%system('python ./Pse-in-One-2.0/nac.pyc ./neg_79101.txt Protein Kmer -k 1 -f tab -labels 0 -out PCInd_neg.txt');
%DR
system('python ./Pse-in-One-2.0/nac.pyc ./1Test.txt Protein DR -max_dis 2 -f tab -labels 0 -out PCBmark_pos.txt');
system('python ./Pse-in-One-2.0/nac.pyc ./0Test.txt Protein DR -max_dis 2 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/nac.pyc ./Ind-pos.txt Protein DR -max_dis 4 -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/nac.pyc ./Ind-neg.txt Protein DR -max_dis 4 -f tab -labels 0 -out PCInd_neg.txt');
%Distance Pair
%system('python ./Pse-in-One-2.0/nac.pyc ./pos_3825.txt Protein DR -max_dis 3 -f tab -labels 0 -out PCBmark_pos.txt');
%system('python ./Pse-in-One-2.0/nac.pyc ./neg_79101.txt Protein DR -max_dis 3 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/nac.pyc ./Ind-pos.txt Protein DP -max_dis 4 -cp cp_19 -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/nac.pyc ./Ind-neg.txt Protein DP -max_dis 4 -cp cp_19 -f tab -labels 0 -out PCInd_neg.txt');
% %PC-PseAAC-General
%system('python ./Pse-in-One-2.0/pse.pyc ./pos_3825.txt Protein PC-PseAAC-General -i propChosen.txt -lamada 2 -w 0.1 -f tab -labels 0 -out PCBmark_pos.txt');
%system('python ./Pse-in-One-2.0/pse.pyc ./neg_79101.txt Protein PC-PseAAC-General -i propChosen.txt -lamada 2 -w 0.1 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./Ind-pos.txt Protein PC-PseAAC-General -i propChosen.txt -lamada 2 -w 0.1  -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./Ind-neg.txt Protein PC-PseAAC-General -i propChosen.txt -lamada 2 -w 0.1  -f tab -labels 0 -out PCInd_neg.txt');
% %SC-PseAAC-General
% system('python ./Pse-in-One-2.0/psee.pyc ./Bmark-pos.txt Protein SC-PseAAC-General -i propChosen.txt -lamada 2 -w 0.1 -f tab -labels 0 -out PCBmark_pos.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./Bmark-neg.txt Protein SC-PseAAC-General -i propChosen.txt -lamada 2 -w 0.1 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./Ind-pos.txt Protein SC-PseAAC-General -i propChosen.txt -lamada 2 -w 0.1  -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./Ind-neg.txt Protein SC-PseAAC-General -i propChosen.txt -lamada 2 -w 0.1  -f tab -labels 0 -out PCInd_neg.txt');
%PC-PseAAC
% system('python ./Pse-in-One-2.0/psee.pyc ./pos_3825.txt Protein PC-PseAAC -lamada 2 -w 0.1 -f tab -labels 0 -out PCBmark_pos.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./neg_79101.txt Protein PC-PseAAC -lamada 2 -w 0.1 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./Ind-pos.txt Protein PC-PseAAC -lamada 2 -w 0.1  -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./Ind-neg.txt Protein PC-PseAAC -lamada 2 -w 0.1  -f tab -labels 0 -out PCInd_neg.txt');
%SC-PseAAC
 %system('python ./Pse-in-One-2.0/psee.pyc ./pos_3825.txt Protein SC-PseAAC -lamada 2 -w 0.1 -f tab -labels 0 -out PCBmark_pos.txt');
 %system('python ./Pse-in-One-2.0/psee.pyc ./neg_79101.txt Protein SC-PseAAC -lamada 2 -w 0.1 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./Ind-pos.txt Protein SC-PseAAC -lamada 2 -w 0.1  -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/psee.pyc ./Ind-neg.txt Protein SC-PseAAC -lamada 2 -w 0.1  -f tab -labels 0 -out PCInd_neg.txt');
% %PDT
% system('python ./Pse-in-One-2.0/profile.pyc ./pos_3825.txt Protein PDT -lamada 2 -f tab -labels 0 -out PCBmark_pos.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./neg_79101.txt Protein PDT -lamada 2 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Ind-pos.txt Protein PDT -lamada 2 -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Ind-neg.txt Protein PDT -lamada 2 -f tab -labels 0 -out PCInd_neg.txt');
% %PDT-Profile
% system('python ./Pse-in-One-2.0/profile.pyc ./Bmark-pos.txt Protein PDT-Profile -lamada 1 -n 1 -f tab -labels 0 -out PCBmark_pos.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Bmark-neg.txt Protein PDT-Profile -lamada 1 -n 1 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Ind-pos.txt Protein PDT-Profile -lamada 1 -n 1 -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Ind-neg.txt Protein PDT-Profile -lamada 1 -n 1 -f tab -labels 0 -out PCInd_neg.txt');
% %Top-n-gram
% system('python ./Pse-in-One-2.0/profile.pyc ./Bmark-pos.txt Protein Top-n-gram -n 1 -f tab -labels 0 -out PCBmark_pos.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Bmark-neg.txt Protein Top-n-gram -n 1 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Ind-pos.txt Protein Top-n-gram -n 1 -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Ind-neg.txt Protein Top-n-gram -n 1 -f tab -labels 0 -out PCInd_neg.txt');
% %DT
 %system('python ./Pse-in-One-2.0/profile.pyc ./pos_3825.txt Protein DT -max_dis 1 -f tab -labels 0 -out PCBmark_pos.txt');
%system('python ./Pse-in-One-2.0/profile.pyc ./neg_79101.txt.txt Protein DT -max_dis 1 -f tab -labels 0 -out PCBmark_neg.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Ind-pos.txt Protein DT -max_dis 1 -f tab -labels 0 -out PCInd_pos.txt');
% system('python ./Pse-in-One-2.0/profile.pyc ./Ind-neg.txt Protein DT -max_dis 1 -f tab -labels 0 -out PCInd_neg.txt');

Train_p = load('./PCBmark_pos.txt');
Train_n = load('./PCBmark_neg.txt');
% Test_p = load('./PCInd_pos.txt');
% Test_n = load('./PCInd_neg.txt');