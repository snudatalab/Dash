%Ekta Gujral, Georgios Theocharous and Vagelis Papalexakis - University of
%California,Riverside,CA.Computer Science (2019-2020)

% "SPADE:StreamingPARAFAC2DEcompistion for Sparse Datasets",
% input:  Xold, data tensor used for initialization
%         initialFacs, a cell array contains the loading matrices of initX
%         R, tensor rank
% ouputs: Ls, Ms, cell arrays contain the complementary matrices

function [ Ls, Ms, As, Pold, Uold ] = spade_initial( Xold, R,PARFOR_FLAG)
% calculate the PARAFAC2 decomposition of the initial data
Options = [1e-6 10 2 0 0 1 PARFOR_FLAG]; % first argument is convergence criterion
[Hold,Bold,Cold,Pold,initiX, ~, ~]=parafac2_sparse_paper_version(Xold,R,[0 0],Options);
 K=size(Cold,1);
Uold=cell(1,K);
    initialFacs={Hold,Bold,Cold};
    for k=1:K
        Uold{k}=Pold{k}*Hold;
    end

As = initialFacs ;
dims = size(initiX);
 
N=3;
% for the first N-1 modes, calculte their assistant matrices L and M
Ls{1}=mttkrp_for_parafac2(initiX, dims(2), initialFacs,1, PARFOR_FLAG);
Ls{2}=mttkrp_for_parafac2(initiX, dims(2), initialFacs,2, PARFOR_FLAG);
%Ls = {mttkrp(initiX,initialFacs,1) ; mttkrp(initiX,initialFacs,2)}; 
for n=1:N
    VtV(:,:,n) = initialFacs{n}'*initialFacs{n}; 
end
Ms = {prod(VtV(:,:,[2:3]),3) ; prod(VtV(:,:,[1 3]),3) };
end



