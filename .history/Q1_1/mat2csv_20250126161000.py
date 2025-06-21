import scipy.io
import pandas as pd

def mat_to_csv(mat_path, csv_path, variable_name='your_var_name'):
    """
    将 .mat 文件转换为 CSV 文件
    
    参数：
    mat_path: 输入的 .mat 文件路径（字符串）
    csv_path: 输出的 CSV 文件路径（字符串）
    variable_name: 需要导出的变量名（字符串）
    """
    # 加载 MAT 文件
    mat_data = scipy.io.loadmat(mat_path)
    
    # 获取指定变量数据
    data = mat_data[variable_name]
    
    # 转换数据为 DataFrame（根据数据类型调整）
    if data.dtype.names:  # 如果是结构体数组
        df = pd.DataFrame(data.item())
    else:                 # 如果是普通数值数组
        df = pd.DataFrame(data)
    
    # 保存为 CSV（带索引可选）
    df.to_csv(csv_path, index=False, encoding='utf-8')
    print(f"成功转换 {variable_name} 到 {csv_path}")

# 使用示例（假设你的变量名为 'athletes'）
mat_to_csv('Q1_1/medal.mat', 'Q1_1/medal.mat', 'medal')