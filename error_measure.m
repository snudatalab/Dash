function [fit]=error_measure(X,U,V,S,K)
  
    fit = 0;
   fitK = zeros(K,1);
   for k = 1:K
       if prod(size(X{k})) == 0
            continue
       end
     M= (U{k})*(S{k})*V';     

    M_diff = abs(X{k} - M);
    fitK(k) = mean(M_diff,'all');

   end
   fit = mean(fitK);
   
end
