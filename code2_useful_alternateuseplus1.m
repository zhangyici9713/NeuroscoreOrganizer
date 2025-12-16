clear
close all
data_path='C:\Users\DELL\Desktop\24hour-ChenLab\20250801-WT-bsl-ChenLab'; %数据存放位置，数据分区以文件夹形式存放，每个文件夹为一个区，每个文件夹中的文档为物质文档，文档中记录KEGG编号及映射名称
b=xlsread('C:\Users\DELL\Desktop\EEG code\sleep1.xlsx');
filedir=dir(data_path);
filenames = {filedir.name};
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
        
        mark=strfind(sub1dir(q).name,'Rodent Sleep Statistics Report (whole');     %文件夹名称
        if ~isempty(mark)
            filename=fullfile( subdirpath, sub1dir(q).name);
            [name,txt,raw]= xlsread(filename);
            wake(:,cnt)=raw(b(:,1),7);
            microarousal(:,cnt)=raw(b(:,1),10);
            REM(:,cnt)=raw(b(:,1),12);
            NREM(:,cnt)=raw(b(:,1),15);%提取数据
            cnt=cnt+1;
            
        end
    end
end
 xlswrite([data_path,'\wake.xls'],wake);
 xlswrite([data_path,'\microarousal.xls'],microarousal);
 xlswrite([data_path,'\aREM.xls'],REM);
 xlswrite([data_path,'\NREM.xls'],NREM);
