function [Vnew, PVnew, QVnew] = updateV(newX, Unew, Sold, PVold, QVold, lambda)
    
    K = numel(newX);
    PVtmp = cell(K,1);
    QVtmp = cell(K,1);
    for k=1:K
        if prod(size(newX{k})) == 0
           continue 
        end
        PVtmp{k} = newX{k}' * Unew{k} * Sold{k};
        QVtmp{k} = Sold{k}*Unew{k}' * Unew{k} * Sold{k};
    end
    PVnew = lambda*PVold + sum(cat(3,PVtmp{:}), 3);
    QVnew = lambda*QVold + sum(cat(3,QVtmp{:}), 3);
    

    Vnew = PVnew / QVnew;


end

