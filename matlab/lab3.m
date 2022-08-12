%�Ȳ�������ѩ��ƽ������FIR�˲���
clc;clear;
%[x,fs,bits]=wavread('test01.wav');
[x,fs]=audioread('recording_0.wav');  
ainfo=audioinfo('recording_0.wav');
bits=ainfo.BitsPerSample;
%sound(x,fs,bits);     %��ָ���Ĳ����ʺ�ÿ��������λ���ط�
N=length(x)        % �����ź�x�ĳ���
fn=1900;  
t=0:1/fs:(N-1)/fs;     % ����ʱ�䷶Χ�����������Բ���Ƶ��
x=x(:,1);
x=x';
y=x+ 0.1*sin(fn*2*pi*t); 
%sound(y,fs,bits);       % Ӧ�ÿ������������м���ĵ�ƵХ����

X=abs(fft(x));  Y=abs(fft(y));   	% ��ԭʼ�źźͼ����źŽ���fft�任
X=X(1:length(X)/2); Y=Y(1:length(Y)/2);     %��ȡǰ�벿�� 
deltaf=fs/2/length(X);         %����Ƶ�׵����߼��
f=0:deltaf:fs/2-deltaf;        %����Ƶ��Ƶ�ʷ�Χ
figure (1);
subplot(2,2,1);plot(t,x);grid on;
xlabel('ʱ��');ylabel('ԭʼ�ź�');
subplot(2,2,2);plot(f,X);grid on;
xlabel('Ƶ��');ylabel('ԭʼ�ź�Ƶ��');
subplot(2,2,3);plot(t,y);grid on;
xlabel('ʱ��');ylabel('����������ź�');
subplot(2,2,4);plot(f,Y);grid on;
xlabel('Ƶ��');ylabel('����������ź�Ƶ��');

rp = 3;
rs = 40;
fv = [1800 1850 1950 2000];
a = [1 0 1];
dev = [(10^(rp/20)-1)/(10^(rp/20)+1) 10^(-rs/20) (10^(rp/20)-1)/(10^(rp/20)+1)];
[n, fo, ao, w] = firpmord(fv,a,dev,fs);
n
h_bs = firpm(n, fo, ao, w);
size(h_bs)
[db,mag,pha,grd,w]=freqz_m(h_bs,1);    %�����Աຯ�������˲�����Ƶ������
figure (2);
subplot(2,2,1);plot(w,db); grid on;
xlabel('Ƶ��');ylabel('db');
subplot(2,2,2);plot(w,mag); grid on;
xlabel('Ƶ��');ylabel('����');
subplot(2,2,3);plot(w,pha); grid on;
xlabel('Ƶ��');ylabel('��λ');
subplot(2,2,4);plot(h_bs);grid on;
xlabel('Ƶ��');ylabel('�˲���������Ӧ');

y_fil=fftfilt(h_bs,y);    %����ƺõ��˲�����y�����˲�
Y_fil=abs(fft(y_fil));Y_fil=Y_fil(1:length(Y_fil)/2);   %����Ƶ��ȡǰһ��
figure (3);
subplot(3,2,1);plot(t,x);grid on;
xlabel('ʱ��');ylabel('ʱ��ԭʼ�ź�');title('ʱ��ԭʼ�ź�');
subplot(3,2,2);plot(f,X);grid on;
xlabel('Ƶ��');ylabel('ԭʼ�ź�Ƶ��');title('ԭʼ�ź�Ƶ��');
subplot(3,2,3);plot(t,y);grid on;
xlabel('ʱ��');ylabel('�����ź�');title('�����ź�');
subplot(3,2,4);plot(f,Y);grid on;
xlabel('Ƶ��');ylabel('�����ź�Ƶ��');title('�����ź�Ƶ��');
subplot(3,2,5);plot(t,y_fil);grid on;
xlabel('ʱ��');ylabel('�˲��ź�');title('�˲��ź�');
subplot(3,2,6);plot(f,Y_fil);grid on;
xlabel('Ƶ��');ylabel('�˲��ź�Ƶ��');title('�˲��ź�Ƶ��');
sound (y_fil,fs,bits);    %Ӧ�ÿ���������ԭ�����źŻ������Ƶ�����
