 %�綯�����������ܳ�絥Ԫ
 %ȷ�� �������ճ��Ӻ󣬼������SS��L��i��
 SS=zeros(1,96);
 L=zeros(1,Ntest);
 %CO=zeros(1,Ntest);
 for i=1:Ntest
  %=========================================================================
   if (yesfirst(1,i)+yessec(1,i)==0)%�������
       SS(i,1:96)=0;
       x(1,1:96)=0;
      L(1,i)=myfen(x,Pbiao,price, lambda,bsload,P_mft,Ntest);
  %========================================================================= 
   elseif(yessec(1,i)==0)%��һ�γ�磬�ڶ��β����
    hh= ceil(((SOC_end-SOC_sa(1,i))*Cbattery/Pcharge*4+1));%������
    x=zeros(1,96);
    y=1000000;
    for te=T1(1,i):T2(1,i)-hh
        x(1,1:te-1)=0;
        x(1,te:te+hh)=1;
        x(1,te+hh+1:96)=0;
        hanshu=myfen(x,Pbiao,price, lambda,bsload,P_mft,Ntest);
        if(hanshu<y)
            y=hanshu;
            SS(i,:)=x;
        end
    end
    L(1,i)=y;
%=========================================================================    
   elseif(yesfirst(1,i)==0)%��һ�β���磬�ڶ��γ��
     hh= ceil(((SOC_end-SOC_sb(1,i))*Cbattery/Pcharge*4+1));%������
     xt=zeros(1,192);
     x=zeros(1,96);
     y=100000000000;
   for te=T3(1,i):32*4+1-hh
        xt(1,1:te-1)=0;
        xt(1,te:te+hh)=1;
        xt(1,te+hh+1:192)=0;
        
        x=xt(1,1:96)+xt(1,97:192);
        hanshu=myfen(x,Pbiao,price, lambda,bsload,P_mft,Ntest);
        if(hanshu<y)
            y=hanshu;
            myte=te;
            SS(i,:)=x;
        end
   end
    L(1,i)=y;
   %=========================================================================  
   else %���ξ����
   %��һ�����
   hh= ceil(((SOC_end-SOC_sa(1,i))*Cbattery/Pcharge*4+1));%������
   xa=zeros(1,96);
    y=1000000;
    for te=T1(1,i):T2(1,i)-hh
        xa(1,1:te-1)=0;  
        xa(1,te:te+hh)=1;
        xa(1,te+hh+1:96)=0;
        hanshu=myfen(xa,Pbiao,price, lambda,bsload,P_mft,Ntest);
        if(hanshu<y)
            y=hanshu;
            xa_jl=xa;
        end
    end
    %�ڶ������
    hh= ceil(((SOC_end-SOC_sb(1,i))*Cbattery/Pcharge*4+1));%������
     xt=zeros(1,192);
    % x=zeros(1,96);
     y=1000000;
   for te=T3(1,i):32*4+1-hh
        xt(1,1:te-1)=0;
        xt(1,te:te+hh)=1;
        xt(1,te+hh+1:192)=0;
        
        x=xt(1,1:96)+xt(1,97:192);
        hanshu=myfen(x,Pbiao,price, lambda,bsload,P_mft,Ntest);
        if(hanshu<y)
            y=hanshu;
            xb_ju=x;
        end
   end
   x=xa_jl+xb_ju;
   L(1,i)=myfen(x,Pbiao,price, lambda,bsload,P_mft,Ntest);
   SS(i,:)=x; 
   end
 end
 