% ���ɵ�������������OneTestSet_offgrid.mat
% thetaOneTest_on������������ǣ�������: {1,2,3,4} x 1 double
% Signal_eta_on (ѵ�����������������õ�R��: 8 x 8 x 2 double
% Signal_label_on��ѵ����ǩ��01��ǩ��: 1 x 181 double
% thetaOneTest_off������������ǣ�����С����: {1,2,3,4} x 1 double
% Signal_eta_off (ѵ��������������С���õ�R��: 8 x 8 x 2 double
% Signal_label_off��ѵ����ǩ��С����ǩ��: 1 x 181 double

clc; clear; close all; warning off
%%ģ�ͻ�������
dd = 0.5;               % ��Ԫ��ನ����
snr = 10;               % input SNR (dB)
kelm = 8;               % ��Ԫ��=8
snapshot = 512;         % ������
phi_start = -90;        % ������������
phi_end = 90;           % ����������յ�
Phi = phi_start:phi_end; % ���������
P = length(Phi);         % ����Ƕ���=180
kelmArr = (0:kelm-1)+0*randn(1,kelm);

%% ����theta_train
%thetaOneTest_off = [-31.5837 -8.2913]       %�źŽǶȣ���С����  
thetaOneTest_off = [-60 + 120 * rand,-60 + 120 * rand]
thetaOneTest_on = round(thetaOneTest_off);  %�źŽǶȣ�������
numSignal = length(thetaOneTest_off);   % �ź�Դ��

%% ����Signal_eta_off��Signal_label_off��С����ǩ��
Signal_eta_off = zeros(kelm,kelm,2*1);
Signal_eta_on = zeros(kelm,kelm,2*1);
Signal_label_off = zeros(1,P)-1;
Signal_label_on = zeros(1,P);
Signal = randn(numSignal,snapshot);
A_off = exp(-1j*2*pi*kelmArr'*dd*sind(thetaOneTest_off));% �������
A_on = exp(-1j*2*pi*kelmArr'*dd*sind(thetaOneTest_on));
X_off = A_off*Signal;
X_on = A_on*Signal;
X1_off = awgn(X_off,snr,'measured');    
X1_on = awgn(X_on,snr,'measured');  
R_off=1/snapshot*(X1_off*X1_off');    %Э�������2ά������
R_on=1/snapshot*(X1_on*X1_on');    %Э�������2ά������
normR_off = norm(R_off);  % ����R�ķ�����ģ����
normR_on = norm(R_on);  
Signal_eta_off(:,:,1) = real(R_off) / normR_off;  % ����CNN_R�ĵ��������Լ�����
Signal_eta_off(:,:,2) = imag(R_off) / normR_off;  
Signal_eta_on(:,:,1) = real(R_on) / normR_on;  % ����CNN_R�ĵ��������Լ�����
Signal_eta_on(:,:,2) = imag(R_on) / normR_on; 
Signal_label_off(round(thetaOneTest_off)+91) = thetaOneTest_off-round(thetaOneTest_off);
Signal_label_on(round(thetaOneTest_on)+91) = ones(1,length(thetaOneTest_on));

%% ��������
save('OneTestSet_offgrid.mat','thetaOneTest_off','Signal_eta_off','Signal_label_off'...
     ,'thetaOneTest_on','Signal_eta_on','Signal_label_on','Phi');

