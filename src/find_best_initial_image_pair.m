function best_pair = find_best_initial_image_pair(dataset_number, verbose)

if nargin<2
    verbose = true;
end

%% Load dataset
if verbose 
    fprintf("Loading dataset ...\n");
end

try
    [K, img_names, ~, threshold] = retrieve_dataset_information(dataset_number);
catch
    error("Dataset not found!");
end

n_images = length(img_names);
imgs = cell(1, n_images);
for i=1:n_images
    imgs{i} = imread(img_names{i});
end


%% Getting the features and descriptors for each image
if verbose 
    fprintf("Extracting features ...\n");
end

features = cell(1,n_images);
descriptors = cell(1,n_images);
for i=1:n_images
    [f, d] = vl_sift(single(rgb2gray(imgs{i})),'PeakThresh', 1);
    features{i} = f;
    descriptors{i} = d;
end


%% Find best pair
if verbose 
    fprintf("Finding the best pair ...\n");
end

best_pair = 0;
best_pair_score = 0;
for i=1:n_images
    for j=(i+1):n_images
        
        pair = [i,j];
        
        d1 = descriptors{pair(1)};
        d2 = descriptors{pair(2)};
        f1 = features{pair(1)};
        f2 = features{pair(2)};
        
        % Point matching
        [matches, ~] = vl_ubcmatch(d1, d2);
        x1s = [f1(1,matches(1,:)); f1(2,matches(1,:)); ones(1,size(matches,2))]; % Homogeneous coordinates
        x2s = [f2(1,matches(2,:)); f2(2,matches(2,:)); ones(1,size(matches,2))]; % Homogeneous coordinates
        
        % Robust estimation of essential matrix
        [Eapprox, inliers] = estimate_E_robust(K, x1s, x2s, threshold, 1);
        E = apply_essential_matrix_constraints(Eapprox);
        
        % Find camera matrices
        P1 = eye(3,4);
        [P2, ~] = get_valid_P(P1, E, inv(K)*x1s(:,inliers), inv(K)*x2s(:,inliers));
        
        [~, axis1] = calculate_camera_center_and_axis(P1);
        [~, axis2] = calculate_camera_center_and_axis(P2);
        
        sin_2_angle = 1-((axis1'*axis2)/(norm(axis1)*norm(axis2)))^2;
        score = sum(inliers) * sin_2_angle;
        
        if (score > best_pair_score)
            best_pair_score = score;
            best_pair = pair;
        end
        
        if verbose 
             fprintf("Pair: [%d, %d],\tScore: %f ,\tBest Pair: [%d, %d],\tBest Score: %f\n", ...
                     pair(1), pair(2), score, best_pair(1), best_pair(2), best_pair_score);
        end
    end
end

end

