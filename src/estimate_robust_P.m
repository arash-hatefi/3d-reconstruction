function P = estimate_robust_P(xs, Xs, K, err_threshold_px, d)

if nargin<5
    d = 0;
end

assert(size(xs,1)==2 | size(xs,1)==3, "Wrong xs shape!");
assert(size(Xs,1)==3 | size(Xs,1)==4, "Wrong Xs shape!");
assert(size(xs,2)==size(Xs,2), "Length of Xs and xs must be equal!");
assert(isequal(size(K), [3,3]), "Size of K must be [3,3]!");
assert(err_threshold_px>0, "err_threshold_px must be positive!");
assert(d>=0, "d must be  grater than zero!");

if (size(xs, 1)==2)
    xs = [xs; ones(1, size(xs, 2))];
end
if (size(Xs, 1)==3)
    Xs = [Xs; ones(1, size(Xs, 2))];
end
xs = project_to_flat_representation(xs);
Xs = project_to_flat_representation(Xs);

P_init = 0;
score = -1;
for i=1:100
    indices = randperm(size(xs, 2), 6);
    P = K*estimate_camera_parameters_DLT(inv(K)*xs(:, indices), Xs(:, indices));
    errors = sqrt(sum((project_to_flat_representation(P*Xs)-xs).^2, 1));
    inliers = (errors<err_threshold_px);
    if (sum(inliers)>score)
        score = sum(inliers);
        P_init = P;
    end
end

% distances_to_center = sqrt(sum((Xs - mean(Xs, 2)).^2, 1));
% [distances_to_center_sorted, indices] = sort(distances_to_center);
% selected_indices = indices(distances_to_center_sorted<3*std(distances_to_center));
% selected_indices = selected_indices(1:min(2000, length(selected_indices)));
% 
% P_init = K*estimate_camera_parameters_DLT(inv(K)*xs(:, selected_indices), Xs(:, selected_indices));
errors = sqrt(sum((project_to_flat_representation(P_init*Xs)-xs).^2, 1));
inliers = (errors<err_threshold_px);
if (sum(inliers)<6)
    errors_sorted = sort(errors);
    inliers = (errors<=errors_sorted(6));
end

xs_inlier = xs(:, inliers);
Xs_inlier = Xs(:, inliers);
best_set = inliers;

best_P = 0;
max_iter = 4000;
for iter=1:max_iter
    indices = randperm(size(xs_inlier, 2), 6);

    P = K*estimate_camera_parameters_DLT(inv(K)*xs_inlier(:, indices), Xs_inlier(:, indices));
    
    % T_d,d testing_script
    if (d>0)
        indices = randperm(size(xs, 2), d);
        error = sqrt(sum((project_to_flat_representation(P*Xs(:, indices))-xs(:, indices)).^2, 1));
        if (sum(error>err_threshold_px))
            continue;
        end
    end
    
    errors = sqrt(sum((project_to_flat_representation(P*Xs)-xs).^2, 1));
    
    inliers = (errors<err_threshold_px);
    if (sum(inliers)<6)
        inliers = best_set;
    end
    
    xs_inlier = xs(:, inliers);
    Xs_inlier = Xs(:, inliers);  
    
    if (sum(inliers)>sum(best_set))
        best_set = inliers;
        best_P = P;
    end
end

xs_inlier = xs(:, best_set);
Xs_inlier = Xs(:, best_set);
P_normal = estimate_camera_parameters_DLT(inv(K)*xs_inlier(:, 1:min(size(xs_inlier,2), 1000)), Xs_inlier(:, 1:min(size(xs_inlier,2), 1000)));
det_ = det(P_normal(1:3,1:3));
P_normal = P_normal / abs(det_)^(1/3)*sign(det_);
P = K*P_normal;

end

