%�����������Ԥ������
clear;clc;close all;
load('cnn_predict_OneTestR.mat','P_cnn_R'); % Ԥ���������Ϣ
load('cnn_predict_OneTest_offgrid.mat','P_cnn_offgrid','P_cnn_offgrid_tanh'); % Ԥ���С����Ϣ
load('OneTestSet_offgrid.mat','thetaOneTest_off','Phi');

% %Ԥ��ֵ�����������С����
% pj=find(P_cnn_R > 0.5); %��ֵ���������
% zj=P_cnn_offgrid(pj); %��ֵ���ȣ�С����
% result=-1*ones(1,181);
% result(pj)=zj;
%��ʵֵ
thetaOneTest_off
Signal_eta_int = round(thetaOneTest_off);
Signal_eta_dec = thetaOneTest_off - round(thetaOneTest_off);
%% Ԥ��ֵ���������������Դ��
%pj=find(P_cnn_R > 0.8);%��ֵ���������
pj=getPeak(double(P_cnn_offgrid_tanh),2)+91;%���������ķ���
theta_rec = zeros(1,length(pj));
th = -0.6; %ѡ����ʵ�������ֵ           %%�ĳɲ�ֵ����ֵ
for i = 1:length(pj)
    p1=pj(i); %�����Ƕ�����ֵ
    p2=p1+1;
    %p3=p1-1;
    z1=P_cnn_offgrid_tanh(p1);
    z2=P_cnn_offgrid_tanh(p2);
    %z3=P_cnn_offgrid_tanh(p3);
    if z1 > th && z2 > th 
        theta_rec(i)=((p1-91)*(z1+1)+(p2-91)*(z2+1))/(z1+z2+2);
    %elseif abs(z1 - z3) > th
    %    theta_rec(i)=((p1-91)*(z1+1)+(p3-91)*(z3+1))/(z1+z3+2);
    %elseif abs(z1 - z2) > th && abs(z1 - z3) > th
    %    theta_rec(i)=((p1-91)*(z1+1)+(p3-91)*(z3+1)+(p2-91)*(z2+1))/(z1+z2+z3+3);
    else
        theta_rec(i)=p1-91+z1;
    end
end
theta_rec

%% ��ͼ
figure(1);
% set(gcf, 'Position', [100,400,1200, 400]);
% subplot(1,2,1);% �����������С��ģ��
% plot(Phi,result,'-','Linewidth',1.2);hold on 
% plot(Signal_eta_int,Signal_eta_dec,'*','Linewidth',1.2);hold on;
% % ����ÿ���㣬�����������������
% for i = 1:length(Signal_eta_int)% ��ֱ���� % ˮƽ����
%     line([Signal_eta_int(i), Signal_eta_int(i)], [-1, Signal_eta_dec(i)], 'LineStyle', '--', 'Color', 'k');
%     line([-90, Signal_eta_int(i)], [Signal_eta_dec(i), Signal_eta_dec(i)], 'LineStyle', '--', 'Color', 'k');
% end
% xlim([-90, 90]);%ylim([-1.01, 0.6]);
% legend('Ԥ��ֵ','��ʵֵ');title('������С�����');grid off;
% 
% subplot(1,2,2);% tanh��������
plot(Phi,P_cnn_offgrid_tanh,'-','Linewidth',1.2);hold on;
plot(Signal_eta_int,Signal_eta_dec,'*','Linewidth',1.2);hold on;
for i = 1:length(Signal_eta_int)% ��ֱ���� % ˮƽ����
    line([Signal_eta_int(i), Signal_eta_int(i)], [-1, Signal_eta_dec(i)], 'LineStyle', '--', 'Color', 'k');
    line([-90, Signal_eta_int(i)], [Signal_eta_dec(i), Signal_eta_dec(i)], 'LineStyle', '--', 'Color', 'k');
end
xlim([-90, 90]);ylim([-1.01, 0.6]);
xlabel('���������������Ϣ(��)');ylabel('���������С����Ϣ(��)');
legend('Ԥ��ֵ','��ʵֵ');title('��񼤻����');grid on;

figure(2);
plot(Phi,P_cnn_offgrid,'-','Linewidth',1.2);hold on;%ֻ��offgridģ��
plot(Signal_eta_int,Signal_eta_dec,'*','Linewidth',1.2);hold on;
xlim([-90, 90]);
xlabel('���������������Ϣ(��)');ylabel('������м����z');
legend('Ԥ��ֵ','��ʵֵ');title('���ֱ�����');grid on;


