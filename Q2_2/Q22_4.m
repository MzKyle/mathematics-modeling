clc
clear
data = xlsread('FRA.xlsx');
W = xlsread('各指标权重.xlsx');
% 1、指标正向化
max1=max(data(:,1));
max2=max(data(:,2));
max3=max(data(:,3));
for i=1:size(data,1)
    data(i,1)=max1-data(i,1);
    data(i,2)=max2-data(i,2);
    data(i,3)=max3-data(i,3);
end
% 2、标准化
normalized_data = mapminmax(data', 0, 1)';
for i=1:size(data,2)
    normalized_data(:,i)=normalized_data(:,i)*W(i);
end
% 3、计算正负距离
maxmin(1,:) = max(normalized_data); 
maxmin(2,:) = min(normalized_data); 
D_score=[];
num_columns = size(normalized_data, 2); % 获取列数  
num_rows = size(normalized_data, 1); % 获取行数  
num_clusters = size(maxmin, 1); % 获取簇的数量  
D_score = zeros(num_rows, num_clusters); % 初始化 D_score 矩阵  
  
for i = 1:num_rows  
    for k = 1:num_clusters  
        sum_of_squares = 0;  
        for j = 1:num_columns  
            sum_of_squares = sum_of_squares + (maxmin(k, j) - normalized_data(i, j)).^2;  
        end  
        D_score(i, k) = sqrt(sum_of_squares);  
    end  
end
% 4、计算得分
score=[];
for i=1:size(D_score,1)
   score(i,1)= D_score(i,2)./(D_score(i,1)+D_score(i,2));
end

