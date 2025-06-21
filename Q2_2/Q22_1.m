clc
clear
close all
load("athletes_times.mat")
% 把要的国家筛选出来
athletes_USA = athletes(strcmp(athletes.NOC, "USA"),:);
athletes_ITA = athletes(strcmp(athletes.NOC, "ITA"),:);
athletes_FRA = athletes(strcmp(athletes.NOC, "FRA"),:);

%% USA
USA_set = {};
sport = unique(athletes_USA.Sport); %找出所有运动
for i=1:size(sport,1)
    USA_set{i,1} = sport{i}; %运动名
    athletes_temp = athletes_USA(strcmp(athletes_USA.Sport, sport{i}),:);
    USA_set{i,2} = sum(~strcmp(athletes_temp.Medal,'No medal')); %总奖牌数
    USA_set{i,3} = sum(strcmp(athletes_temp.Medal,'Gold')); %总金牌数
    USA_set{i,4} = size(unique(athletes_temp.Year),1); %参赛次数
end

%% ITA
ITA_set = {};
sport = unique(athletes_ITA.Sport); %找出所有运动
for i=1:size(sport,1)
    ITA_set{i,1} = sport{i}; %运动名
    athletes_temp = athletes_ITA(strcmp(athletes_ITA.Sport, sport{i}),:);
    ITA_set{i,2} = sum(~strcmp(athletes_temp.Medal,'No medal')); %总奖牌数
    ITA_set{i,3} = sum(strcmp(athletes_temp.Medal,'Gold')); %总金牌数
    ITA_set{i,4} = size(unique(athletes_temp.Year),1); %参赛次数
end

%% FRA
FRA_set = {};
sport = unique(athletes_FRA.Sport); %找出所有运动
for i=1:size(sport,1)
    FRA_set{i,1} = sport{i}; %运动名
    athletes_temp = athletes_FRA(strcmp(athletes_FRA.Sport, sport{i}),:);
    FRA_set{i,2} = sum(~strcmp(athletes_temp.Medal,'No medal')); %总奖牌数
    FRA_set{i,3} = sum(strcmp(athletes_temp.Medal,'Gold')); %总金牌数
    FRA_set{i,4} = size(unique(athletes_temp.Year),1); %参赛次数
end