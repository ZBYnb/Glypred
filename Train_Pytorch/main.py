import pandas as pd
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, TensorDataset
from sklearn.model_selection import KFold
from sklearn.metrics import roc_auc_score, confusion_matrix
import math
import time
from model_multiattention_new import BiLSTM_attention_fusion_new

# 读取数据
index = pd.read_csv('index.csv').values.flatten()

pos = pd.read_csv('POS.csv')
neg = pd.read_csv('NEG.csv')

# 检查索引范围是否正确
assert np.max(index) <= pos.shape[1], f"Index out of range for POS.csv: max index {np.max(index)}, number of columns {pos.shape[1]}"
assert np.max(index) <= neg.shape[1], f"Index out of range for NEG.csv: max index {np.max(index)}, number of columns {neg.shape[1]}"

# 应用索引
index = index - 1  # 确保索引从0开始
pos = pos.iloc[:, index]
neg = neg.iloc[:, index]

# 标签
pos_labels = np.zeros(pos.shape[0])  # 使用0作为正类标签
neg_labels = np.ones(neg.shape[0])  # 使用1作为负类标签

# 数据和标签合并
Kfoldxapp = np.vstack((pos, neg))
Kfoldyapp = np.hstack((pos_labels, neg_labels))

# K折交叉验证
n = Kfoldxapp.shape[0]
kf = KFold(n_splits=10, shuffle=True, random_state=42)

# 训练和验证
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')  # 定义device
criterion = nn.CrossEntropyLoss()

# 参数设置
num_epochs = 30
learning_rate_schedule = [7]  # 在第25个epoch降低学习率
learning_rate_drop_factor = 0.1

results = {'Fold': [], 'SN': [], 'SP': [], 'ACC': [], 'MCC': [], 'AUC': [], 'Time': []}

for fold, (train_idx, test_idx) in enumerate(kf.split(Kfoldxapp)):
    print(f"\nFold {fold + 1}")

    # 重新初始化模型和优化器
    net = BiLSTM_attention_fusion_new().to(device)
    # net = BiLSTM_attention_fusion_new_MLP().to(device)
    optimizer = optim.Adam(net.parameters(), lr=0.01)

    x_train, x_test = Kfoldxapp[train_idx], Kfoldxapp[test_idx]
    y_train, y_test = Kfoldyapp[train_idx], Kfoldyapp[test_idx]

    # 数据转换为Tensor
    x_train_tensor = torch.tensor(x_train, dtype=torch.float32).unsqueeze(1).to(device)
    y_train_tensor = torch.tensor(y_train, dtype=torch.long).to(device)
    x_test_tensor = torch.tensor(x_test, dtype=torch.float32).unsqueeze(1).to(device)
    y_test_tensor = torch.tensor(y_test, dtype=torch.long).to(device)

    train_dataset = TensorDataset(x_train_tensor, y_train_tensor)
    train_loader = DataLoader(train_dataset, batch_size=64, shuffle=True)

    start_time = time.time()
    # 训练模型
    for epoch in range(num_epochs):
        net.train()
        for inputs, labels in train_loader:
            optimizer.zero_grad()
            outputs = net(inputs)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()

        if epoch in learning_rate_schedule:
            for param_group in optimizer.param_groups:
                param_group['lr'] *= learning_rate_drop_factor

    training_time = time.time() - start_time

    # 验证模型
    net.eval()
    with torch.no_grad():
        outputs = net(x_test_tensor)
        _, predicted = torch.max(outputs, 1)
        probas = outputs[:, 1].cpu().numpy()
        predicted = predicted.cpu().numpy()  # 转换为NumPy数组
        y_test = y_test_tensor.cpu().numpy()  # 转换为NumPy数组

    # 计算指标
    cm = confusion_matrix(y_test, predicted)
    TP = cm[0, 0]
    FN = cm[0, 1]
    FP = cm[1, 0]
    TN = cm[1, 1]
    Sn = TP / (TP + FN)
    Sp = TN / (TN + FP)
    acc = (TP + TN) / (TP + TN + FP + FN)
    mcc = (TP * TN - FP * FN) / math.sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN))
    auc = roc_auc_score(y_test, probas)

    results['Fold'].append(fold + 1)
    results['SN'].append(Sn)
    results['SP'].append(Sp)
    results['ACC'].append(acc)
    results['MCC'].append(mcc)
    results['AUC'].append(auc)
    results['Time'].append(training_time)

    print(f'Fold {fold + 1}: SN={Sn:.4f}, SP={Sp:.4f}, ACC={acc:.4f}, MCC={mcc:.4f}, AUC={auc:.4f}, Time={training_time:.2f} seconds')

# 计算十折交叉验证平均结果
SN_mean = np.mean(results['SN'])
SP_mean = np.mean(results['SP'])
ACC_mean = np.mean(results['ACC'])
MCC_mean = np.mean(results['MCC'])
AUC_mean = np.mean(results['AUC'])
Time_mean = np.mean(results['Time'])

print(f'\n十折交叉验证平均结果: SN={SN_mean:.4f}, SP={SP_mean:.4f}, ACC={ACC_mean:.4f}, MCC={MCC_mean:.4f}, AUC={AUC_mean:.4f}, Time={Time_mean:.2f} seconds')








