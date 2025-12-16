clear
close all
data_path='C:\Users\DELL\Desktop\24hour-ChenLab\20250803-WT-S3-ChenLab'; %数据存放位置，数据分区以文件夹形式存放，每个文件夹为一个区，每个文件夹中的文档为物质文档，文档中记录KEGG编号及映射名称
filedir=dir(data_path);
filenames = {filedir.name};
cnt=1;
for i = 1 : length( filedir )
%     if( isequal( filedir( i ).name, '.' )||...%文件名为.(系统的）
%             isequal( filedir( i ).name, '..')||...%或者文件名为..
%             ~filedir( i ).isdir)%或者文件不是一个文件夹
%         continue;
%     end
        mark1=strfind(filedir(i).name,'wake');
        if ~isempty(mark1)
            filename=fullfile( data_path, filedir(i).name);
            [name,txt,raw1]= xlsread(filename);
            a1=cell2mat(raw1((1:2:47),:));
            b1=cell2mat(raw1((2:2:48),:));
            c1=a1+b1;
            d1=c1/60;
        end
        mark2=strfind(filedir(i).name,'aREM');
        if ~isempty(mark2)
            filename=fullfile( data_path, filedir(i).name);
            [name,txt,raw2]= xlsread(filename);
            a2=cell2mat(raw2((1:2:47),:));
            b2=cell2mat(raw2((2:2:48),:));
            c2=a2+b2;
            d2=c2/60;
        end
        mark3=strfind(filedir(i).name,'NREM');
        if ~isempty(mark3)
            filename=fullfile(data_path, filedir(i).name);
            [name,txt,raw3]= xlsread(filename);
            a3=cell2mat(raw3((1:2:47),:));
            b3=cell2mat(raw3((2:2:48),:));
            c3=a3+b3;
            d3=c3/60;
        end
         mark4=strfind(filedir(i).name,'microarousal');
         if ~isempty(mark4)
            filename=fullfile( data_path, filedir(i).name);
            [name,txt,raw4]= xlsread(filename);
            a4=cell2mat(raw4((1:2:47),:));
            b4=cell2mat(raw4((2:2:48),:));
            c4=a4+b4;
            d4=c4/60;
        end
    end

cd(data_path);
 xlswrite('sumwake.xls',d1);
 xlswrite('summicroarousal.xls',d4);
 xlswrite('sumREM.xls',d2);
 xlswrite('sumNREM.xls',d3);
