clc
clear
close all
load("uniqueMedalNOCs.mat")
load("ts_DATA.mat")
change_set = {};
new_set = {};
num = 0;
for c=1:size(uniqueMedalNOCs,1)
    if size(ts_DATA{c,1},1)>10 %有一定的长度再进行变点检测
        seq = ts_DATA{c,1};
        % 设置滑动窗口大小
        window_size = floor(size(seq,1)*0.4);

        % 初始化变点位置
        changepoints = [];

        % 逐步进行 Anderson-Darling 检验
        for i = window_size+1:length(seq)-window_size
            % 划分前后部分
            data1 = seq(i-window_size:i-1);  % 前一部分
            data2 = seq(i:i+window_size-1);  % 后一部分

            % 进行 Anderson-Darling 检验
            [h, p, adstat] = adtest(data1);  % 对前一部分进行检验
            if h == 1  % 如果前部分不符合假设分布
                changepoints = [changepoints; i];  % 记录变点位置
            end
        end
        if size(changepoints,1)>6
            num = num +1;
            change_set{num,1} = changepoints;
            new_set{num,1} = seq;
            new_set{num,2} = ts_DATA{c,2};
            country{num,1} = uniqueMedalNOCs(c);
        end

    end
end
%% 下面绘图
figure;
for i = 1:5
    subplot(3, 2, i);

    % 获取数据
    y = new_set{i, 1};
    x = 1:1:size(y, 1);

    % 绘制数据线
    plot(x, y, 'LineWidth', 2, 'Color', [0.2, 0.6, 0.8]); % 使用蓝色调线条
    hold on;

    % 获取变点区域
    x1 = min(change_set{i, 1});
    x2 = max(change_set{i, 1});
    y_min = min(y);
    y_max = max(y);

    % 使用 fill 函数绘制红色半透明阴影
    fill([x1, x1, x2, x2], [y_min, y_max, y_max, y_min], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    % 设置坐标轴和标题
    xlabel('Time', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Total medals', 'FontSize', 12, 'FontWeight', 'bold');
    xticklabels(num2str(new_set{i, 2}))
    xticks(1:1:max(x));
    % 设置标题
    title([country{i}], 'FontSize', 14);

    % 增加网格线
    grid on;
set(gca, 'XTickLabelRotation', 60);
    % 调整坐标轴范围（如有需要，可以根据数据调整）
    axis tight;

    % 设置字体
    set(gca, 'FontSize', 10, 'FontName', 'Arial');

end