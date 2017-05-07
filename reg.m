clc
clear all
y=importdata('Ԥ������.txt');%Ԥ������
x=importdata('Ӱ������.txt');%Ԥ������

M=[x y];%�ϲ�Ԥ�����Ӻ�Ԥ������
n=size(M,1);%��������
XNUM=size(x,2);%Ԥ��������Ŀ
TOTALNUM=size(M,2);%���ӺͶ�������
MM=roundn(mean(M),-2);%ƽ��ֵ����
R=corrcoef(M);%���ϵ������
COVM=cov(M);%Э����
flag=0;%ѭ������
INDEXG=[];%������������
while 1
    flag=flag+1;
    V=[];%�������ӷ����������
    for i=1:XNUM
        V=[V power(R(i,TOTALNUM),2)/R(i,i)];
    end
    
    if flag>3 %�������������Ӻ���Ҫ�����޳�����
        %[VM,INDEX]=min(V);
        VM=V(1);
        for tt=1:XNUM
            if V(tt)<=VM && isIn(INDEXG,tt)
                INDEX=tt;
                VM=V(tt);
            end
        end
        str=['Check:x' num2str(INDEX)];
        disp(str);
        %VMΪ��ѡ����������С�ķ����ֵ��INDEXΪ����ֵ���±�
        F2=VM*(n-length(INDEXG)-1)/R(TOTALNUM,TOTALNUM);
        if F2<=5.0
            K=INDEX;
            %ɾ������
            for tt=1:size(INDEXG,2)
                if INDEXG(tt)==K
                    INDEXG(tt)=[];
                    str=['Delete:x' num2str(tt)];
                    disp(str);
                end
            end
        else
            %[VM,INDEX]=max(V);
            VM=0;
            for tt=1:XNUM
                if V(tt)>=VM && isIn(INDEXG,tt)==false
                    INDEX=tt;
                    VM=V(tt);
                end
            end
         %VMΪ��δѡ�����������ķ����ֵ��INDEXΪ����ֵ���±�
            F1=VM*(n-length(INDEXG)-2)/(R(TOTALNUM,TOTALNUM)-VM);
            if F1<=5.0 %�Ȳ����޳�Ҳ���ܼ���
                break;
            else
                K=INDEX;
                INDEXG=[INDEXG K];
                str=['Introduce:x' num2str(K)];
                disp(str);
            end
        end
    else
        %[VM,INDEX]=max(V);
        VM=0;
        for tt=1:XNUM
          if (V(tt)>=VM) && (isIn(INDEXG,tt)==false)
              INDEX=tt;
              VM=V(tt);
          end
        end
        %VMΪ��δѡ�����������ķ����ֵ��INDEXΪ����ֵ���±�
        F1=VM*(n-length(INDEXG)-2)/(R(TOTALNUM,TOTALNUM)-VM);
        if F1<=5.0 %�Ȳ����޳�Ҳ����VN��
            break;
        else
            K=INDEX;
            INDEXG=[INDEXG K];
            str=['Introduce:x' num2str(K)];
            disp(str);
        end
    end
    RTMP=R;%��һ�α仯�ľ���
    for x=1:TOTALNUM
        for y=1:TOTALNUM
            if (x~=K) && (y~=K)
                R(x,y)=RTMP(x,y)-RTMP(x,K)*RTMP(K,y)/RTMP(K,K);
            else if x==y
                    R(K,K)=1/RTMP(K,K);
                else if y==K
                        R(x,K)=-RTMP(x,K)/RTMP(K,K);
                    else
                        R(K,y)=RTMP(K,y)/RTMP(K,K);
                    end
                end
            end
        end
    end
    
end
disp('End of regression');
streqa=['y='];
b=[MM(size(MM,2))];
for ii=1:size(INDEXG,2)
   str=['b_',num2str(ii),'='];
   b=[b 0];
   disp(str);
   disp(R(INDEXG(ii),TOTALNUM));
   b(1)=b(1)-R(INDEXG(ii),TOTALNUM)*sqrt(COVM(TOTALNUM,TOTALNUM))/sqrt(COVM(INDEXG(ii),INDEXG(ii)))*MM(INDEXG(ii));
   b(ii+1)=R(INDEXG(ii),TOTALNUM)*sqrt(COVM(TOTALNUM,TOTALNUM))/sqrt(COVM(INDEXG(ii),INDEXG(ii)));
   streqa=[streqa,'(',num2str(b(ii+1)),')','*x',num2str(INDEXG(ii)),'+'];
end
streqa=[streqa,'(',num2str(b(1)),')'];
disp('Final equation:')
disp(streqa);