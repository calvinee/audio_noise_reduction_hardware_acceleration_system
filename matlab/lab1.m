%[x,fs,bits]=wavread('test01.wav');
%sound(x,fs,bits);     %��ָ���Ĳ����ʺ�ÿ��������λ���ط�

[x,fs]=audioread('recording_0.wav');  
ainfo=audioinfo('recording_0.wav');
bits=ainfo.BitsPerSample;

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

fpd=1800;fsd=1850;fsu=1950;fpu=2000;Rp=1;As=100;      %�����˲������ָ��
fcd=(fpd+fsd)/2;fcu=(fpu+fsu)/2;
df=min((fsd-fpd),(fpu-fsu));             %�������´�����Ƶ�ʺ�Ƶ�ʼ��
% ��HzΪ��λ��ģ��Ƶ�ʻ���ΪradΪ��λ������Ƶ��
wcd=fcd/fs*2*pi;wcu=fcu/fs*2*pi;dw=df/fs*2*pi;    
wsd=fsd/fs*2*pi;wsu=fsu/fs*2*pi;
M=ceil(15.4*pi/dw)+1;      %����nuttallwin����Ƹ��˲���ʱ��Ҫ�Ľ���
n=0:M-1;                  %����ʱ�䷶Χ
w_ham= nuttallwin (M);      %����M�׵�nuttallwin��
M
size(w_ham)
hd_bs=ideal_lp(wcd,M)+ideal_lp(pi,M)-ideal_lp(wcu,M);
% �����Աຯ��������������˲�����������Ӧ
h_bs=w_ham'.*hd_bs;     %�ô��ڷ�����ʵ���˲���������Ӧ 
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
