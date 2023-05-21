function [Snew, PSnew, QSnew] = updateS(newX, Unew, Vnew, PSold, QSold, Sold, lambda)
    K = numel(newX);
    PSnew = cell(K,1);
    QSnew = cell(K,1);
    Snew = cell(K,1);
    R = size(Vnew, 2);
    for k=1:K
       if k > size(PSold, 1)
          if prod(size(newX{k})) == 0
            continue
          end
          PSnew{k} =  Unew{k}'* newX{k};
          QSnew{k} = (Unew{k}'*Unew{k});
           PStmp = zeros(1,R);
           for r=1:R
               PStmp(1,r) = PSnew{k}(r,:) * Vnew(:,r);
           end          
          Snew{k} = diag(PStmp /(Vnew'*Vnew .* QSnew{k}));      
       else
           if prod(size(newX{k})) == 0 
              Snew{k} = Sold{k};
              PSnew{k} = PSold{k};
              QSnew{k} = QSold{k};
              continue
            elseif prod(size(PSold{k})) == 0
              PSnew{k} =  Unew{k}'* newX{k};
              QSnew{k} = (Unew{k}'*Unew{k});
               PStmp = zeros(1,R);
               for r=1:R
                   PStmp(1,r) = PSnew{k}(r,:) * Vnew(:,r);
               end          
              Snew{k} = diag(PStmp /(Vnew'*Vnew .* QSnew{k}));      
              continue
            end
          PSnew{k} = lambda*PSold{k}+Unew{k}'*newX{k};
          QSnew{k} = (lambda*QSold{k} + (Unew{k}'*Unew{k}));  
           PStmp = zeros(1,R);
           for r=1:R
               PStmp(1,r) = PSnew{k}(r,:) * Vnew(:,r);
           end       
          Snew{k} = diag(PStmp /(Vnew'*Vnew .*QSnew{k}));               
       end
       
    end


end

