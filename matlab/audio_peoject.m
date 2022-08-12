% Fs     --Data rate
% Fpass  --pass band
% Fstop  --Cutoff frequencies
% Apass  --Passband ripple
% Astop  --Stopband ripple
% Q_Bit  --Quantization bits

%Ƶ��ȡ�������FIR�˲���
%[x,fs]=audioread('test.wav');
[x,fs]=audioread('restaurant_sn15.wav');
audiowrite('ԭʼtest.wav',x,fs);%�����м���Ƶ
%sound(x,fs,bits);     %��ָ���Ĳ����ʺ�ÿ��������λ���ط�
N=length(x)        % �����ź�x�ĳ���
fn=1900;  
t=0:1/fs:(N-1)/fs;     % ����ʱ�䷶Χ�����������Բ���Ƶ��
x=x(:,1);
x=x';
y=x+ 0.1*sin(fn*2*pi*t); % ������
%sound(y,fs);       % Ӧ�ÿ������������м���ĵ�ƵХ����
audiowrite('�м�test.wav',y,fs);%�����м���Ƶ

X=abs(fft(x));  Y=abs(fft(y));   	% ��ԭʼ�źźͼ����źŽ���fft�任
X=X(1:length(X)/2); Y=Y(1:length(Y)/2);     %��ȡǰ�벿�� 
deltaf=fs/2/length(X);         %����Ƶ�׵����߼��
f=0:deltaf:fs/2-deltaf;        %����Ƶ��Ƶ�ʷ�Χ
figure;
subplot(2,2,1);plot(t,x);grid on;
xlabel('ʱ��');ylabel('ԭʼ�ź�');
subplot(2,2,2);plot(f,X);grid on;
xlabel('Ƶ��');ylabel('ԭʼ�ź�Ƶ��');
subplot(2,2,3);plot(t,y);grid on;
xlabel('ʱ��');ylabel('����������ź�');
subplot(2,2,4);plot(f,Y);grid on;
xlabel('Ƶ��');ylabel('����������ź�Ƶ��');

fpd=1800;fsd=1850;fsu=1950;fpu=2000;Rp=1;As=100;    %�����˲������ָ��
fcd=(fpd+fsd)/2;fcu=(fpu+fsu)/2;
df=min((fsd-fpd),(fpu-fsu));             %�������´�����Ƶ�ʺ�Ƶ�ʼ��
% ��������˲���
M=150;L=(M+mod(M,2))/2;
wsd=fsd/fs;wsu=fsu/fs;
F=[0:1/L:1];%F������length(L)+1
A=[ones(1,fix(wsd*M)), zeros(1,fix(wsu*M)-fix(wsd*M)), ones(1,L+1-fix(wsu*M))];
%fir2��������Ƶ�ʳ�������������˲���
B=fir2(M,F,A);
[db,mag,pha,grd,w]=freqz_m(B,1);    %�����Աຯ�������˲�����Ƶ������
figure (2);
subplot(2,2,1);plot(w,db); grid on;
xlabel('Ƶ��');ylabel('db');
subplot(2,2,2);plot(w,mag); grid on;
xlabel('Ƶ��');ylabel('����');
subplot(2,2,3);plot(w,pha); grid on;
xlabel('Ƶ��');ylabel('��λ');
%[h,t] = impz(B,1);
%stem(t,h);
%subplot(2,2,4);plot(h);grid on;
%xlabel('Ƶ��');ylabel('�˲���������Ӧ');

y_fil=fftfilt(B,y,63);    %����ƺõ��˲�����y�����˲�
Y_fil=abs(fft(y_fil));Y_fil=Y_fil(1:length(Y_fil)/2);   %����Ƶ��ȡǰһ��
figure;
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
sound (y_fil,fs);    %Ӧ�ÿ���������ԭ�����źŻ������Ƶ�����
audiowrite('��ԭtest.wav',y_fil,fs);%�����м���Ƶ
%gerenate txt
%fid = fopen('fir_coe.txt','w');
%fprintf(fid,'%2.6f\t',B);
%fclose(fid);