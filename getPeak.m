% funtion for seeking peaks
% input: arr:�׷������Ŀռ���
%          n:�������׷�������ź�Դ��
% output��peakTheta���źŵĽǶ�ֵ
function peakTheta = getPeak(arr,n)
    theta = -90:90;
    [peak,peak_index] = findpeaks(arr);
    [~,peak_index_sort] = sort(peak,'descend');
    if length(peak_index_sort)>1
        peakTheta = theta(peak_index(peak_index_sort(1:n)));
    elseif length(peak_index_sort)==1 % ��������һ��ֱ��else�ģ������һ�У�12�б���*����
        peak_index_sort = ones(1,n)*peak_index_sort;
        peakTheta = theta(peak_index(peak_index_sort(1:n)));
    else
        peakTheta=NaN(1,n); % ���û���ҵ���ֵ������һ������Ϊn��NaN����
    end 
end