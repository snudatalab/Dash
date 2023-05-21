% This code is implemented by 
%Ekta Gujral, Georgios Theocharous and Vagelis Papalexakis - University of
%California,Riverside,CA.Computer Science (2019-2020) for the following paper
% "SPADE:Streaming PARAFAC2 DEcompistion for Sparse Datasets",
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:
% X: Tensor or sptensor. [I x J x K]
% ratio: initial batch ratio [0-0.5]
% OUTPUT
% Xold: Initial tensor data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Xold,dimsX,initialBatch,streamingBatch,idx]=getDataforStreaming(X,I_initial)
    J=size(X{1},2);K=size(X,2);
    dimsX = [[], J, K]; 
    initialBatch = size(find(I_initial > 0), 1);
    streamingBatch = dimsX(end)-initialBatch;

    idx = repmat({':'}, 1, length(dimsX));
    idx(end) = {1:initialBatch};
    Xold = X(idx{:});
    for k=1:size(Xold, 2)
        Xold{k} = Xold{k}(1:I_initial(k),:);
    end
    

end
