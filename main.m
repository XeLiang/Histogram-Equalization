function main
tStart=tic;
figure(1);
imhist1('butterfly.bmp');   %����ֱ��ͼ��ͼ����
figure(2);
GlobalHistogramEqualization('butterfly.bmp');%����ȫ��ֱ��ͼ���⻯����
figure(3);
LocalHistogramEqualization('butterfly.bmp');%���þֲ�ֱ��ͼ���⻯����
figure(4);
DynamicHistogramEqualization('butterfly_noisy.bmp');%���ö�ֱ̬��ͼ���⻯����
figure(5);
DynamicHistogramEqualization('brain.bmp');%���ö�ֱ̬��ͼ���⻯����
 tEnd=toc(tStart);
 fprintf('�ܹ�����ʱ�䣺%.4fs\n',tEnd);