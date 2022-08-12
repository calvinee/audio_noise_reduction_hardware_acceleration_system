%设计FIR数字低通滤波器
%通带截止频率：fp（单位Hz）
%通带衰减：Rp（单位dB）
%阻带截止频率：fs（单位Hz）
%阻带衰减：Rs（单位dB）
%采样频率：Fs（单位Hz）
 
%技术指标要求设置，按自己需求更改即可
%fp=1000;fs=2000;%低通示例
fp=2000;fs=1000;%高通示例
%fp=[500,1200];fs=[300,1500];%带通示例
%fp=[300,1500];fs=[500,1200];%带阻示例
Rp=1;Rs=45; 
Fs=5000;%采样频率
filter_type=2;%1:低通，2：高通，3：带通，4：带阻
 
wp=2*pi*fp/Fs; ws=2*pi*fs/Fs; %转换为数字角频率指标
tr_width=abs(wp-ws);
P=2;%海明窗的窗宽系数为2
N0=ceil(P*4*pi/tr_width);%计算加窗宽度N（取整数）
N=N0+mod(N0+1,2);%确保N为奇数
m=(N-1)/2;%计算移位系数
wc=(wp+ws)/2;%截止频率
n=(0:1:N-1);
window=(hamming(N))';
nm=n-m+eps;%避免除零
hd=(sin(pi*nm)-sin(wc*nm))./(pi*nm);
hn=hd.*window;
[H,W]=freqz(hn,1,100);
mag=abs(H);pha=angle(H);
db=20*log10((mag+eps)/max(mag));
subplot(2,1,1);plot(W*Fs/(2*pi),db);
title('窗函数设计FIR滤波器幅频曲线');xlabel('频率（Hz）');ylabel('幅度（dB）');
subplot(2,1,2);plot(W*Fs/(2*pi),pha);
title('窗函数设计FIR滤波器相频曲线');xlabel('频率（Hz）');ylabel('相位（rad）');

