function [err,res] = calculate_reprojection_error(P,U,u)

m = length(P);
n = length(U);

res = zeros(m*n, 1);

idx = 1;
for j=1:n
    for i=1:m
        Pi = P{i};
        ui = u{i};
        res(idx) = norm([ui(1,j)-(Pi(1,:)*U(:,j))/(Pi(3,:)*U(:,j)), ...
                         ui(2,j)-(Pi(2,:)*U(:,j))/(Pi(3,:)*U(:,j))]);
        idx = idx + 1;
    end
end

err = sum(res);

end

