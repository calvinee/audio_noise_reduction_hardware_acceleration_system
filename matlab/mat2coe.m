width=32;%rom�����ݵĿ��
depth=2048;%rom�����

C=fix(C)
%y=0:2048;
y=fliplr(C);%����Ҫ���͵����ݣ�255��254......2,1,0
fid=fopen('fir.coe','w');%��һ��.coe�ļ�
%���ROM�е�.coe�ļ���һ���ַ�����16��ʾ16���ƣ����Ըĳ���������
fprintf(fid,'memory_initialization_radix=32;\n');
%�����ROM�е�.coe�ļ��ڶ����ַ���
fprintf(fid,'memory_initialization_vector=\n');
%��ǰ255������д��.coe�ļ��У����ö��Ÿ�����ÿ��һ������
fprintf(fid,'%2.0f,\n',y(1:end-1));
%�����һ������д��.coe�ļ��У����÷ֺŽ�β
fprintf(fid,'%2.0f;\n',y(end));
fclose(fid);%�ر��ļ�ָ��
