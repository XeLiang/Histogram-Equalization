function GlobalHistogramEqualization(img)
% tStart=tic;
data=uint8(imread(img));%��ȡͼ�������ֵ

subplot(2,2,1);
imshow(data);
title('ԭͼƬ');
subplot(2,2,2);
imhist(data);
title('ԭͼƬ  ֱ��ͼ');

[m,n]=size(data);
data=data(:); %������������ʽ
axis_x=0:255; %���ص��ȡֵ��0-255
inter=double(intersect(axis_x,data));%ȡ������ֻ�����е�����   ò����ʵȡһ������Ȼ������һЩ�Ա�ȫ������������������µ�Ч����̫����,���Կ���ȫ������
axis_y=zeros(256,1); %Ԥ�ȷ���ռ�


for i=inter'
    axis_y(i+1)=sum(data==axis_x(i+1));%����ÿ�����ص�ֵ�ж��٣�ֻ�����еģ�ò����ʵӰ�첻̫�󣬾����������ĸ�����Ҳûʵ���ˣ�
end

pr=axis_y./length(data);%��ö�Ӧ��p(Rk),����һ��

% for i=1:256
%     transform(i)=round(255*sum(pr(1:i)));  %���ֱ��ͼ����ı任������Ϊһ��������sum������CDF(�ۼƷֲ�����)
% end

transform=round(cumsum(pr)*255);   %Ϊ���Ч�ʸ��������ԭ��ʹ�õ��������Ǹ��㷨���ֱ��ͼ����ı任������Ϊһ��������sum������CDF(�ۼƷֲ�����)

for i=1:length(data)
    data(i)=transform(data(i)+1);  %��ԭͼ��Ķ�Ӧ����ձ任�������б任����������MATLAB�������Ǵ�1��ʼ�ģ���Ҫ��1
end
% tEnd=toc(tStart);

subplot(2,2,3);
imshow(reshape(data,m,n));%��ʾԭͼ��
title('ȫ��ֱ��ͼ���⻯��');
subplot(2,2,4);
imhist(data);
title('ȫ��ֱ��ͼ���⻯��  ֱ��ͼ');
% fprintf('\nһ����ʱ%.4f',tEnd);
