clc
clear
d=xlsread('判断矩阵.xlsx');
data=d;


string_name={'Total Medals','Total Gold Medals','Number of entries'};
xvalues = string_name;
yvalues = string_name;
h=heatmap(xvalues,yvalues,data, 'FontSize',10, 'FontName','宋体');
color = ncl_colormap('cmocean_algae');
% color = [250/255,127/255,111/255;
%     130/255,176/255,210/255;
%     190/255,184/255,220/255;
%     231/255,218/255,210/255;
%     153/255,153/255,153/255];
colormap(color)
set(gcf,'Color',[1 1 1])
function color = ncl_colormap(colorname)

temp = import_ascii([colorname '.rgb']);
temp(1:2) = [];
temp = split(temp,'#');
temp = temp(:,1);
% color = deblank(color);
temp = strtrim(temp);
temp = regexp(temp, '\s+', 'split');
for i=1:size(temp,1)
    color(i,:) = str2double(temp{i});    
end
color = color/255;
end

function ascii = import_ascii(file_name)
i = 1;
fid = fopen(file_name);
while feof(fid) ~= 1
    tline = fgetl(fid);
    ascii{i,1} = tline; i = i + 1;
end
fclose(fid);
end