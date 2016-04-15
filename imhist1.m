function imhist1(img)
% tStart=tic;
% imhist(imread(img));
% tEnd=toc(tStart);
% fprintf('\nһ����ʱ%.4f',tEnd);
% tStart=tic;
data=uint8(imread(img));%��ȡͼ�������ֵ
data=data(:); %������������ʽ
axis_x=0:255; %���ص��ȡֵ��0-255
% axis_x=intersect(axis_x,data);
axis_y=zeros(256,1); %Ԥ�ȷ���ռ�

for i=1:length(axis_x)
    axis_y(i)=sum(data==axis_x(i));%����ÿ�����ص�ֵ�ж���
end

stem(axis_x,axis_y,'Marker','none');  %������ɢ����ͼ����״��ȥ�����
xlabel('���ػҶȼ���','FontSize',10);
ylabel('����','FontSize',10);   %�趨x��y�������

axis([0,255,min(axis_y),2.5*sqrt(axis_y'*axis_y/length(axis_y))]);%��ʱд�ţ������Χ���趨��֪Ϊɶ�������ÿ�����
% tEnd=toc(tStart);
% fprintf('\nһ����ʱ%.4f',tEnd);