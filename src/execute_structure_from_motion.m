function [common_Xs, additional_Xs, Ps_normal] = execute_structure_from_motion(dataset_number, verbose, plot_results)

MAX_BUNDLE_ADJUSTMENT_ERROR_PX = 200;
N_BUNDLE_ADJUSTMENT_ITER = 10;
BUNDLE_ADJUSTMENT_LAMBDA = 3;
OFF_CENTERED_POINTS_PERCENTILE = 0.9;
OFF_CENTERED_POINTS_M = 5;
BOUNDING_BOX_MARGIN = 1;

if nargin<3
    plot_results = true;
end
if nargin<2
    verbose = true;
end


%% Load dataset
if verbose 
    fprintf("Loading dataset ...\n");
end

try
    [K, img_names, init_pair, threshold] = retrieve_dataset_information(dataset_number);
catch
    error("Dataset not found!");
end

n_images = length(img_names);
imgs = cell(1, n_images);
for i=1:n_images
    imgs{i} = imread(img_names{i});
end


%% Extracting the features and descriptors for each image
if verbose 
    fprintf("Extracting SIFT features from dataset ...\n");
end

xs_array = cell(1,n_images);
descriptors_array = cell(1,n_images);
for i=1:n_images
    [f, d] = vl_sift(single(rgb2gray(imgs{i})),'PeakThresh', 1);
    xs_array{i} = [f(1,:); f(2,:); ones(1,size(f,2))]; % Homogeneous coordinates
    descriptors_array{i} = d;
end


%% Choosing a pair to match features and initial 3d reconstruction
% Choosing pairs
% init_pair = [2,6]%%%%%%%%
if (init_pair(1)<0)
    init_pair = [1, 2];
end

d1 = descriptors_array{init_pair(1)};
d2 = descriptors_array{init_pair(2)};
x1s = xs_array{init_pair(1)};
x2s = xs_array{init_pair(2)};

Ps_normal = cell(1, n_images);
Ps_normal{init_pair(1)} = eye(3,4);
[Xs, desc_X, P_init_pair_2, inlier_matches] = reconstruct_3D_structure(x1s, x2s, d1, d2, K, K*Ps_normal{init_pair(1)}, threshold);
Ps_normal{init_pair(2)} = K \ P_init_pair_2;
Ps_normal{init_pair(2)} = Ps_normal{init_pair(2)} / det(Ps_normal{init_pair(2)}(1:3,1:3))^(1/3);


%% Remove off-centered points
[selected_indices, center_of_gravity, max_offset] = remove_off_centered_points(Xs, OFF_CENTERED_POINTS_PERCENTILE, OFF_CENTERED_POINTS_M);
Xs = Xs(:, selected_indices);
desc_X = desc_X(:, selected_indices);
inlier_matches = inlier_matches(:, selected_indices);

% Debug: Show initial 3d reconstruction and 2 cameras
% visualize_3D_points(Xs);axis equal;grid on;hold on;visualize_cameras(Ps_normal(init_pair));

%% Feature matching for all images
if verbose 
    fprintf("Matching features for all images ...\n");
end

visibility_matrix = zeros(size(desc_X, 2), n_images);
visibility_matrix(:, init_pair) = inlier_matches';
for i=1:n_images
    if (i==init_pair(1) || i==init_pair(2))
        continue
    else
        d = descriptors_array{i};
        [matches, ~] = vl_ubcmatch(desc_X, d);
        visibility_matrix(matches(1,:), i) = matches(2,:); %%%% Check for outlier
    end
end

% adj_matches = cell(1, n_images-1);
% for i=1:(n_images-1)
%     d1 = descriptors_array{i};
%     d2 = descriptors_array{i+1};
%     [adj_matches{i}, ~] = vl_ubcmatch(d1, d2);
% end
% [min_pair, idx] = min(init_pair);
% visibility_matrix = zeros(size(desc_X, 2), n_images);
% visibility_matrix(:, min_pair) = inlier_matches(idx,:)';
% for i=min_pair:(n_images-1)
%     tmp = zeros(max(adj_matches{i}(1,:)), 1);
%     tmp(adj_matches{i}(1,:)) = adj_matches{i}(2,:);
%     visibility_matrix(visibility_matrix(:, i)>0, i+1) = tmp(visibility_matrix(visibility_matrix(:, i)>0, i));
% end
% if min_pair>1
%     for i=min_pair:-1:2
%         tmp = zeros(max(adj_matches{i-1}(2,:)), 1);
%         tmp(adj_matches{i-1}(2,:)) = adj_matches{i-1}(1,:);
%         visibility_matrix(visibility_matrix(:, i)>0, i-1) = tmp(visibility_matrix(visibility_matrix(:, i)>0, i));
%     end
% end





%% Finding all camera matrices
if verbose 
    fprintf("Finding all camera matrices ...\n");
end

for i=1:n_images
    if all(init_pair~=i)
        xs = xs_array{i};
        visible_points = (visibility_matrix(:,i)>0);
        matches = visibility_matrix(visible_points, i);%([init_pair(1),i], visibility_matrix(i,:)>0);
        Xs_match = Xs(:, visible_points);
        xs_match = xs(:, matches); % Homogeneous coordinates
        Ps_normal{i} = inv(K)*estimate_robust_P(xs_match, Xs_match, K, threshold, 1);
    end
end


%% Finding points visible in all cameras
common_points_indices = (sum(visibility_matrix>0,2)==n_images);
common_Xs = Xs(:, common_points_indices);
common_xs_normal = cell(1, length(n_images));
for i=1:n_images
    common_xs_normal{i} = project_to_flat_representation(inv(K)*xs_array{i}(:, visibility_matrix(common_points_indices, i)));
end


%% Run bounle adjustment
if verbose 
    fprintf("Running boundle adjustment ...\n");
end
[common_Xs, common_xs_normal] = remove_outliers_from_common_feature_points(common_Xs, common_xs_normal, Ps_normal, MAX_BUNDLE_ADJUSTMENT_ERROR_PX/K(1,1));
[common_Xs, Ps_normal, bundle_adjustment_errors] = perform_bundle_adjustment(common_Xs, common_xs_normal, Ps_normal, N_BUNDLE_ADJUSTMENT_ITER, BUNDLE_ADJUSTMENT_LAMBDA);
% Xs(:, common_points_indices) = common_Xs;


%% Triangulate additional 3d points
if verbose 
    fprintf("Triangulating additional points ...\n");
end
bounding_box = calculate_bounding_box(common_Xs, BOUNDING_BOX_MARGIN);
additional_Xs = calculate_additional_triangulated_points(Ps_normal, K, descriptors_array, xs_array, threshold);

for i=1:length(additional_Xs)
    inlier = filter_points_by_sphere(additional_Xs{i}, center_of_gravity, max_offset) & ...
             filter_points_by_bounding_box(additional_Xs{i}, bounding_box);
    additional_Xs{i} = project_to_flat_representation(additional_Xs{i}(:, inlier));
    
end


%% Plotting the reconstruction
if plot_results
    if verbose 
        fprintf("Plotting the results ...\n");
    end
    figure();
    axis equal;
    hold on; 
    grid on;
    visualize_cameras(Ps_normal);
    for i=1:length(additional_Xs)
        visualize_3D_points(project_to_flat_representation(additional_Xs{i}), '.b', 0.5)
    end
    visualize_3D_points(common_Xs, '.b', 1);
end

if verbose 
    fprintf("Process finished.\n");
end

end

