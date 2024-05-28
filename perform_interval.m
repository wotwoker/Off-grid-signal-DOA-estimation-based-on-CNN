%���Ƶȼ���źŵ�����������
clear;clc;close all;
load('cnn_predict_ITVR.mat','estCNN_R'); % 2D-CNN�Ĺ�����
load('cnn_predict_ITVC.mat','estCNN_C'); % 1D-CNN�Ĺ�����
load('cnn_predict_ITVoff.mat','estCNN_off'); % 1D-CNN�Ĺ�����
load('test_set_interval.mat','theta_test');

nSignal = size(theta_test,1);    % ��Դ����
nsample = size(theta_test,2);    % ÿ��������������
estCnn_C = zeros(nSignal,nsample);
estCnn_R = zeros(nSignal,nsample);

estCnn_on = zeros(nSignal,nsample);
estCnn_off = zeros(nSignal,nsample);
for iSample = 1:nsample
%     cnn_doa_C = reshape(estCNN_C(iSample,:),181,1);
%     estCnn_C(:,iSample) = getPeak(cnn_doa_C,2);     % CNN_C�����׵��׷�����

    %cnn_doa_R = reshape(estCNN_R(iSample,:),181,1);
    %estCnn_R(:,iSample) = getPeak(cnn_doa_R,2);     % CNN_R�����׵��׷�����
    
    cnn_doa_on = reshape(estCNN_R(iSample,:),181,1);
    estCnn_on(:,iSample) =getPeak(cnn_doa_on,2);
    theta_rec = zeros(1,length(estCnn_on(:,iSample)));
    th=-0.6;
    for i = 1:length(estCnn_on(:,iSample))
        p1=estCnn_on(i,iSample); %�����Ƕ�����ֵ��
        p2=p1+1;
        z1=estCNN_off(iSample,p1+91);
        z2=estCNN_off(iSample,p2+91);
        if z1 > th && z2 > th 
            theta_rec(i)=((p1)*(z1+1)+(p2)*(z2+1))/(z1+z2+2);
        else
            theta_rec(i)=z1+p1;
        end
    end
    estCnn_off(:,iSample) = theta_rec; %CNN_off�����׵�ȫ����Ϣ
    
end
estCnn_C = sort(estCnn_C, 1, 'ascend'); %������������
%estCnn_R = sort(estCnn_R, 1, 'ascend');
estCnn_offgrid = sort(estCnn_off, 1, 'ascend');%�������źŵ�ȫ����Ϣ


column = 1:nsample;
% ����ɢ��ͼ
% figure; 
% subplot(1,2,1);
% scatter(column, estCnn_R(1, :),'*');hold on;% ���Ƶ�һ�е����ݵ�
% scatter(column, estCnn_R(2, :),'*');hold on; % ���Ƶڶ��е����ݵ�
% line([100,100], [-60,60]);
% line([200,200], [-60,60]);
% line([300,300], [-60,60]);
% xlabel('��������');ylabel('DOA����(��)');ylim([-60,60]);
% subplot(1,2,2);
% scatter(column, estCnn_R(1, :)-theta_test(1, :),'*');hold on;
% scatter(column, estCnn_R(2, :)-theta_test(2, :),'*');hold on;
% xlabel('��������');ylabel('DOA���(��)');ylim([-5,5]);

%�������������ɢ��ͼ
figure; 
subplot(1,2,1);
scatter(column, estCnn_offgrid(1, :),'*');hold on;% ���Ƶ�һ�е����ݵ�
scatter(column, estCnn_offgrid(2, :),'*');hold on; % ���Ƶڶ��е����ݵ�
line([100,100], [-60,60]);
line([200,200], [-60,60]);
line([300,300], [-60,60]);
legend('��һ���ź�','�ڶ����ź�');grid on;
xlabel('��������');ylabel('DOA����(��)');ylim([-60,60]);

subplot(1,2,2);
scatter(column, (estCnn_offgrid(1, :)-theta_test(1, :)),'*');hold on;
scatter(column, (estCnn_offgrid(2, :)-theta_test(2, :)),'*');hold on;
legend('��һ���ź����','�ڶ����ź����');grid on;
xlabel('��������');ylabel('DOA���(��)');ylim([-1,1]);





