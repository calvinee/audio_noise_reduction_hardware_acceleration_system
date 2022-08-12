width=32;%rom中数据的宽度
depth=2048;%rom的深度

C=fix(C)
%y=0:2048;
y=fliplr(C);%产生要发送的数据，255，254......2,1,0
fid=fopen('fir.coe','w');%打开一个.coe文件
%存放ROM中的.coe文件第一行字符串，16表示16进制，可以改成其他进制
fprintf(fid,'memory_initialization_radix=32;\n');
%存放在ROM中的.coe文件第二行字符串
fprintf(fid,'memory_initialization_vector=\n');
%把前255个数据写入.coe文件中，并用逗号隔开，每行一个数据
fprintf(fid,'%2.0f,\n',y(1:end-1));
%把最后一个数据写入.coe文件中，并用分号结尾
fprintf(fid,'%2.0f;\n',y(end));
fclose(fid);%关闭文件指针
