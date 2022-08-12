clear
clc
[audio,fs]=audioread('test.wav');%������ȡ
%audio = audio(:,1); %˫ͨ���䵥ͨ��
n=length(audio);
T = 1/fs;%�������
t = (0:n-1)*T;%ʱ����
f = (0:n-1)/n*fs;%Ƶ����
 %���ٸ���Ҷ�任
audio_fft=fft(audio,n)*T; 
%������
tt =(1:n);
noise=0.02*cos(8000*2*pi/fs*tt');%������
s=audio+noise;
s_fft=fft(s,n)*T; 
%���IIR��ͨ�˲���
rp = 1;
rs=60;
Ft=fs;
Fp=2000;
Fs=4000;                                        
wp=2*pi*Fp/Ft;
ws = 2*pi*Fs/Ft ;   %�������Ƶ�ģ���˲����ı߽�Ƶ��
[N,wn]=buttord(wp,ws,rp,rs,'s');    %��ͨ�˲����Ľ����ͽ�ֹƵ��
[b,a]=butter(N,wn,'s');             %S��Ƶ����Ӧ�Ĳ��������˲����Ĵ��亯��
[bz,az]=bilinear(b,a,0.5);          %����˫���Ա任ʵ��Ƶ����ӦS��Z��ı任
figure(2);%��ͨ�˲�������
[h,w]=freqz(bz,az);
title('IIR��ͨ�˲���');
plot(w*fs/(2*pi),abs(h));
grid;
%�˲�
z=filter(bz,az,s);
z_fft=fft(z);     %�˲�����ź�Ƶ��
figure(1); 
%���ԭʼ��Ƶʱ��
subplot(2,3,1);
plot(t,audio);   
xlabel('ʱ��/s');
ylabel('����');
title('��ʼ�źŲ���');  
grid;
 %���ԭʼ��ƵƵ��Ƶ��
subplot(2,3,4); 
audiof = abs(audio_fft);
plot(f(1:(n-1)/2),audiof(1:(n-1)/2));
title('��ʼ�ź�Ƶ��');
xlabel('Ƶ��/Hz');
ylabel('����');
grid;
%���������Ƶʱ��
subplot(2,3,2)
plot(t,s);
title('���������źŲ���')
xlabel('ʱ��/s');
ylabel('����');
grid;
 %���������ƵƵ��Ƶ��
subplot(2,3,5)
sf = abs(s_fft);
plot(f(1:(n-1)/2),sf(1:(n-1)/2));
xlabel('Ƶ��/Hz');
ylabel('����');
title('���������ź��ź�Ƶ��');
grid;
%����˲���Ƶʱ��
subplot(2,3,3);
plot(t,z);
title('��ͨ�˲�����źŲ���');
xlabel('ʱ��/s');
ylabel('����');
grid;
%����˲���ƵƵ��
subplot(2,3,6);
zf = abs(z_fft);
plot(f(1:(n-1)/2),zf(1:(n-1)/2));
title('��ͨ�˲����źŵ�Ƶ��');
xlabel('Ƶ��/Hz');
ylabel('����');
grid;
audio_final = [audio;s;z];%ԭʼ�����������������˲������ĺϳ���Ƶ����
sound(audio_final,fs); %��������
audiowrite('����test_1.wav',audio_final,fs);%������Ƶ
