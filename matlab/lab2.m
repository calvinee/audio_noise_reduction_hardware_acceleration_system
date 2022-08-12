%频率取样法设计FIR滤波器
%[x,fs,bits]=wavread('test01.wav');
[x,fs]=audioread('recording_0.wav');  
ainfo=audioinfo('recording_0.wav');
bits=ainfo.BitsPerSample;
%sound(x,fs,bits);     %按指定的采样率和每样本编码位数回放
N=length(x)        % 计算信号x的长度
fn=1900;  
t=0:1/fs:(N-1)/fs;     % 计算时间范围，样本数除以采样频率
x=x(:,1);
x=x';
y=x+ 0.1*sin(fn*2*pi*t); 
%sound(y,fs,bits);       % 应该可以明显听出有尖锐的单频啸叫声

X=abs(fft(x));  Y=abs(fft(y));   	% 对原始信号和加噪信号进行fft变换
X=X(1:length(X)/2); Y=Y(1:length(Y)/2);     %截取前半部分 
deltaf=fs/2/length(X);         %计算频谱的谱线间隔
f=0:deltaf:fs/2-deltaf;        %计算频谱频率范围
figure;
subplot(2,2,1);plot(t,x);grid on;
xlabel('时间');ylabel('原始信号');
subplot(2,2,2);plot(f,X);grid on;
xlabel('频率');ylabel('原始信号频谱');
subplot(2,2,3);plot(t,y);grid on;
xlabel('时间');ylabel('加入的噪声信号');
subplot(2,2,4);plot(f,Y);grid on;
xlabel('频率');ylabel('加入的噪声信号频谱');

fpd=1800;fsd=1850;fsu=1950;fpu=2000;Rp=1;As=100;      %带阻滤波器设计指标
fcd=(fpd+fsd)/2;fcu=(fpu+fsu)/2;
df=min((fsd-fpd),(fpu-fsu));             %计算上下带中心频率和频率间隔
% 构造带阻滤波器
M=3396;L=(M+mod(M,2))/2;
wsd=fsd/fs;wsu=fsu/fs;
F=[0:1/L:1];%F长度是length(L)+1
A=[ones(1,fix(wsd*M)), zeros(1,fix(wsu*M)-fix(wsd*M)), ones(1,L+1-fix(wsu*M))];
%fir2函数——频率抽样法构造带阻滤波器
B=fir2(M,F,A);
[db,mag,pha,grd,w]=freqz_m(B,1);    %调用自编函数计算滤波器的频率特性
figure (2);
subplot(2,2,1);plot(w,db); grid on;
xlabel('频率');ylabel('db');
subplot(2,2,2);plot(w,mag); grid on;
xlabel('频率');ylabel('幅度');
subplot(2,2,3);plot(w,pha); grid on;
xlabel('频率');ylabel('相位');
subplot(2,2,4);plot(h_bs);grid on;
xlabel('频率');ylabel('滤波器脉冲响应');

y_fil=fftfilt(B,y);    %用设计好的滤波器对y进行滤波
Y_fil=abs(fft(y_fil));Y_fil=Y_fil(1:length(Y_fil)/2);   %计算频谱取前一般
figure;
subplot(3,2,1);plot(t,x);grid on;
xlabel('时间');ylabel('时域原始信号');title('时域原始信号');
subplot(3,2,2);plot(f,X);grid on;
xlabel('频率');ylabel('原始信号频谱');title('原始信号频谱');
subplot(3,2,3);plot(t,y);grid on;
xlabel('时间');ylabel('加噪信号');title('加噪信号');
subplot(3,2,4);plot(f,Y);grid on;
xlabel('频率');ylabel('加噪信号频谱');title('加噪信号频谱');
subplot(3,2,5);plot(t,y_fil);grid on;
xlabel('时间');ylabel('滤波信号');title('滤波信号');
subplot(3,2,6);plot(f,Y_fil);grid on;
xlabel('频率');ylabel('滤波信号频谱');title('滤波信号频谱');
sound (y_fil,fs,bits);    %应该可以听到与原语音信号基本相似的语音
