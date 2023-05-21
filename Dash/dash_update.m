function [Unew, Snew, Vnew, PVnew, QVnew, PSnew, QSnew] = dash_update(newX,PVold, QVold, PSold, QSold, Sold, Vold, K_cp, lambda)

    Unew = updateU(newX, Sold, Vold, K_cp);
    [Snew, PSnew, QSnew] = updateS(newX, Unew, Vold, PSold, QSold, Sold, lambda);        
    [Vnew, PVnew, QVnew] = updateV(newX, Unew, Snew, PVold, QVold, lambda);           
    
    
end

