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
sample = 2000;    % ����n����������:����1000-5000
kelm = 8;         % Ĭ����������
snapshot = 512;     % Ĭ�Ͽ�������
theta_test = zeros(numSignal, sample); % ���ڱ�������Ƕ�

%% ������������Ƕ�
for iTheta = 1:sample
    theta1 = randi([-60,60]);
    theta2 = randi([-60,60]);
    theta_test(:,iTheta) = [theta1;theta2];
end

%% �����ռ��ײ�����
%VariableARR = 2:4:32; %SNR 
VariableARR = 50:50:500; %������
Signal_eta = zeros(length(VariableARR),kelm,kelm,2*sample);
Signal_eta_forC = zeros(length(VariableARR),sample,P);
estMUSIC = zeros(length(VariableARR),numSignal,sample);

iVariable = 0;
% for kelm = VariableARR %����������ı����� for kelmҪ�ĵ�̫����
% for snapshot = VariableARR %����������ı����� 
for snapshot= VariableARR  % ��ÿһ������ȶ�����sample����������
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
        P_MUSIC = music_doa(X1,numSignal,dd,Phi);    % MUSIC_DOA
        P_CBF = cbf_doa(X1,numSignal,dd,Phi);  % CBF_DOA
        Signal_eta_forC(iVariable,iSample,:) =P_CBF; % ����CNN_C�Ĳ��Լ�����   
        estMUSIC(iVariable,:,iSample) = getPeak(P_MUSIC,numSignal);    
    end
end
%% ��������
save('test_set_snap.mat','theta_test','VariableARR','Signal_eta','Signal_eta_forC','estMUSIC');

