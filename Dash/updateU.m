function Unew = updateU(newX, Sold, Vold, K_cp)
%UPDATEU 이 함수의 요약 설명 위치
%   자세한 설명 위치

K = numel(newX);
Unew = cell(K, 1);
R = size(Vold, 2);

for k=1:K_cp
    if ~isempty(newX{k})
        if k <= size(Sold, 1)
            if prod(size(Sold{k})) == 0
                Sold{k} = diag(randn(R,1));
            end
            Unew{k} = (newX{k} * Vold * Sold{k}) / (Sold{k}*Vold'*Vold*Sold{k});
        else
            Srand = diag(randn(R,1));
            Unew{k} = (newX{k} * Vold * Srand) / (Srand*Vold'*Vold*Srand);
        end
    end
end


end

