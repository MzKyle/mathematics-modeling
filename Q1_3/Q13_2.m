% Q13_2.m
clc;
clear;
load("R.mat"); % 加载相关系数矩阵
load("medal.mat"); % 加载奖牌数据

% 目标国家：中国、美国、法国
targetCountries = {'CHN', 'USA', 'FRA'};

% 访问国家数据（确保R矩阵顺序正确）
if size(R, 1) >= 3
    r1 = R{1, 1}; % 中国
    r2 = R{2, 1}; % 美国
    r3 = R{3, 1}; % 法国
else
    error('R矩阵数据不足');
end

%% ========== 灵敏度分析 ==========
% 添加高斯噪声
noise_level = 0.1;
r1_noisy = r1 + noise_level * randn(size(r1));
r2_noisy = r2 + noise_level * randn(size(r2));
r3_noisy = r3 + noise_level * randn(size(r3));

%% ========== 综合灵敏度计算 ==========
% 计算国家综合灵敏度（平均MSE）
country_mse = [
    mean(mean((r1 - r1_noisy).^2)),   % 中国
    mean(mean((r2 - r2_noisy).^2)),   % 美国
    mean(mean((r3 - r3_noisy).^2))    % 法国
];

%% ========== 3D综合灵敏度可视化 ==========
figure('Position', [100, 100, 800, 600], 'Color', [0.98 0.98 0.98],...
       'InvertHardcopy','off');

% 创建3D柱状图
ax = axes('Parent', gcf);
h = bar3(ax, country_mse); % 使用行向量（1x3 矩阵）

% 图表标注设置
title('National comprehensive sensitivity analysis of Olympic events',...
      'FontSize', 20, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2])
zlabel('Comprehensive sensitivity index（MSE）', 'FontSize', 16, 'FontWeight', 'bold')

% ========== 视觉增强设置 ==========
% 颜色映射
cmap = flipud(parula(256));
colormap(cmap);

% 柱子样式设置
for k = 1:length(h)
    h(k).FaceAlpha = 0.85;
    h(k).EdgeColor = [0.4 0.4 0.4];
    h(k).LineWidth = 0.8;
    % Assign CData correctly for each bar
    h(k).CData = repmat(k, size(h(k).ZData)); % Assign color based on country
end

% ========== 坐标轴设置 ==========
% X轴国家标签
set(ax, 'XTickLabel', targetCountries,... % 直接使用国家名称作为标签
        'XTick', 1:3,...
        'FontSize', 14,...
        'FontWeight', 'bold');

% Y轴隐藏（单维度数据）
set(ax, 'YTick', []);

% 视角设置
view(ax, -20, 30)
set(ax, 'Projection', 'perspective')

% ========== 辅助元素 ==========
% 动态颜色条范围
caxis([min(country_mse)-0.1 max(country_mse)+0.1])
cb = colorbar('eastoutside');
cb.Label.String = 'Sensitivity level';
cb.Label.FontSize = 14;
cb.Label.FontWeight = 'bold';

% 添加数值标签和国家标签
for i = 1:length(country_mse)
    % 在柱子前面添加国家标签
    text(0, i, 0, targetCountries{i},... % 调整位置参数
        'FontSize', 14,...
        'FontWeight', 'bold',...
        'Color', [0.2 0.2 0.2],...
        'HorizontalAlignment', 'center',...
        'VerticalAlignment', 'middle');
    
    % 在柱子顶部添加数值标签
    text(i, 1, country_mse(i)+0.02,... 
        num2str(country_mse(i), '%.3f'),...
        'FontSize', 12,...
        'FontWeight', 'bold',...
        'Color', [0.3 0.3 0.3],...
        'HorizontalAlignment', 'center',...
        'VerticalAlignment', 'bottom');
end

% ========== 导出设置 ==========
exportgraphics(gcf, 'National comprehensive sensitivity analysis.png',...
              'Resolution', 600,... 
              'BackgroundColor', [0.98 0.98 0.98]);

% 添加显示代码
drawnow;

%% ========== 保留原有数据输出功能 ==========
% ...（原有数据输出到Excel的代码保持不变）

disp('可视化完成');