%�������ؿ���ģ�ⷨģ����綯������������
%ͬʱ���������繦�����ߣ���Ϊ���������ߵĶԱȻ���
clc;clear;
Ntest=100;%������� ������
SOC_end=0.9;
Pbiao=15;%��繦��Ϊ15kW
nn=0.9;%���Ч��Ϊ0.9
Pcharge=Pbiao*nn;%ʵ�ʳ��Ĺ���
Cbattery=30;                     %�������
distance=unifrnd(30,80,1,Ntest);     %Ntest���� ÿ�����ĵ��̾���
judge=0.15*distance/Cbattery;            %���̺ĵ�SOC

SOC=rand(1,Ntest).*(1-judge)+judge;          %��ʼSOC
timestart=8;                     %8�����
timework=normrnd(8.5,0.5,1,Ntest);          %����ʱ�䣬������̬�ֲ�
timerest=normrnd(17.5,0.5,1,Ntest);         %�°�ʱ��
timehome=normrnd(19,0.5,1,Ntest);           %����ʱ�䣬�������°�߷�·�����ӣ����Բ���Ϊ�°�ؼҺ�ʱ���ϰ��ʱ��ͬ



SOC=SOC-judge;
battery=SOC*Cbattery;    %�����ĵ���
time1=zeros(1,Ntest);
time2=zeros(1,Ntest);
%SOC��¼����
SOC_sa=ones(1,Ntest);
SOC_sb=ones(1,Ntest);

for i=1:Ntest
    if SOC(i)<judge+0.2
        SOC_sa(i)=SOC(i);
        time1(i)=timework(i);           %�������Ҫ��磬��翪ʼʱ��Ϊ����ʱ��
        time2(i)=time1(i)+(1-SOC(i))*Cbattery/Pcharge;     %������ʱ�䣬��繦��Pcharge
        SOC(i)=SOC_end;                              %�°�ǰ������
        battery(i)=Cbattery*SOC(i);
    end
end

SOC=SOC-judge;
battery=SOC*Cbattery;    %���Һ�ĵ���
time3=zeros(1,Ntest);
time4=zeros(1,Ntest);

for i=1:Ntest
    if SOC(i)<max(judge,0.4)
        SOC_sb(i)=SOC(i);
        time3(i)=timehome(i);           %���Һ���Ҫ��磬��翪ʼʱ��Ϊ����ʱ��
        time4(i)=time3(i)+(1-SOC(i))*Cbattery/Pcharge;     %������ʱ�䣬��繦��4KW
        SOC(i)=SOC_end;                              %�ڶ���8��ǰ���Գ�����
        battery(i)=Cbattery*SOC(i);
    end
end


time=0:0.1:48;
Ycharge=zeros(1,481);
roundn(time1,-1);
roundn(time2,-1);
roundn(time3,-1);
roundn(time4,-1);

 for i=1:Ntest
     if (time2(i)-time1(i)~=0)
         kstart=round(10*time1(i)+1);
         kend=round(10*time2(i)+1);
        Ycharge(1,kstart:kend)=Ycharge(1,kstart:kend)+1;
     end
     if (time4(i)-time3(i)~=0)
         kstart=round(10*time3(i)+1);
         kend=round(10*time4(i)+1);
        Ycharge(1,kstart:kend)=Ycharge(1,kstart:kend)+1;
     end
 end
 temp=Ycharge(1:241)+Ycharge(241:481);
 x=0:0.1:24;
 xx=0:0.05:24;
 tempp = interp1(x,temp,xx,'linear');
 Pwuxu=tempp(1:5:481)*Pbiao;
%=========================================================================
%ԭ������������
 bsload=1.5*xlsread('baseload',1,'B2:CT2');
 Swuxu=bsload+Pwuxu;
 xt=0:0.25:24;
 plot(xt,bsload,xt,Swuxu);
 %plot(xt,Pwuxu);
 legend('����ԭ����','���������縺�ɺ�');
 xlabel('ʱ��/h');
 ylabel('����/kW');
 
   %=========================================================================
 %��������ģ��
 
 %��ʱ��۸�ֵ
 price=zeros(1,96);
 for j=1:33-1
     price(j)=0.365;%�ȵ��0.365Ԫ/kWh 
 end
 for j=33:4*8+1-1
     price(j)=0.869;%����   Ԫ/kWh 
 end
  for j=4*8+1:4*17+1-1
     price(j)=0.687;%ƽ���   Ԫ/kWh 
  end
  for j=4*17+1:4*21+1-1
     price(j)=0.869;%����   Ԫ/kWh 
  end
 for j=4*21+1:4*24+1-1
     price(j)=0.687;%ƽ���   Ԫ/kWh 
 end
 
 deltaT=15/60;%15min�����Сʱ
 cost=0;%������
 
 S=zeros(Ntest,96);
 %��翪ʼʱ�������96����ʽ
 J1=zeros(1,Ntest);
 J2=zeros(1,Ntest);
 J3=zeros(1,Ntest);
 J4=zeros(1,Ntest);
 for temp=1:Ntest
    J1(temp) =round(4*time1(temp)+1);
    J2(temp) =round(4*time2(temp)+1);
    J3(temp) =round(4*time3(temp)+1);
    J4(temp) =round(4*time4(temp)+1);
 end
 
 %�Ƿ����¼���� 1��ʾ���
 yesfirst=zeros(1,Ntest);
 yessec=zeros(1,Ntest);
%S��ij������ֵ Ҳ�����������ֵ 
 for i=1:Ntest
    %���ﵥλ��ĳ�����
   if(J2(i)-J1(i)~=0)
       yesfirst(1,i)=1;
       jstart=J1(i);
       jend=J2(i);
       for temp=jstart:jend
           S(i,temp)=1;
       end
   end
   %�°�������
     if(J4(i)-J3(i)~=0)
       yessec(1,i)=1;
       jstart=J3(i);
       jend=J4(i);
       for temp=jstart:jend
           S(i,temp)=1;
       end
     end
 end
 
 P_mft=5087;%���������5087kW
 cost_wuxu=0;
 for i=1:Ntest
     for j=1:96
         cost_wuxu=cost_wuxu+Pbiao*S(i,j)*deltaT*price(j);
     end
 end
 
 T1=round(timework*4+1);
 T2=round(timerest*4+1);
 
 T3=round(timehome*4+1);
 
 S_yx=zeros(Ntest,96);
  %SS=S; 
 
  lambda=0.1*ones(1,96);%�������ճ��ӳ�ֵ
  v=1;
  obj=10000000000000000;%��ֵ�㹻��
  jingdu=0.1;
  a=1;
  b=0.1;
  die=100;
  
  while((v<4)&&(die>jingdu))
      
    L=zeros(1,Ntest);
    x=zeros(1,96); 
    SS=zeros(Ntest,96);
    %ִ�����ܳ�絥Ԫ
    run('ZN.m');  
    myk=1/(a+b*v);
    temp=5087*ones(1,96);
    mybsload=bsload(1,1:96);
    myh=mybsload+Pcharge*sum(S_yx)-temp;
    Tlambda=lambda;
     lambda=lambda+myk*myh/norm(myh);
    die=norm(lambda-Tlambda,2)/norm(Tlambda);
     v=v+1;
  end
  
  PSS=zeros(1,97);
  PSS(1,1:96)=sum(SS)*Pbiao;
  PSS(1,97)=PSS(1,1);
  
  Syouxu=bsload+PSS;
   xt=0:0.25:24;
  plot(xt,bsload,xt,Swuxu,'r:',xt,Syouxu,'g');
  legend('����ԭ����','���������縺�ɺ�','���������縺�ɺ�');
  xlabel('ʱ��/h');
  ylabel('����/kW');
  

  
 
  
  
  
  

 
 
 
 
 
 
 
 
 


 
 
 











