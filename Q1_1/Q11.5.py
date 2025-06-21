import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.io import loadmat

# 设置绘图风格
sns.set_theme(style="whitegrid", palette="pastel")
plt.rcParams['font.family'] = 'Arial'
plt.rcParams['axes.labelsize'] = 10
plt.rcParams['axes.titlesize'] = 12

# 加载数据
medal = pd.read_csv('medal.csv')  # 假设已转换为 CSV
pre = pd.read_excel("95个城市预测结果.xlsx")
country = pre['NOC'].values

# 构建历史数据
hData = []
for c in country:
    temp = medal[medal['NOC'] == c]
    hData.append(temp[['Year','Gold','Silver','Bronze','Total']].values.astype(float))

# 过滤数据
valid_indices = [i for i, arr in enumerate(hData) if len(arr) > 2]
hData = [hData[i] for i in valid_indices]
pre = pre.iloc[valid_indices]
country = country[valid_indices]

# 随机选择
np.random.seed(42)  # 确保可重复性
selected = np.random.choice(len(country), 28, replace=False)
hData = [hData[i] for i in selected]
pre = pre.iloc[selected]

# 创建可视化
fig, axs = plt.subplots(7, 4, figsize=(20, 28), dpi=300)
plt.subplots_adjust(hspace=0.6, wspace=0.3)

colors = plt.cm.tab10.colors  # 使用现代颜色方案
metrics = ['Gold', 'Silver', 'Bronze', 'Total']

for idx, (ax, (_, row)) in enumerate(zip(axs.flat, pre.iterrows())):
    # 准备数据
    history = hData[idx][:, 1:]  # 跳过年份列
    prediction = row[2:].values.astype(float)
    full_data = np.vstack([history, prediction])
    
    # 绘制时间序列
    time_points = np.arange(1, full_data.shape[0]+1)
    for col in range(4):
        # 历史数据
        ax.plot(time_points[:-1], 
                full_data[:-1, col],
                color=colors[col],
                lw=1.5,
                marker='o',
                markersize=6,
                markerfacecolor='white',
                markeredgewidth=1.5,
                label=metrics[col] if idx == 0 else None)
        
        # 预测值和误差条
        deviation = np.mean(np.abs(full_data[:-1, col] - np.mean(full_data[:-1, col])))
        ax.errorbar(time_points[-1], 
                   full_data[-1, col],
                   yerr=[[deviation], [deviation]],
                   color=colors[col],
                   fmt='D',
                   markersize=8,
                   markerfacecolor='white',
                   markeredgewidth=1.5,
                   capsize=4,
                   elinewidth=1.5)
    
    # 美化设置
    ax.set_title(row['NOC'], fontsize=11, pad=10)
    ax.set_xlim(0.5, full_data.shape[0]+0.5)
    ax.set_xticks(time_points)
    ax.set_xticklabels([f'T+{i}' for i in range(1, len(time_points)+1)])
    ax.tick_params(axis='both', which='major', labelsize=8)
    ax.grid(True, linestyle='--', alpha=0.7)
    
    # 仅在最后一行显示标签
    if idx >= 24:
        ax.set_xlabel('Time Sequence', fontsize=9)
    if idx %4 ==0:
        ax.set_ylabel('Medal Count', fontsize=9)

# 添加共享图例
handles, labels = ax.get_legend_handles_labels()
fig.legend(handles, labels, 
           loc='lower center', 
           ncol=4, 
           bbox_to_anchor=(0.5, 0.96),
           fontsize=10,
           frameon=True,
           title='Medal Type')

plt.savefig('medal_forecast.png', 
           bbox_inches='tight', 
           dpi=300,
           transparent=False)
plt.show()