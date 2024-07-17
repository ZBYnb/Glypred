close all;
clear;
clc;
format compact;


pos_kmer=csvread('Poskmer.csv');
pos_DR=csvread('PosDR.csv');

neg_kmer=csvread("Negkmer.csv");
neg_DR=csvread('NegDR.csv');


pos=[pos_DR,pos_kmer];
neg=[neg_DR,neg_kmer];


csvwrite('Postrain.csv', pos);
csvwrite('Negtrain.csv',neg);


