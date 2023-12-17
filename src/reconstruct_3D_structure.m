function [X, desc_X, P2, inlier_matches] = reconstruct_3D_structure(x1s, x2s, d1s, d2s, K, P1, threshold)

assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(size(x1s, 2)==size(d1s, 2), "Length of x1s and d1s must be equal");
assert(size(x2s, 2)==size(d2s, 2), "Length of x2s and d2s must be equal");
assert(threshold>0, "Threshold must be positive!");
assert(isequal(size(P1), [3,4]), "Size of P1 must be [3,4]!");
assert(isequal(size(K), [3,3]), "Size of K must be [3,3]!");

if (size(x1s, 1)==2)
    x1s = [x1s; ones(1, size(x1s, 2))];
end
if (size(x2s, 1)==2)
    x2s = [x2s; ones(1, size(x2s, 2))];
end
x1s = project_to_flat_representation(x1s);
x2s = project_to_flat_representation(x2s);

[matches, ~] = vl_ubcmatch(d1s, d2s);
x1s_matches = x1s(:, matches(1,:));
x2s_matches = x2s(:, matches(2,:));

[Eapprox, inliers] = estimate_E_robust(K, x1s_matches, x2s_matches, threshold, 1);
E = apply_essential_matrix_constraints(Eapprox);

desc_X = d1s(:, matches(1,inliers));

inlier_matches = [(1:length(x1s)); zeros(1, length(x1s))];
inlier_matches(2, matches(1,inliers)) = matches(2,inliers);
inlier_matches = inlier_matches(:, inlier_matches(2,:)>0);

x1s_inlier_matches = x1s(:, inlier_matches(1,:));
x2s_inlier_matches = x2s(:, inlier_matches(2,:));
x1s_inlier_matches_normal = K \ x1s_inlier_matches;
x2s_inlier_matches_normal = K \ x2s_inlier_matches;
P1_normal = K \ P1;
[P2_normal, X] = get_valid_P(P1_normal, E, x1s_inlier_matches_normal, x2s_inlier_matches_normal);
P2 = K * P2_normal;

end

