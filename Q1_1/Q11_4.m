clc
clear
close all
load('LSTM_data.mat')
load('input28.mat')
ref = 1;
record_set = [];
predict_set = [];


    Hdata =  LSTM_data{1,2}; % 假设至少有一个子表格

% 循环合并剩余的子表格
numRows = size(LSTM_data, 1); % 获取 LSTM_data 的行数
for i = 1:numRows
    Hdata = vertcat(Hdata, LSTM_data{i, 2});
end

highValueData = Hdata(Hdata(:, 1) + Hdata(:, 2) + Hdata(:, 3) > 70, :); % 筛选高值样本点
Hdata = [Hdata; repmat(highValueData, 6, 1)]; % 复制高值样本点
% 
%% 
for i = size(Hdata,1):-1:1
    if Hdata(i,1)+Hdata(i,2)+Hdata(i,3)<30
        randomValue = rand;

    % 判断随机数是否小于等于0.5
        if randomValue <= 0.8
            Hdata(i,:)=[];
        end


    end

end
%% 

maxValue = max(Hdata(:, 10));
minValue = min(Hdata(:, 10));
Hdata(:, 10) = (Hdata(:, 10) - minValue) / (maxValue - minValue);
maxValue = max(Hdata(:, 11));
minValue = min(Hdata(:, 11));
Hdata(:, 11) = (Hdata(:, 11) - minValue) / (maxValue - minValue);
maxValue = max(Hdata(:, 12));
minValue = min(Hdata(:, 12));
Hdata(:, 12) = (Hdata(:, 12) - minValue) / (maxValue - minValue);

maxValue = max(input28(:, 10));
minValue = min(input28(:, 10));
input28(:, 10) = (input28(:, 10) - minValue) / (maxValue - minValue);
maxValue = max(input28(:, 11));
minValue = min(input28(:, 11));
input28(:, 11) = (input28(:, 11) - minValue) / (maxValue - minValue);
maxValue = max(input28(:, 12));
minValue = min(input28(:, 12));
input28(:, 12) = (input28(:, 12) - minValue) / (maxValue - minValue);




% max1=max(Hdata(:,1));
% max2=max(Hdata(:,2));
% max3=max(Hdata(:,3));
% max4=max(Hdata(:,4));
% max5=max(Hdata(:,5));
% max6=max(Hdata(:,6));
% max7=max(Hdata(:,7));
% max8=max(Hdata(:,8));
% max9=max(Hdata(:,9));
% 
% 
% Hdata(:,1)=(Hdata(:,1))/(max1-0.001);
% Hdata(:,2)=(Hdata(:,2))/(max1-0.001);
% Hdata(:,3)=(Hdata(:,3))/(max1-0.001);
% Hdata(:,4)=(Hdata(:,4))/(max1-0.001);
% Hdata(:,5)=(Hdata(:,5))/(max1-0.001);
% Hdata(:,6)=(Hdata(:,6))/(max1-0.001);
% Hdata(:,7)=(Hdata(:,7))/(max1-0.001);
% Hdata(:,8)=(Hdata(:,8))/(max1-0.001);
% Hdata(:,9)=(Hdata(:,9))/(max1-0.001);
% 
% 
% 
% 
% max1=max(input28(:,1));
% max2=max(input28(:,2));
% max3=max(input28(:,3));
% max4=max(input28(:,4));
% max5=max(input28(:,5));
% max6=max(input28(:,6));
% max7=max(input28(:,7));
% max8=max(input28(:,8));
% max9=max(input28(:,9));
% 
% 
% input28(:,1)=(input28(:,1))/(max1-0.001);
% input28(:,2)=(input28(:,2))/(max1-0.001);
% input28(:,3)=(input28(:,3))/(max1-0.001);
% input28(:,4)=(input28(:,4))/(max1-0.001);
% input28(:,5)=(input28(:,5))/(max1-0.001);
% input28(:,6)=(input28(:,6))/(max1-0.001);
% input28(:,7)=(input28(:,7))/(max1-0.001);
% input28(:,8)=(input28(:,8))/(max1-0.001);
% input28(:,9)=(input28(:,9))/(max1-0.001);

    % Hdata = LSTM_data{:,2}; %历史的训练数据

    Pdata = input28(:,:); %要预测的数据

    



    %% 

    [y_predict]=LSTM(Hdata,Pdata,ref);
    predict_set = [predict_set;y_predict'];


%% 

% for c = 1:size(LSTM_data,1) %遍历每个国家
%     Hdata = LSTM_data{c,2}; %历史的训练数据
%     Pdata = input28(c,:); %要预测的数据
%     [y_predict]=LSTM(Hdata,Pdata,ref);
%     predict_set = [predict_set;y_predict'];
% end
% 计算每一行的和
row_sums = sum(predict_set, 2); % 对每一行求和，sum(..., 2) 表示按行求和

% 将 predict_set 和行和保存到 Excel 表格中
output_data = [predict_set, row_sums]; % 将 predict_set 和行和合并为一个矩阵

one=sum(output_data(:,1));
two=sum(output_data(:,2));
three=sum(output_data(:,3));
four=sum(output_data(:,4));

output_data(:,1)=floor(output_data(:,1)*328/one);
output_data(:,2)=floor(output_data(:,2)*327/two);
output_data(:,3)=floor(output_data(:,3)*384/three);
output_data(:,4)=floor(output_data(:,4)*1039/four);

% 保存到 Excel 文件
filename = '国家奖牌预测.xlsx'; % Excel 文件名
writematrix(output_data, filename,'Range', 'B2'); % 将数据写入 Excel 文件
writecell(LSTM_data(:, 1), filename, 'Range', 'A2');
% 显示保存成功信息
disp(['预测结果已保存到文件: ', filename]);
