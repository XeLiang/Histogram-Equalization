function LocalHistogramEqualization(img)
% tStart=tic;
data=uint8(imread(img));%��ȡͼ�������ֵ
[m,n]=size(data);

subplot(2,2,1);
imshow(data);
title('ԭͼƬ');
subplot(2,2,2);
imhist(data);
title('ԭͼƬ  ֱ��ͼ');

padSize=20;  %�����padSize��Ҫ���������Ĵ�С���̶��Ĵ���Ϊ�����Σ���������
%���ڳ���Ϊ 2*padSize+1
lenn=padSize*2+1;
spatial=padarray(data,[padSize,padSize],0);%�����ܱ�����0���

blockNum=lenn^2;  %��ǰ����block������������ص���Ŀ������ÿ�ι̶���������ǰ����

midBlockPos=padSize+1;   %��ǰ�����������ص��λ�ã�����ʱ����С�������ٶȸ���

LocalHist=zeros(m,n);%Ԥ�ȷ���ռ䣬���д洢ֱ��ͼ���⻯֮���ͼ��
for i=1:m
    for j=1:n
        LocalHist(i,j)=getPixel(spatial(i:i+2*padSize,j:j+2*padSize),midBlockPos,blockNum);%������ȡ��һ�������ֵ
    end
end
LocalHist=uint8(LocalHist);
% tEnd=toc(tStart);
% fprintf('%.4f',tEnd);
subplot(2,2,3);
imshow(LocalHist);%��ʾԭͼ��
title(['�ֲ�ֱ��ͼ���⻯��','(���ڴ�С��',num2str(lenn),'*',num2str(lenn),')']);
subplot(2,2,4);
imhist(LocalHist);
title('�ֲ�ֱ��ͼ���⻯��  ֱ��ͼ');



function pixel=getPixel(block,midBlockPos,blockNum)
midPixel=block(midBlockPos,midBlockPos);   %��ȡ��Ҫ���������ص������ֵ
%      index=length(find(block(:)<=midPixel));
index=sum(block(:)<=midPixel);  %������ָ����Ҷ�ֵС�ڵ������
pixel=round(255*index/blockNum);%ȡ��ת��֮�������ֵӦ��Ϊ����

%      block=sort(block(:));   %�������ڲ�������ֵ���������ɴ˿���ΪΪ�ۼƺ����ļ��㷽��ʹ��
%      index=find(block==midPixel);  %�ҵ������к���Ҫ�޸�������ͬ������������֮�����ȡ���һ������������λ�ü������ۼ�����
%      pixel=round(255*index(end)/blockNum);  %ȡ��ת��֮�������ֵӦ��Ϊ����

%%������㷨Ч�ʱȽϵ�
% [m,n]=size(spatial);
% data=spatial(:); %������������ʽ
% axis_x=0:255; %���ص��ȡֵ��0-255
% inter=intersect(axis_x,data); %ȡ������ֻ�����е�����
% axis_y=zeros(256,1); %Ԥ�ȷ���ռ�
%
% for i=inter'
%     axis_y(i+1)=sum(data==axis_x(i+1));%����ÿ�����ص�ֵ�ж���
% end
%
% pr=axis_y./length(data);%��ö�Ӧ��p(Rk),����һ��
%
% midPixel=spatial((m+1)/2,(n+1)/2)+1;
%
% pixel=round(255*sum(pr(1:midPixel)));  %���ֱ��ͼ����ı任������Ϊһ��������sum������CDF(�ۼƷֲ�����)

% pixel=transform(spatial((m+1)/2,(n+1)/2)+1);  %��ԭͼ��Ķ�Ӧ����ձ任�������б任����������MATLAB�������Ǵ�1��ʼ�ģ���Ҫ��1

