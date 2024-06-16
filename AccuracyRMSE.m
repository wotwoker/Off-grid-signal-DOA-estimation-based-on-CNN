% ����׼ȷ�ʺ;��������
% ��CNN��Ԥ������ MUSIC ���Ƚ�
clear;clc;close all
%load('test_set_snr.mat','theta_test','VariableARR','Signal_eta','Signal_eta_forC','estMUSIC');
load('test_set_snap.mat','theta_test','VariableARR','Signal_eta','Signal_eta_forC','estMUSIC');
nLevel = size(estMUSIC,1);     % �ּ��ĸ�����snr������/����Ԫ����������ȣ�
nSignal = size(estMUSIC,2);    % ��Դ����
nsample = size(estMUSIC,3);    % ÿ��������������
threshold = 1;                  % ��Ϊ������ȷ������

%% ����׼ȷ������������
[probMUSIC,rmseMUSIC] = ShotOrNot(estMUSIC,theta_test,threshold);  

%% ����CNN��Ԥ����
% load('cnn_predict_C.mat','estCNN_C');
% load('cnn_predict_R.mat','estCNN_R');
load('cnn_predict_Csnap.mat','estCNN_C');
load('cnn_predict_Rsnap.mat','estCNN_R'); % ע���������tanh֮���ֵ
estCnn_C = zeros(nLevel,nSignal,nsample);
estCnn_R = zeros(nLevel,nSignal,nsample); %����������
estCnn_off = zeros(nLevel,nSignal,nsample);%����+С��
for iLevel = 1:nLevel
    for iSample = 1:nsample
        cnn_doa_C = reshape(estCNN_C(iLevel,iSample,:),181,1);
        estCnn_C(iLevel,:,iSample) = getPeak(cnn_doa_C,2);     % CNN_C�����׵��׷�����
        
        cnn_doa_R = reshape(estCNN_R(iLevel,iSample,:),181,1);
        estCnn_R(iLevel,:,iSample) = getPeak(cnn_doa_R,2);     % CNN_R�����׵��׷�����
        %���������С��ֵ����
        theta_rec = zeros(1,length(estCnn_R(iLevel,:,iSample)));
        th=-0.6;
        for i = 1:length(estCnn_R(iLevel,:,iSample)) %�������ǶȰ�������
            p1=estCnn_R(iLevel,i,iSample);
            p2=p1+1;
            z1=estCNN_R(iLevel,iSample,p1+91);
            z2=estCNN_R(iLevel,iSample,p2+91);
            if z1 > th && z2 > th 
                theta_rec(i)=((p1)*(z1+1)+(p2)*(z2+1))/(z1+z2+2);
            else
                theta_rec(i)=z1+p1;
            end
        end
        estCnn_off(iLevel,:,iSample) = theta_rec;
        
    end
end
[probCNN_C,rmseCNN_C] = ShotOrNot(estCnn_C,theta_test,threshold); 
[probCNN_R,rmseCNN_R] = ShotOrNot(estCnn_R,theta_test,threshold); 
[probCNN_off,rmseCNN_off] = ShotOrNot(estCnn_off,theta_test,threshold); 

Linewidth = 1.5;
figure;
plot(VariableARR,probMUSIC*100,'d-','Linewidth',Linewidth);hold on
plot(VariableARR,probCNN_C*100,'s-','Linewidth',Linewidth);hold on
plot(VariableARR,probCNN_R*100,'o-','Linewidth',Linewidth);hold on
plot(VariableARR,probCNN_off*100,'p-','Linewidth',Linewidth);hold off;
xlabel('SNR(dB)');ylabel('DOA����׼ȷ��(%)');xlabel('������');
legend('MUSIC','1D-CNN','2D-CNN','2D-CNN-OG');grid on;


figure;
semilogy(VariableARR,rmseMUSIC,'d-','Linewidth',Linewidth);hold on
semilogy(VariableARR,rmseCNN_C,'s-','Linewidth',Linewidth);hold on
semilogy(VariableARR,rmseCNN_R,'o-','Linewidth',Linewidth);hold on
semilogy(VariableARR,rmseCNN_off,'p-','Linewidth',Linewidth);hold off;
xlabel('SNR(dB)');ylabel('RMSE(��)');xlabel('������');
legend('MUSIC','1D-CNN','2D-CNN','2D-CNN-OG');grid on;ylim([0.1,10]);


