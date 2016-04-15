function DynamicHistogramEqualization(img)
% tStart=tic;  %gapֵ�ĵ�����123��
data=imread(img);%��ȡͼ�������ֵ
data=data(:,:,1);

subplot(2,2,1);
imshow(data);
title('ԭͼƬ');
subplot(2,2,2);
imhist(data);
title('ԭͼƬ  ֱ��ͼ');

[m,n]=size(data);
data=data(:); %������������ʽ
allPixel=0:255; %���ص��ȡֵ��0-255
inter=double(intersect(allPixel,data));%ȡ������ֻ�����е�����  %���ﾹȻҪתdouble��Ȼ�������
pixelCount=zeros(256,1); %Ԥ�ȷ���ռ�

for i=inter'
    pixelCount(i+1)=sum(data==allPixel(i+1));%����ÿ�����ص�ֵ�ж��٣�ֻ�����е�
end


padCount=[0
    pixelCount
    0];
for i=2:257
    pixelCount1(i-1)=sum(padCount(i-1:i+1))/3.0;  %1x3��ƽ���˲���ȥ
end

pixelCount1=round(pixelCount1);
index=find(pixelCount1~=0);   %�ҵ����в�Ϊ0�ĵ㴦
pixelStart=index(1);    %����һ�������һ����Ϊ0�ĵ���Ϊ��һ�������һ���ֲ���Сֵ��
pixelEnd=index(end);

part=partition(pixelStart,pixelEnd,pixelCount1);    %part��Ӧ��ȥ����������ת���Ҷ�ֵ��Ҫ-1

flag=1;
i=1;
while flag
    [i,part,flag]=rePartition(pixelCount,part,i);  %����ÿ�����ֵ�֧����������жϣ�������Ҫ�ٴν��зָ�
end

span(1)=part(1,2)-part(1,1);
for i=2:size(part,1)
    span(i)=part(i,2)-part(i,1)+1;
end
% for i=1:size(part,1)
%     span(i)=part(i,2)-part(i,1)+1-sum(ismember(pixelCount(part(i,1):part(i,2)),0));%��������Ƕ��ȵĳ��Բ���
% end

range=span.*255./sum(span);   %����span��range�ļ���

partSpan(1,1)=0;         %partSpan��0��ʼ������ʾ�Ҷ�ֵ����part��Ӧ��ȥ����������ת���Ҷ�ֵ��Ҫ-1
partSpan(1,2)=range(1);  %��ʼ��

for i=2:size(part,1)
    partSpan(i,1)=partSpan(i-1,2);
    partSpan(i,2)=partSpan(i,1)+range(i);   %���з�������ļ���
end

partSpan=round(partSpan);
%%  ��һ������Ϊ�˻����ָ���
min2=min(pixelCount);
max2=2.5*sqrt(pixelCount'*pixelCount/length(pixelCount));
tempy=min2:500:max2;
yLen=length(tempy);
hold;
for i=1:size(part,1)
    tempx=(part(i,1)-1)*ones(1,yLen);    
    plot(tempx,tempy,'-.k*');
end
tempx=(part(size(part,1),2)-1)*ones(1,yLen);    
plot(tempx,tempy,'-.k*');
%%
transFun=getTransformFunction(part,partSpan,pixelCount);   %�õ���Ӧ�ı任�ĺ���

for i=1:length(data)
    data(i)=transFun(data(i)+1);  %��ԭͼ��Ķ�Ӧ����ձ任�������б任����������MATLAB�������Ǵ�1��ʼ�ģ���Ҫ��1
end

% tEnd=toc(tStart);
subplot(2,2,3);
imshow(reshape(data,m,n));%��ʾԭͼ��
title('��ֱ̬��ͼ���⻯��');
subplot(2,2,4);
imhist(data);
title('��ֱ̬��ͼ���⻯��  ֱ��ͼ');
% fprintf('\nһ����ʱ%.4f',tEnd);
% a=3;

function transFun=getTransformFunction(part,partSpan,pixelCount)   %������Ӧ���صı任����
transFun=zeros(1,256);   %��ʼ��
transFun=GH(pixelCount(part(1,1):part(1,2)),part(1,1):part(1,2),partSpan(1,:),transFun);
for i=2:size(part,1)
    transFun=GH(pixelCount(part(i,1):part(i,2)),part(i,1):part(i,2),[partSpan(i,1)+1 partSpan(i,2)],transFun);
end

function transFun=GH(pixelCount,pixelIndex,partSpan,transFun)
pixelAll=sum(pixelCount);  %������һ�����ܵ����ص�ĸ���
max1=max(pixelIndex)-1;
min1=min(pixelIndex)-1;

pixelIndex1=round((pixelIndex-min1)./(max1-min1).*(partSpan(2)-partSpan(1))+partSpan(1));  %���Ҷȼ�����任��ָ��������

for i=1:length(pixelIndex)
    index=find(pixelIndex1<=pixelIndex1(i));    %����һ������Ϊ�˼���CDF׼����
    count=0;
    for j=1:length(index)
        count=count+pixelCount(index(j));
    end
    transFun(pixelIndex(i))=round(count/pixelAll*(partSpan(2)-partSpan(1))+partSpan(1));  %������о��⻯����
    %     temp=round((max1-min1)*sum(pixelCount(1:i))/pixelAll+min1);
    %     transFun(pixelIndex(i))=round((partSpan(2)-(partSpan(1)))*(temp-min1)/(max1-min1)+partSpan(1));
    % %     transFun(pixelIndex(i))=round((partSpan(2)-(partSpan(1)))*sum(pixelCount(1:i))/pixelAll+partSpan(1));  %���ֱ��ͼ����ı任������Ϊһ��������sum������CDF(�ۼƷֲ�����)
end

function part=partition(pixelStart,pixelEnd,pixelCount)   %���е�һ�εķָ�
%pixelCount=pixelCount';
part(1,1)=pixelStart;
count=1;
winSize=1;   %��ⴰ�ڵĴ�С �ܳ���Ϊ2*winSize+1
gap=5;      %�ֲ���Сֵ����С����
padPix=padarray(pixelCount,[0,winSize]);    %����������оֲ���Сֵ���
for i=pixelStart+1+winSize:pixelEnd-1+winSize
    if check(padPix,i,winSize,gap)  %�ֲ���С�б�ĺ������������      
        part(count,2)=i-winSize;
        count=count+1;
        part(count,1)=i+1-winSize;
        continue;
    end
end
% a=60;
% part(1,2)=a;
% count=count+1;
% part(count,1)=a+1;
part(count,2)=pixelEnd;

function F=check(padPix,i,winSize,gap)
F=all([padPix((i-winSize):(i-1)) padPix((i+1):(i+winSize))]>(padPix(i)+gap));%����������Ǳ�׼�����ĵķ�������������Ҹ�����������ͼƬ������л��ֳ����Ľ��Ľ��                   %&&~(all([padPix((i-winSize):(i-1)) padPix((i+1):(i+winSize))]==(padPix(i)+gap)))
%  check1=all([padPix((i-winSize):(i-1)) padPix((i+1):(i+winSize))]>(padPix(i)+gap));
%  check2=~(all([padPix((i-winSize):(i+winSize))]==0))&&padPix(i)==0;%�����Ƕ��ȵĳ��Բ���
%  F=check1||check2;

function [i,part,flag]=rePartition(pixelCount,part,i)   %������һ�ε�����֧��������
[mean,std,totalNum]=caculate((part(i,1)-1):(part(i,2)-1),pixelCount(part(i,1):part(i,2)));  %����ָ������ľ�ֵ�Լ���׼��


if isnan(mean)   %�Կ��ܳ��ֵ�����������д���
    
    i=i+1;
    if(i>=size(part,1))  
        flag=0;
    else
        flag=1;
    end
    return;
    
else   %�����ж�֧��̶Ȳ���Ӧ�ز�����������
 
    if(round(mean-std)+1>=1)
    regionCount=sum(pixelCount((round(mean-std)+1):(round(mean+std)+1)));
    else
        regionCount=sum(pixelCount(1:(round(mean+std)+1)));
    end
    if regionCount/totalNum>0.683
        i=i+1;
    else
        partTemp=zeros(size(part,1)+2,2);   %�������ֻ�Ǹ�ֵ���ѵ�һЩ�������ѣ�������һ�������������һЩ����
        partTemp(1:(i-1),:)=part(1:(i-1),:);
        partTemp(i,:)=[part(i,1) round(mean-std)+1];
        partTemp(i+1,:)=[round(mean-std)+2 round(mean+std)+1];
        partTemp(i+2,:)=[round(mean+std)+2 part(i,2)];
        partTemp((i+3):end,:)= part((i+1):end,:);
        part=partTemp;
    end
    if i>=size(part,1)   %����ֵ�߽��ж�
        flag=0;
    else
        flag=1;
    end
end

function [mean,std,totalNum]=caculate(num,count)   %���м����ֵ�Լ���׼��
totalNum=sum(count');
mean=sum(num.*count')/totalNum;
std=sqrt(sum(((num-mean).^2).*count')/totalNum);
