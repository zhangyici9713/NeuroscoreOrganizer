clear
close all
data_path='C:\data\zyc\20250730-fad-guanfacine ip small dose';        %数据存放位置，数据分区以文件夹形式存放，每个文件夹为一个区，每个文件夹中的文档为物质文档，文档中记录KEGG编号及映射名称
filedir=dir(data_path);
cnt=1;
for i = 1 : length( filedir )
    if( isequal( filedir( i ).name, '.' )||...%文件名为.(系统的）
            isequal( filedir( i ).name, '..')||...%或者文件名为..
            ~filedir( i ).isdir)%或者文件不是一个文件夹
        continue;
    end
    subdirpath = fullfile( data_path, filedir( i ).name);     %文件夹名称
    sub1dir= dir( subdirpath );                                                 %文件夹中文件名称
    for q=1:length(sub1dir)
        if( isequal( sub1dir(q).name, '.' )||...
                isequal( sub1dir(q).name, '..'))
            continue;
        end
          mark1=strfind(sub1dir(q).name,'powerspectrumwake.');     %文件夹名称
          if ~isempty(mark1) 
           filename1=fullfile( subdirpath, sub1dir(q).name);
           raw1=load(filename1);  
           powerwake=sum((raw1(1:24,2:201)),2);
          
           norm_delta1(1:24,cnt)=sum(raw1(1:24,3:9),2)./powerwake;%0.5-4Hz
           norm_theta1(1:24,cnt)=sum(raw1(1:24,10:17),2)./powerwake;%4-8Hz
           norm_alpha1(1:24,cnt)=sum(raw1(1:24,18:25),2)./powerwake;%8-12Hz
           norm_beta1(1:24,cnt)=sum(raw1(1:24,26:61),2)./powerwake;%12-30Hz
           norm_gamma1(1:24,cnt)=sum(raw1(1:24,62:201),2)./powerwake;
%            norm_lowgamma1(1:24,cnt)=sum(raw1(1:24,62:101),2)./powerwake;%30-50Hz
%            norm_highgamma1(1:24,cnt)=sum(raw1(1:24,102:201),2)./powerwake;%50-100Hz
%            d_t1=norm_delta1./norm_theta1;
%            d_b1=norm_delta1./norm_beta1;
%            d_lg1=norm_delta1./norm_lowgamma1;
           cnt=cnt+1;
          end
          
      end
end

cnt=1;
for i = 1 : length( filedir )
    if( isequal( filedir( i ).name, '.' )||...%文件名为.(系统的）
            isequal( filedir( i ).name, '..')||...%或者文件名为..
            ~filedir( i ).isdir)%或者文件不是一个文件夹
        continue;
    end
    subdirpath = fullfile( data_path, filedir( i ).name);     %文件夹名称
    sub1dir= dir( subdirpath );                                                 %文件夹中文件名称
    for q=1:length(sub1dir)
        if( isequal( sub1dir(q).name, '.' )||...
                isequal( sub1dir(q).name, '..'))
            continue;
        end
          mark2=strfind(sub1dir(q).name,'powerspectrumnrem.');     %文件夹名称
          if ~isempty(mark2) 
           filename2=fullfile( subdirpath, sub1dir(q).name);
          raw2=load(filename2); 
          powernrem=sum((raw2(1:24,2:201)),2);
         
        
          norm_delta2(1:24,cnt)=sum(raw2(1:24,3:9),2)./ powernrem;
           norm_theta2(1:24,cnt)=sum(raw2(1:24,10:17),2)./ powernrem;
           norm_alpha2(1:24,cnt)=sum(raw2(1:24,18:25),2)./ powernrem;
           norm_beta2(1:24,cnt)=sum(raw2(1:24,26:61),2)./ powernrem;
            norm_gamma2(1:24,cnt)=sum(raw2(1:24,62:201),2)./ powernrem;
%            norm_lowgamma2(1:24,cnt)=sum(raw2(1:24,62:81),2)./ powernrem;%30-40Hz
%            norm_highgamma2(1:24,cnt)=sum(raw2(1:24,82:161),2)./ powernrem;%40-80Hz
%            d_t2=norm_delta2./norm_theta2;
%            d_b2=norm_delta2./norm_beta2;
%            d_lg2=norm_delta2./norm_lowgamma2;
%           xb=repmat(bout2,[1,1025]);
%            
%             for ii=1:24
%               if xb(ii,1)==0
%                   raw22(ii,1:1025)=raw(ii,1025);
%               else           
%            raw22(ii,1:1025)=raw2(ii,1:1025)./xb;
%               end
%           end
%            
% %            [m,n]=find(isnan(raw22)==1);
% %            raw22(m,:)=[];         
% %            [a2,b2]=size(raw22);
%            
%            delta2(1:a2,cnt)=sum(raw22(1:a2,3:10),2);
%            theta2(1:a2,cnt)=sum(raw22(1:a2,11:18),2);
%            alpha2(1:a2,cnt)=sum(raw22(1:a2,19:26),2);
%            beta2(1:a2,cnt)=sum(raw22(1:a2,27:42),2);
           
%             delta2(1:24,cnt)=sum(raw2(1:24,3:10),2)./sum(raw2(1:24,2:202),2);
%            theta2(1:24,cnt)=sum(raw2(1:24,11:18),2)./sum(raw2(1:24,2:202),2);
%            alpha2(1:24,cnt)=sum(raw2(1:24,19:26),2)./sum(raw2(1:24,2:202),2);
%            beta2(1:24,cnt)=sum(raw2(1:24,27:42),2)./sum(raw2(1:24,2:202),2);
           cnt=cnt+1;
           end
      end
end

cnt=1;
for i = 1 : length( filedir )
    if( isequal( filedir( i ).name, '.' )||...%文件名为.(系统的）
            isequal( filedir( i ).name, '..')||...%或者文件名为..
            ~filedir( i ).isdir)%或者文件不是一个文件夹
        continue;
    end
    subdirpath = fullfile( data_path, filedir( i ).name);     %文件夹名称
    sub1dir= dir( subdirpath );                                                 %文件夹中文件名称
    for q=1:length(sub1dir)
        if( isequal( sub1dir(q).name, '.' )||...
                isequal( sub1dir(q).name, '..'))
            continue;
        end
          mark3=strfind(sub1dir(q).name,'powerspectrumrem.');     %文件夹名称
          if ~isempty(mark3) 
           filename3=fullfile( subdirpath, sub1dir(q).name);
           raw3=load(filename3);
           bout3=raw3(1:24,1);
           %删掉3个及以下bout的小时
           c=find(bout3<4);
           raw3(c,:)=0;
            %得到每个小时的平均功率谱
           powerrem=sum((raw3(1:24,2:201)),2);
           
           
           norm_delta3(1:24,cnt)=sum(raw3(1:24,3:9),2)./ powerrem;
           norm_theta3(1:24,cnt)=sum(raw3(1:24,10:17),2)./ powerrem;
           norm_alpha3(1:24,cnt)=sum(raw3(1:24,18:25),2)./ powerrem;
           norm_beta3(1:24,cnt)=sum(raw3(1:24,26:61),2)./ powerrem;
           norm_gamma3(1:24,cnt)=sum(raw3(1:24,62:201),2)./ powerrem;
%            norm_lowgamma3(1:24,cnt)=sum(raw3(1:24,62:81),2)./ powerrem;%30-40Hz
%            norm_highgamma3(1:24,cnt)=sum(raw3(1:24,82:161),2)./ powerrem;%40-80Hz
%            d_t3=norm_delta3./norm_theta3;
%            d_b3=norm_delta3./norm_beta3;
%            d_lg3=norm_delta3./norm_lowgamma3;
           cnt=cnt+1;
           end
      end
end

cd(data_path);

csvwrite('norm_pwakedelta.csv',norm_delta1);%excel最大256列
csvwrite('norm_pwaketheta.csv',norm_theta1);
csvwrite('norm_pwakealpha.csv',norm_alpha1);
csvwrite('norm_pwakebeta.csv',norm_beta1);
csvwrite('norm_pwakegamma.csv',norm_gamma1);
% csvwrite('norm_pwakelowgamma.csv',norm_lowgamma1);
% csvwrite('norm_pwakehighgamma.csv',norm_highgamma1);
% csvwrite('wakedelta_thetaratio.csv',d_t1);
% csvwrite('norm_wakedelta_betaratio.csv',d_b1);
% csvwrite('wakedelta_lowgammaratio.csv',d_lg1);


csvwrite('norm_pnremdelta.csv',norm_delta2);%excel最大256列
csvwrite('norm_pnremtheta.csv',norm_theta2);
csvwrite('norm_pnremalpha.csv',norm_alpha2);
csvwrite('norm_pnrembeta.csv',norm_beta2);
csvwrite('norm_pnremgamma.csv',norm_gamma2);
% csvwrite('norm_pnremlowgamma.csv',norm_lowgamma2);
% csvwrite('norm_pnremhighgamma.csv',norm_highgamma2);
% csvwrite('nremdelta_thetaratio.csv',d_t2);
% csvwrite('norm_nremdelta_betaratio.csv',d_b2);
% csvwrite('nremdelta_lowgammaratio.csv',d_lg2);


csvwrite('norm_premdelta.csv',norm_delta3);%excel最大256列
csvwrite('norm_premtheta.csv',norm_theta3);
csvwrite('norm_premalpha.csv',norm_alpha3);
csvwrite('norm_prembeta.csv',norm_beta3);
csvwrite('norm_premgamma.csv',norm_gamma3);
% csvwrite('norm_premlowgamma.csv',norm_lowgamma3);
% csvwrite('norm_premhighgamma.csv',norm_highgamma3);
% % csvwrite('remdelta_thetaratio.csv',d_t3);
% csvwrite('norm_remdelta_betaratio.csv',d_b3);
% csvwrite('remdelta_lowgammaratio.csv',d_lg3);
