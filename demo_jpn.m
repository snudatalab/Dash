clc;clear all;close all;
addpath(genpath('Dash'));
addpath(genpath('library'));
delete(gcp('nocreate'));
PARFOR_FLAG = 0;


%% Load Data
fname = './data/JPN/stock_date_kv_jpn.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);
time_indices = struct2cell(val);

 

filename = './data/JPN/jpn_stock1.mat';
X = load(filename).data;


K = size(X,2);
I = zeros(K, 1);
ratio=0.2;

for k=1:K
    time_indices{k} = time_indices{k} + 1;
end   

max_time_I = -1;
min_time_I = inf*ones(K,1);
for k=1:K
    tmp_max_time = max(time_indices{k});
    if max_time_I < tmp_max_time
        max_time_I = tmp_max_time;
    end
    min_time_I(k) = min(time_indices{k});
end

[val,ind] = sort(min_time_I);
X = X(ind);
time_indices = time_indices(ind);

%% End of Load Data


minibatchSize= 20;
num_iter = ceil((max_time_I*(1-ratio)/minibatchSize));

time_dash = zeros(num_iter,1);
fit_dash = zeros(num_iter,1);
fit_local_dash = zeros(num_iter,1);

I_initial = zeros(K,1);

current_time_ind = max_time_I - num_iter*minibatchSize+1;
for k=1:K
   I(k) = size(time_indices{k}, 1);
    I_initial(k) = size(find(time_indices{k} < (max_time_I - num_iter*minibatchSize) +1), 1);
end


K_cp = size(find(I_initial>0), 1);
I_initial = I_initial(find(I_initial>0),1);


I_cp = I_initial;

F = 10; %target rank 
lambda = 0.7; % forgetting factor

%% Initialization

[Xold, dimsX, initialBatch, streamingBatch, idx]=getDataforStreaming(X,I_initial);

%% Data Normalization
for k=1:size(Xold, 2)
   Xold{k} = normalize(Xold{k}, 1, 'range');
   if norm(Xold{k}, 'fro') == 0
        Xold{k} = Xold{k} +0.5;
   end
end

accumulated_tensor = Xold;

[PVold, QVold, PSold, QSold, Uold, Sold, Vold] = dash_initial(Xold, F);

%% New data arrive

for t=1:minibatchSize:num_iter*minibatchSize
    K_cp_old = K_cp;
    newX = cell(1,K_cp_old);
    endTime = min(current_time_ind+minibatchSize-1, max_time_I);
    idx = (endTime - minibatchSize+1):endTime;
    for k = 1:K
        [~,k_idx] = ismember(idx,time_indices{k});
        k_idx = k_idx(k_idx~=0);
        if numel(k_idx) ~= 0
            newX{k} = X{k}(k_idx,:);
            newX{k} = normalize(newX{k}, 1, 'range');
            if norm(newX{k}, 'fro') == 0
                newX{k} = newX{k} + 0.5;
            end
            if k <= K_cp_old
                accumulated_tensor{k} = cat(1, accumulated_tensor{k}, newX{k});    
            else
                accumulated_tensor{k} = newX{k};
            end
        end
    end    
    K_cp = size(accumulated_tensor, 2);
    st_dash=tic;
    %% update factor matrices for a newly arrived tensor
    [Unew, Snew, Vnew, PVold, QVold, PSold, QSold] = dash_update(newX, PVold, QVold, PSold, QSold, Sold, Vold, K_cp, lambda);
    Sold = Snew;
    Vold = Vnew;    
    
    for k = 1:K_cp
        [~,k_idx] = ismember(idx,time_indices{k});
        k_idx = k_idx(k_idx~=0);
        if numel(k_idx) ~= 0
            if k <= K_cp_old
                if prod(size(Uold{k}, 1)) == 0
                    Uold{k} = Unew{k};
                else
                    Uold{k} = cat(1, Uold{k}, Unew{k});
                end
            else 
                Uold{k} = Unew{k};
            end
        end
    end     
    time_dash(ceil(t/minibatchSize), 1)=toc(st_dash); 


   [fit_dash_iter]=error_measure(accumulated_tensor, Uold,Vnew, Snew, K_cp);
   fit_dash(ceil(t/minibatchSize), 1) = fit_dash_iter;
   [fit_local_dash_iter]=error_measure(newX, Unew,Vnew, Snew, K_cp);
   fit_local_dash(ceil(t/minibatchSize), 1) = fit_local_dash_iter;

    current_time_ind = current_time_ind+minibatchSize;
    fprintf('Running time in %dth update is %f \n', ceil(t/minibatchSize), time_dash(ceil(t/minibatchSize), 1));
    fprintf('Local error in %dth update is %f \n',ceil(t/minibatchSize),  fit_local_dash(ceil(t/minibatchSize),1));
    fprintf('Global error in %dth update is %f \n', ceil(t/minibatchSize), fit_dash(ceil(t/minibatchSize),1));
    fprintf('%dth update is done \n\n', ceil(t/minibatchSize));
end


writematrix(time_dash,'./result/jpn/time_dash.csv','Delimiter',',')
%
writematrix(fit_dash,'./result/jpn/fit_dash.csv','Delimiter',',')
%
writematrix(fit_local_dash,'./result/jpn/fit_local_dash.csv','Delimiter',',')


