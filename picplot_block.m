% ����sigmoid����
sigmoid = @(x) 1 ./ (1 + exp(-x));
% ����sigmoid�����ĵ���
sigmoid_derivative = @(x) sigmoid(x) .* (1 - sigmoid(x));
% ����һ��xֵ�ķ�Χ�Ի��ƺ���
x = -10:0.1:10;
% ����sigmoid����
subplot(1,2,1); % ����������ͼ
plot(x, sigmoid(x), 'b', 'LineWidth', 2);
title('Sigmoid Function');
xlabel('x');
ylabel('sigmoid(x)');
grid on;
% ����sigmoid�����ĵ���
subplot(1,2,2); % �����Ҳ����ͼ
plot(x, sigmoid_derivative(x), 'r', 'LineWidth', 2);
title('Derivative of Sigmoid Function');
xlabel('x');
ylabel('sigmoid''(x)');
grid on;
% ����ͼ��
legend('Sigmoid', 'Derivative');
% ������ͼ��ļ��
subplot(1,2,1);
pos1 = get(gca, 'Position'); % ��ȡ��ǰ���λ��
pos1(3) = 0.4; % ���ÿ��
set(gca, 'Position', pos1);
subplot(1,2,2);
pos2 = get(gca, 'Position'); % ��ȡ��ǰ���λ��
pos2(3) = 0.4; % ���ÿ��
set(gca, 'Position', pos2);