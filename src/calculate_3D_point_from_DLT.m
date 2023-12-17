function [X, lambda1, lambda2] = calculate_3D_point_from_DLT(P1, P2, x1s, x2s)

assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(isequal(size(x1s), size(x2s)), "Size of x1s and x2s must be equal!");
assert(isequal(size(P1), [3,4]), "Size of P1 must be [3,4]!");
assert(isequal(size(P2), [3,4]), "Size of P2 must be [3,4]!");

if (size(x1s, 1)==2)
    x1s = [x1s; ones(1, size(x1s, 2))];
end
if (size(x2s, 1)==2)
    x2s = [x2s; ones(1, size(x2s, 2))];
end
x1s = project_to_flat_representation(x1s);
x2s = project_to_flat_representation(x2s);

N = size(x1s, 2);

X = zeros(4, N);
lambda1 = zeros(1, N);
lambda2 = zeros(1, N);

for i=1:N
    M = [P1, -x1s(:,i), zeros(3,1); ...
         P2, zeros(3,1), -x2s(:,i)];
    [~,~,V] = svd(M);
    sol = V(:,end);
    sol = sol / sol(4);
    X(:,i) = sol(1:4);
    lambda1(i) = sol(5);
    lambda2(i) = sol(6);
end
