% ���ɵ�������������OneTestSet.mat
% thetaOneTest������������ǣ�: {1,2,3,4} x 1 double
% Signal_eta (ѵ������������: 8 x 8 x 2 double
% Signal_eta_forC��ѵ������������: 1 x 181 double
% Signal_label��ѵ����ǩ��: 1 x 181 double
% Phi �������Ƕȣ���1��181 double
% P_MUSIC (MUSIC�㷨�Ŀռ���) ��1��181 double

clc; clear; close all; warning off
%%ģ�ͻ�������
dd = 0.5;               % ��Ԫ��ನ����
snr = 0;               % input SNR (dB)
kelm = 8;               % ��Ԫ��=8
snapshot = 512;         % ������
phi_start = -90;        % ������������
phi_end = 90;           % ����������յ�
Phi = phi_start:phi_end; % ���������
P = length(Phi);         % ����Ƕ���=180
kelmArr = (0:kelm-1)+0*randn(1,kelm);

%% ����theta_train
thetaOneTest = [ 0  30 ] 
%thetaOneTest = [ -65 65 ]          %�źŽǶ�  
numSignal = length(thetaOneTest);   % �ź�Դ��

%% ����Signal_eta��Signal_label
Signal_eta = zeros(kelm,kelm,2*1);
Signal_eta_forC = zeros(1,P);
Signal_label = zeros(1,P);
Signal = randn(numSignal,snapshot);
A = exp(-1j*2*pi*kelmArr'*dd*sind(thetaOneTest));% �������
X = A*Signal;
X1 = awgn(X,snr,'measured');    
R=1/snapshot*(X1*X1');    %Э�������2ά������
normR = norm(R);  % ����R�ķ�����ģ����
Signal_eta(:,:,1) = real(R) / normR;  % ����CNN_R�ĵ��������Լ�����
Signal_eta(:,:,2) = imag(R) / normR;  
Signal_eta_forC = Signal_eta_forC + cbf_doa(X1,numSignal,dd,Phi);% ����CNN_M�ĵ��������Լ�����
Signal_label(round(thetaOneTest)+91) = ones(1,length(thetaOneTest));

%% MUSIC_DOA
P_MUSIC = music_doa(X1,numSignal,dd,Phi);    % MUSIC_DOA
%% ��������
save('OneTestSet.mat','thetaOneTest','Signal_eta','Signal_eta_forC','Signal_label','Phi','P_MUSIC');


% figure('Position', [200,100,900, 450]);  % �鿴ĳ����R��ʵ�鲿ͼ��
% subplot(1, 2, 1);  % ��ʾʵ��
% imagesc(Signal_eta(:,:,1));  
% title('Real Part of R'); colorbar; axis square;  %���⣻ɫ�飻������ʾ
% subplot(1, 2, 2);  % ��ʾ�鲿
% imagesc(Signal_eta(:,:,2));  
% title('Imaginary Part of R'); colorbar; axis square;  
figure();
plot(Phi,Signal_eta_forC(1,:),'LineWidth',1.5);hold on;
stem(find(Signal_label(1,:)==1)-91,ones(1,numSignal),'LineWidth',1)
grid on;xlim([-90,90]); ylim([-0.1,1.1]);xlabel('�Ƕ�(��)');
legend('CBFԤ��','��ʵ�Ƕ�');hold off;


