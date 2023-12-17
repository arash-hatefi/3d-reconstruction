function [P, S, sol_norm] = estimate_camera_parameters_DLT(xs, Xs)

assert(size(xs,1)==2 | size(xs,1)==3, "Wrong xs shape!");
assert(size(Xs,1)==3 | size(Xs,1)==4, "Wrong Xs shape!");
assert(size(xs,2)==size(Xs,2), "Length of Xs and xs must be equal!");

if (size(xs, 1)==2)
    xs = [xs; ones(1, size(xs, 2))];
end
if (size(Xs, 1)==3)
    Xs = [Xs; ones(1, size(Xs, 2))];
end
xs = project_to_flat_representation(xs);
Xs = project_to_flat_representation(Xs);

n_points = size(xs, 2);

M = zeros(3*n_points, 12+n_points);

for i=1:n_points
    x_block = zeros(1, n_points);
    x_block(i) = xs(1, i);
    y_block = zeros(1, n_points);
    y_block(i) = xs(2, i);
    unity_block = zeros(1, n_points);
    unity_block(i) = 1;
    block_M = [Xs(:,i)', zeros(1,4), zeros(1,4), -x_block; ...
               zeros(1,4), Xs(:,i)', zeros(1,4), -y_block; ...
               zeros(1,4), zeros(1,4), Xs(:,i)', -unity_block];
    startRow = 3*(i-1)+1;
    M(startRow:startRow+2, :) = block_M;
end
    [~,S,V] = svd(M);
    sol = V(:,end);
    P = sol(1:12);
    if (mean(sol(13:end))<0)
        P = -P;
    end
    P = reshape(P, 4,3)';
    
    sol_norm = norm(M*sol);
end

