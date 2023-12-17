function [X, lambda1, lambda2] = calculate_inlier_triangulation(x1s, x2s, K, P1, P2, err_threshold_px)

assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(size(x2s,2)==size(x2s,2), "Length of x1s of x2s must be equal!");
assert(isequal(size(K), [3,3]), "Size of K must be [3,3]!");
assert(isequal(size(P1), [3,4]), "Size of P1 must be [3,4]!");
assert(isequal(size(P2), [3,4]), "Size of P2 must be [3,4]!");
assert(err_threshold_px>0, "err_threshold_px must be positive!");

if (size(x1s, 1)==2)
    x1s = [x1s; ones(1, size(x1s, 2))];
end
if (size(x2s, 1)==2)
    x2s = [x2s; ones(1, size(x2s, 2))];
end
x1s = project_to_flat_representation(x1s);
x2s = project_to_flat_representation(x2s);

x1s_normal = inv(K) * x1s;
x2s_normal = inv(K) * x2s;
P1_normal = inv(K) * P1;
P2_normal = inv(K) * P2;

E = find_Essential_matrix_from_P_matrices(P1_normal, P2_normal);

errors = sqrt((calculate_epipolar_errors(E, x1s_normal, x2s_normal).^2 + ...
               calculate_epipolar_errors(E', x2s_normal, x1s_normal).^2)/2);

normal_error_threshold = err_threshold_px / K(1, 1);

inliers = (errors<normal_error_threshold);

[X, lambda1, lambda2] = calculate_3D_point_from_DLT(P1_normal, P2_normal, x1s_normal(:, inliers), x2s_normal(:, inliers));

end

