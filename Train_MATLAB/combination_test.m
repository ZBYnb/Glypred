close all;
clear;
clc;
format compact;


pos_kmer=csvread('Poskmer_test.csv');
pos_DR=csvread('PosDR_test.csv');

neg_kmer=csvread("Negkmer_test.csv");
neg_DR=csvread('NegDR_test.csv');

pos=[pos_DR,pos_kmer];
neg=[neg_DR,neg_kmer];


csvwrite('Postest.csv', pos);
csvwrite('Negtest.csv',neg);

