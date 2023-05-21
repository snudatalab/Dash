%Ekta Gujral, Georgios Theocharous and Vagelis Papalexakis - University of
%California,Riverside,CA.Computer Science (2019-2020)
% "SPADE:Streaming PARAFAC2 DEcompistion for Sparse Datasets",
function  [ Bnew, Hnew,Cnew,Unew,Ls, Ms]=spade_update( X,F, Facs, Ls, Ms )
       PARFOR_FLAG=0;
        J=size(X{1},2); K=size(X,2);
        B = Facs{2}; 
        % random linear combinations of columns of the existing C matrix 
        C = rand(K,F);
        %[C] = getTemporalMatrix(Facs{3},K);
        
        H = Facs{1};
        if PARFOR_FLAG==1
        parfor k = 1:K
             Qk = H*diag(C(k,:))*(X{k}*B)';
             Pnew{k} = Qk'*psqrt(Qk*Qk');
%              YY(:,:,k) = Pnew{k}'*X{k};
             YY{k}=Pnew{k}'*X{k};
        end
        else
              for k = 1:K
             Qk = H*diag(C(k,:))*(X{k}*B)';
             Pnew{k} = Qk'*psqrt(Qk*Qk');
%              YY(:,:,k) = Pnew{k}'*X{k};
             YY{k}=Pnew{k}'*X{k};
        end
        end
    
   
%         YY=sptensor(YY);
        %% Update C matrix
      
        V{1}= H ; V{2}= B; V{3}= C;
        clearvars H B C Qk X
        for n=1:3;VtV(:,:,n) = V{n}'*V{n};end
        %% Update C matrix
        
        DD=mttkrp_for_parafac2(YY, K, V, 3, PARFOR_FLAG);
        Cnew =  DD / prod(VtV(:,:,[1 2]),3); % mttkrp(YY,V,3)
        V{3}= Cnew; VtV(:,:,3)= V{3}'*V{3};
        %% Update B matrix
        DD=mttkrp_for_parafac2(YY, K, V,2, PARFOR_FLAG);
        Ls{2}=(Ls{2} + DD ); %mttkrp(YY,V,2)
        Ms{2}=(Ms{2} + prod(VtV(:,:,[1 3]),3));
        Bnew = Ls{2} / Ms{2};
        V{2}= Bnew; VtV(:,:,2)= V{2}'*V{2}; 
        %% Update H matrix
        DD=mttkrp_for_parafac2(YY, K, V,1, PARFOR_FLAG);
        Ls{1}=(Ls{1} + DD ); %mttkrp(YY,V,1)
        Ms{1}=(Ms{1} + prod(VtV(:,:,[2 3]),3));     
        Hnew = Ls{1} / Ms{1};
         
        %% Update U matrix
        Unew=cell(1,K);
        for k=1:K
               Unew{k}=Pnew{k}*Hnew;
        end
  
end
 function X = psqrt(A,tol)

   % Produces A^(-.5) even if rank-problems

   [U,S,V] = svd(A,0);
   if min(size(S)) == 1
     S = S(1);
   else
     S = diag(S);
   end
   if (nargin == 1)
     tol = max(size(A)) * S(1) * eps;
   end
   r = sum(S > tol);
   if (r == 0)
     X = zeros(size(A'));
   else
     S = diag(ones(r,1)./sqrt(S(1:r)));
     X = V(:,1:r)*S*U(:,1:r)';
  end
  
end
