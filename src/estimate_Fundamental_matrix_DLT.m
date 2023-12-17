function [F, min_singular_val, norm_Mv] = estimate_Fundamental_matrix_DLT(x1s, x2s)

assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(isequal(size(x1s), size(x2s)), "Size of x1s and x2s must be equal!");

if (size(x1s, 1)==2)
    x1s = [x1s; ones(1, size(x1s, 2))];
end
if (size(x2s, 1)==2)
    x2s = [x2s; ones(1, size(x2s, 2))];
end
x1s = project_to_flat_representation(x1s);
x2s = project_to_flat_representation(x2s);

M = zeros(length(x1s), 9);

for i=1:length(x1s)
    xx = x2s(:,i)*x1s(:,i)';
    M(i,:) = xx(:)';
end
    [~,S,V] = svd(M);
    min_singular_val = S(min(9, length(x1s)), min(9, length(x1s)));
    F = V(:,end);
    norm_Mv = norm(M*F);
    F = reshape(F, [3,3]);
end

