%���FIR���ֵ�ͨ�˲���
%ͨ����ֹƵ�ʣ�fp����λHz��
%ͨ��˥����Rp����λdB��
%�����ֹƵ�ʣ�fs����λHz��
%���˥����Rs����λdB��
%����Ƶ�ʣ�Fs����λHz��
 
%����ָ��Ҫ�����ã����Լ�������ļ���
%fp=1000;fs=2000;%��ͨʾ��
fp=2000;fs=1000;%��ͨʾ��
%fp=[500,1200];fs=[300,1500];%��ͨʾ��
%fp=[300,1500];fs=[500,1200];%����ʾ��
Rp=1;Rs=45; 
Fs=5000;%����Ƶ��
filter_type=2;%1:��ͨ��2����ͨ��3����ͨ��4������
 
wp=2*pi*fp/Fs; ws=2*pi*fs/Fs; %ת��Ϊ���ֽ�Ƶ��ָ��
tr_width=abs(wp-ws);
P=2;%�������Ĵ���ϵ��Ϊ2
N0=ceil(P*4*pi/tr_width);%����Ӵ����N��ȡ������
N=N0+mod(N0+1,2);%ȷ��NΪ����
m=(N-1)/2;%������λϵ��
wc=(wp+ws)/2;%��ֹƵ��
n=(0:1:N-1);
window=(hamming(N))';
nm=n-m+eps;%�������
hd=(sin(pi*nm)-sin(wc*nm))./(pi*nm);
hn=hd.*window;
[H,W]=freqz(hn,1,100);
mag=abs(H);pha=angle(H);
db=20*log10((mag+eps)/max(mag));
subplot(2,1,1);plot(W*Fs/(2*pi),db);
title('���������FIR�˲�����Ƶ����');xlabel('Ƶ�ʣ�Hz��');ylabel('���ȣ�dB��');
subplot(2,1,2);plot(W*Fs/(2*pi),pha);
title('���������FIR�˲�����Ƶ����');xlabel('Ƶ�ʣ�Hz��');ylabel('��λ��rad��');

