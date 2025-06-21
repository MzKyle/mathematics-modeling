clc
clear
close all
load("medal.mat")
load("athletes_times.mat")
%% 以Swimming为例
Swimming_athletes = athletes(strcmp(athletes.Sport, "Swimming"),:);
%% 先获取所有国家的唯一值
uniqueMedalNOCs = unique(Swimming_athletes.NOC);
ts_DATA = {};
for c=1:size(uniqueMedalNOCs,1) %遍历每一个国家
    nowNOC = uniqueMedalNOCs{c}; %当前要查找的国家
    temp = []; %当前要考虑的国家的表
    % 找到当前 NOC 的所有行
    NOC_Swimming_athletes = Swimming_athletes(strcmp(Swimming_athletes.NOC, nowNOC),:);
    NOC_Swimming_athletes = sortrows(NOC_Swimming_athletes, 'Year', 'ascend');

    uniqueYear = unique(NOC_Swimming_athletes.Year); %获取所有年份
    ts_DATA{c,2} = uniqueYear;
    ts_DATA{c,1} = zeros(size(uniqueYear,1),1);
    for i=1:size(ts_DATA{c,2},1) %遍历每个年份
        year = ts_DATA{c,2}(i,1);
        for p=1:size(NOC_Swimming_athletes,1) %遍历每个人；
            if NOC_Swimming_athletes.Year(p) == year & ~strcmp(NOC_Swimming_athletes.Medal(p),'No medal')
                ts_DATA{c,1}(i,1) = ts_DATA{c,1}(i,1) + 1;
            end
        end
    end
end