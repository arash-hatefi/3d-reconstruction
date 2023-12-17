function X = calculate_additional_triangulated_points(Ps_normal, K, descriptors, xs, threshold, pairs)

if nargin<6
    pairs = cell(1, length(Ps_normal)-1);
    for i=1:length(Ps_normal)-1
        pairs{i} = [i, i+1];
    end
end

X = {};
idx = 1;
for i=1:length(pairs)
    camera_pairs = pairs{i};
    
    d1 = descriptors{camera_pairs(1)};
    d2 = descriptors{camera_pairs(2)};
    x1s = xs{camera_pairs(1)};
    x2s = xs{camera_pairs(2)};
    P1 = K * Ps_normal{camera_pairs(1)};
    P2 = K * Ps_normal{camera_pairs(2)};
    
    [matches, ~] = vl_ubcmatch(d1, d2);
    x1s = x1s(:, matches(1,:));
    x2s = x2s(:, matches(2,:));
    
    X_new = calculate_inlier_triangulation(x1s, x2s, K, P1, P2, threshold);
    if numel(X_new)
        X{idx} = project_to_flat_representation(X_new);
        idx = idx + 1;
    end
end

end

