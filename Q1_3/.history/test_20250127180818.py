import matplotlib.pyplot as plt
import numpy as np

# 提取数据（示例数据，实际需从表格中读取）
projects = ["SWM", "OWS", "BKB", "JUD", "SKB", "SWA", "SRF", "GTR", "AFB", "CTR"]
countries = ["China", "USA", "France"]
mse_data = [
    [0.06234, 0.01282, 0.01333],   # SWM
    [0.04370, 0.01255, 0.01831],   # OWS
    [0.03798, 0.00863, 0.01544],   # BKB
    [0.03680, 0.00785, 0.00628],   # JUD
    [0.03459, 0.00341, 0.00604],   # SKB
    [0.02918, 0.00707, 0.02215],   # SWA
    [0.02546, 0.01828, 0.00713],   # SRF
    [0.02514, 0.00109, 0.00990],   # GTR
    [0.02388, 0.00298, 0.02856],   # AFB
    [0.02154, 0.00850, 0.01325]    # CTR
]

# 设置3D坐标
fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')

# 生成柱状图位置
xpos = np.arange(len(projects))
ypos = np.arange(len(countries))
xpos, ypos = np.meshgrid(xpos, ypos, indexing="ij")
xpos = xpos.flatten()
ypos = ypos.flatten()
zpos = np.zeros_like(xpos)

# 柱状图高度和颜色
dx = dy = 0.4
dz = [val for sublist in mse_data for val in sublist]
colors = ['#FF6B6B', '#4ECDC4', '#556270']  # 中国、美国、法国对应颜色

# 绘制柱状图
for i in range(len(dz)):
    ax.bar3d(xpos[i], ypos[i], zpos[i], dx, dy, dz[i], color=colors[ypos[i]])

# 坐标轴标签
ax.set_xticks(np.arange(len(projects)) + dx/2)
ax.set_xticklabels(projects, rotation=45, ha='right')
ax.set_yticks(np.arange(len(countries)) + dy/2)
ax.set_yticklabels(countries)
ax.set_zlabel('MSE')

# 视角调整和图例
ax.view_init(elev=20, azim=-45)
ax.legend(handles=[
    plt.Rectangle((0,0),1,1, color=colors[0], label="China"),
    plt.Rectangle((0,0),1,1, color=colors[1], label="USA"),
    plt.Rectangle((0,0),1,1, color=colors[2], label="France")
], loc='upper right')

plt.title("MSE Comparison Across Projects and Countries (Top 10 Projects)")
plt.tight_layout()
plt.show()