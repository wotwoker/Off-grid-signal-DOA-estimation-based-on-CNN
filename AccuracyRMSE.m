% ����׼ȷ�ʺ;��������
% ��CNN��Ԥ������ MUSIC ���Ƚ�
clear;clc;close all
load('test_set_snr.mat','theta_test','VariableARR','Signal_eta','Signal_eta_forC','estMUSIC');
nLevel = size(estMUSIC,1);     % �ּ��ĸ�����snr������/����Ԫ����������ȣ�
nSignal = size(estMUSIC,2);    % ��Դ����
nsample = size(estMUSIC,3);    % ÿ��������������
threshold = 1;                  % ��Ϊ������ȷ������

%% ����׼ȷ������������
[probMUSIC,rmseMUSIC] = ShotOrNot(estMUSIC,theta_test,threshold);  

%% ����CNN��Ԥ����
load('cnn_predict_C.mat','estCNN_C');
load('cnn_predict_R.mat','estCNN_R');
estCnn_C = zeros(nLevel,nSignal,nsample);
estCnn_R = zeros(nLevel,nSignal,nsample);
for iLevel = 1:nLevel
    for iSample = 1:nsample
        cnn_doa_C = reshape(estCNN_C(iLevel,iSample,:),181,1);
        estCnn_C(iLevel,:,iSample) = getPeak(cnn_doa_C,2);     % CNN_C�����׵��׷�����
        
        cnn_doa_R = reshape(estCNN_R(iLevel,iSample,:),181,1);
        estCnn_R(iLevel,:,iSample) = getPeak(cnn_doa_R,2);     % CNN_R�����׵��׷�����
    end
end
[probCNN_C,rmseCNN_C] = ShotOrNot(estCnn_C,theta_test,threshold); 
[probCNN_R,rmseCNN_R] = ShotOrNot(estCnn_R,theta_test,threshold); 

Linewidth = 1.5;
figure;
plot(VariableARR,probMUSIC,'--','Linewidth',Linewidth);hold on
plot(VariableARR,probCNN_C,'.-','Linewidth',Linewidth);hold on
plot(VariableARR,probCNN_R,':','Linewidth',Linewidth);hold off
xlabel('SNR(dB)');ylabel('DOA����׼ȷ��')
legend('MUSIC','CNN_C','CNN_R');
title('Change of Number of SNR');

figure;
plot(VariableARR,rmseMUSIC,'--','Linewidth',Linewidth);hold on
plot(VariableARR,rmseCNN_C,'.-','Linewidth',Linewidth);hold on
plot(VariableARR,rmseCNN_R,':','Linewidth',Linewidth);hold off;

xlabel('SNR(dB)');ylabel('RMSE(��)');%xlabel('������');
legend('MUSIC','CNN_C','CNN_R');
title('Change of Number of SNR');

