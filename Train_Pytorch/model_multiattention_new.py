import torch
import torch.nn as nn

class MultiHeadAttention(nn.Module):
    def __init__(self, embed_size, heads):
        super(MultiHeadAttention, self).__init__()
        self.embed_size = embed_size
        self.heads = heads
        self.head_dim = embed_size // heads

        assert (
            self.head_dim * heads == embed_size
        ), "Embedding size needs to be divisible by heads"

        self.values = nn.Linear(self.head_dim, embed_size, bias=False)
        self.keys = nn.Linear(self.head_dim, embed_size, bias=False)
        self.queries = nn.Linear(self.head_dim, embed_size, bias=False)
        self.fc_out = nn.Linear(embed_size, embed_size)

    def forward(self, values, keys, query):
        N = query.shape[0]
        value_len, key_len, query_len = values.shape[1], keys.shape[1], query.shape[1]

        values = values.reshape(N, value_len, self.heads, self.head_dim)
        keys = keys.reshape(N, key_len, self.heads, self.head_dim)
        queries = query.reshape(N, query_len, self.heads, self.head_dim)

        energy = torch.einsum("nqhd,nkhd->nhqk", [queries, keys])
        attention = torch.softmax(energy / (self.embed_size ** (1 / 2)), dim=3)

        out = torch.einsum("nhql,nlhd->nqhd", [attention, values]).reshape(
            N, query_len, self.embed_size
        )

        out = self.fc_out(out)

        return out

class BiLSTM_attention_fusion_new(nn.Module):
    def __init__(self, input_size=433, hidden_size=64, num_layers=1, heads=8):
        super(BiLSTM_attention_fusion_new, self).__init__()
        self.lstm = nn.LSTM(input_size=input_size, hidden_size=hidden_size, num_layers=num_layers, batch_first=True, bidirectional=True)
        self.multihead_attention = MultiHeadAttention(hidden_size * 2, heads)
        self.layer_norm1 = nn.LayerNorm(hidden_size * 2)
        self.layer_norm2 = nn.LayerNorm(hidden_size * 2)
        self.fc1 = nn.Linear(hidden_size * 2 * 2, 32)  # 由于拼接了两个特征，所以这里是hidden_size * 2 * 2
        self.fc2 = nn.Linear(32, 2)
        self.dropout = nn.Dropout(0.5)  # 调整Dropout比例
        self.gelu = nn.GELU()  # 使用GELU激活函数
        self.softmax = nn.Softmax(dim=1)

    def forward(self, x):
        h_lstm, _ = self.lstm(x)
        h_lstm = self.layer_norm1(h_lstm)  # 添加LayerNorm

        attn_output = self.multihead_attention(h_lstm, h_lstm, h_lstm)
        attn_output = self.layer_norm2(attn_output)  # 添加LayerNorm

        # 融合特征，拼接LSTM输出的最后一个时间步和多头注意力机制的输出
        combined_features = torch.cat((h_lstm[:, -1, :], attn_output[:, -1, :]), dim=1)

        out = self.gelu(combined_features)
        out = self.fc1(out)
        out = self.gelu(out)
        out = self.dropout(out)
        out = self.fc2(out)
        out = self.softmax(out)
        return out