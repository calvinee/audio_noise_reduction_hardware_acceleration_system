clear all;
clc;
%[filename,filepath]=uigetfile('.wav','Open wav file');
[y,fs]=audioread('restaurant_sn15.wav');  %从电脑文件夹选择wav音频文件
b=menu('请选择选项','原始信号采样后时域图和频谱图','FIR滤波器','IIR滤波器','退出');
while(b~=4)
if b==1
    temp=menu('请选择选项','播放原始语音','原始语音时域图','原始语音做FFT变换后频谱图','返回');
    if temp==1
       %播放语音
       sound(y);
    elseif temp==2
       %画出原始语音时域图
       figure(11) 
       plot(y);
       xlabel('时间（ms)'); 
       ylabel('幅值');    
       title('原始语音时域图');
    elseif temp==3
       %画出原始语音做FFT变换后频谱图
       Y1=fft(y);
       Y=abs(Y1);
       figure(12)
       plot(Y);
       xlabel('频率'); 
       ylabel('幅值');
       title('原始语音做FFT变换后频谱图');
    else
       end
end   
if b==2
    temp=menu('请选择选项','FIR低通滤波器','FIR高通滤波器','FIR带通滤波器','返回');
    if temp==1
        %FIR低通滤波器
        fs=10000;
        wp=2*pi*1000/fs;
        wst=2*pi*1200/fs;
        Rp=1;
        Rs=100;
        wdelta=wst-wp;
        N=ceil(8*pi/wdelta);              %取整
        wn=(wp+wst)/2;
        [b,a]=fir1(N,wn/pi,hamming(N+1));       %选择窗函数，并归一化截止频率
        figure(21)
        freqz(b,a,512);
        title('FIR低通滤波器');
        y1=filter(b,a,y);
        figure(22)
        subplot(2,1,1)
        plot(y)
        title('FIR低通滤波器滤波前的时域波形');
        xlabel('时间（ms)'); 
        ylabel('幅值'); 
        subplot(2,1,2)
        plot(y1);
        title('FIR低通滤波器滤波后的时域波形');
        xlabel('时间（ms)'); 
        ylabel('幅值');    
        sound(y1,8000);                    %播放滤波后的语音信号
        F0=fft(y1,1024);
        f=fs*(0:511)/1024;
        figure(23)
        y2=fft(y,1024);
        subplot(2,1,1);
        plot(f,abs(y2(1:512)));
        title('FIR带通滤波器滤波前的频谱')
        xlabel('频率/Hz');
        ylabel('幅值');
        subplot(2,1,2)
        F2=plot(f,abs(F0(1:512)));
        title('FIR低通滤波器滤波后的频谱');
        xlabel('频率/Hz');
        ylabel('幅值');
    elseif temp==2
    %FIR高通滤波器
        fs=20000;
        wp=2*pi*5000/fs;
        wst=2*pi*3000/fs;
        Rp=1;
        Rs=100;
        wdelta=wp-wst;
        N=ceil(8*pi/wdelta);    %取整
        wn=(wp+wst)/2;
        [b,a]=fir1(N,wn/pi,'high');     
        figure(24)
        freqz(b,a,512);
        title('FIR高通滤波器');
        y1=filter(b,a,y);
        figure(25)
        subplot(2,1,1)
        plot(y)
        title('FIR高通滤波器滤波前的时域波形');
        xlabel('时间（ms)'); 
        ylabel('幅值');
        subplot(2,1,2)
        plot(y1);
        title('FIR高通滤波器滤波后的时域波形');
        xlabel('时间（ms)'); 
        ylabel('幅值');
        sound(y1,8000);      %播放滤波后的语音信号
        audiowrite('2_滤波test.wav',y1,8000);
        F0=fft(y1,3000);
        f=fs*(0:511)/1024;
        figure(26)
        y2=fft(y,1024);
        subplot(2,1,1);
        plot(f,abs(y2(1:512)));
        title('FIR高通滤波器滤波前的频谱')
        xlabel('频率/Hz');
        ylabel('幅值');
        subplot(2,1,2)
        plot(f,abs(F0(1:512)));
        title('FIR高通滤波器滤波后的频谱')
        xlabel('频率/Hz');
        ylabel('幅值');
    elseif temp==3
     %FIR带通滤波器
        fs=22050;
        wp1=2*pi*1200/fs;wp2=2*pi*3000/fs;
        ws1=2*pi*1000/fs;ws2=2*pi*3200/fs;
        Rp=1;
        Rs=100;
        wp=(wp1+ws1)/2;ws=(wp2+ws2)/2;
        wdelta=wp1-ws1;
        N=ceil(8*pi/wdelta);              %取整
        wn=[wp ws];
       [b,a]=fir1(N,wn/pi,'bandpass');      
        figure(27)
        freqz(b,a,512);
        title('FIR带通滤波器');
        y1=filter(b,a,y);
        figure(28)
        subplot(2,1,1)
        plot(y);
        xlabel('时间（ms)'); 
        ylabel('幅值'); 
        title('FIR带通滤波器滤波前的时域波形');
        subplot(2,1,2)
        plot(y1);
        title('FIR带通滤波器滤波后的时域波形');
        xlabel('时间（ms)'); 
        ylabel('幅值'); 
        sound(y1,8000);                    %播放滤波后的语音信号
        F0=fft(y1,3000);
        f=fs*(0:511)/1024;
        figure(29)
        y2=fft(y,1024);
        subplot(2,1,1);
        plot(f,abs(y2(1:512)));
        title('FIR带通滤波器滤波前的频谱')
        xlabel('频率/Hz');
        ylabel('幅值');
        subplot(2,1,2)
        plot(f,abs(F0(1:512)));
        title('FIR带通滤波器滤波后的频谱')
        xlabel('频率/Hz');
        ylabel('幅值');
    else
        end
end
   if b==3
      temp=menu('请选择选项','IIR低通滤波器','IIR高通滤波器','IIR带通滤波器','返回');
      if temp==1
    %IIR低通滤波器
       fs=22050;
       Ts=1/fs;
       R1=10;
       wp=2*pi*1000/fs;
       ws=2*pi*1200/fs;
       Rp=1;
       Rl=100;
       wp1=2/Ts*tan(wp/2);                 %将模拟指标转换成数字指标
       ws1=2/Ts*tan(ws/2); 
       [N,Wn]=buttord(wp1,ws1,Rp,R1,'s');  %选择滤波器的最小阶数
       [Z,P,K]=buttap(N);                  %创建butterworth模拟滤波器
       [Bap,Aap]=zp2tf(Z,P,K);
       [b,a]=lp2lp(Bap,Aap,Wn);   
       [bz,az]=bilinear(b,a,fs);           %用双线性变换法实现模拟滤波器到数字滤波器的转换
       [H,W]=freqz(bz,az); 
       figure(31)
       plot(W*fs/(2*pi),abs(H))
       grid
       xlabel('频率／Hz');
       ylabel('频率响应幅度');
       title('IIR低通滤波器');
       f1=filter(bz,az,y);
       figure(32)
       subplot(2,1,1)    %画出滤波前的时域图
       plot(y); 
       xlabel('时间（ms)'); 
       ylabel('幅值'); 
       title('IIR低通滤波器滤波前的时域波形');
       subplot(2,1,2)
       plot(f1);                         %画出滤波后的时域图
       title('IIR低通滤波器滤波后的时域波形');
       xlabel('时间（ms)'); 
       ylabel('幅值');
       sound(f1,9000);                    %播放滤波后的信号
       F0=fft(f1,3000);
       f=fs*(0:511)/1024;
       figure(33)
       y2=fft(y,1024);
       subplot(2,1,1);
       plot(f,abs(y2(1:512)));             %画出滤波前的频谱图
       title('IIR低通滤波器滤波前的频谱')
       xlabel('频率/Hz');
       ylabel('幅值');
       subplot(2,1,2)
       f=fs*(0:511)/1024;
       F1=plot(f,abs(F0(1:512)));          %画出滤波后的频谱图
       title('IIR低通滤波器滤波后的频谱')
       xlabel('频率/Hz');
       ylabel('幅值');
      elseif temp==2
     %IIR高通滤波器
        fs=22050;
        Fs=22050;
        Ts=1/Fs;
        R1=50;
        Wp=2*pi*5000/fs;
        Ws=2*pi*3000/fs;
        Rp=1;
        Rl=100;
        Wp1=2/Ts*tan(Wp/2);                 %将模拟指标转换成数字指标
        Ws1=2/Ts*tan(Ws/2); 
        [N,Wn]=cheb2ord(Wp1,Ws1,Rp,Rl,'s');  %选择滤波器的最小阶数
        [Z,P,K]=cheb2ap(N,Rl);                  %创建切比雪夫模拟滤波器
        [Bap,Aap]=zp2tf(Z,P,K);
        [b,a]=lp2hp(Bap,Aap,Wn);   
        [bz,az]=bilinear(b,a,Fs);           %用双线性变换法实现模拟滤波器到数字滤波器的转换
        [H,W]=freqz(bz,az);                 %绘制频率响应曲线
        figure(34)
        plot(W*fs/(2*pi),abs(H));
        grid
        xlabel('频率／Hz');
        ylabel('频率响应幅度');
        title('IIR高通滤波器');
        f1=filter(bz,az,y);
        figure(35)
        subplot(2,1,1)
        plot(y);                       %画出滤波前的时域图
        xlabel('时间（ms)'); 
        ylabel('幅值'); 
        title('IIR高通滤波器滤波前的时域波形');
        subplot(2,1,2)
        xlabel('时间（ms)'); 
        ylabel('幅值'); 
        plot(f1);
        xlabel('时间（ms)'); 
        ylabel('幅值'); 
        title('IIR高通滤波器滤波后的时域波形');
        sound(f1,8000);                    %播放滤波后的信号
        F0=fft(f1,1024);
        figure(36)
        y2=fft(y,1024);
        subplot(2,1,1);
        plot(f,abs(y2(1:512)));             %画出滤波前的频谱图
        title('IIR高通滤波器滤波前的频谱')
        xlabel('频率/Hz');
        ylabel('幅值');
        subplot(2,1,2)
        f=fs*(0:511)/1024;
        plot(f,abs(F0(1:512)));          %画出滤波后的频谱图
        title('IIR高通滤波器滤波后的频谱')
        xlabel('频率/Hz');
        ylabel('幅值');
    elseif temp==3
    %IIR带通滤波器
       Fs=22050;
       Ts=1/Fs;
       R1=30;
       fb1=1200;
       fb2=3000;
       fc1=1000;
       fc2=3200;
       fs=22050;
       W1=2*fb1*pi/fs;
       W2=2*fc1*pi/fs;
       W3=2*fb2*pi/fs;
       W4=2*fc2*pi/fs;
       Wp=[W1,W3];
       Ws=[W2,W4];
       Rp=1;
       Rl=100;
       Wp1=2/Ts*tan(Wp/2);                 %将模拟指标转换成数字指标
       Ws1=2/Ts*tan(Ws/2); 
       [N,Wn]=cheb2ord(Wp1,Ws1,Rp,R1,'s');  %选择滤波器的最小阶数
       [Z,P,K]=cheb2ap(N,Rl);                  %创建切比雪夫模拟滤波器
       [Bap,Aap]=zp2tf(Z,P,K);
       [b,a]=lp2bp(Bap,Aap,2100*2*pi,1800*2*pi);   
       [bz,az]=bilinear(b,a,Fs);           %用双线性变换法实现模拟滤波器到数字滤波器的转换
       [H,W]=freqz(bz,az);                 %绘制频率响应曲线
       figure(37)
       plot(W*fs/(2*pi),abs(H));
       grid
       xlabel('频率／Hz');
       ylabel('频率响应幅度');
       title('IIR带通滤波器');
       f1=filter(bz,az,y);
       figure(38)
       subplot(2,1,1)
       plot(y);                        %画出滤波前的时域图
       xlabel('时间（ms)'); 
       ylabel('幅值'); 
       title('IIR带通滤波器滤波前的时域波形');
       subplot(2,1,2)
       F0=fft(f1,1024);
       f=fs*(0:511)/1024;
       plot(f1);
       title('IIR带通滤波器滤波后的时域波形');
       xlabel('时间（ms)'); 
       ylabel('幅值'); 
       sound(f1,8000);  %播放滤波后的信号
       F0=fft(f1,3000);
       figure(39)
       y2=fft(y,1024);
       f=fs*(0:511)/1024;
       subplot(2,1,1);
       plot(f,abs(y2(1:512)));             %画出滤波前的频谱图
       title('IIR带通滤波器滤波前的频谱')
       xlabel('频率/Hz');
       ylabel('幅值');
       subplot(2,1,2)
       plot(f,abs(F0(1:512)));          %画出滤波后的频谱图
       title('IIR带通滤波器滤波后的频谱')
       xlabel('频率/Hz');
       ylabel('幅值');
     else 
    end
   end
b=menu('请选择选项','原始信号采样后时域图和频谱图','FIR滤波器','IIR滤波器','退出');
end
