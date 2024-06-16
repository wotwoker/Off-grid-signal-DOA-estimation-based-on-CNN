% ���ɱ����������/���и���/�������ּ��Ĳ��Լ���test_set.mat
% 
% theta_test��ѵ������������ǣ�: {1,2,3} x sample double��Ŀ���� x ��������
% VariableARR (�ּ����� �����/���и���/������ 2:4:32
% Signal_eta��ѵ������������: variable x 8 x 8 x ____ double ����Ԫ�� x ��Ԫ�� x 2����������
% Signal_eta_forC��ѵ������������: sample x 181 double�������� x ����������
% estMUSIC��MUSIC�㷨��������ǣ�: variable x 2 x sample double ���ּ� x Ŀ���� x ��������

clc; clear; close all;
dd = 0.5;               % space 
numSignal = 2;          % number of DOA
phi_start = -90;        % ������������
phi_end = 90;           % ����������յ�
Phi = phi_start:1:phi_end; % ���������
P = length(Phi);        % ����Ƕ���=180

%% ���ò����źŻ���������Ĭ�ϲ���
snr = 0;         % Ĭ�������
sample = 300;    % ����n����������:����1000-5000
kelm = 8;         % Ĭ����������
snapshot = 512;     % Ĭ�Ͽ�������
theta_test = zeros(numSignal, sample); % ���ڱ�������Ƕ�

%% ������������Ƕ�
for iTheta = 1:sample
%     theta1 = -60+120*rand;
%     theta2 = -60+120*rand;
%     theta_test(:,iTheta) = [theta1;theta2];
    zeta = -0.1 + rand()/5; %����һ���ڡ�-0.1,0.1����Χ�����ȡֵ��zeta
    theta_test(:,iTheta) = [15.7+zeta;59.2+zeta]; %���ؿ���ʵ��
end

%% �����ռ��ײ�����
VariableARR = -10:2:20; %SNR 
%VariableARR = 5:50:555; %������
Signal_eta = zeros(length(VariableARR),kelm,kelm,2*sample);
Signal_eta_forC = zeros(length(VariableARR),sample,P);
estMUSIC = zeros(length(VariableARR),numSignal,sample);

iVariable = 0;
totalTime = 0; % ��ʼ����ʱ�����
%for kelm = VariableARR %����������ı����� for kelmҪ�ĵ�̫����
for snr = VariableARR %����������ı����� 
%for snapshot= VariableARR  % ��ÿһ������ȶ�����sample����������
    iVariable = iVariable+1;
    for iSample = 1:sample     
        thetaOneTest = theta_test(:,iSample)';
        Signal = randn(numSignal,snapshot);
        A = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(thetaOneTest));% �������
        X = A*Signal;
        X1 = awgn(X,snr,'measured'); 
        R=1/snapshot*(X1*X1');    %Э�������2ά������
        normR = norm(R);  % ����R�ķ�����ģ����
        
        Signal_eta(iVariable,:,:,1+2*(iSample-1)) = real(R) / normR;  % ����CNN_R�Ĳ��Լ����� 
        Signal_eta(iVariable,:,:,2+2*(iSample-1)) = imag(R) / normR;  
        tic; % ��ʼ��ʱmusic_doa
        P_MUSIC = music_doa(X1,numSignal,dd,Phi);    % MUSIC_DOA
        elapsedTime = toc; % ������ʱ����ȡʱ��
        totalTime = totalTime + elapsedTime; % �ۼ�ÿ�ε��õ�ʱ��
        P_CBF = cbf_doa(X1,numSignal,dd,Phi);  % CBF_DOA
        Signal_eta_forC(iVariable,iSample,:) =P_CBF; % ����CNN_C�Ĳ��Լ�����   
        estMUSIC(iVariable,:,iSample) = getPeak(P_MUSIC,numSignal);    
    end
end
fprintf('music_doa��ѭ���е�������ʱ�䣺%.2f�롣\n', totalTime)
%% ��������
save('test_set_snr.mat','theta_test','VariableARR','Signal_eta','Signal_eta_forC','estMUSIC');
%save('test_set_snap.mat','theta_test','VariableARR','Signal_eta','Signal_eta_forC','estMUSIC');

