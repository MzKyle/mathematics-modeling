clc
clear
close all
load('BP_data.mat')
load('input28.mat')
data = [];
for i=1:size(BP_data,1)
    data = [data ; BP_data{i,2}];
end
R = randperm(size(data,1));
data = data(R,:);

train_ratio=0.90;%用作训练集的比例
train1=data(1:(floor(train_ratio*size(data, 1))),:);%前95%用于训练
x_train=train1(:,1:end-1);
y_train=train1(:,end);
test1=data(((floor(train_ratio*size(data, 1)))+1):size(data, 1),:);%后5%用于测试
x_test=test1(:,1:end-1);
y_test=test1(:,end);
% 进行标准化
[x_train_normalized, mu, sigma] = zscore(x_train);
x_test_normalized = (x_test - mu) ./ sigma;

%建立网络
net=feedforwardnet([30]);%建立一个隐含层数为1，节点数为10的网络;这里用了梯度下降的训练函数

%定义在训练集过程中不使用测试集，只保留训练集与验证集（用于验证泛化能力）
net.divideParam.trainRatio = 80/100; %训练集
net.divideParam.valRatio = 20/100; %验证集
net.divideParam.testRatio = 0/100; %测试集
% net.trainParam.showWindow = 0;
net.trainParam.epochs=5000;%指定最大迭代次数
net.trainParam.goal=0;%目标精度，验证集的误差达到该数字时就停止迭代
% net.trainParam.min_grad=1e-2;%最小下降梯度
% net.trainParam.lr=0.1;%学习率
% net.trainparam.max_fail =50;%持续无法优化次数（泛化能力）
% net.layers{2}.transferFcn= 'logsig';%指定传递函数
%训练网络。
net=train(net,x_train_normalized',y_train');%注意，这里每一列为一个实例，所以需要转置
%测试效果
test_out=sim(net,x_test_normalized');%测试
test_out=test_out';
%分类
test_out=round(test_out);
test_out(test_out<0) = 0;
test_out(test_out>1) = 1;
%评价
y_true = y_test;
y_pred = test_out;
% 计算 True Positive (TP)、True Negative (TN)、False Positive (FP) 和 False Negative (FN)  
TP = sum((y_true == 1) & (y_pred == 1));  
TN = sum((y_true == 0) & (y_pred == 0));  
FP = sum((y_true == 0) & (y_pred == 1));  
FN = sum((y_true == 1) & (y_pred == 0));  
  
% 计算准确率（Accuracy）  
accuracy = (TP + TN) / (TP + TN + FP + FN);  
  
% 计算精确率（Precision）  
precision = TP / (TP + FP);  
  
% 计算召回率（Recall）  
recall = TP / (TP + FN);  
  
% 计算 F1 分数（F1 Score）  
F1 = 2 * (precision * recall) / (precision + recall);  
% 显示结果  
fprintf('Accuracy: %f\n', accuracy);  
fprintf('Precision: %f\n', precision);  
fprintf('Recall: %f\n', recall);  
fprintf('F1 Score: %f\n', F1);  
% 预测
predict_set = [];
for c = 1:size(input28,1) %遍历每个国家
    Pdata = input28(c,:); %要预测的数据
    Pdata_normalized = (Pdata - mu) ./ sigma;
    %预测
    y_predict=sim(net,Pdata_normalized');%测试
    y_predict=y_predict';
    %分类
%     y_predict=round(y_predict);
    y_predict(y_predict<0) = 0;
    y_predict(y_predict>1) = 1;
    predict_set = [predict_set;y_predict'];
end
