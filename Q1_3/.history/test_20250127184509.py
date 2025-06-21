import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D

# 1. 从Excel文件读取数据
file_path = "Sensitivity_and_Error_Analysis.xlsx"
df = pd.read_excel(file_path, sheet_name="Country_Detailed", header=0)

# 2. 数据预处理
projects = df['Project'].tolist()          # 获取项目列表
countries = ['CHN_MSE', 'USA_MSE', 'FRA_MSE']  # 定义国家列
mse_data = df[countries].values            # 提取MSE数据矩阵

# 3. 创建3D图形
fig = plt.figure(figsize=(16, 10))
ax = fig.add_subplot(111, projection='3d')

# 4. 设置可视化参数
colors = ['#E63946', '#457B9D', '#2A9D8F']  # 现代配色方案：中国红、美国蓝、法国绿
x_labels = projects
y_labels = ['China', 'USA', 'France']

# 5. 生成坐标网格
xpos, ypos = np.meshgrid(np.arange(len(projects)), 
                        np.arange(len(countries)), 
                        indexing="ij")
xpos = xpos.flatten()
ypos = ypos.flatten()
zpos = np.zeros_like(xpos)
dx = dy = 0.6  # 柱体宽度
dz = mse_data.flatten()  # 高度数据

# 6. 绘制3D柱状图
bars = []
for i in range(len(dz)):
    bar = ax.bar3d(xpos[i], ypos[i], zpos[i], 
                  dx, dy, dz[i],
                  color=colors[ypos[i]],
                  edgecolor='w',        # 白色边框
                  linewidth=0.5,        # 边框粗细
                  alpha=0.9,            # 透明度
                  shade=True)           # 启用阴影
    bars.append(bar)

# 7. 添加数据标签
for i in range(mse_data.shape[0]):
    for j in range(mse_data.shape[1]):
        if mse_data[i,j] > 0.01:  # 只标注显著值
            ax.text(x=i+0.3, y=j+0.3, z=mse_data[i,j]+0.005,
                    s=f"{mse_data[i,j]:.3f}",
                    ha='center', va='bottom',
                    fontsize=8, color='#2d3436')

# 8. 坐标轴美化
ax.set_xticks(np.arange(len(projects)) + dx/2)
ax.set_xticklabels(x_labels, rotation=45, ha='right', fontsize=10)
ax.set_yticks(np.arange(len(countries)) + dy/2)
ax.set_yticklabels(y_labels, fontsize=12)
ax.set_zlabel('MSE Value', fontsize=12, labelpad=15)
ax.zaxis.set_tick_params(labelsize=10)

# 9. 视角与光照设置
ax.view_init(elev=2)
plt.show()