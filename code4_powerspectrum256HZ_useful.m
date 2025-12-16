clear
close all
data_path='C:\data\zyc\20250730-fad-guanfacine ip small dose';        %数据存放位置，数据分区以文件夹形式存放，每个文件夹为一个区，每个文件夹中的文档为物质文档，文档中记录KEGG编号及映射名称
filedir=dir(data_path);
for i = 1 : length( filedir )
    if( isequal( filedir( i ).name, '.' )||...%文件名为.(系统的）
            isequal( filedir( i ).name, '..')||...%或者文件名为..
            ~filedir( i ).isdir)%或者文件不是一个文件夹
        continue;
    end
    subdirpath = fullfile( data_path, filedir( i ).name);     %文件夹名称
    sub1dir=dir( subdirpath );                                                 %文件夹中文件名称
    for q=1:length(sub1dir)
        if( isequal( sub1dir(q).name, '.' )||...
                isequal( sub1dir(q).name, '..'))
            continue;
        end
          mark=strfind(sub1dir(q).name,'periods');     %文件夹名称
          if ~isempty(mark) 
           filename=fullfile( subdirpath, sub1dir(q).name);
            [name,txt,raw]= xlsread(filename);%初始值为0,1代表从第二行开始读
          
          for j=1:24 
              periodshour=raw((j-1)*720+1:j*720,:);%每720行提取出来
              
              xwake=find(strcmp(periodshour(:,2),'W'));%把wake的行数找出来
              xnrem=find(strcmp(periodshour(:,2),'S'));
              xrem=find(strcmp(periodshour(:,2),'P'));
              xmicroarousal=find(strcmp(periodshour(:,2),'M'));
              
              boutwake(j)=length(xwake);
              boutnrem(j)=length(xnrem);
              boutrem(j)=length(xrem);
              boutmicroarousal(j)=length(xmicroarousal);
              
              wake=periodshour(xwake,1:259); %把wake的行数提出来  wake=periodshour(xwake,1:515)
              y1=find(cell2mat(wake(1:(size(wake,1)),3))<2);%删选wake阶段delta波比值小的
              wake1=wake(y1,4:259);  %  wake1=wake(y1,4:515);
%               [m,n]=find(isnan(wake1)==1);
%               wake1(m,:)=[];
              wake2=cell2mat(wake1);
              pwake(j,1:256)=sum(wake2); %1:512

              nrem=periodshour(xnrem,1:259);%把nrem的行数提出来  %515
              y2=find(cell2mat(nrem(1:(size(nrem,1)),3))<5);
              nrem1=nrem(y2,4:259); %515
%               [m,n]=find(isnan(nrem1)==1);
%               wake1(m,:)=[];
              nrem2=cell2mat(nrem1);%把nrem的频率提出来
              pnrem(j,1:256)=sum(nrem2); %512

              rem=periodshour(xrem,1:259);%把rem的行数提出来  
              y3=find(cell2mat(rem(1:(size(rem,1)),3))<1.9);
              rem1=rem(y3,4:259); %515
%               [m,n]=find(isnan(rem1)==1);
%               rem1(m,:)=[];
              rem2=cell2mat(rem1);%把rem的频率提出来
              prem(j,1:1:256)=sum(rem2);%512

              microarousal=periodshour(xmicroarousal,1:259);%把microarousal的行数提出来 %515
              y4=find(cell2mat(microarousal(1:(size(microarousal,1)),3))<2);
              microarousal1=microarousal(y4,4:259); 
%               [m,n]=find(isnan(microarousal1)==1);
%               microarousal1(m,:)=[];
              microarousal2=cell2mat(microarousal1);%把microarousal的频率提出来
              pmicroarousal(j,1:1:256)=sum(microarousal2); %512

              j=j+1;
          end        
        boutwake2=boutwake';
        boutnrem2=boutnrem';
        boutrem2=boutrem';
        boutmicroarousal2=boutmicroarousal';
        
        powerspectrumwake=[boutwake2,pwake];
        powerspectrumnrem=[boutnrem2,pnrem];
        powerspectrumrem=[boutrem2,prem];
        powerspectrummicroarousal=[boutmicroarousal2,pmicroarousal];
        
        cd(subdirpath);
        csvwrite('powerspectrumwake.csv',powerspectrumwake);%excel最大256列
        csvwrite('powerspectrumnrem.csv',powerspectrumnrem);
        csvwrite('powerspectrumrem.csv',powerspectrumrem);
        csvwrite('powerspectrummicroarousal.csv',powerspectrummicroarousal); 
     end 
   end
end