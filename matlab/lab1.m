%[x,fs,bits]=wavread('test01.wav');
%sound(x,fs,bits);     %按指定的采样率和每样本编码位数回放

[x,fs]=audioread('recording_0.wav');  
ainfo=audioinfo('recording_0.wav');
bits=ainfo.BitsPerSample;

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
figure (1);
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
% 将Hz为单位的模拟频率换算为rad为单位的数字频率
wcd=fcd/fs*2*pi;wcu=fcu/fs*2*pi;dw=df/fs*2*pi;    
wsd=fsd/fs*2*pi;wsu=fsu/fs*2*pi;
M=ceil(15.4*pi/dw)+1;      %计算nuttallwin窗设计该滤波器时需要的阶数
n=0:M-1;                  %定义时间范围
w_ham= nuttallwin (M);      %产生M阶的nuttallwin窗
M
size(w_ham)
hd_bs=ideal_lp(wcd,M)+ideal_lp(pi,M)-ideal_lp(wcu,M);
% 调用自编函数计算理想带阻滤波器的脉冲响应
h_bs=w_ham'.*hd_bs;     %用窗口法计算实际滤波器脉冲响应 
size(h_bs)
[db,mag,pha,grd,w]=freqz_m(h_bs,1);    %调用自编函数计算滤波器的频率特性
figure (2);
subplot(2,2,1);plot(w,db); grid on;
xlabel('频率');ylabel('db');
subplot(2,2,2);plot(w,mag); grid on;
xlabel('频率');ylabel('幅度');
subplot(2,2,3);plot(w,pha); grid on;
xlabel('频率');ylabel('相位');
subplot(2,2,4);plot(h_bs);grid on;
xlabel('频率');ylabel('滤波器脉冲响应');

y_fil=fftfilt(h_bs,y);    %用设计好的滤波器对y进行滤波
Y_fil=abs(fft(y_fil));Y_fil=Y_fil(1:length(Y_fil)/2);   %计算频谱取前一般
figure (3);
subplot(3,2,1);plot(t,x);grid on;
xlabel('时间');ylabel('时域原始信号');title('时域原始信号');
subplot(3,2,2);plot(f,X);grid on;
