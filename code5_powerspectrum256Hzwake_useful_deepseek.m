clear
close all
data_path='C:\data\zyc\20250730-fad-guanfacine ip small dose';
filedir=dir(data_path);

% 初始化结果矩�?
pwhole1 = []; plight1 = []; pdark1 = [];
pwhole2 = []; plight2 = []; pdark2 = [];
pwhole3 = []; plight3 = []; pdark3 = [];

% 处理WAKE数据
wake_files = {};
wake_cnt = 1;
for i = 1:length(filedir)
    if isequal(filedir(i).name, '.') || isequal(filedir(i).name, '..') || ~filedir(i).isdir
        continue;
    end
    
    subdirpath = fullfile(data_path, filedir(i).name);
    sub1dir = dir(subdirpath);
    
    for q = 1:length(sub1dir)
        if isequal(sub1dir(q).name, '.') || isequal(sub1dir(q).name, '..')
            continue;
        end
        
        if contains(sub1dir(q).name, 'powerspectrumwake.')
            filename = fullfile(subdirpath, sub1dir(q).name);
            wake_files{wake_cnt} = filename;
            wake_cnt = wake_cnt + 1;
            
            % 读取数据
            data = load(filename);
            
            % 处理全期数据 (24小时)
            whole_avg = zeros(24, 201);
            valid_whole_hours = 0;
            
            % 处理明期数据 (1-12小时)
            light_avg = zeros(12, 201);
            valid_light_hours = 0;
            
            % 处理暗期数据 (13-24小时)
            dark_avg = zeros(12, 201);
            valid_dark_hours = 0;
            
            for hour = 1:24
                bout_count = data(hour, 1);
                
                % 如果bout数为0，跳过该小时
                if bout_count == 0
                    continue;
                end
                
                % 提取功率谱数�?
                power_spectrum = data(hour, 2:202);
                
                % �?查数据是否有�?
                if any(isnan(power_spectrum)) || any(isinf(power_spectrum)) || all(power_spectrum == 0)
                    continue;
                end
                
                % 计算每个bout的平均功�?
                hourly_avg = power_spectrum / bout_count;
                
                % 添加到全期数�?
                whole_avg(hour, :) = hourly_avg;
                valid_whole_hours = valid_whole_hours + 1;
                
                % 添加到明期或暗期数据
                if hour <= 12
                    light_avg(hour, :) = hourly_avg;
                    valid_light_hours = valid_light_hours + 1;
                else
                    dark_avg(hour-12, :) = hourly_avg;
                    valid_dark_hours = valid_dark_hours + 1;
                end
            end
            
            % 计算全期平均�?
            if valid_whole_hours > 0
                pwhole1 = [pwhole1; sum(whole_avg, 1) / valid_whole_hours];
            else
                pwhole1 = [pwhole1; NaN(1, 201)];
            end
            
            % 计算明期平均�?
            if valid_light_hours > 0
                plight1 = [plight1; sum(light_avg, 1) / valid_light_hours];
            else
                plight1 = [plight1; NaN(1, 201)];
            end
            
            % 计算暗期平均�?
            if valid_dark_hours > 0
                pdark1 = [pdark1; sum(dark_avg, 1) / valid_dark_hours];
            else
                pdark1 = [pdark1; NaN(1, 201)];
            end
        end
    end
end

% 处理NREM数据
nrem_files = {};
nrem_cnt = 1;

% 预分配结果矩阵（假设�?多处�?100个文件）
max_files = 100;
pwhole2 = NaN(max_files, 201);
plight2 = NaN(max_files, 201);
pdark2 = NaN(max_files, 201);

for i = 1:length(filedir)
    if isequal(filedir(i).name, '.') || isequal(filedir(i).name, '..') || ~filedir(i).isdir
        continue;
    end
    
    subdirpath = fullfile(data_path, filedir(i).name);
    sub1dir = dir(subdirpath);
    
    for q = 1:length(sub1dir)
        if isequal(sub1dir(q).name, '.') || isequal(sub1dir(q).name, '..')
            continue;
        end
        
        if contains(sub1dir(q).name, 'powerspectrumnrem.')
            filename = fullfile(subdirpath, sub1dir(q).name);
            nrem_files{nrem_cnt} = filename;
            
            % 读取并验证数�?
            try
                data = load(filename);
                
                % 验证数据维度
                if size(data, 1) ~= 24 || size(data, 2) < 202
                    fprintf('File %s has invalid dimensions: %dx%d\n', filename, size(data, 1), size(data, 2));
                    continue;
                end
                
                % 初始化有效数据收集器
                valid_whole_data = [];
                valid_light_data = [];
                valid_dark_data = [];
                
                % 处理每个小时的数�?
                for hour = 1:24
                    bout_count = data(hour, 1);
                    
                    % 如果bout数为0或无效，跳过该小�?
                    if bout_count <= 0 || isnan(bout_count) || isinf(bout_count)
                        fprintf('Skipping hour %d in file %s: invalid bout count (%f)\n', hour, filename, bout_count);
                        continue;
                    end
                    
                    % 提取功率谱数�?
                    power_spectrum = data(hour, 2:202);
                    
                    % �?查数据是否有�?
                    if any(isnan(power_spectrum)) || any(isinf(power_spectrum))
                        fprintf('Skipping hour %d in file %s: invalid power values\n', hour, filename);
                        continue;
                    end
                    
                    if all(power_spectrum == 0)
                        fprintf('Skipping hour %d in file %s: all power values are 0\n', hour, filename);
                        continue;
                    end
                    
                    % 计算每个bout的平均功�?
                    hourly_avg = power_spectrum / bout_count;
                    
                    % �?查计算结果是否合�?
                    if any(isnan(hourly_avg)) || any(isinf(hourly_avg)) || max(hourly_avg) > 1e-3
                        fprintf('Skipping hour %d in file %s: unreasonable calculated values (max: %e)\n', hour, filename, max(hourly_avg));
                        continue;
                    end
                    
                    % 添加到全期数�?
                    if isempty(valid_whole_data)
                        valid_whole_data = hourly_avg;
                    else
                        valid_whole_data = [valid_whole_data; hourly_avg];
                    end
                    
                    % 添加到明期或暗期数据
                    if hour <= 12
                        if isempty(valid_light_data)
                            valid_light_data = hourly_avg;
                        else
                            valid_light_data = [valid_light_data; hourly_avg];
                        end
                    else
                        if isempty(valid_dark_data)
                            valid_dark_data = hourly_avg;
                        else
                            valid_dark_data = [valid_dark_data; hourly_avg];
                        end
                    end
                end
                
                % 计算全期平均�?
                if ~isempty(valid_whole_data) && size(valid_whole_data, 1) > 0
                    pwhole2(nrem_cnt, :) = mean(valid_whole_data, 1);
                    fprintf('File %s: %d valid whole hours, max value: %e\n', filename, size(valid_whole_data, 1), max(pwhole2(nrem_cnt, :)));
                else
                    pwhole2(nrem_cnt, :) = NaN(1, 201);
                    fprintf('File %s: NO valid whole hours\n', filename);
                end
                
                % 计算明期平均�?
                if ~isempty(valid_light_data) && size(valid_light_data, 1) > 0
                    plight2(nrem_cnt, :) = mean(valid_light_data, 1);
                else
                    plight2(nrem_cnt, :) = NaN(1, 201);
                end
                
                % 计算暗期平均�?
                if ~isempty(valid_dark_data) && size(valid_dark_data, 1) > 0
                    pdark2(nrem_cnt, :) = mean(valid_dark_data, 1);
                else
                    pdark2(nrem_cnt, :) = NaN(1, 201);
                end
                
                nrem_cnt = nrem_cnt + 1;
                
            catch ME
                fprintf('Error processing file %s: %s\n', filename, ME.message);
                continue;
            end
        end
    end
end

% 裁剪结果矩阵到实际大�?
pwhole2 = pwhole2(1:nrem_cnt-1, :);
plight2 = plight2(1:nrem_cnt-1, :);
pdark2 = pdark2(1:nrem_cnt-1, :);

% 处理REM数据
rem_files = {};
rem_cnt = 1;
for i = 1:length(filedir)
    if isequal(filedir(i).name, '.') || isequal(filedir(i).name, '..') || ~filedir(i).isdir
        continue;
    end
    
    subdirpath = fullfile(data_path, filedir(i).name);
    sub1dir = dir(subdirpath);
    
    for q = 1:length(sub1dir)
        if isequal(sub1dir(q).name, '.') || isequal(sub1dir(q).name, '..')
            continue;
        end
        
        if contains(sub1dir(q).name, 'powerspectrumrem.')
            filename = fullfile(subdirpath, sub1dir(q).name);
            rem_files{rem_cnt} = filename;
            rem_cnt = rem_cnt + 1;
            
            % 读取数据
            data = load(filename);
            
            % 处理全期数据 (24小时)
            whole_avg = zeros(24, 201);
            valid_whole_hours = 0;
            
            % 处理明期数据 (1-12小时)
            light_avg = zeros(12, 201);
            valid_light_hours = 0;
            
            % 处理暗期数据 (13-24小时)
            dark_avg = zeros(12, 201);
            valid_dark_hours = 0;
            
            for hour = 1:24
                bout_count = data(hour, 1);
                
                % 如果bout数小�?4，跳过该小时
                if bout_count < 4
                    continue;
                end
                
                % 提取功率谱数�?
                power_spectrum = data(hour, 2:202);
                
                % �?查数据是否有�?
                if any(isnan(power_spectrum)) || any(isinf(power_spectrum)) || all(power_spectrum == 0)
                    continue;
                end
                
                % 计算每个bout的平均功�?
                hourly_avg = power_spectrum / bout_count;
                
                % 添加到全期数�?
                whole_avg(hour, :) = hourly_avg;
                valid_whole_hours = valid_whole_hours + 1;
                
                % 添加到明期或暗期数据
                if hour <= 12
                    light_avg(hour, :) = hourly_avg;
                    valid_light_hours = valid_light_hours + 1;
                else
                    dark_avg(hour-12, :) = hourly_avg;
                    valid_dark_hours = valid_dark_hours + 1;
                end
            end
            
            % 计算全期平均�?
            if valid_whole_hours > 0
                pwhole3 = [pwhole3; sum(whole_avg, 1) / valid_whole_hours];
            else
                pwhole3 = [pwhole3; NaN(1, 201)];
            end
            
            % 计算明期平均�?
            if valid_light_hours > 0
                plight3 = [plight3; sum(light_avg, 1) / valid_light_hours];
            else
                plight3 = [plight3; NaN(1, 201)];
            end
            
            % 计算暗期平均�?
            if valid_dark_hours > 0
                pdark3 = [pdark3; sum(dark_avg, 1) / valid_dark_hours];
            else
                pdark3 = [pdark3; NaN(1, 201)];
            end
        end
    end
end

% 保存结果
cd(data_path);
csvwrite('pwake.csv', pwhole1);
csvwrite('pwakelight.csv', plight1);
csvwrite('pwakedark.csv', pdark1);
csvwrite('pnrem.csv', pwhole2);
csvwrite('pnremlight.csv', plight2);
csvwrite('pnremdark.csv', pdark2);
csvwrite('prem.csv', pwhole3);
csvwrite('premlight.csv', plight3);
csvwrite('premdark.csv', pdark3);

% 显示处理的文件数量和信息
fprintf('Processed %d WAKE files\n', length(wake_files));
fprintf('Processed %d NREM files\n', length(nrem_files));
fprintf('Processed %d REM files\n', length(rem_files));
fprintf('Result sizes: WAKE %dx%d, WAKE-light %dx%d, WAKE-dark %dx%d\n', ...
    size(pwhole1, 1), size(pwhole1, 2), ...
    size(plight1, 1), size(plight1, 2), ...
    size(pdark1, 1), size(pdark1, 2));
fprintf('Result sizes: NREM %dx%d, NREM-light %dx%d, NREM-dark %dx%d\n', ...
    size(pwhole2, 1), size(pwhole2, 2), ...
    size(plight2, 1), size(plight2, 2), ...
    size(pdark2, 1), size(pdark2, 2));
fprintf('Result sizes: REM %dx%d, REM-light %dx%d, REM-dark %dx%d\n', ...
    size(pwhole3, 1), size(pwhole3, 2), ...
    size(plight3, 1), size(plight3, 2), ...
    size(pdark3, 1), size(pdark3, 2));