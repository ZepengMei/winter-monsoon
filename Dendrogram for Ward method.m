clear
close all

%% 参数
maxDis = 0.3;   % 最大距离百分比
maxNodes = 55;

% 分类的颜色指定
typeColor = [[1,0,0]    % 红
    [0,1,0]             % 绿
    [0,0,0]             % 黑    
    [1,1,0]             % 黄
    [1,0,1]];           % 紫

%% 数据计算
% 读取数据集
data = readmatrix('按温度分类2.csv', 'Delimiter', ',')';

% 所有温度
temperature = data(2:end,1);

% 提取海温面积数据列
temperature_data = data(2:end, 2:end);

% 构建谱系图矩阵
hierarchy_matrix = linkage(temperature_data, 'ward');

%% 画图
% 如果分类比较多，需要补充颜色
typeColor2 = hsv(20);
% 随机颜色
index = randperm(size(typeColor2,1));
typeColor2 = typeColor2(index,:);
typeColor = [typeColor;typeColor2];


% 绘制谱系图
figure;
[allLine,type,label] = dendrogram(hierarchy_matrix,maxNodes);
xlabel('样本');
ylabel('距离');
title('聚类结果谱系图');

% 将刻度方向设置为朝外
set(gca, 'TickDir', 'out');

% 计算“最佳距离”
for i = size(hierarchy_matrix,1) : -1 : 1
    if hierarchy_matrix(i,3) > hierarchy_matrix(end,3)*maxDis
       sel(i) = 1;
    end
end
j = 1;
for i = 1:length(allLine)
    if sel(end-i+1) == 1
        allLine(end-i+1).Color = typeColor(j,:);
        allLine(end-i+1).LineWidth = 2;
        j = j + 1;
    end
end

%% 输出分类结果
for i = 1 : maxNodes
    index = type == i;
    temp_type{i} = temperature(index);
    
    fprintf(['类型' num2str(i) ': '])
    fprintf('%.2f   ',temp_type{i});
    fprintf('\n')
end