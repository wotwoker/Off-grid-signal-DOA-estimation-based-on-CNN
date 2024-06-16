% ����5��15��30�ȼ���Ĳ��Լ���test_set.mat
% 
% theta_test��ѵ������������ǣ�: {1,2,3} x sample double��Ŀ���� x ��������
% Signal_eta���������������: variable x 8 x 8 x ____ double ����Ԫ�� x ��Ԫ�� x 2����������
% Signal_eta_forC��ѵ������������: sample x 181 double�������� x ����������
% Signal_eta_on��ѵ����������������: variable x 8 x 8 x ____ double ����Ԫ�� x ��Ԫ�� x 2����������

clc; clear; close all;
dd = 0.5;               % space 
numSignal = 2;          % number of DOA
phi_start = -90;        % ������������
phi_end = 90;           % ����������յ�
Phi = phi_start:1:phi_end; % ���������
P = length(Phi);        % ����Ƕ���=180

%% ���ò����źŻ���������Ĭ�ϲ���
snr = 0;         % Ĭ�������
sample = 300;    % ����n����������
kelm = 8;         % Ĭ����������
snapshot = 512;     % Ĭ�Ͽ�������

%% ÿ100�����������ȼ���������Ƕ�
theta1 = [linspace(-60,55,100),linspace(-60,45,100),linspace(-60,30,100)];
theta2 = [linspace(-60,55,100)+5.5,linspace(-60,45,100)+15.6,linspace(-60,30,100)+30.7];
theta_test = [theta1;theta2];
theta_test_on = round(theta_test);  %�źŽǶȣ�������
%% �����ռ��ײ�����

Signal_eta = zeros(kelm,kelm,2*sample);
Signal_eta_on = zeros(kelm,kelm,2*sample);
Signal_eta_forC = zeros(sample,P);
%estMUSIC = zeros(numSignal,sample);

for iSample = 1:sample     
    thetaOneTest = theta_test(:,iSample)';
    thetaOneTest_on=theta_test_on(:,iSample)';%���������źŽǶȶ�Ϊ����
    Signal = randn(numSignal,snapshot);
    A = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(thetaOneTest));% �������
    A_on=exp(-1j*2*pi*(0:kelm-1)'*dd*sind(thetaOneTest_on));
    X = A*Signal;
    X_on=A_on*Signal;
    X1 = awgn(X,snr,'measured'); 
    X1_on = awgn(X_on,snr,'measured'); 
    R=1/snapshot*(X1*X1');    %Э�������2ά������
    R_on=1/snapshot*(X1_on*X1_on');
    normR = norm(R);  % ����R�ķ�����ģ����
    normR_on = norm(R_on);
    
    Signal_eta(:,:,1+2*(iSample-1)) = real(R) / normR;  % ����CNN_R�Ĳ��Լ����� 
    Signal_eta(:,:,2+2*(iSample-1)) = imag(R) / normR;  
    Signal_eta_on(:,:,1+2*(iSample-1)) = real(R_on) / normR_on;  % ����CNN_R�Ĳ��Լ����� 
    Signal_eta_on(:,:,2+2*(iSample-1)) = imag(R_on) / normR_on;  
    P_CBF = cbf_doa(X1,numSignal,dd,Phi);  % CBF_DOA
    Signal_eta_forC(iSample,:) =P_CBF; % ����CNN_C�Ĳ��Լ�����   

end

%% ��������
save('test_set_interval.mat','theta_test','Signal_eta','Signal_eta_forC','Signal_eta_on');

