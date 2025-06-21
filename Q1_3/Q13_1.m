clc
clear
close all
programs = xlsread("programs.xlsx");
load("medal.mat")
load("athletes_times.mat")

% 只选择中国、美国和法国（已修正为列向量）
Country = {'CHN'; 'USA'; 'FRA'}; 
X = programs(:,2:end);

YSET = {}; % 储存用的表
for c=1:size(Country,1) % 遍历每一个国家
    nowNOC = Country{c}; % 当前要查找的国家
    for i=1:size(programs,1) % 去找每个年份的获奖情况
        year = programs(i,1);
        NOC_medal = medal(strcmp(medal.NOC, nowNOC) & medal.Year == year,{'Gold','Silver','Bronze'}); % 提取奖牌信息
        if ~isempty(NOC_medal)
            YSET{c,1}(i,:) =  table2array(NOC_medal(1,:));
        else
            YSET{c,1}(i,:) = [0 0 0];
        end
    end
end

R = {}; % 储存相关性结果用的表
for c=1:size(Country,1) % 遍历每一个国家
    R{c,1} = zeros(3, size(X,2)); % 初始化每个国家的相关性矩阵
    for e = 1:size(X,2) % 遍历每个项目
        for p =1:size(YSET{c,1},2) % 遍历每个奖项
            x = X(:,e);
            y = YSET{c,1}(:,p);
            if isempty(x)||isempty(y)
                rho =  0;
            else
                rho = corr(x, y, 'Type', 'Spearman');
                if isnan(rho)
                    rho =  0;
                end
            end
            R{c,1}(p,e) = rho;
        end
    end
end

% 保存相关性矩阵
save('R.mat', 'R');