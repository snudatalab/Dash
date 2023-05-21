function [PVold, QVold, PSold, QSold, Uold, Sold, Vold] = dash_initial(X, R)

Maxiters = 10; 
Constraints = [0 0]; 
Options = [1e-6 Maxiters 2 0 0 1 0]; 

K = numel(X);

%% Use SPARTan for initialization
[H, Vold, Wold, Q,~, ~, ~]=parafac2_sparse_paper_version(X,R,Constraints,Options);
Uold =cell(K,1);
PVtmp = cell(K,1);
QVtmp = cell(K,1);
Sold = cell(K,1);
PSold = cell(K,1);
QSold = cell(K,1);

for k=1:K
        Sold{k} = diag(Wold(k,:));
        Uold{k}=Q{k}*H;
        XU = X{k}'*Uold{k};
        PVtmp{k} = XU*Sold{k};
        QVtmp{k} = Sold{k}*Uold{k}'*Uold{k}*Sold{k};
        
        PSold{k} = Uold{k}'*X{k};
        QSold{k} = (Uold{k}'*Uold{k});
end

PVold = sum(cat(3,PVtmp{:}), 3);
QVold = sum(cat(3,QVtmp{:}), 3);

clear PVtmp
clear QVtmp



end

