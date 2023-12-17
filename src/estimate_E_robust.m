function [E, best_set] = estimate_E_robust(K, x1s, x2s, err_threshold_px, d, use_degensac)

if nargin<6
    use_degensac = true;
end
if nargin<5
    d = 1;
end

assert(isequal(size(K), [3,3]), "Size of K must be [3,3]!");
assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(isequal(size(x1s), size(x2s)), "Size of x1s and x2s must be equal!");
assert(err_threshold_px>0, "err_threshold_px must be positive!");
assert(d>=0, "d must be  in grater than 0!");

if (size(x1s, 1)==2)
    x1s = [x1s; ones(1, size(x1s, 2))];
end
if (size(x2s, 1)==2)
    x2s = [x2s; ones(1, size(x2s, 2))];
end
x1s = project_to_flat_representation(x1s);
x2s = project_to_flat_representation(x2s);

err_threshold = err_threshold_px / K(1, 1);

x1s_normalized = inv(K) * x1s;
x2s_normalized = inv(K) * x2s;


best_H = 0;       % For DEGENSAC
best_H_score = 0; % For DEGENSAC

inliers = true(1, length(x1s_normalized));
inliers1 = x1s_normalized(:, inliers);
inliers2 = x2s_normalized(:, inliers);

best_set = false(1, length(x1s_normalized));
max_iter = 20000;

degensac_threshold = err_threshold;

for iter=1:max_iter
    indices = randperm(length(inliers1), 8);
    selected_x1s = inliers1(:,indices);
    selected_x2s = inliers2(:,indices);
    E = estimate_Fundamental_matrix_DLT(selected_x1s, selected_x2s);
    
    if (d>0)
        indices = randperm(length(x1s_normalized), d);
        error = (calculate_epipolar_errors(E, x1s_normalized(:, indices), x2s_normalized(:, indices)).^2 + ...
                 calculate_epipolar_errors(E', x2s_normalized(:, indices), x1s_normalized(:, indices)).^2)/2;
        if (sum(error>err_threshold^2))
            continue;
        end
    end
    
    inliers = (calculate_epipolar_errors(E, x1s_normalized, x2s_normalized).^2 + ...
               calculate_epipolar_errors(E', x2s_normalized, x1s_normalized).^2)/2 <= err_threshold^2;
    
    if (sum(inliers)>sum(best_set))
        if use_degensac
            [is_degenerate_, H, errors] = check_for_degeneracy(selected_x1s, selected_x2s, degensac_threshold);
            if is_degenerate_
                errors = sqrt(sum((project_to_flat_representation(H*selected_x1s)-selected_x2s).^2));
                H_inliers = errors<=degensac_threshold;
                H_score = sum(H_inliers);
                if (H_score>best_H_score)
                    best_H = H;
                    best_H_score = H_score;
                end
                degensac_E = estimate_E_with_plain_parallax(selected_x1s, selected_x2s, best_H, degensac_threshold);
                if numel(degensac_E)>1
                    degensac_inliers = (calculate_epipolar_errors(degensac_E, x1s_normalized, x2s_normalized).^2 + ...
                                        calculate_epipolar_errors(degensac_E', x2s_normalized, x1s_normalized).^2)/2 <= err_threshold^2;
                    if (sum(degensac_inliers)>sum(inliers))
                        inliers = degensac_inliers;
                    end
                end
            end
        end
        best_set = inliers;
    end
    
    inliers1 = x1s_normalized(:, inliers);
    inliers2 = x2s_normalized(:, inliers);
end

inliers1 = x1s_normalized(:, best_set);
inliers2 = x2s_normalized(:, best_set);
E = estimate_Fundamental_matrix_DLT(inliers1, inliers2);
if use_degensac && numel(best_H)>1
    degensac_E = estimate_E_with_plain_parallax(inliers1, inliers2, best_H, degensac_threshold);
    if numel(degensac_E)>1
        degensac_inliers = (calculate_epipolar_errors(degensac_E, x1s_normalized, x2s_normalized).^2 + ...
                            calculate_epipolar_errors(degensac_E', x2s_normalized, x1s_normalized).^2)/2 <= err_threshold^2;
        inliers = (calculate_epipolar_errors(E, x1s_normalized, x2s_normalized).^2 + ...
                   calculate_epipolar_errors(E', x2s_normalized, x1s_normalized).^2)/2 <= err_threshold^2;
        if (sum(degensac_inliers)>sum(inliers))
            E = degensac_E;
        end
    end
end



end

