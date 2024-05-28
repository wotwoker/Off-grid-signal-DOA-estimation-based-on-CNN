% ����ѵ������traningoff_set.mat ���ݴ洢�ļ�
% theta_train��ѵ������������ǣ�: 2 x ____ double��Ŀ���� x ��������
% Signal_eta���������� R��2@M x M�����ع���: 8 x 8 x ____ double ����Ԫ�� x ��Ԫ�� x 2����������
% Signal_label��С����ǩ -1 �� -0.5~0.5��: ____ x 181 double �������� x ��������

%%ģ�ͻ�������
dd = 0.5;            % ��Ԫ��ನ����
numSignal = 2;       % number of DOA           
kelm = 8;            % ��Ԫ�� 
snapshot = 512;      % ������
phi_start = -90;     % ������������
phi_end = 90;        % ����������յ�
Phi = phi_start:phi_end; % �����Ƕ�
P = length(Phi);     % ����Ƕ���=180
nsample = 50000;     % ������ 5w~10w

%% ����theta_train  
theta1=[];theta2=[];
for iTheta = 1:nsample
    theta1 = [theta1,-60 + 120 * rand]; %��С���������
    theta2 = [theta2,-60 + 120 * rand];
end
theta_train = [theta1;theta2];

%% ����Signal_eta��Signal_label
Signal_eta = zeros(kelm,kelm,2*nsample);
Signal_label = zeros(length(theta_train),P)-1;
for iThetaTrain = 1:length(theta_train)      % ����ÿ��ѵ������
    S0 = randn(numSignal,snapshot);     %ģ����ź�Դ
    A = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(theta_train(:,iThetaTrain)')); % �������
    X = A*S0;
    X1 = awgn(X,randi([-10,20]),'measured');    % ��[-10:20]dB������  
    R=1/snapshot*X1*X1';    %Э�������2ά������
    normR = norm(R);  % ����R�ķ�����ģ����
    Signal_eta(:,:,1+2*(iThetaTrain-1)) = real(R) / normR;  % ����һ�����ʵ����ֵ
    Signal_eta(:,:,2+2*(iThetaTrain-1)) = imag(R) / normR;  % ����һ������鲿��ֵ
    Signal_label(iThetaTrain,round(theta_train(:,iThetaTrain))+91) = theta_train(:,iThetaTrain)-round(theta_train(:,iThetaTrain));   % �����źű�ǩΪС��ֵ 
end

%% ����ѵ������
save('trainoff_set.mat','theta_train','Signal_label','Signal_eta');

%% �鿴����
load('trainoff_set.mat','theta_train','Signal_label','Signal_eta');
iSample = floor(rand * length(theta_train));    %���ѡ���������ڿɲ鿴
figure('Position', [200,100,900, 450]);  % �鿴ĳ����R��ʵ�鲿ͼ��
subplot(1, 2, 1);  % ��ʾʵ��
imagesc(Signal_eta(:,:,1+2*(iSample-1)));  
title('Real Part of R'); colorbar; axis square;  %���⣻ɫ�飻������ʾ
subplot(1, 2, 2);  % ��ʾ�鲿
imagesc(Signal_eta(:,:,2+2*(iSample-1)));  
title('Imaginary Part of R'); colorbar; axis square;  
