function [common_Xs, common_xs_normal] = remove_outliers_from_common_feature_points(common_Xs, common_xs_normal, Ps_normal, threshold)

assert(size(common_Xs,1)==3 | size(common_Xs,1)==4, "Wrong common_Xs shape!");
assert(length(common_xs_normal)==length(Ps_normal), "common_xs_normal and Ps_normal musr have similar length!");
for i=1:length(Ps_normal)
    assert(isequal(size(Ps_normal{i}), [3,4]), "Size of elements of Ps_normal must be [3,4]!");
    assert(size(common_Xs, 2)==size(common_xs_normal{i}, 2), "Length of common_Xs must be similar to the elements of common_xs_normal");
end
assert(threshold>0, "threshold must be positive!");

if (size(common_Xs,1)==3)
    common_Xs = [common_Xs; ones(1, size(common_Xs,2))];
end
common_Xs = project_to_flat_representation(common_Xs);

for i=1:length(common_xs_normal)
    if (size(common_xs_normal{i},1)==2)
        common_xs_normal{i} = [common_xs_normal{i}; ones(1, size(common_xs_normal{i},2))];
    end
    common_xs_normal{i} = project_to_flat_representation(common_xs_normal{i});
end

n_cameras = length(common_xs_normal);
outliers = zeros(1, size(common_Xs, 2));
for i=1:n_cameras
    xs_normal = common_xs_normal{i};
    P_normal = Ps_normal{i};
    errors = sqrt(sum((project_to_flat_representation(P_normal*common_Xs)-project_to_flat_representation(xs_normal)).^2, 1));
    outliers = outliers + (errors>threshold);
end

inliers = (outliers<n_cameras/2);
common_Xs = common_Xs(:, inliers);
for i=1:length(common_xs_normal)
    common_xs_normal{i} = common_xs_normal{i}(:, inliers);
end

for i=1:n_cameras
    xs_normal = common_xs_normal{i};
    P_normal = Ps_normal{i};
    errors = sqrt(sum((project_to_flat_representation(P_normal*common_Xs)-project_to_flat_representation(xs_normal)).^2, 1));
    outliers = (errors>threshold);
    common_xs_normal{i}(:, outliers) = project_to_flat_representation(P_normal*common_Xs(:, outliers));
end

end

