clc
clear
close all
load("athletes.mat")
Ano = xlsread("运动员姓名匹配表.xlsx");
%% 先在运动员表中加上每个人的参赛次数
uniqueNames = unique(athletes.Name); % 这将返回一个 cell 数组
Cdata = [Ano double(athletes.Year)]; %创建比较表

for i=1:size(Cdata,1)
    temp_data = Cdata(Cdata(:,1)==Cdata(i,1),:);
    Cdata(i,3) = sum(Cdata(i,2)>temp_data(:,2))+1; %第几年参赛
end
if istable(athletes)
    % 如果 athletes 是表格，直接添加新列
    athletes.times = Cdata(:, 3); % 将 Cdata 的第三列（参赛次数）添加到 athletes 中
elseif isstruct(athletes)
    % 如果 athletes 是结构体，动态添加字段
    athletes.times = Cdata(:, 3); % 将 Cdata 的第三列（参赛次数）添加到 athletes 中
else
    error("athletes 必须是表格或结构体");
end

save("athletes_times.mat","athletes");