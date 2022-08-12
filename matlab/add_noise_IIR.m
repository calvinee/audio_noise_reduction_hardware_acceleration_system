clear
clc
[audio,fs]=audioread('test.wav');%声音读取
%audio = audio(:,1); %双通道变单通道
n=length(audio);
T = 1/fs;%采样间隔
t = (0:n-1)*T;%时间轴
f = (0:n-1)/n*fs;%频率轴
 %快速傅里叶变换
audio_fft=fft(audio,n)*T; 
%加噪声
tt =(1:n);
noise=0.02*cos(8000*2*pi/fs*tt');%加噪声
s=audio+noise;
s_fft=fft(s,n)*T; 
%设计IIR低通滤波器
rp = 1;
rs=60;
Ft=fs;
Fp=2000;
Fs=4000;                                        
wp=2*pi*Fp/Ft;
ws = 2*pi*Fs/Ft ;   %求出待设计的模拟滤波器的边界频率
[N,wn]=buttord(wp,ws,rp,rs,'s');    %低通滤波器的阶数和截止频率
[b,a]=butter(N,wn,'s');             %S域频率响应的参数即：滤波器的传输函数
[bz,az]=bilinear(b,a,0.5);          %利用双线性变换实现频率响应S域到Z域的变换
figure(2);%低通滤波器特性
[h,w]=freqz(bz,az);
title('IIR低通滤波器');
plot(w*fs/(2*pi),abs(h));
grid;
%滤波
z=filter(bz,az,s);
z_fft=fft(z);     %滤波后的信号频谱
figure(1); 
%绘出原始音频时域波
subplot(2,3,1);
plot(t,audio);   
xlabel('时间/s');
ylabel('幅度');
title('初始信号波形');  
grid;
 %绘出原始音频频域频谱
subplot(2,3,4); 
audiof = abs(audio_fft);
plot(f(1:(n-1)/2),audiof(1:(n-1)/2));
title('初始信号频谱');
xlabel('频率/Hz');
ylabel('幅度');
grid;
%绘出加噪音频时域波
subplot(2,3,2)
plot(t,s);
title('加噪声后信号波形')
xlabel('时间/s');
ylabel('幅度');
grid;
 %绘出加噪音频频域频谱
subplot(2,3,5)
sf = abs(s_fft);
plot(f(1:(n-1)/2),sf(1:(n-1)/2));
xlabel('频率/Hz');
ylabel('幅度');
title('加噪声后信号信号频谱');
grid;
%绘出滤波音频时域波
subplot(2,3,3);
plot(t,z);
title('低通滤波后的信号波形');
xlabel('时间/s');
ylabel('幅度');
grid;
%绘出滤波音频频域波
subplot(2,3,6);
zf = abs(z_fft);
plot(f(1:(n-1)/2),zf(1:(n-1)/2));
title('低通滤波后信号的频谱');
xlabel('频率/Hz');
ylabel('幅度');
grid;
audio_final = [audio;s;z];%原始语音，加噪语音，滤波语音的合成音频矩阵
sound(audio_final,fs); %播放语音
audiowrite('降噪test_1.wav',audio_final,fs);%保存音频
